function lock(app,excludeObj)
% LOCK  Disable all UI components to prevent user interaction during execution.
%
% Purpose
% - Temporarily disables all controls in the UIFigure to ensure exclusive operation
%   (e.g., while recording or calibrating).
% - Optionally keeps a specific control enabled for interaction (e.g., a Cancel button).
%
% Inputs
% - app        : App handle containing UIFigure and its child components.
% - excludeObj : (Optional) Handle to a UI component to remain enabled, or the string 'all'
%                to skip re-enabling any single element.
%
% Behavior
% - Iterates through all UI components under app.UIFigure, disabling those that
%   have an 'Enable' property.
% - If excludeObj is provided and valid, re-enables it after global disabling.
%
% Output
% - No return value; directly modifies UI component states.
for c = findall(app.UIFigure)', if isprop(c,'Enable'), try c.Enable = 'off';catch, end, end, end
if nargin == 2 && ~isequal(excludeObj, 'all') && isvalid(excludeObj), try excludeObj.Enable = 'on'; catch, end, end
end