%% Read JSON File
function jsonData = readJsonFile(app, filePath)
% READJSONFILE  Load and decode a JSON file; show a UI alert on failure.
%
% Purpose
% - Attempts to read a JSON file from disk and decode it into a MATLAB struct/array.
% - Provides user-facing alerts for missing files or invalid/unreadable JSON.
%
% Inputs
% - app      : App handle exposing UI alert utilities (showAlert).
% - filePath : Absolute or relative path to the JSON file.
%
% Behavior
% - If the file does not exist, shows an error alert and returns [].
% - Wraps I/O and decoding in a try/catch; on failure, alerts and returns [].
%
% Output
% - jsonData : Decoded JSON content (struct/array) or [] on error.

if ~exist(filePath, 'file')
    showAlert(app, ['File not found: ', filePath], 'File Error', 'error'); jsonData = []; return;
end

try
    fid = fopen(filePath, 'r'); rawData = fread(fid, '*char')'; fclose(fid);
    jsonData = jsondecode(rawData);
catch
    showAlert(app, 'Invalid or unreadable JSON file.', 'Error', 'error'); jsonData = [];
end
end
