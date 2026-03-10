function proceed = checkAndRunCalibration(app)
% CHECKANDRUNCALIBRATION  Guardrail before running acquisition: ensure recent calibration.
%
% Purpose
% - Verifies the presence of the Phidget calibration JSON file.
% - Reads its timestamp and checks whether the calibration is older than 12 hours.
% - If stale, prompts the user with options to recalibrate or proceed anyway.
%
% Inputs
% - app : App handle exposing UIFigure and file utilities (tempPath, readJsonFile).
%
% Behavior
% - If the calibration file is missing → shows a warning and blocks execution.
% - If present but unreadable / missing timestamp → quietly exits (returns current `proceed`).
% - If older than 12 hours → opens a confirmation dialog with three options:
%     * 'Recalibrate Now'     → do not proceed
%     * 'Continue Anyway'     → proceed
%     * 'Recalibrate Later'   → do not proceed
%
% Output
% - proceed : Logical flag indicating whether to continue with the main program.

proceed = true;

% **Check Calibration File**
calibrationFile = tempPath(app, 'phidget_calibration.json');
if ~exist(tempPath(app, 'phidget_calibration.json'), 'file')
    uialert(app.UIFigure, ...
        'Calibration is required before running this program.', ...
        'Calibration Required', ...
        'Icon', 'warning');
    proceed = false; return;
end

% **Read Calibration File**
jsonData = readJsonFile(app, calibrationFile); if isempty(jsonData) || ~isfield(jsonData, 'Timestamp'), return; end

% **Calculate Calibration Time Difference**
timeDiff = hours(datetime('now') - datetime(jsonData.Timestamp, 'InputFormat', 'dd/MM/yyyy HH:mm:ss'));

% **If Calibration is Older than 12 Hours, Prompt User**
if timeDiff > 12
    selection = uiconfirm(app.UIFigure, ...
        'The last calibration was performed more than 12 hours ago. Are you sure you want to continue? This may affect accuracy.', ...
        'Calibration Expired', ...
        'Options', {'Recalibrate Now', 'Continue Anyway', 'Recalibrate Later'}, ...
        'DefaultOption', 'Recalibrate Now', ...
        'CancelOption', 'Recalibrate Later');

    if strcmp(selection, 'Recalibrate Now')
        proceed = false;

    elseif strcmp(selection, 'Recalibrate Later')
        proceed = false;
    end
end
end
