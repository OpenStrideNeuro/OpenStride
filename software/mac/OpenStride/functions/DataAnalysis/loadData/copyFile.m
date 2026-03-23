function result = copyFile(app,files, path) 
% COPYFILE  Normalize selected file paths, copy/convert when needed, update UI list.
% 
% Purpose
% - Accepts one or multiple user-selected files and prepares them for use in the app.
% - If a file has the `.lvm` extension, a sibling `.txt` copy is ensured in the same folder.
% - Merges with existing app data, removes duplicates while preserving order, and refreshes the file list UI.
%
% Inputs
% - app   : App handle providing `app.data` and `app.FileList` UI component.
% - files : Either a char path or a cell array of file names selected by the user.
% - path  : Base directory in which the selected files reside.
%
% Behavior
% - If selection indicates cancel (non-cell and contains 0), returns the existing `app.data` unchanged.
% - Converts a single char input into a 1x1 cell for uniform handling.
% - For each input file, ensures a `.txt` copy for `.lvm` sources; otherwise uses the original path.
% - Concatenates with existing `app.data` (if present and nonnumeric), deduplicates (stable), and updates:
%     - `app.FileList.Items` with the final list
%     - `app.FileList.Value` with the first item
%
% Output
% - result : Cell array of absolute file paths after normalization/deduplication.

    %% Handle cancel-like selection early
    if ~iscell(files) && any(files == 0)
        result = app.data;
        return; 
    end

    %% Normalize `files` into a cell array
    if ischar(files)
        files = {files};
    end

    % Preallocate container for resolved (copied/converted) file paths
    copiedFiles = cell(size(files));

    %% Resolve/copy each selected file, converting .lvm -> .txt when applicable
    for f = 1:length(files)
        fullpath = fullfile(path, files{f});
        [~, name, ext] = fileparts(fullpath);

        if strcmpi(ext, '.lvm')
            filename = fullfile(path, [name, '.txt']);
        else
            filename = fullpath;
        end

        if ~exist(filename, 'file')
            copyfile(fullpath, filename);
        end

        copiedFiles{f} = filename;
    end

    %% Merge with existing app data (if present) before deduplication
    if ~isempty(app.data) && ~isnumeric(app.data)
        copiedFiles = [app.data, copiedFiles];
    end

    %% Deduplicate while preserving original order, then update UI
    [copiedFiles, ~, ~] = unique(copiedFiles, 'stable');

    app.FileList.Items = copiedFiles;
    app.FileList.Value = copiedFiles{1};

    result = copiedFiles;

end
