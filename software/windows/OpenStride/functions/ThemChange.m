function ThemChange(app, mode)
    switch upper(mode)
        case "R"
            bgColor      = [0.8000   0.8392   0.8510];
            buttonColor  = [0.7294   0.7804   0.7882];
            panelColor   = [0.7294   0.7804   0.7882];
            fontColor    = [1 1 1];             
            machineColor = [56 189 248] / 255;  


            if isprop(app, 'AdvancedPanel')
                app.AdvancedPanel.Enable = "on";
            end

        case "A"
            bgColor      = [51 65 85] / 255;    
            buttonColor  = [34 197 94] / 255;   
            fontColor    = [1 1 1];
            machineColor = [249 115 22] / 255;  % #F97316

            if isprop(app, 'AdvancedPanel')
                app.AdvancedPanel.Enable = "off";
            end

        otherwise
            warning("Unknown MODE: %s", mode);
            return;
    end

    if isprop(app, 'GridLayout')
        app.GridLayout.BackgroundColor = bgColor;
    end
    if isprop(app, 'GridLayout_A')
        app.GridLayout_A.BackgroundColor = bgColor;
    end

    if isprop(app, 'GridLayout_R')
        app.GridLayout_R.BackgroundColor = bgColor;
    end

    if isprop(app, 'OperatingSystemLabel')
        app.OperatingSystemLabel.BackgroundColor = bgColor;
    end

    % Panel Color
    if isprop(app, 'ExportSettingsPanel')
        app.ExportSettingsPanel.BackgroundColor = panelColor;
    end

    if isprop(app, 'GridLayout15')
        app.GridLayout15.BackgroundColor = panelColor;
    end

    if isprop(app, 'AcquisitionSettingsPanel')
        app.AcquisitionSettingsPanel.BackgroundColor = panelColor;
    end

    if isprop(app, 'GridLayout17')
        app.GridLayout17.BackgroundColor = panelColor;
    end

    % % 按钮颜色
    if isprop(app, 'ModeSwitch')
        app.ModeSwitch.BackgroundColor = buttonColor;
        app.ModeSwitch.FontColor = fontColor;
    end
    % 
    % if isprop(app, 'StopButton')
    %     app.StopButton.BackgroundColor = buttonColor;
    %     app.StopButton.FontColor = fontColor;
    % end
    % 
    % % 机器显示颜色（示例：用 patch 或 line）
    % if isprop(app, 'MachinePatch')
    %     app.MachinePatch.FaceColor = machineColor;
    % end
    % 
    % if isprop(app, 'MachineLine')
    %     app.MachineLine.Color = machineColor;
    % end

end
