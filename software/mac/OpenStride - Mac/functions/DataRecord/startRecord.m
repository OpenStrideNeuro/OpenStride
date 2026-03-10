function startRecord(app)

% === Generate config file ===
generateConfigFile(app, 'record');

% === Prepare log file ===
log_filename = tempPath(app, 'phidget_log.log');
if exist(log_filename, 'file')
    delete(log_filename);
end

% === Optional debug log for Python stdout/stderr ===
debug_log = tempPath(app, 'python_debug.log');
if exist(debug_log, 'file')
    delete(debug_log);
end

% === Python interpreter path (modify if needed) ===
python_exe = '/usr/bin/python3';

% === Path to Python script ===
script_path = phidgetPath(app, 'main.py');

if exist(script_path, 'file') ~= 2
    app.TextUpdate.Text = {['Error1001: Python script is missing: ', script_path]};
    return;
end

if exist(python_exe, 'file') ~= 2
    app.TextUpdate.Text = {['Error1002: Python executable is missing: ', python_exe]};
    return;
end

% === Use script folder as working directory ===
work_dir = fileparts(script_path);

% === Launch Python script in background ===
cmd = sprintf('cd "%s" && nohup "%s" "%s" > "%s" 2>&1 &', ...
    work_dir, python_exe, script_path, debug_log);

status = system(cmd);

if status ~= 0
    app.TextUpdate.Text = {'Error1003: Failed to launch Python script.'};
    return;
end

% === Update UI after launch ===
pause(0.2);
app.TextUpdate.Text = {'Program launched...'};
drawnow;

% === Monitor log and update UI ===
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

        % Extract message from format:
        % [timestamp] [level] message
        tokens = regexp(line, '^\[.*?\]\s*\[.*?\]\s*(.*)$', 'tokens');

        if ~isempty(tokens)
            message_count = message_count + 1;
            messages{message_count} = tokens{1}{1};
        end
    end

    % Keep only valid parsed messages
    messages = messages(1:message_count);

    if ~isempty(messages)
        app.TextUpdate.Text = messages;
        drawnow;
    end

    % Check stop conditions
    if any(contains(messages, 'Recording complete.')) || ...
       any(contains(messages, 'Auto-stop condition met.')) || ...
       any(contains(messages, 'ERROR'))

        app.TextUpdate.Text = {'Program finished.'};
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

% === Send terminate flag ===
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