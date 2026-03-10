function runCalibrationScript(app, event)
% RUNCALIBRATIONSCRIPT Launch main.py on macOS for calibration and stream log to UI.

% === Check user confirmation ===
try
    if isempty(event) || ~isfield(event, 'SelectedOption')
        return;
    end
    if ~strcmp(event.SelectedOption, 'Sure, start now!')
        return;
    end
catch
    return;
end

lock(app);
app.CalibrateButton.Text = 'Calibrating ...';

% === Generate config file ===
generateConfigFile(app, 'calibration');

% === Prepare log ===
log_filename = tempPath(app, 'phidget_log.log');
if exist(log_filename, 'file')
    delete(log_filename);
end

% === Path to main.py ===
py_path = phidgetPath(app, 'main.py');

if ~exist(py_path, 'file')
    app.TextUpdate.Text = {'Error1002: main.py is missing!'};
    unlock(app);
    app.CalibrateButton.Value = 0;
    app.CalibrateButton.Text = 'Calibrate';
    return;
end

% === Launch main.py in background on macOS ===
script_dir = fileparts(py_path);
cmd = ['cd "', script_dir, '" && nohup python3 main.py >> "', log_filename, '" 2>&1 &'];

status = system(cmd);
if status ~= 0
    app.TextUpdate.Text = {'Failed to launch main.py'};
    unlock(app);
    app.CalibrateButton.Value = 0;
    app.CalibrateButton.Text = 'Calibrate';
    return;
end

% === Monitor log and update UI ===
timeout = 300; % 5 minutes
start_time = tic;

pause(0.2);
app.TextUpdate.Text = {'Program launched...'};
drawnow;

while toc(start_time) <= timeout
    pause(0.1);

    if ~exist(log_filename, 'file')
        continue;
    end

    fid = fopen(log_filename, 'r');
    if fid == -1
        continue;
    end

    log_text = textscan(fid, '%s', 'Delimiter', '\n', 'Whitespace', '');
    fclose(fid);
    log_text = log_text{1};

    messages = {};
    for i = 1:length(log_text)
        line = log_text{i};

        % Parse format: [timestamp] [level] message
        tokens = regexp(line, '^\[.*?\]\s*\[.*?\]\s*(.*)$', 'tokens');

        if ~isempty(tokens)
            messages{end+1} = tokens{1}{1}; %#ok<AGROW>
        else
            % Show plain text lines too
            if ~isempty(strtrim(line))
                messages{end+1} = line; %#ok<AGROW>
            end
        end
    end

    if ~isempty(messages)
        app.TextUpdate.Text = messages;
        drawnow;
    end

    % Check for termination conditions
    if any(contains(messages, 'Phidget calibration completed.')) || ...
       any(contains(messages, 'ERROR'))

        currentText = app.TextUpdate.Text;
        if iscell(currentText)
            app.TextUpdate.Text = [currentText; {'Program finished.'}];
        else
            app.TextUpdate.Text = {currentText; 'Program finished.'};
        end
        break;
    end
end

% === Timeout handling ===
if toc(start_time) > timeout
    app.TextUpdate.Text = {'Error1005_1: Timeout waiting for program to finish.'};
end

app.CalibrateButton.Value = 0;
app.CalibrateButton.Text = 'Calibrate';
unlock(app);

end