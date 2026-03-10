function saveFigureAtPath(pathway, filename, figHandle)
% SAVEFIGUREATPATH  Save a MATLAB figure in both PNG and .fig formats to a specified folder.
%
% Purpose
% - Exports a figure handle as both a .png image and a MATLAB .fig file.
% - Ensures consistent naming and automatic figure cleanup after saving.
%
% Inputs
% - pathway   : Target directory path where the files will be saved.
% - filename  : Base filename (without extension) for the output files.
% - figHandle : Handle to the MATLAB figure to be saved.
%
% Behavior
% - Saves `[filename].png` and `[filename].fig` under the given folder.
% - Closes the figure handle after both files are successfully written.
%
% Output
% - No return value; side effects include written files and closed figure.

    % --- Save as PNG ---
    pngFile = fullfile(pathway, [filename, '.png']);
    saveas(figHandle, pngFile);
    
    % --- Save as .fig (MATLAB Figure) ---
    figFile = fullfile(pathway, [filename, '.fig']);
    savefig(figHandle, figFile);
    
    % --- Close the figure after saving ---
    close(figHandle);
end
