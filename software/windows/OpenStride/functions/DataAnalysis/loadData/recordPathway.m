function result = recordPathway(app)
% RECORDPATHWAY  Create an analysis output folder structure and write a run log.
%
% Purpose
% - Builds a timestamped (or user-named) parent folder under app.outputAnalysisFolderPath.
% - Creates subfolders for each enabled analysis module (Tremor, DisplacementAndSpeed, Ataxia, LowMobilityBouts).
% - Writes an Information.txt file summarizing the run time, input data files, enabled modules,
%   and selected parameters (tremor band, ataxia thresholds, plot options).
%
% Input
% - app : App handle exposing UI values and output path fields
%         (e.g., app.OutputFolderNameEditField, app.TremorCheckBox, app.data, etc.).
%
% Behavior
% - Uses current timestamp as folder name when no custom name is provided.
% - Creates missing directories as needed.
% - Logs a concise summary of the analysis configuration into Information.txt.
%
% Output
% - result : Absolute path to the created analysis folder.

    %% Step 1: Resolve folder name (timestamp fallback)
    timestamp = datestr(now, 'yyyy-mm-dd_HH-MM-SS');
    if isempty(app.OutputFolderNameEditField.Value)
        folderName = char(timestamp);
    else
        folderName = app.OutputFolderNameEditField.Value;
    end

    %% Step 2: Create main output folder
    newFolderPath = fullfile(app.outputAnalysisFolderPath, folderName);
    if ~exist(newFolderPath, 'dir')
        mkdir(newFolderPath);
    end

    %% Step 3: Collect analysis module toggles
    analysisOptions = {
        'Tremor',                app.TremorCheckBox.Value;
        'DisplacementAndSpeed',  app.DistanceSpeedCheckBox.Value;
        'Ataxia',                app.AtaxiaCheckBox.Value;
        'LowMobilityBouts',      app.LowMobilityBoutsCheckBox.Value
    };

    %% Step 4: Create subfolders for enabled analyses
    for i = 1:size(analysisOptions,1)
        name = analysisOptions{i,1};
        enabled = analysisOptions{i,2};
        if enabled
            subFolder = fullfile(newFolderPath, name);
            if ~exist(subFolder, 'dir')
                mkdir(subFolder);
            end
        end
    end

    %% Step 5: Start Information.txt and log data sources + enabled modules
    txtFilePath = fullfile(newFolderPath, 'Information.txt');
    fid = fopen(txtFilePath, 'w');

    fprintf(fid, 'Analysis time: (%s)\n\n', char(timestamp));
    for i = 1:numel(app.data)
        fprintf(fid, 'Data %d: (%s)\n', i, char(app.data{i}));
    end
    fprintf(fid, '\n----- This analysis includes -----\n');

    for i = 1:size(analysisOptions,1)
        name = analysisOptions{i,1};
        enabled = analysisOptions{i,2};
        if enabled
            fprintf(fid, '%s\n', name);
        end
    end

    %% Step 6: Log detailed parameters for selected analyses
    if app.TremorCheckBox.Value == 1
        fprintf(fid, '  Tremor frequency: %d - %d Hz\n', ...
            app.lowerTremorFrequency.Value, app.higherTremorFrequency.Value);
    end
    app.higherTremorFrequency.Value
    if app.AtaxiaCheckBox.Value == 1
        fprintf(fid, '  Ataixa threshold: %d mm\n', app.SoGThreshold.Value);
        fprintf(fid, '  Max X: %d, Max Y: %d\n', app.xMaximum.Value, app.yMaximum.Value);
        if app.SurfacePlotCheckBox.Value == 1
            fprintf(fid, '  Includes surface plots\n');
        end
    end

    fclose(fid);

    %% Step 7: Return analysis folder path
    result = newFolderPath;

end
