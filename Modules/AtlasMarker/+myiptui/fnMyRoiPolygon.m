classdef fnMyRoiPolygon < impoly

    methods

    
        function obj = fnMyRoiPolygon(h_parent,finished_cmenu_text,X,Y)

            obj = iptui.impoly(h_parent,[X,Y]);
            if ~isempty(obj)
                obj.setupContextMenu(finished_cmenu_text);
            end

        end

        function setupContextMenu(obj,finished_cmenu_text)

            % get polygon context menus
            body_cmenu   = obj.getContextMenu();
            vertex_cmenu = obj.getVertexContextMenu();

            uimenu(body_cmenu,...
                'Label',finished_cmenu_text,...
                'Tag',sprintf('%s cmenu item',lower(finished_cmenu_text)),...
                'Callback',@(varargin) obj.resume());

            % setup 'Cancel' context menu item and 'ESC' key callback
            uimenu(body_cmenu,'Label','Cancel','Tag','cancel cmenu item',...
                'Callback', @(varargin) obj.delete());

            create_mask_item = uimenu(vertex_cmenu,...
                'Label',finished_cmenu_text,...
                'Tag', sprintf('%s cmenu item',lower(finished_cmenu_text)),...
                'Callback',@(varargin) obj.resume());

            %Switch order of delete and create mask cmenu items so that Delete is
            %last option in context menu
            vertex_menu_children = get(vertex_cmenu,'Children');
            delete_vertex_item = findobj(vertex_cmenu,'tag','delete vertex cmenu item');

            other_idx = ~ismember(vertex_menu_children,...
                [delete_vertex_item,create_mask_item]);

            other_items = vertex_menu_children(other_idx);

            vertex_menu_children = [delete_vertex_item,create_mask_item,...
                other_items'];

            set(vertex_cmenu,'Children',vertex_menu_children);

        end

    end

end
