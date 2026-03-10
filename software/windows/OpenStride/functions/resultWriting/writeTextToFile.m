function writeTextToFile(pathway, filename, textContect)
% WRITETEXTTOFILE  Write a text string to a .txt file within the specified folder.
%
% Purpose
% - Creates or overwrites a .txt file and writes the provided text content into it.
% - Ensures the target directory exists before writing and validates successful file access.
%
% Inputs
% - pathway      : Target directory where the text file should be saved.
% - filename     : Base name of the file (without extension).
% - textContect  : Text content to be written into the file.
%
% Behavior
% - Throws an error if the target directory does not exist.
% - Opens the file in write mode ('w'), overwriting any existing file.
% - Throws an error if the file cannot be created or opened.
%
% Output
% - No return value; writes file as a side effect.

    % --- Ensure the output directory exists ---
    if ~exist(pathway, 'dir')
        error('File path does not exist: %s', pathway);
    end

    % --- Construct full file path ---
    fullFilePath = fullfile(pathway, [filename, '.txt']);

    % --- Open file for writing ---
    fileID = fopen(fullFilePath, 'w');
    if fileID == -1
        error('Unable to create or open result file: %s', fullFilePath);
    end

    % --- Write text content ---
    fprintf(fileID, '%s', textContect);

    % --- Close file handle ---
    fclose(fileID);
end
