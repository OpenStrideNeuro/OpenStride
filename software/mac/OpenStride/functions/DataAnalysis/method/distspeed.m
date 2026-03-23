function distspeed(data, fs, resultPath, name)
% DISTSPEED  Optional preprocess (low-pass + smoothing), downsample to 1 Hz,
% plot path and speed, export cumulative distance, and save a TXT summary.
%
% Inputs
% - data      : Table/array with X in column 2 and Y in column 3 (col 1 = time/index).
% - fs        : Sampling rate (Hz).
% - resultPath: Base output directory (a 'DisplacementAndSpeed' subfolder is used).
% - name      : Identifier appended to output filenames.
%
% Notes
% - Preprocessing (optional, controlled by switches below):
%   1) Low-pass Butterworth (4th order, zero-phase via filtfilt)
%   2) movmean smoothing (window = winSec * fs samples)
% - Downsample to 1 Hz is kept as original (this itself is a strong smoothing).

    % =========================================================
    %                USER SWITCHES / PARAMETERS
    % =========================================================
    doLowpass = false;   % <<< true = apply low-pass; false = no low-pass
    doSmooth  = false;   % <<< true = apply movmean;  false = no smoothing

    fc     = 25;         % <<< low-pass cutoff frequency (Hz), used only if doLowpass=true
    winSec = 0.05;       % <<< smoothing window (seconds), used only if doSmooth=true
    % =========================================================

    % --- Extract coordinates ---
    data = rmmissing(data);
    x = data{:, 2};
    y = data{:, 3};

    % --- Resolve result path subfolder ---
    resultPath = fullfile(resultPath, 'DisplacementAndSpeed');
    if ~exist(resultPath, 'dir')
        mkdir(resultPath);
    end

    % ===================== Preprocess =====================
    % --- 1) Low-pass Butterworth (zero-phase) ---
    if doLowpass
        if fs > 0 && fc > 0 && fc < fs/2
            [b_lp, a_lp] = butter(4, fc/(fs/2), 'low');
            try
                x = filtfilt(b_lp, a_lp, x);
                y = filtfilt(b_lp, a_lp, y);
            catch ME
                warning('Low-pass filtfilt failed: %s. Proceeding without low-pass.', ME.message);
            end
        else
            warning('Skip low-pass: fs=%.3f Hz invalid/too low or cutoff fc=%.3f Hz not in (0, Nyquist).', fs, fc);
        end
    end

    % --- 2) movmean smoothing ---
    win = max(1, round(winSec * fs));   % samples
    if doSmooth && win > 1
        x = movmean(x, win);
        y = movmean(y, win);
    end

    % ===================== 1 Hz averaging =====================
    % (kept as your original logic)
    if fs <= 0 || abs(fs - round(fs)) > 1e-9
        error('fs must be a positive integer for 1 Hz block averaging. Got fs=%.6f', fs);
    end

    nBlocks = floor(length(x) / fs);
    a = zeros(1, nBlocks);
    b = zeros(1, nBlocks);

    for i = 1:nBlocks
        idx = (fs*i-(fs-1)) : (fs*i);
        a(i) = mean(x(idx));
        b(i) = mean(y(idx));
    end

    % --- Prepare color dimension for path (time-like coloring) ---
    z = zeros(size(a));
    col = 1:fs:(fs * nBlocks);

    % ===================== Plot averaged trajectory =====================
    resultFigure = figure('Visible', 'off');
    fixplot();
    surface([a; a], [b; b], [z; z], [col; col], ...
        'facecol', 'no', 'edgecol', 'interp', 'linew', 2);
    axis([-15 15 -15 15]);
    xlabel('X Position');
    ylabel('Y Position');
    name1 = ['PositionVsTime_', name];
    saveFigureAtPath(resultPath, name1, resultFigure);

    % ===================== Distance & speed =====================
    % Total displacement (total path length over 1 Hz averaged points)
    totaldist = 0;
    for i = 2:length(a)
        totaldist = totaldist + sqrt((a(i) - a(i - 1))^2 + (b(i) - b(i - 1))^2);
    end

    % Instantaneous speed between consecutive averaged points (1 Hz => cm/s)
    speed = zeros(1, max(0, length(a) - 1));
    for i = 1:length(speed)
        dx = a(i+1) - a(i);
        dy = b(i+1) - b(i);
        speed(i) = sqrt(dx^2 + dy^2);   % distance per 1 second
    end

    % Plot speed vs time
    resultFigure = figure('Visible', 'off');
    plot(speed);
    xlabel('Time (s)');
    ylabel('Speed (cm / s)');
    name1 = ['SpeedVsTime_', name];
    saveFigureAtPath(resultPath, name1, resultFigure);
    fixplot();

    % Per-segment distances
    segmentDist = zeros(1, max(0, length(a)-1));
    for i = 1:length(segmentDist)
        dx = a(i+1) - a(i);
        dy = b(i+1) - b(i);
        segmentDist(i) = sqrt(dx^2 + dy^2);
    end

    % Cumulative distance and time axis (1 Hz => 1 step = 1 second)
    cumulativeDist = cumsum(segmentDist);
    t = 1:length(cumulativeDist);

    % Plot cumulative distance vs time
    resultFigure = figure('Visible','off');
    plot(t, cumulativeDist, 'LineWidth', 2);
    xlabel('Time (s)');
    ylabel('Cumulative Distance (cm)');
    title('Cumulative Distance vs Time');
    name1 = ['CumulativeDistance_', name];
    saveFigureAtPath(resultPath, name1, resultFigure);
    fixplot();

    % ===================== Save TXT summary =====================
    avgSpeed_mean  = mean(speed, 'omitnan');           % mean of 1 Hz speeds
    totalTime_s    = numel(speed);                     % seconds (1 Hz)
    avgSpeed_total = totaldist / max(1, totalTime_s);  % equivalent avg

    fileName = ['DistSpeed_Result_', name, '.txt'];
    fullFilePath = fullfile(resultPath, fileName);
    fileID = fopen(fullFilePath, 'w');
    if fileID == -1
        error('Unable to create or open file: %s', fileName);
    end

    fprintf(fileID, 'Name: %s\n', name);
    fprintf(fileID, 'Sampling Rate (fs): %.3f Hz\n', fs);

    fprintf(fileID, 'Low-pass enabled: %d\n', logical(doLowpass));
    fprintf(fileID, '  Cutoff (fc): %.6f Hz\n', fc);
    fprintf(fileID, 'Smoothing enabled: %d\n', logical(doSmooth));
    fprintf(fileID, '  Smooth window (winSec): %.6f s\n', winSec);
    fprintf(fileID, '  Smooth window (win): %d samples\n\n', win);

    fprintf(fileID, 'Total displacement (cm): %.6f\n', totaldist);
    fprintf(fileID, 'Total time (s, at 1 Hz): %d\n', totalTime_s);
    fprintf(fileID, 'Average speed (cm/s, mean of 1 Hz speed): %.6f\n', avgSpeed_mean);
    fprintf(fileID, 'Average speed (cm/s, totaldist/totalTime): %.6f\n', avgSpeed_total);

    fclose(fileID);

end
