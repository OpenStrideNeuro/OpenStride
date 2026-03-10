function fixplot()
    % fix plots for presentation
    % need to call for each selection of figure
    set(findobj('Type','line'),'LineWidth',2);
    set(findobj('Type','text'),'FontSize',12);
    set(findobj('Type','axes'),'FontSize',14);
    set(get(gca,'XLabel'),'FontSize',14);
    set(get(gca,'YLabel'),'FontSize',14);
    set(get(gca,'ZLabel'),'FontSize',14);
    set(get(gca,'Title'),'FontSize',14);
    
    set(gcf, 'color', 'white');     % sets the outer color to white
    set(gca, 'Box', 'off');         % turn off the full box
    set(gca, 'TickDir', 'out');     % ticks go out from axes
    set(gca,'LineWidth', 2);
    set(gca,'Label')
return