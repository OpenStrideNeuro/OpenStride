function runCalibrationScript(app, event)
% RUNCALIBRATIONSCRIPT  Launch the external Phidget calibration app and live-stream its log to the UI.
%
% Purpose
% - Confirms user intent, locks the UI, and prepares a clean log file.
% - Generates a calibration config, locates the unified launcher executable, and starts it.
% - Monitors the log file in near-real time to update a UI text area with parsed messages.
% - Detects completion or error markers, handles timeout, and restores UI state.
%
% Inputs
% - app   : App handle exposing UI components, helpers (tempPath, phidgetPath, generateConfigFile),
%           and lock/unlock utilities.
% - event : UI event object carrying the user's confirmation (expects SelectedOption).
%
% Behavior
% - Requires `event.SelectedOption == 'Sure, start now!'` to proceed.
% - Uses Windows `start /B` to launch the exe in the background (POSIX `nohup` line included, commented).
% - Polls the log (phidget_log.log) up to 5 minutes; parses lines of form: [timestamp] [level] message.
% - Stops when it sees "Phidget calibration completed." or any "ERROR"; otherwise times out.
% - Always resets the Calibrate button state and unlocks the UI at the end.
%
% Output
% - No return value; side effects include UI text updates and creation of the log file.

% === Check user confirmation ===
if ~strcmp(event.SelectedOption, 'Sure, start now!')
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

% === Path to your unified exe ===
exe_path = phidgetPath(app, 'phidget_launcher.exe');

if ~exist(exe_path, 'file')
    app.TextUpdate.Text = {'Error1001: Unified exe is missing!'};
    return;
end

% === Launch main.py ===
system(['nohup python3 "', phidgetPath(app,'main.py'), '" > /dev/null 2>&1 &']);

% === Monitor log and update UI ===
timeout = 300; % 5 minutes
start_time = tic;

pause(0.1);
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

    messages = cell(1, length(log_text));
    message_count = 0;

    for i = 1:length(log_text)
        line = log_text{i};
        % Extract the message part from: [timestamp] [level] message
        tokens = regexp(line, '^\[.*?\]\s*\[.*?\]\s*(.*)$', 'tokens');
        if ~isempty(tokens)
            message_count = message_count + 1;
            messages{message_count} = tokens{1}{1};
        end
    end

    % Only keep non-empty parsed messages
    messages = messages(1:message_count);

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

% Timeout handling
if toc(start_time) > timeout
    app.TextUpdate.Text = 'Error1005_1: Timeout waiting for program to finish.';
end
unlock(app);
app.CalibrateButton.Value = 0;
app.CalibrateButton.Text = 'Calibrate';
end