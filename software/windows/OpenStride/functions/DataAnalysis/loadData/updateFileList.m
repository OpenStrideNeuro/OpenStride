function updateFileList(app, action)
% UPDATEFILELIST Reorder or remove items in the file list UI and sync app.data.

    % Current UI items
    items = app.FileList.Items;

    % Ignore placeholder when checking real data
    placeholder = 'Please import data file(s)';
    hasPlaceholderOnly = isscalar(items) && strcmp(items{1}, placeholder);

    if isempty(items) || hasPlaceholderOnly
        return;
    end

    % Resolve current selection
    selectedIndex = find(strcmp(items, app.FileList.Value), 1);

    % Early exit if nothing selected
    if isempty(selectedIndex)
        return;
    end

    switch action
        case 'up'
            if selectedIndex > 1
                [items{selectedIndex-1}, items{selectedIndex}] = deal(items{selectedIndex}, items{selectedIndex-1});
                app.FileList.Items = items;
                app.FileList.Value = items{selectedIndex-1};
            end

        case 'down'
            if selectedIndex < numel(items)
                [items{selectedIndex+1}, items{selectedIndex}] = deal(items{selectedIndex}, items{selectedIndex+1});
                app.FileList.Items = items;
                app.FileList.Value = items{selectedIndex+1};
            end

        case 'remove'
            items(selectedIndex) = [];

            if isempty(items)
                % UI shows placeholder, but app.data stays empty
                app.FileList.Items = {placeholder};
                app.FileList.Value = placeholder;

                app.MoveDownButton.Enable = 'off';
                app.MoveUpButton.Enable = 'off';
                app.RemoveButton.Enable = 'off';

                app.data = {};
            else
                % Update Items first, then Value
                app.FileList.Items = items;
                app.FileList.Value = items{min(selectedIndex, numel(items))};

                app.MoveDownButton.Enable = 'on';
                app.MoveUpButton.Enable = 'on';
                app.RemoveButton.Enable = 'on';

                app.data = items;
            end
            return;
    end

    % Sync app.data for up/down
    app.data = items;
end