%IMPOLY Create draggable, resizable polygon.
%   H = IMPOLY begins interactive placement of a polygon on the
%   current axes. The function returns H, a handle to an impoly object.
%
%   During interactive placement, left-click to place polygon
%   vertices. Double-click to add a vertex and finish initial placement of
%   the polygon. Right-click to finish initial placement of the polygon.
%   The function returns H, a handle to an impoly object. 
%
%   To add new vertices, position the pointer along an edge of the polygon
%   and press the "A" key. The pointer changes shape. Left-click to add a
%   vertex at the specified position.
%
%   The polygon has a context menu associated with it that allows you to
%   copy the current position to the clipboard and change the color used to
%   display the polygon. Right-click on the polygon to access this context
%   menu.
%
%   H = IMPOLY(HPARENT) begins interactive placement of a polygon on the
%   object specified by HPARENT. HPARENT specifies the HG parent of the
%   polygon graphics, which is typically an axes but can also be
%   any other object that can be the parent of an hggroup. 
%
%   H = IMPOLY(HPARENT,POSITION) creates a draggable, resizable polygon on
%   the object specified by HPARENT. POSITION is an N-by-2 array that
%   specifies the initial position of the vertices of the polygon. POSITION
%   has the form [X1,Y1;...;XN,YN].
%
%   H = IMPOLY(...,PARAM1,VAL1,PARAM2,VAL2,...) creates a draggable, resizable 
%   polygon, specifying parameters and corresponding values that control the 
%   behavior of the polygon. Parameter names can be abbreviated, and case does 
%   not matter.
%    
%   Parameters include:
%    
%   'Closed'                       A scalar logical that controls whether the 
%                                  polygon is closed. True creates a closed polygon. 
%                                  False creates an open polygon.
%
%   'PositionConstraintFcn'        Function handle fcn that is called whenever
%                                  the polygon is dragged using the mouse.
%                                  Type "help impoly/setPositionConstraintFcn"
%                                  for information on valid function
%                                  handles.
%
%   Methods
%   -------
%   Type "methods impoly" to see a list of the methods.
%
%   For more information about a particular method, type 
%   "help impoly/methodname" at the command line.
%       
%   Remarks
%   -------    
%   If you use IMPOLY with an axis that contains an image object, and do not
%   specify a position constraint function, users can drag the polygon outside the
%   extent of the image and lose the polygon.  When used with an axis created
%   by the PLOT function, the axis limits automatically expand to accommodate
%   the movement of the polygon.
%    
%   Example 1
%   ---------    
%   Display updated position in the title. Specify a position constraint function
%   using makeConstrainToRectFcn to keep the polygon inside the original xlim
%   and ylim ranges.
% 
%   figure, imshow('gantrycrane.png');
%   h = impoly(gca, [188,30; 189,142; 93,141; 13,41; 14,29]);
%   setColor(h,'yellow');    
%   addNewPositionCallback(h,@(p) title(mat2str(p,3)));
%   fcn = makeConstrainToRectFcn('impoly',get(gca,'XLim'),get(gca,'YLim'));
%   setPositionConstraintFcn(h,fcn);
%    
%   Example 2
%   ---------
%   Interactively place a polygon by clicking to specify vertex locations.
%   Double-click or right-click to finish positioning the polygon. Use wait
%   to block the MATLAB command line. Double-click on the polygon to
%   resume execution of the MATLAB command line.
%
%   figure, imshow('pout.tif');
%   h = impoly;
%   position = wait(h);  
%
%   See also  IMFREEHAND, IMLINE, IMRECT, IMPOINT, IMELLIPSE, IPTGETAPI, makeConstrainToRectFcn.

%   Copyright 2007-2010 The MathWorks, Inc.
%   $Revision: 1.1.6.16 $ $Date: 2010/09/13 16:14:17 $

