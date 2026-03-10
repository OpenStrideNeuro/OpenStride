function ataxiaTest(app, data, fs, resultPath, name)
% ATAXIATEST  Detect ataxia-like one-second bouts and compute movement ratio metrics.

    % =========================================================
    %                USER SWITCHES / PARAMETERS
    % =========================================================
    doLowpass = false;   % <<< true = apply low-pass; false = no low-pass
    doSmooth  = true;   % <<< true = apply movmean;  false = no smoothing

    fc  = 10;            % <<< low-pass cutoff frequency (Hz)
    win = 30;            % <<< movmean window (samples)
    % =========================================================

    % --- Extract coordinates ---
    data = rmmissing(data);
    x = data{:, 2};
    y = data{:, 3};

    % ===================== Preprocess =====================

    % --- 1) Optional Butterworth low-pass (zero-phase) ---
    if doLowpass
        if fs > 0 && fc > 0 && fc < fs/2
            [b_lp, a_lp] = butter(4, fc/(fs/2), 'low');
            try
                x = filtfilt(b_lp, a_lp, x);
                y = filtfilt(b_lp, a_lp, y);
            catch ME
                warning('Low-pass filtfilt failed: %s. Proceeding without low-pass.', ME.message);
            end
        end
    end

    % --- 2) Optional movmean smoothing ---
    if doSmooth
        win = max(1, round(win));
        if win > 1
            x = movmean(x, win);
            y = movmean(y, win);
        end
    end

    % ===================== Main Logic =====================

    % --- Ensure output folder exists ---
    resultPath = fullfile(resultPath, 'Ataxia');
    if ~exist(resultPath, 'dir')
        mkdir(resultPath);
    end

    % --- Init accumulators and counters ---
    i = 1; j = 1; figurenum = 1;
    totaldist = [];
    totalchange = [];

    while i + (fs - 1) <= length(x)

        x_chunk = x(i:i+fs-1);
        y_chunk = y(i:i+fs-1);

        displacement = sqrt((x_chunk(end)-x_chunk(1))^2 + (y_chunk(end)-y_chunk(1))^2);

        xrange = max(x_chunk) - min(x_chunk);
        yrange = max(y_chunk) - min(y_chunk);

        if displacement > app.SoGThreshold.Value && ...
           xrange < app.xMaximum.Value && ...
           yrange < app.yMaximum.Value

            a = x_chunk;
            b = y_chunk;

            if app.SurfacePlotCheckBox.Value == 1
                z = zeros(size(a));
                col = 1:fs;
                resultFigure = figure('Visible','off');
                surface([a';a'], [b';b'], [z';z'], [col;col], ...
                        'facecol','no','edgecol','interp','linew',2);
                axis([0 30 0 30]);
                name1 = sprintf('%d_%s', figurenum, name);
                saveas(resultFigure, fullfile(resultPath, [name1 '.fig']));
                saveas(resultFigure, fullfile(resultPath, [name1 '.png']));
                close(resultFigure);
                figurenum = figurenum + 1;
            end

            totaldist(j) = displacement;

            movement = sum(sqrt(diff(a).^2 + diff(b).^2));
            totalchange(j) = movement;

            j = j + 1;
            i = i + fs;
        else
            i = i + 1;
        end
    end

    % ===================== Metrics =====================

    if isempty(totaldist)
        Movement_Ratio = [];
        Average_Movement_Ratio = NaN;
    else
        Movement_Ratio = (totalchange ./ totaldist).';
        Average_Movement_Ratio = mean(Movement_Ratio);
    end

    % ===================== Save TXT (FORMAT UNCHANGED) =====================

    fileName = ['Ataxia_Result_', name, '.txt'];
    fullFilePath = fullfile(resultPath, fileName);
    fileID = fopen(fullFilePath, 'w');
    if fileID == -1
        error('Unable to create or open file: %s', fileName);
    end

    fprintf(fileID, 'Average Movement Ratio: ');
    if isnan(Average_Movement_Ratio)
        fprintf(fileID, 'NaN\n\n');
    else
        fprintf(fileID, '%.4f\n\n', Average_Movement_Ratio);
    end

    fprintf(fileID, 'Individual Movement Ratios:\n');
    if isempty(Movement_Ratio)
        fprintf(fileID, '(none)\n');
    else
        fprintf(fileID, '%f\n', Movement_Ratio);
    end

    fclose(fileID);

end
