function setResultButton(app)
% SETRESULTBUTTON  Enable and show result buttons for selected analyses.
%
% Purpose
% - After analyses finish, this function reveals and activates the result buttons
%   corresponding to each analysis type that was selected via checkboxes.
%
% Input
% - app : App handle exposing analysis checkboxes and corresponding result buttons.
%
% Behavior
% - For each analysis module (Distance/Speed, Tremor, Ataxia, Low Mobility Bouts):
%     * If its checkbox is checked (Value == 1), make its button visible and enabled.
% - Does not hide or disable unselected buttons (leaves them unchanged).
%
% Output
% - No return value; updates UI button states directly.

if app.DistanceSpeedCheckBox.Value == 1
    app.DistanceSpeedButton.Visible = 'on';
    app.DistanceSpeedButton.Enable = 'on';
end

if app.TremorCheckBox.Value == 1
    app.TremorButton.Visible = 'on';
    app.TremorButton.Enable = 'on';
end

if app.AtaxiaCheckBox.Value == 1
    app.AtaxiaButton.Visible = 'on';
    app.AtaxiaButton.Enable = 'on';
end

if app.LowMobilityBoutsCheckBox.Value == 1
    app.LowMobilityBoutsButton.Visible = 'on';
    app.LowMobilityBoutsButton.Enable = 'on';
end

end