classdef fnMyImpoly < imroi
    
    methods
        
        function obj = fnMyImpoly(varargin)
            %impoly  Constructor for impoly.

            [h_group,draw_api] = impolyAPI(varargin{:});
            obj = obj@imroi(h_group,draw_api);

        end

        function pos = getPosition(obj)
            %getPosition  Return current position of polygon.
            %
            %   pos = getPosition(h) returns the current position of the
            %   polygon h. The returned position, pos, is an N-by-2 array
            %   [X1 Y1;...;XN YN].
            
            pos = obj.api.getPosition();

        end
        
        function setPosition(obj,pos)
            %setPosition  Set polygon to new position.
            %
            %   setPosition(h,pos) sets the polygon h to a new position.
            %   The new position, pos, has the form [X1 Y1;...;XN YN].
            
            invalidPosition = ndims(pos) ~=2 || size(pos,2) ~=2 || ~isnumeric(pos);
            if invalidPosition
                error_id = sprintf('Images:%s:setPosition:invalidPosition',mfilename);
                error(error_id,...
                      'Invalid position specified. Position has the form [X1 Y1;...;XN YN].');
            end
            
            obj.api.setPosition(pos);
           
        end

        function setClosed(obj,TF)
            %setClosed  Set geometry of polygon.
            %
            %   setClosed(h,TF) sets the geometry of the polygon h. TF is a
            %   logical scalar. True means that the polygon is closed.
            %   False means that the polygon is an open polyline.

            obj.api.setClosed(TF);

        end
        
        function setVerticesDraggable(obj,TF)
            %setVerticesDraggable  Control whether vertices may be dragged.
            %
            %   setVerticesDraggable(h,TF) sets the interactive behavior of
            %   the vertices of the polygon h. TF is a logical scalar. True
            %   means that the vertices of the polygon are draggable. False
            %   means that the vertices of the polygon are not draggable.
           
            obj.api.setVerticesDraggable(TF);
            
        end
        
    end
    
    methods (Access = 'protected')
        
        function cmenu = getVertexContextMenu(obj)
           
            cmenu = obj.api.getVertexContextMenu();
            
        end
        
        function cmenu = getContextMenu(obj)

            cmenu = obj.api.getContextMenu();

        end
        
    end
    
end


function [h_group,draw_api] = impolyAPI(varargin)

    
  [commonArgs,specificArgs] = roiParseInputs(0,2,varargin,mfilename,{'Closed'});
  
  xy_position_vectors_specified = (nargin > 2) && ...
                                  isnumeric(varargin{2}) && ...
                                  isnumeric(varargin{3});
  
  if xy_position_vectors_specified
      error(sprintf('Images:%s:invalidPosition',mfilename),...
            'Position must be specified in the form [X1,Y1;...;XN,YN].');
  end
  
  position              = commonArgs.Position;
  interactive_placement = commonArgs.InteractivePlacement;
  h_parent              = commonArgs.Parent;
  h_axes                = commonArgs.Axes;
  h_fig                 = commonArgs.Fig;
  
  positionConstraintFcn = commonArgs.PositionConstraintFcn;
  if isempty(positionConstraintFcn)
      % constraint_function is used by dragMotion() to give a client the
      % opportunity to constrain where the point can be dragged.
      positionConstraintFcn = identityFcn;
  end

  is_closed = specificArgs.Closed;
     
  try
    h_group = hggroup('Parent', h_parent,'Tag','impoly');
  catch ME
    error(sprintf('Images:%s:noAxesAncestor',mfilename), ...
          'HPARENT must be able to have an hggroup object as a child.');
  end
   
  draw_api = polygonSymbol();
  
  basicPolygonAPI = basicPolygon(h_group,draw_api,positionConstraintFcn);
  
  % Handles to each of the polygon vertices
  h_vertices = {};
  
  % Handle to currently active vertex
  h_active_vertex = [];
  
  % Function scoped variable that keeps track of whether A key is
  % depressed.
  a_down = false;
  
  % Alias functions defined in basicPolygonAPI to shorten calling syntax in
  % impoly.
  setPosition               = basicPolygonAPI.setPosition;
  setConstrainedPosition    = basicPolygonAPI.setConstrainedPosition;
  getPosition               = basicPolygonAPI.getPosition;
  setClosed                 = basicPolygonAPI.setClosed;
  setVisible                = basicPolygonAPI.setVisible;
  updateView                = basicPolygonAPI.updateView;
  addNewPositionCallback    = basicPolygonAPI.addNewPositionCallback;
  deletePolygon             = basicPolygonAPI.delete;
     
  if interactive_placement
  	  setClosed(false);
      setVisible(true);

      % Create listener for changes to the active MATLAB figure ui mode. If
      % a figure mode becomes active during interactive placement, we stop
      % the "active" line segment animation
      animate_id = [];
      fig_mode_manager = uigetmodemanager(h_fig);
      mode_listener = handle.listener(fig_mode_manager, ...
          fig_mode_manager.findprop('CurrentMode'), ...
          'PropertyPostSet', @newFigureMode); %#ok<NASGU>
      
  	  animate_id(end+1) = iptaddcallback(h_fig,'WindowButtonMotionFcn',@animateLine);
      placement_aborted = manageInteractivePlacement(h_axes,h_group,@placePolygon,@buttonUpPlacement);
      for cb_id = 1:numel(animate_id)
          iptremovecallback(h_fig,'WindowButtonMotionFcn',...
              animate_id(cb_id));
      end
      clear mode_listener;
      if placement_aborted
          h_group = [];
          return;
      end
  else
      % Create vertices in initial locations specified by user.    
      setPosition(position);
      createVertices();
  end
  
  setClosed(is_closed);
  setVisible(true);
  draw_api.pointerManagePolygon(true);
  
  % Create context menu for polygon body and vertices once initial placement
  % of polygon is complete. Create context menus after possible
  % buttonUp event during interactive placement to avoid posting context
  % menus during right click interactive placement gestures.
  
  % setColor called within createROIContextMenu requires that cmenu_poly is
  % an initialized variable.
  cmenu_poly =[];
  cmenu_vertices = [];
  
  % Cache current color so that color of new vertices can be kept in sync
  % with tool as they are added.
  current_color = [];
    
