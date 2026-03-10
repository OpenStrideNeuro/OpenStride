function startRecord(app)
% STARTRECORD  Launch the recorder, live-stream its log to the UI, and manage auto-stop.
%
% Purpose
% - Builds a fresh recording config and starts the unified Phidget launcher.
% - Monitors the log file in near-real time and mirrors parsed messages to a UI text area.
% - Detects completion/auto-stop/error conditions, notifies the user, and resets UI state.
%
% Inputs
% - app : App handle exposing UI components and utilities
%         (tempPath, phidgetPath, generateConfigFile, unlock, UIFigure, etc.).
%
% Behavior
% - Overwrites any previous log (`phidget_log.log`) before launching.
% - Uses Windows `start /B` (POSIX `nohup` variant is provided but commented).
% - Polls the log while the StartRecord toggle is ON; parses lines of form:
%     [timestamp] [level] message  → displays only the message portion.
% - Stops when seeing any of:
%     'Recording complete.'  |  ' Auto-stop condition met.'  |  'ERROR'
%   → turns the toggle OFF, shows an informational alert with the stop time,
%     and updates the button text.
%
% Output
% - No return value; side effects include UI updates, log parsing, and a short
%   "terminate.flag" handshake to ask the external program to exit.

% === Generate config file ===
generateConfigFile(app, 'record');

% === Prepare log ===
log_filename = tempPath(app, 'phidget_log.log');
if exist(log_filename, 'file')
    delete(log_filename);
end

% === Path to  unified exe ===
exe_path = phidgetPath(app, 'phidget_launcher.exe');

if ~exist(exe_path, 'file')
    app.TextUpdate.Text = {'Error1001: Unified exe is missing!'};
    return;
end

% === Launch exe ===
system(['start /B "" "', exe_path, '"']);
% system(['nohup "', exe_path, '" > /dev/null 2>&1 &']);

% === Monitor log and update UI ===

pause(0.1);
app.TextUpdate.Text = {'Program launched...'};
drawnow;

while app.StartRecordButton.Value == 1
    pause(1);

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
    if any(contains(messages, 'Recording complete.')) || ...
            any(contains(messages, ' Auto-stop condition met.')) || ...
            any(contains(messages, 'ERROR'))
        app.TextUpdate.Text = 'Program finished.';
        app.StartRecordButton.Value = 0;
        currentTimeStr = datestr(now, 'dd-mmm-yyyy HH:MM:SS');
        uialert(app.UIFigure, ...
            ['Recording automatically stopped at ', currentTimeStr], ...
            'Auto-Stop Triggered', ...
            'Icon', 'info');
        app.StartRecordButton.Text = 'Start Record';
        break;
    end
end

fid = fopen(tempPath(app, 'terminate.flag'), 'w');
fclose(fid);
pause(1);

if exist(tempPath(app, 'terminate.flag'), 'file')
    delete(tempPath(app, 'terminate.flag'));
end

app.StartRecordButton.Text = 'Start Record';
unlock(app);

end
