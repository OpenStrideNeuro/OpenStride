function showFigOnAxes(figPath, targetAxes)
% SHOWFIGONAXES  Load a .fig off-screen and replicate its axes onto a target axes.
%
% Purpose
% - Opens a source MATLAB figure file (.fig) invisibly and copies all graphics
%   children from its first axes onto a provided target axes.
% - Synchronizes important visual properties (limits, scales, colormap/CLim,
%   aspect ratios, view, labels, ticks/grid/box, fonts) and recreates legend.
%
% Inputs
% - figPath    : Path to the .fig file to load.
% - targetAxes : Handle to axes where the figure's content should be rendered.
%
% Behavior
% - If no axes are found in the source figure, clears target and exits.
% - Uses copyobj on all children of the source axes, then mirrors key visual
%   settings using best-effort try-blocks (robust to missing props).
% - Applies the source figure's colormap to the target axes (figure-scoped),
%   and reconstructs a legend if one exists.
%
% Output
% - No return value; `targetAxes` is modified in place to display the content.

    % Open source .fig invisibly
    hFig = openfig(figPath, 'invisible');  % safer than open()
    srcAx = findobj(hFig, 'Type', 'axes');
    if isempty(srcAx), cla(targetAxes); close(hFig); return; end
    srcAx = srcAx(1);

    % Clear target then copy graphics objects
    cla(targetAxes); hold(targetAxes, 'on');
    copyobj(allchild(srcAx), targetAxes);

    % ---- Sync critical visual properties ----
    % Limits & scales
    try, set(targetAxes,'XLim',get(srcAx,'XLim')); end
    try, set(targetAxes,'YLim',get(srcAx,'YLim')); end
    try, set(targetAxes,'ZLim',get(srcAx,'ZLim')); end
    try, set(targetAxes,'XScale',get(srcAx,'XScale')); end
    try, set(targetAxes,'YScale',get(srcAx,'YScale')); end
    try, set(targetAxes,'ZScale',get(srcAx,'ZScale')); end

    % Colormap & CLim (crucial for surface/patch colors)
    try
        cax = caxis(srcAx);
        caxis(targetAxes, cax);
    end
    try
        % colormap is figure-scoped; copy from source figure to target axes
        colormap(targetAxes, colormap(hFig));
    end

    % Aspect ratios / view
    try, set(targetAxes,'DataAspectRatio',get(srcAx,'DataAspectRatio')); end
    try, set(targetAxes,'DataAspectRatioMode',get(srcAx,'DataAspectRatioMode')); end
    try, set(targetAxes,'PlotBoxAspectRatio',get(srcAx,'PlotBoxAspectRatio')); end
    try, set(targetAxes,'PlotBoxAspectRatioMode',get(srcAx,'PlotBoxAspectRatioMode')); end
    try, view(targetAxes, get(srcAx,'View')); end

    % Labels / title
    try, xlabel(targetAxes, get(get(srcAx,'XLabel'),'String')); end
    try, ylabel(targetAxes, get(get(srcAx,'YLabel'),'String')); end
    try, zlabel(targetAxes, get(get(srcAx,'ZLabel'),'String')); end
    try, title(targetAxes,  get(get(srcAx,'Title' ),'String')); end

    % Ticks, grid, box
    try, set(targetAxes,'Box',get(srcAx,'Box')); end
    try, set(targetAxes,'XGrid',get(srcAx,'XGrid'),'YGrid',get(srcAx,'YGrid'),'ZGrid',get(srcAx,'ZGrid')); end
    try, set(targetAxes,'TickDir',get(srcAx,'TickDir'),'TickLength',get(srcAx,'TickLength')); end
    try, set(targetAxes,'Layer',get(srcAx,'Layer')); end

    % Fonts (optional but helps match look)
    try
        set(targetAxes, 'FontName', get(srcAx,'FontName'), ...
                        'FontSize', get(srcAx,'FontSize'), ...
                        'FontWeight', get(srcAx,'FontWeight'));
    end

    % Legend (recreate)
    try
        srcLeg = findobj(hFig,'Type','legend');
        if ~isempty(srcLeg) && isvalid(srcLeg(1))
            legStr = srcLeg(1).String;
            legend(targetAxes, legStr{:}, 'Location', srcLeg(1).Location);
        end
    end

    hold(targetAxes, 'off');
    close(hFig);
end