%   cmenu_poly     = createROIContextMenu(h_fig,getPosition,@setColor);
%   setContextMenu(cmenu_poly);
 
  cmenu_vertices = createVertexContextMenu();
  setVertexContextMenu(cmenu_vertices);
    
  set(h_group,'DeleteFcn',@cleanUpPolygon);
  
  % Wire new position callback to update vertex position whenever position
  % matrix of polygon changes
  addNewPositionCallback(@updateVertexPositions);
  
  % Wire callbacks to provide A+click gesture to insert new vertices
  a_click_id = iptaddcallback(h_fig,'WindowButtonDownFcn',@aClickInsert);
  key_down_id = iptaddcallback(h_fig,'WindowKeyPressFcn',@aDown);
  key_up_id = iptaddcallback(h_fig,'WindowKeyReleaseFcn',@aUp);
  
      
  % Define API
  api.setPosition               = setPosition;
  api.setConstrainedPosition    = setConstrainedPosition;
  api.getPosition               = getPosition;
  api.setClosed                 = setClosed;
  api.addNewPositionCallback    = addNewPositionCallback;
  api.delete                    = deletePolygon;
  api.setVerticesDraggable      = draw_api.showVertices;
  api.removeNewPositionCallback = basicPolygonAPI.removeNewPositionCallback;
  api.getPositionConstraintFcn  = basicPolygonAPI.getPositionConstraintFcn;
  api.setPositionConstraintFcn  = basicPolygonAPI.setPositionConstraintFcn;
  api.setColor                  = @setColor;
  
  % Undocumented API methods.
  api.setContextMenu       = @setContextMenu;
  api.getContextMenu       = @getContextMenu;
  api.setVertexContextMenu = @setVertexContextMenu;
  api.getVertexContextMenu = @getVertexContextMenu;
  
  iptsetapi(h_group,api);
  
  updateView(getPosition());
      
    %----------------------------
    function aDown(h_fig,evt) %#ok<INUSL>
       
        if strcmp(evt.Key,'a');
            a_down = true;
        end
        
    end


    %--------------------------
    function aUp(h_fig,evt) %#ok<INUSL>
        
        if strcmp(evt.Key,'a');
            a_down = false;
        end
        
    end
  
    %------------------------------------------
    function aClickInsert(h_fig,evt)
  
        if ~a_down
            return;
        end
           
        if feature('HGUsingMATLABClasses')
            h_hit = evt.HitObject;
        else
            h_hit = hittest(h_fig);
        end
               
        hit_line = strcmp(get(h_hit,'type'),'line') && ...
            (ancestor(h_hit,'hggroup') == h_group);
        
        if hit_line
            x_line = get(h_hit,'XData');
            y_line = get(h_hit,'YData');
            
            new_ind = getInsertVertex(x_line,y_line);
            [x_pos,y_pos] = getCurrentPoint(h_axes);
            mouse_pos = [x_pos,y_pos];
            insertPos = getPositionOnLine(x_line,y_line,mouse_pos);
                       
            addVertex(insertPos,new_ind);
            setVertexContextMenu(cmenu_vertices);
            setContextMenu(cmenu_poly);
            setVertexPointerBehavior();
            setColor(current_color);
               
        end
        
        %------------------------------------------------
        function new_ind = getInsertVertex(x_line,y_line)
            
            vert1 = repmat([x_line(1) y_line(1)],getNumVert(),1);
            vert2 = repmat([x_line(2) y_line(2)],getNumVert(),1);
            
            ind1 = find(all(vert1 == getPosition(),2));
            ind2 = find(all(vert2 == getPosition(),2));
            
            duplicate_vertices = length(ind1) > 1 || length(ind2) > 1;
            if duplicate_vertices
                
                found_ind = false;
                for i = 1:length(ind1)
                    if found_ind
                        break;
                    end
                    
                    for j = 1:length(ind2)
                        % In the case of duplicate vertices, choose the set
                        % of vertices that are correctly directly. Direct
                        % connection means being spaced one row apart in
                        % the position matrix.
                        between_first_and_last = abs(ind1(i) - ind2(j)) == getNumVert()-1;
                        spaced_one_apart = (abs(ind1(i) - ind2(j)) == 1)||...
                                           between_first_and_last;
                                       
                        if  spaced_one_apart
                            ind1 = ind1(i);
                            ind2 = ind2(j);
                            found_ind = true;
                            break;
                        end
                        
                    end
                    
                end
                
            end
                        
            between_first_and_last = any([ind1 ind2] == getNumVert()) &&...
                                     any([ind1 ind2] == 1);
            
            if between_first_and_last
                new_ind = getNumVert()+1;
            else
                new_ind = min([ind1,ind2])+1;
            end
            
        end
        
        %--------------------------------------------------------------
        function insertPos = getPositionOnLine(x_line,y_line,mouse_pos)
         % Interactive polygon addition picks the closest point that lies
         % exactly along the line between two vertices. Since the perimter
         % line has width associated with it, the location where button
         % down occurs along the line has to be tuned slightly.
            
            %v1 is vector along polygon line segment
            v1 = [diff(x_line),diff(y_line)];
            
            % v2 is a vector from vertex to current mouse position
            v2 = [mouse_pos(1)-x_line(1),mouse_pos(2)-y_line(1)];
            
            %project parallel portion of v2 onto v1 to find point where
            %perpendicular bisector of current point to line segment connects
            insertPos = (dot(v1,v2)./dot(v1,v1)).*v1 +[x_line(1) y_line(1)];
   
        end
        
    end
  
    %-----------------------
    function setColor(color)
        if ishghandle(getContextMenu())
            updateColorContextMenu(getVertexContextMenu(),color);
            updateColorContextMenu(getContextMenu(),color);
        end
        draw_api.setColor(color);
        current_color = color;
    end

    %----------------------------- 
    function setContextMenu(cmenu_new)
      
       cmenu_obj = findobj(h_group,'Type','line','-or','Type','patch');  
       set(cmenu_obj,'uicontextmenu',cmenu_new);
       
       cmenu_poly = cmenu_new;
        
    end
    
    %-------------------------------------
    function context_menu = getContextMenu
       
        context_menu = cmenu_poly;
    
    end
  
    %-----------------------------------
    function setVertexContextMenu(cmenu_new)
       
        for i = 1:getNumVert()
           set(getVertexHGGroup(h_vertices{i}),'UIContextMenu',cmenu_new); 
        end
        
        cmenu_vertices = cmenu_new;
          
    end

    %-------------------------------------------
    function vertex_cmenu = getVertexContextMenu
    
        % All of the vertices in the polygon shares the same UIContextMenu
        % object. Obtain the shared uicontextmenu from the first vertex in
        % the polygon.
        vertex_cmenu = get(getVertexHGGroup(h_vertices{1}),'UIContextMenu');
        
    end
        
    %--------------------------------
    function cleanUpPolygon(varargin)
       
        deleteContextMenu();
        
        iptremovecallback(h_fig,'WindowbuttonDownFcn',a_click_id);
        iptremovecallback(h_fig,'WindowKeyPressFcn',key_down_id);
        iptremovecallback(h_fig,'WindowKeyReleaseFcn',key_up_id);
        
        %Remove callbacks added to listen for key press for cursor
        %management.
        draw_api.unwireShiftKeyPointAffordance();
        
    end

    %------------------------- 
    function deleteContextMenu
        if ishghandle(cmenu_poly)
            delete([cmenu_poly,cmenu_vertices]);
        end
        
    end

    %------------------------------
    function newFigureMode(obj,evt) %#ok<INUSL>
        % disable line animation when we have an active mode
        
        modeManager = get(evt.AffectedObject);
        if isempty(modeManager.CurrentMode)
            animate_id(end+1) = iptaddcallback(h_fig,...
                'WindowButtonMotionFcn',@animateLine);
        else
            for i = 1:numel(animate_id)
                iptremovecallback(h_fig,'WindowButtonMotionFcn',...
                    animate_id(i));
            end
            updateView(getPosition());
        end
    end % newFigureMode
 
    %-----------------------------
	function animateLine(varargin)
        		
		[x_init,y_init] = getCurrentPoint(h_axes);
        animate_pos = [getPosition(); x_init, y_init];
		updateView(animate_pos);
		
	end % animateLine
 
    %-------------------------------------
	function completed = placePolygon(x,y)
      	
	    is_double_click = strcmp(get(h_fig,'SelectionType'),'open');
	    is_right_click  = strcmp(get(h_fig,'SelectionType'),'alt');
        is_left_click = strcmp(get(h_fig, 'SelectionType'), 'normal');
        
        if ~is_left_click && (getNumVert()==0)
            completed = false;
            return
        end
	    
	    h_hit_test = hittest(h_fig);
        
        % Get hggroup that contains impoint HG group graphics objects so
        % that you can compare the output of hittest with the graphics of
        % the first vertex.       
        clicked_on_first_vertex = ...
                    ~isempty(h_vertices) &&...
                    h_hit_test == getVertexHGGroup(h_vertices{1});
	    
        completed = is_double_click || (is_closed && clicked_on_first_vertex);
	    
        % Distinction between right click and other completion gestures is
        % that right click placement ends on buttonUp.
        if completed || is_right_click
            setVertexPointerBehavior();
        else
            addVertex([x,y],getNumVert()+1);

            % Provide circle affordance to first vertex to communicate that polygon can
            % be closed by clicking on first vertex.
            if ( is_closed && (getNumVert() == 1) )
                setVertexPointerBehavior();
            end

        end
         
    end %placePolygon
    
    %-------------------------------------
    function completed = buttonUpPlacement
 
        completed  = strcmp(get(h_fig,'SelectionType'),'alt') &&...
                     getNumVert() > 0;
        
    end
  
    %--------------------------------
	function setVertexPointerBehavior

		for i = 1:getNumVert()
            
            iptSetPointerBehavior(h_vertices{i},...
                                @(h_fig,loc) set(h_fig,'Pointer','circle'));
                                
		end

	end %setVertexPointerBehavior

    %-----------------------------
    function num_vert = getNumVert
       
        num_vert = size(getPosition(),1);
        
    end
    
    %-------------------------------------
    function h_group = getVertexHGGroup(p)
       
        h_group = findobj(p,'type','hggroup');
        
    end

    %----------------------------------
    function idx = getActiveVertexIndex
       
        getActiveVertexIdx = @(p) isequal(getVertexHGGroup(p),h_active_vertex);
        idx = cellfun(getActiveVertexIdx,h_vertices);
        
    end
    
    %----------------------------------
    function updateVertexPositions(pos)
        % This function is called whenever the position of the polygon
        % changes. This function manages each impoint vertex instance to
        % keep each vertex in the appropriate position. If a user calls
        % setPosition with a different number of vertices than are
        % currently in the polygon, we delete all vertices and create the
        % require number of vertices from scratch.
        
        num_vert_drawn = length(h_vertices);
        if num_vert_drawn ~= getNumVert()
        
            for i = 1:num_vert_drawn
                h_vertices{i}.delete();
            end
            createVertices();
            setVertexContextMenu(cmenu_vertices);
            setContextMenu(cmenu_poly);
        else
                    
            for i = 1:getNumVert()
                h_vertices{i}.setPosition(pos(i,:));
            end
        end
               
    end %setPosition
    

    %--------------------------
    function vertexDragged(pos)
        
        candidate_position = getPosition();
        candidate_position(getActiveVertexIndex(),:) = pos;
        
        setConstrainedPosition(candidate_position);
                  
    end %vertexDragged
    
    %----------------------------------
    function vertexButtonDown(h_vertex) 
    
        h_active_vertex = h_vertex;
        
    end %vertexButtonDown
	      
    %----------------------
    function createVertices
    
        % If the number of vertices being drawn is being adjusted via a
        % call to setPosition, re-initialize h_vertices
        h_vertices = {};
        
        pos = getPosition();
        for i = 1:getNumVert()
            h_vertices{i} =  iptui.impolyVertex(h_group,pos(i,1),pos(i,2));
            
            % This is necessary to ensure that vertices are drawn with the
            % right color when setPosition alters the number of vertices
            % via updateVertexPositions
            h_vertices{i}.setColor(draw_api.getColor())
            
            % This pattern is done twice, however performance is better inline
            % than as a separate subfunction.
            addlistener(h_vertices{i}, 'ImpointButtonDown', ...
                @(vert,data) vertexButtonDown(getVertexHGGroup(vert)));
            
            addlistener(h_vertices{i}, 'ImpointDragged', ...
                @(vert,data) vertexDragged(vert.getPosition()));
              
        end
        setVertexPointerBehavior();
       	  
    end %createVertices
    
    %--------------------------
    function addVertex(pos,idx)
    % addVertex adds the vertex position pos to index idx of the resized (N+1)
    % by 2 position matrix.
        
		position = getPosition();
        num_vert = getNumVert() + 1;
              
        position_new = zeros(num_vert,2);
        h_vertices_new = cell(1,num_vert);
        
        position_new(idx,:) = pos;
        h_vertices_new{idx} = iptui.impolyVertex(h_group,pos(1),pos(2));
        
        % This pattern is done twice, however performance is better inline
        % than as a separate subfunction.
        addlistener(h_vertices_new{idx}, 'ImpointButtonDown', ...
            @(vert,data) vertexButtonDown(getVertexHGGroup(vert)));
        
        addlistener(h_vertices_new{idx}, 'ImpointDragged', ...
            @(vert,data) vertexDragged(vert.getPosition()));
                
        if num_vert > 1
      	  
             left_ind = 1:idx-1;
              right_ind = idx+1:num_vert;
          	  position_new(left_ind,:) = position(left_ind,:);
                h_vertices_new(left_ind) = h_vertices(left_ind);
          	  position_new(right_ind,:) = position(right_ind-1,:);
          	  h_vertices_new(right_ind) = h_vertices(right_ind-1);
          
      	  
        end	 
        
        h_vertices = h_vertices_new;
        
		setPosition(position_new);
       
    end %addVertex
    
    %----------------------------------------------
    function vertex_cmenu = createVertexContextMenu
    % createVertexContextMenu creates a single context menu at the figure level
    % that is shared by all of the impoint instances used to define
    % vertices.  
        
        vertex_cmenu = createROIContextMenu(h_fig,getPosition,@setColor);
        uimenu(vertex_cmenu,...
            'Label','Delete Vertex',...
            'Tag','delete vertex cmenu item',...
            'Callback',@deleteVertex);
        
        uimenu(vertex_cmenu,...
            'Label','Split Vertex',...
            'Tag','split vertex cmenu item',...
            'Callback',@splitVertex);
         
        
        
       %------------------------------
        function splitVertex(varargin)

            %Each vertex has a buttonDown callback wired to it which caches the last
            %vertex that was clicked on. The last vertex that received
            %buttonDown is the vertex which posted the delete context menu
            %option.
            idx = find(getActiveVertexIndex());            
            position = getPosition();

            numpts = size(position,1);
            iBefore = idx-1;
            if iBefore <= 0
                iBefore = numpts;
            end
            
