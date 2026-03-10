function analysisMain(app, mode)
% ANALYSISMAIN  Orchestrate analyses (Tremor, Distance/Speed, Ataxia, LMB) over selected files.
%
% Purpose
% - Coordinates how input data files are processed based on the chosen mode:
%   'single'   : run analyses on exactly one file.
%   'combine'  : concatenate all files (sorted by first column) and analyze as a single dataset.
%   'separate' : analyze each file independently.
% - Manages UI state (disables/enables buttons, updates listbox, progress text).
%
% Inputs
% - app  : App handle providing UI state, options (checkboxes), and helper methods.
% - mode : Char/str, one of {'single','combine','separate'}.
%
% Behavior
% - Disables action buttons during processing; re-enables them at the end via setResultButton(app).
% - Reads `app.data` (file paths), filters each file via filtering(...), and dispatches to:
%     * tremorTest(app, dataTable, fs, label)
%     * distspeed(dataTable, fs, resultPath, label)
%     * ataxiaTest(app, dataTable, fs, resultPath, label)
%     * LMB(app, dataTable, fs, resultPath, label)
% - Updates a progress label before each selected analysis.
%
% Output
% - No return value; results are written to disk by the respective analysis functions,
%   and the UI components are updated in-place.

% Disable UI buttons during processing
app.AtaxiaButton.Enable = 'off';
app.LowMobilityBoutsButton.Enable = 'off';
app.DistanceSpeedButton.Enable = 'off';
app.TremorButton.Enable = 'off';

% Resolve common inputs
resultPath = app.resultStoragePath;
data = app.data;
fs = 125;

% Extract file names for UI listbox
filePath = cellstr(data);
[~, fileNames, ~] = cellfun(@fileparts, filePath, 'UniformOutput', false);
app.updateListbox(fileNames);

% Mode-specific dispatch
switch mode
    case 'single'
        % Require exactly one file
        if length(data) ~= 1
            uialert(app.UIFigure, 'Single mode requires exactly one file.', 'Error');
            setResultButton(app);
            return;
        end
        filtered = filtering(data{1});
        fileName = fileNames{1};
        processAllAnalyses(filtered, fs, resultPath, fileName);

    case 'combine'
        % Concatenate all filtered tables; sort by first column (time/index)
        allData = [];
        for i = 1:length(data)
            filtered = filtering(data{i});
            allData = [allData; filtered];
        end
        allData = sortrows(allData, 1);
        processAllAnalyses(allData, fs, resultPath, 'CombinedData');

    case 'separate'
        % Process each file independently
        for i = 1:length(data)
            filtered = filtering(data{i});
            fileName = fileNames{i};
            processAllAnalyses(filtered, fs, resultPath, fileName);
        end

    otherwise
        % Unknown mode guard
        uialert(app.UIFigure, ['Unknown mode: ' mode], 'Error');
end

% Re-enable UI buttons and finalize state
setResultButton(app);

    % -------- Helper: run all selected analyses on a given table --------
    function processAllAnalyses(dataTable, fs, resultPath, label)
        if app.TremorCheckBox.Value
            app.ProgressLabel.Text = sprintf('Processing Tremor Analysis (%s)', label);
            tremorTest(app, dataTable, fs, label);
        end
        if app.DistanceSpeedCheckBox.Value
            app.ProgressLabel.Text = sprintf('Processing Distance/Speed Analysis (%s)', label);
            distspeed(dataTable, fs, resultPath, label);
        end
        if app.AtaxiaCheckBox.Value
            app.ProgressLabel.Text = sprintf('Processing Ataxia Analysis (%s)', label);
            ataxiaTest(app, dataTable, fs, resultPath, label);
        end
        if app.LowMobilityBoutsCheckBox.Value
            app.ProgressLabel.Text = sprintf('Processing Low Mobility Bouts Analysis (%s)', label);
            LMB(app, dataTable, fs, resultPath, label);
        end
    end

end
