function unlock(app)
% UNLOCK  Re-enable all UI components after a locked operation.
%
% Purpose
% - Restores UI interactivity after processes like recording or calibration.
% - Re-enables all components under the UIFigure that support the 'Enable' property.
% - Resets all StateButton controls (e.g., toggle buttons) to an unpressed state.
%
% Input
% - app : App handle containing UIFigure and its child components.
%
% Behavior
% - Iterates over every object in app.UIFigure:
%     * If it has an 'Enable' property, sets it to 'on'.
%     * If it is a StateButton, resets its Value to 0.
%
% Output
% - No return value; modifies UI component states directly.
for c = findall(app.UIFigure)'
    if isprop(c, 'Enable'), try c.Enable = 'on'; catch; end, end
    if isa(c, 'matlab.ui.control.StateButton'), try c.Value = 0; catch; end, end
    
end
end