%             iAfter = idx+1;
%             if iAfter >numpts
%                 iAfter = 1;
%             end
            
            pt_idx = position(idx,:);
            pt_bef = position(iBefore,:);
%             pt_aft = position(iAfter,:);
            addVertex((pt_idx+pt_bef)/2,idx);
              
               setVertexContextMenu(cmenu_vertices);
             setContextMenu(cmenu_poly);
            setVertexPointerBehavior();
            
        
            % Refresh pointer so that vertex affordance isn't showing if
            % you are no longer over a vertex
            iptPointerManager(h_fig,'Enable');

        end %deleteVertex
        
        %------------------------------
        function deleteVertex(varargin)

            %Each vertex has a buttonDown callback wired to it which caches the last
            %vertex that was clicked on. The last vertex that received
            %buttonDown is the vertex which posted the delete context menu
            %option.
            idx = getActiveVertexIndex();
            vertex_being_deleted = h_vertices{idx};
            
            position = getPosition();

            h_vertices = h_vertices(~idx);
            position_new = position(~idx,:);

            vertex_being_deleted.delete();

            if ~isempty(position_new)
                setPosition(position_new);
            else
                % If the last vertex has been deleted, the entire polygon
                % should be destroyed.
                deletePolygon();

            end

            % Refresh pointer so that vertex affordance isn't showing if
            % you are no longer over a vertex
            iptPointerManager(h_fig,'Enable');

        end %deleteVertex

    end %createVertexContextMenu
    
end %impoly

% This is a workaround to g411666. Need pragma to allow ROIs to compile
% properly.
%#function imroi
