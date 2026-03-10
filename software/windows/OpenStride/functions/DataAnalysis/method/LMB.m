function LMB(app, data, fs, resultPath, name)
% LMB  Detect and summarize Low Mobility Bouts (LMB) from X/Y trajectories.
%
% Purpose
% - Smooth 2D position, compute 1-second lag displacement "speed," and flag
%   contiguous low-mobility intervals under a speed threshold for at least a
%   minimum duration.
% - Save a speed-over-time figure with shaded LMB regions and export a
%   text summary (counts, durations, ratio, and per-bout table).
%
% Inputs
% - app        : App handle providing UI parameters
%               (Speedthreshold, Durationthreshold).
% - data       : Table/array with X in column 2 and Y in column 3 (cm).
% - fs         : Sampling frequency (Hz).
% - resultPath : Base output folder (a 'LowMobilityBouts' subfolder is used).
% - name       : Identifier appended to output files.
%
% Behavior
% - Smooths X/Y with movmean(window_size=5).
% - Defines speed(i) = displacement between samples i and i-fs (i.e., over 1 s).
% - Marks frames with speed < Speedthreshold as "low"; merges consecutive frames
%   into bouts and keeps those whose duration >= Durationthreshold.
% - Plots speed with a red threshold line and green patches for bouts; writes a
%   .fig file and a text report via writeTextToFile(...).
%
% Outputs
% - Figure: 'LBM_<name>.fig' saved in 'LowMobilityBouts'.
% - Text  : 'LBM_<name>.txt' containing thresholds, totals, ratio, and bouts table.

    % --- Extract position data ---
    x = data{:, 2};
    y = data{:, 3};

    % Time vector (s)
    t = (0:length(x)-1) / fs;

    % --- Smooth position to reduce noise/jitter ---
    window_size = 5;  % smoothing window (samples)
    x = movmean(x, window_size);
    y = movmean(y, window_size);

    % --- Lagged displacement speed over 1 second ---
    lag = fs;                 % 1-second lag
    speed = zeros(length(x), 1);
    for i = lag+1 : length(x)
        dx = x(i) - x(i - lag);
        dy = y(i) - y(i - lag);
        speed(i) = sqrt(dx^2 + dy^2);  % displacement over 1 s (cm)
    end

    % Align vectors (drop first 'lag' samples)
    speed   = speed(lag+1:end);
    t_speed = t(lag+1:end);

    % --- Thresholds from UI ---
    speed_thresh       = app.Speedthreshold.Value;       % cm/s
    min_bout_duration  = app.Durationthreshold.Value;    % s

    % --- Low-mobility mask and bout detection ---
    is_low    = speed < speed_thresh;
    bouts     = [];
    in_bout   = false;
    bout_start = NaN;

    for i = 1:length(is_low)
        if is_low(i)
            if ~in_bout
                in_bout = true;
                bout_start = t_speed(i);
            end
        else
            if in_bout
                bout_end = t_speed(i);
                duration = bout_end - bout_start;
                if duration >= min_bout_duration
                    bouts = [bouts; bout_start, bout_end, duration];
                end
                in_bout = false;
            end
        end
    end

    % Close a trailing bout if the sequence ends inside one
    if in_bout
        bout_end = t_speed(end);
        duration = bout_end - bout_start;
        if duration >= min_bout_duration
            bouts = [bouts; bout_start, bout_end, duration];
        end
    end

    % --- Ensure result folder exists ---
    resultPath = fullfile(resultPath, 'LowMobilityBouts');
    if ~exist(resultPath, 'dir')
        mkdir(resultPath);
    end

    % --- Plot speed with shaded LMB bouts ---
    fig = figure('Visible', 'off');
    plot(t_speed, speed, 'b'); hold on;
    yline(speed_thresh, 'r--', 'Threshold');

    % Green patches showing detected bouts
    for i = 1:size(bouts,1)
        x_patch = [bouts(i,1), bouts(i,2), bouts(i,2), bouts(i,1)];
        y_patch = [0, 0, max(speed), max(speed)];
        patch(x_patch, y_patch, 'g', 'FaceAlpha', 0.2, 'EdgeColor', 'none');
    end

    xlabel('Time (s)');
    ylabel('Speed (cm/s)');
    title(['Low Mobility Bouts: ', name]);
    % legend('Speed','Threshold','LMB bouts');
    saveas(fig, fullfile(resultPath, ['LBM_', name, '.fig']));

    % --- Summary statistics (with empty-case handling) ---
    total_time = t_speed(end);
    if isempty(bouts)
        total_lbm_time = 0;
        lbm_ratio = 0;
        num_bouts = 0;
    else
        total_lbm_time = sum(bouts(:,3));
        lbm_ratio = total_lbm_time / total_time;
        num_bouts = size(bouts,1);
    end

    % --- Prepare result text ---
    resultLines = {};
    resultLines{end+1} = sprintf('Speed threshold (cm): %.2f', speed_thresh);
    resultLines{end+1} = sprintf('Minimum bout duration (s): %.2f', min_bout_duration);
    resultLines{end+1} = sprintf('Total duration (s): %.2f', total_time);
    resultLines{end+1} = sprintf('Total LMB time (s): %.2f', total_lbm_time);
    resultLines{end+1} = sprintf('LMB ratio: %.2f%%', lbm_ratio * 100);
    resultLines{end+1} = sprintf('Number of LMB bouts: %d', num_bouts);
    resultLines{end+1} = ' ';

    if num_bouts > 0
        resultLines{end+1} = 'Detected LMB bouts:';
        resultLines{end+1} = 'Start(s)\tEnd(s)\tDuration(s)';
        for i = 1:num_bouts
            resultLines{end+1} = sprintf('%.2f\t%.2f\t%.2f', bouts(i,1), bouts(i,2), bouts(i,3));
        end
    else
        resultLines{end+1} = 'No LMB bouts detected.';
    end

    resultText = strjoin(resultLines, '\n');

    % --- Write results via project utility ---
    name1 = ['LBM_', name];
    writeTextToFile(resultPath, name1, resultText);

end
