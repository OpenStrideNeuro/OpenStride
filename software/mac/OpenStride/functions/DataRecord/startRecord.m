function startRecord(app)
% STARTRECORD Launch main.py on macOS and stream log to UI.

% === Generate config file ===
generateConfigFile(app, 'record');

% === Prepare log ===
log_filename = tempPath(app, 'phidget_log.log');
if exist(log_filename, 'file')
    delete(log_filename);
end

% === Path to main.py ===
py_path = phidgetPath(app, 'main.py');

if ~exist(py_path, 'file')
    app.TextUpdate.Text = {'Error1002: main.py is missing!'};
    return;
end

% === Launch main.py in background on macOS ===
script_dir = fileparts(py_path);
cmd = ['cd "', script_dir, '" && nohup "', pythonExePath(app), '" main.py >> "', log_filename, '" 2>&1 &'];

status = system(cmd);
if status ~= 0
    app.TextUpdate.Text = {'Failed to launch main.py'};
    return;
end

% === Monitor log and update UI ===
pause(0.2);
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

    % Check termination conditions
    if any(contains(messages, 'Recording complete.')) || ...
       any(contains(messages, 'Auto-stop condition met.')) || ...
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

% === Ask Python program to stop ===
flag_path = tempPath(app, 'terminate.flag');
fid = fopen(flag_path, 'w');
if fid ~= -1
    fclose(fid);
end

pause(1);

if exist(flag_path, 'file')
    delete(flag_path);
end

app.StartRecordButton.Text = 'Start Record';
unlock(app);

end