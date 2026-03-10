function generateConfigFile(app,type)
% GENERATECONFIGFILE  Build a JSON command file from current UI settings.
%
% Purpose
% - Creates (or replaces) a `command.json` file under the app's temp path with
%   the parameters required by the external recorder/calibration program.
% - Populates fields from UI controls, including auto-stop and discard options.
% - Verifies the resulting file exists and is readable.
%
% Inputs
% - app  : App handle exposing UI components and utilities (e.g., tempPath).
% - type : Char/str tag of the command, e.g. 'record' or 'calibration'.
%
% Behavior
% - Deletes any pre-existing config file before writing a new one.
% - Uses a timestamp-based filename if `customFileName` is empty.
% - Encodes a MATLAB struct to pretty-printed JSON and writes it to disk.
% - Throws an error if the file cannot be created or opened for reading.
%
% Output
% - No return value; side effects include creating/overwriting command.json.

    % 1) Resolve target file path via tempPath utility
    configFilePath = tempPath(app, 'command.json');

    % 2) Delete previous config if present (exist(...,'file')==2 → regular file)
    if exist(configFilePath, 'file') == 2
        delete(configFilePath);
    end

    % 3) Collect UI values into a MATLAB struct
    S = struct();
    S.type = type;                           % e.g., 'record' or 'calibration'
    S.output_file_name = app.customFileName.Value;   % File name entered in UI
    S.note = app.Note.Value;                          % Multiline note from UI
    S.output_folder = {app.outputRecordFolderPath};   % Folder path selected in UI

    if app.customFileName.Value == ""
        t = datestr(now, 'dd-mmm-yyyy HH-MM-SS');
        S.output_file_name = ['data-' t];
    end

    % Nested struct for auto_stop settings
    S.auto_stop = struct( ...
        'enabled', app.AutoStopCheckBox.Value, ...
        'value',   app.AutoStopSpinner.Value, ...
        'unit',    app.AutoStopUnitDropDown.Value ...
    );

    % Nested struct for discard settings
    S.discard = struct( ...
        'enabled', app.DiscardCheckBox.Value, ...
        'value',   app.DiscardSpinner.Value, ...
        'unit',    app.DiscardUnitDropDown.Value ...
    );

    % Additional simple fields
    S.frequency = str2double(extractBefore(app.SampleFrequencyDropDown.Value," Hz"));   % Sampling frequency
    S.animal    = app.SelectExperimentalAnimalButtonGroup.SelectedObject.Text;          % 'rat' or 'mouse'

    % 4) JSON-encode the struct (pretty-printed)
    jsonStr = jsonencode(S, 'PrettyPrint', true);

    % 5) Write JSON string to file (overwrite mode)
    fid = fopen(configFilePath, 'w');
    fwrite(fid, jsonStr, 'char');
    fclose(fid);

    % 6) Verify the file exists and is readable
    if exist(configFilePath, 'file') ~= 2
        error('Failed to create configuration file: %s', configFilePath);
    end

    fid = fopen(configFilePath, 'r');
    if fid == -1
        error('Configuration file created but cannot be opened for reading: %s', configFilePath);
    end
    fclose(fid);

    % Done: command.json is ready for downstream use.
end
