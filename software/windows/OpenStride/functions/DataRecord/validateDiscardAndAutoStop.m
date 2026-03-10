%% Validate that Discard time is not greater than Auto Stop time
function proceed = validateDiscardAndAutoStop(app)
% VALIDATEDISCARDANDAUTOSTOP  Ensure discard duration does not exceed auto-stop duration.
%
% Purpose
% - When both features are enabled, converts UI-entered times to a common unit
%   and verifies that Discard ≤ Auto Stop. Otherwise, it blocks and alerts the user.
%
% Input
% - app : App handle exposing UI controls (DiscardCheckBox, AutoStopCheckBox, spinners, dropdowns, UIFigure).
%
% Behavior
% - Times are normalized to minutes using compact boolean-math conversions:
%     * Auto Stop → minutes: value * ( (unit=='hours')*60 + 1 )
%     * Discard   → minutes: value / ( (unit=='seconds')*60 + 1 )
% - If Discard > Auto Stop, shows an error alert and returns proceed=false.
%
% Output
% - proceed : true if configuration is acceptable; false if blocked by validation.

proceed = true;

if app.DiscardCheckBox.Value && app.AutoStopCheckBox.Value
    % Convert to minutes based on selected unit
    autoStopTime = app.AutoStopSpinner.Value * (strcmp(app.AutoStopUnitDropDown.Value, 'hours') * 60 + 1);
    discardTime = app.DiscardSpinner.Value / (strcmp(app.DiscardUnitDropDown.Value, 'seconds') * 60 + 1);

    % Check if Discard time is greater than Auto Stop time
    if discardTime > autoStopTime
        uialert(app.UIFigure, ...
            'Discard time cannot be greater than Auto Stop time.', ...
            'Error1005: Invalid Time Selection', 'Icon', 'error');
        proceed = false;
    end
end
end
