function result = filtering(path)
% FILTERING  Read FPA-style files and return [Time/Index, X, Y] table.
% - Skips leading remarks.
% - Uses the row before the first data row (whose first cell is '0' and the
%   next row starts numeric) as the header row.
% - Picks columns whose names are exactly 'x' and 'y' (case-insensitive).
% - If not found, falls back to the last two columns as X,Y.
%
% Output variable names are standardized to {'Time/Index','X','Y'}.

    [~, ~, ext] = fileparts(path);
    ext = lower(ext);

    % ----------- Excel files -----------
    if ismember(ext, {'.xlsx', '.xls'})
        tbl = readtable(path, 'VariableNamingRule','preserve');
        varNames = strtrim(tbl.Properties.VariableNames);

        % indices: first column as time/index, x/y by strict match (fallback to last two)
        tIdx = 1;
        [xIdx, yIdx] = findXYColumns(varNames);

        result = tbl(:, [tIdx, xIdx, yIdx]);
        result.Properties.VariableNames = {'Time/Index','X','Y'};
        return;
    end

    % ----------- Text files  -----------
    fid = fopen(path, 'r', 'n', 'UTF-8');
    if fid == -1
        error('Unable to open file: %s', path);
    end
    content = fread(fid, '*char')';
    fclose(fid);

    % Strip BOM if present
    if startsWith(content, char(65279))
        content = content(2:end);
    end

    lines = splitlines(content);
    delimiter = ','; % adjust if you use other delimiters

    % numeric tester (for first-column check)
    isNumeric = @(s) ~isempty(regexp(strtrim(s), ...
        '^[-+]?(?:\d+\.?\d*|\.\d+)([eE][-+]?\d+)?$', 'once'));

    headerLineIdx = []; % 1-based index of header row (a-1)

    % Find first data row: line a starts with '0' and next line numeric.
    for a = 1:numel(lines)-1
        L1 = strtrim(lines{a});
        L2 = strtrim(lines{a+1});
        if isempty(L1) || isempty(L2), continue; end

        e1 = strsplit(L1, delimiter);
        e2 = strsplit(L2, delimiter);

        if ~isempty(e1) && strcmp(strtrim(e1{1}), '0') && ...
           ~isempty(e2) && isNumeric(e2{1})
            headerLineIdx = a - 1;  % header is the previous line
            if headerLineIdx < 1, headerLineIdx = 1; end
            break;
        end
    end

    if isempty(headerLineIdx)
        % Fallback to your older heuristic (row-2) if needed, or error out
        disp('File preview (first 10 lines):');
        disp(lines(1:min(10, end)));
        error('FeatureUnrecognized: Could not locate header/data in file: %s', path);
    end

    % readtable so that the header line becomes VariableNames
    headerLinesToSkip = max(headerLineIdx - 1, 0);
    tbl = readtable(path, ...
        'HeaderLines', headerLinesToSkip, ...
        'Delimiter', delimiter, ...
        'VariableNamingRule','preserve');

    varNames = strtrim(tbl.Properties.VariableNames);

    tIdx = 1;                              % first column = time/index
    [xIdx, yIdx] = findXYColumns(varNames);

    result = tbl(:, [tIdx, xIdx, yIdx]);
    result.Properties.VariableNames = {'Time/Index','X','Y'};
end

% ---------- Helper: choose X/Y columns ----------
function [xIdx, yIdx] = findXYColumns(varNames)
    % 1) exact match first (case-insensitive), prefer the last occurrence
    xIdx = find(strcmpi(varNames, 'x'), 1, 'last');
    yIdx = find(strcmpi(varNames, 'y'), 1, 'last');

    % 2) fallback: use the last two columns (robust for files where x,y are last)
    if isempty(xIdx) || isempty(yIdx)
        if numel(varNames) < 3
            error('Not enough columns to infer X/Y.');
        end
        xIdx = numel(varNames) - 1;
        yIdx = numel(varNames);
    end
end
