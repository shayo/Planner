function varargout = GridHelper(varargin)
% GRIDHELPER M-file for GridHelper.fig
%      GRIDHELPER, by itself, creates a new GRIDHELPER or raises the existing
%      singleton*.
%
%      H = GRIDHELPER returns the handle to a new GRIDHELPER or the handle to
%      the existing singleton*.
%
%      GRIDHELPER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GRIDHELPER.M with the given input arguments.
%
%      GRIDHELPER('Property','Value',...) creates a new GRIDHELPER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GridHelper_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GridHelper_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GridHelper

% Last Modified by GUIDE v2.5 21-Mar-2011 08:39:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @GridHelper_OpeningFcn, ...
    'gui_OutputFcn',  @GridHelper_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before GridHelper is made visible.
function GridHelper_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GridHelper (see VARARGIN)

% Choose default command line output for GridHelper
handles.output = hObject;
setappdata(handles.figure1,'bMouseDown',false);
if length(varargin) >= 1
    strCommand = varargin{1};
    switch strCommand
        case 'InitNewGrid'
            fnMyCameraToolBar(handles.figure1,'show',handles.hGridAxes3D);
%             fnMyCameraToolBar(handles.figure1,'setcoordsys','none');
%             fnMyCameraToolBar(handles.figure1,'setmode','orbit');

            strctPlannerInfo = varargin{2};
            strctGridModel = varargin{3};
            strctGridFunc = varargin{4};
            strGridName = varargin{5};
            setappdata(handles.figure1,'strctPlannerInfo',strctPlannerInfo);
            setappdata(handles.figure1,'strctGridModel',strctGridModel);
            setappdata(handles.figure1,'strctGridFunc',strctGridFunc);
            
            setappdata(handles.figure1,'iCurrentParameter',1);
            
            hGridAxesMenu = uicontextmenu('Callback',{@fnMouseDownEmulator,handles});
            uimenu(hGridAxesMenu, 'Label', 'Align to grid hole','Callback', {@fnAlignToGridHole,handles});
            uimenu(hGridAxesMenu, 'Label', 'MIP Func (neg)','Callback', {@fnGridMIPFuncNeg,handles});
            uimenu(hGridAxesMenu, 'Label', 'MIP Func (pos)','Callback', {@fnGridMIPFuncPos,handles});
            uimenu(hGridAxesMenu, 'Label', 'MIP Vessels','Callback', {@fnGridMIPVessels,handles});
            uimenu(hGridAxesMenu, 'Label', 'Cancel');
            handles.hGridAxesMenu = hGridAxesMenu;
            
            fnBuildGUI(handles);
            fnInvalidate(handles);
            
            
            set(handles.hGridAxes3D,'CameraPosition', [35.7488 -254.012 53.4186]);
            set(handles.hGridAxes3D,'CameraPositionMode', 'manual');
            set(handles.hGridAxes3D,'CameraTarget', [0.0566006 -0.0141744 5]);
            set(handles.hGridAxes3D,'CameraTargetMode', 'auto');
            set(handles.hGridAxes3D,'CameraUpVector', [-0.504187 0.749812 0.892129]);
            set(handles.hGridAxes3D,'CameraUpVectorMode', 'manual');
            set(handles.hGridAxes3D,'CameraViewAngle', [6.60861]);
            set(handles.hGridAxes3D,'CameraViewAngleMode', 'manual');
            set(handles.hGridAxes3D,'CLim',[0 1]);
            axis(handles.hGridAxes3D,'ij')
            set(handles.figure1,'visible','on');
        case 'ClearGrid'
            set(handles.figure1,'visible','off');
            setappdata(handles.figure1,'strctGridModel',[]);
            
    end
end

if ishandle(handles.figure1)
    set(handles.figure1,'WindowButtonMotionFcn',{@fnMouseMove,handles});
    set(handles.figure1,'WindowButtonDownFcn',{@fnMouseDown,handles});
    guidata(hObject, handles);

end


% Update handles structure

% UIWAIT makes GridHelper wait for user response (see UIRESUME)
% uiwait(handles.figure1);

function fnBuildGUI(handles)
strctGridModel = getappdata(handles.figure1,'strctGridModel');
set(handles.figure1,'visible','on');
strctGridParams = strctGridModel.m_strctGridParams;
iNumParams = length(strctGridParams.m_acParam);
a2cData = cell(iNumParams,1);
acRowName = cell(iNumParams,1);
for iIter=1:iNumParams
    acRowName{iIter} = strctGridParams.m_acParam{iIter}.m_strDescription;
    a2cData{iIter} = num2str(strctGridParams.m_acParam{iIter}.m_Value);
    switch strctGridParams.m_acParam{iIter}.m_strType
        case 'Discrete'
            acFormat{iIter} = strctGridParams.m_acParam{iIter}.m_afPossibleValues;
        case 'Logical'
            acFormat{iIter} = 'logical';
        case 'Continuous'
            acFormat{iIter} = 'numeric';
        case 'String'
            acFormat{iIter} = 'char';
    end
    
end
set(handles.hParamTable,'Data',a2cData,'RowName',acRowName,'ColumnFormat',acFormat,'ColumnName','Value','ColumnWidth',{70},'ColumnEditable',true,...
    'CellEditCallback',@fnCellEditCallback,'CellSelectionCallback',@fnCellSelectionCallback,'UserData',handles);


return;

function fnAlignToGridHole(obj,temp,handles)
pt2fSavedMousePos = getappdata(handles.figure1,'pt2fSavedMousePos');

strctGridModel = getappdata(handles.figure1,'strctGridModel');
fHoleDiameterMM = fnGetGridParameter(strctGridModel.m_strctGridParams,'HoleDiam');
afDistToHoleMM = sqrt( (strctGridModel.m_afGridHolesX-pt2fSavedMousePos(1)).^2+(strctGridModel.m_afGridHolesY-pt2fSavedMousePos(2)).^2);
[fMinDistMM, iHoleIndex] = min(afDistToHoleMM);
if fMinDistMM <= fHoleDiameterMM
    strctPlannerInfo = getappdata(handles.figure1,'strctPlannerInfo');
    feval(strctPlannerInfo.m_strCallback,'AlignToGridHole',iHoleIndex);
end
return;


function fnGridMIPFuncNeg(obj,temp,handles)
function fnGridMIPFuncPos(obj,temp,handles)
function fnGridMIPVessels(obj,temp,handles)



function fnMouseDownEmulator(a,b,handles)
setappdata(handles.figure1,'pt2fSavedMousePos',fnGetMouseCoordinate(handles.hGridAxes));
return;

function fnCellSelectionCallback(source,eventdata)
handles = get(source,'UserData');
if ~isempty(eventdata.Indices)
    iNewParameterIndex = eventdata.Indices(1,1);
    setappdata(handles.figure1,'iCurrentParameter',iNewParameterIndex);
else
    iNewParameterIndex = getappdata(handles.figure1,'iCurrentParameter');
end

% Update scroll bar...
%set(handles.    ,'iCurrentParameter',eventdata.Indices(1));
strctGridModel = getappdata(handles.figure1,'strctGridModel');
strctParam = strctGridModel.m_strctGridParams.m_acParam{iNewParameterIndex};
switch strctParam.m_strType
    case 'Continuous'
        set(handles.hSlider,'Enable','on','Min',strctParam.m_afPossibleValues(1),'Max',strctParam.m_afPossibleValues(2),'Value',strctParam.m_Value);
    otherwise
        set(handles.hSlider,'Enable','off');
end

return;


function fnCellEditCallback(source,eventdata)
handles = get(source,'UserData');
iNewParameterIndex = eventdata.Indices(1,1);
setappdata(handles.figure1,'iCurrentParameter',iNewParameterIndex);
% Update scroll bar...
%set(handles.    ,'iCurrentParameter',eventdata.Indices(1));
strctGridModel = getappdata(handles.figure1,'strctGridModel');

switch strctGridModel.m_strctGridParams.m_acParam{iNewParameterIndex}.m_strType
    case 'Discrete'
        NewValue = str2num(eventdata.NewData);
    case 'Logical'
        NewValue = str2num(eventdata.NewData) > 0;
    case 'Continuous'
        NewValue = str2num(eventdata.NewData);
    case 'String'
        NewValue = eventdata.NewData;
end

strctGridModel.m_strctGridParams.m_acParam{iNewParameterIndex}.m_Value = NewValue;

% Build a new grid model (!)
strctGridFunc = getappdata(handles.figure1,'strctGridFunc');
strctNewGridModel = feval(strctGridFunc.m_strBuildModel, strctGridModel.m_strctGridParams);

strctNewGridModel = fnCopySelectedHolesFromAnotherModel(strctNewGridModel, strctGridModel,strctGridModel.m_strctGridParams.m_acParam{iNewParameterIndex}.m_bHardCopySelected);

setappdata(handles.figure1,'strctGridModel',strctNewGridModel);
strctPlannerInfo = getappdata(handles.figure1,'strctPlannerInfo');
feval(strctPlannerInfo.m_strCallback,'UpdateGridModel',strctNewGridModel);


% Invalidate (!)
fnInvalidate(handles);
return;

% --- Outputs from this function are returned to the command line.
function varargout = GridHelper_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
try
varargout{1} = handles.figure1;
catch
end

% --- Executes on slider movement.
function hSlider_Callback(hObject, eventdata, handles)
iParameterIndex = getappdata(handles.figure1,'iCurrentParameter');
NewValue = get(hObject,'Value');

strctGridModel = getappdata(handles.figure1,'strctGridModel');
strctGridModel.m_strctGridParams.m_acParam{iParameterIndex}.m_Value = NewValue;

% Update table
a2cData = get(handles.hParamTable,'Data');
a2cData{iParameterIndex,1} = num2str(NewValue);
set(handles.hParamTable,'Data',a2cData);

% Build a new grid model (!)
strctGridFunc = getappdata(handles.figure1,'strctGridFunc');
strctNewGridModel = feval(strctGridFunc.m_strBuildModel, strctGridModel.m_strctGridParams);
strctNewGridModel = fnCopySelectedHolesFromAnotherModel(strctNewGridModel, strctGridModel,strctGridModel.m_strctGridParams.m_acParam{iParameterIndex}.m_bHardCopySelected );

if length(strctNewGridModel.m_strctGridParams.m_abSelectedHoles) ~= length(strctNewGridModel.m_afGridHolesX)
    assert(false);
end

setappdata(handles.figure1,'strctGridModel',strctNewGridModel);
strctPlannerInfo = getappdata(handles.figure1,'strctPlannerInfo');
feval(strctPlannerInfo.m_strCallback,'UpdateGridModel',strctNewGridModel);

% Invalidate (!)
fnInvalidate(handles);
return;


% --- Executes during object creation, after setting all properties.
function hSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in hReset.
function hReset_Callback(hObject, eventdata, handles)
strAnswer = questdlg('Are you sure? This will erase all orientations, selected holes, etc...!','Warning','Yes','No','No');
if strcmp(strAnswer,'Yes')
strctGridFunc = getappdata(handles.figure1,'strctGridFunc');

strctGridParams = feval(strctGridFunc.m_strDefine);
strctGridModel = feval(strctGridFunc.m_strBuildModel, strctGridParams);
setappdata(handles.figure1,'strctGridModel',strctGridModel);
strctPlannerInfo = getappdata(handles.figure1,'strctPlannerInfo');
feval(strctPlannerInfo.m_strCallback,'UpdateGridModel',strctGridModel);

fnBuildGUI(handles);
% Invalidate (!)
fnInvalidate(handles);
end
return;

function fnInvalidate(handles)
strctGridModel = getappdata(handles.figure1,'strctGridModel');
strctGridFunc = getappdata(handles.figure1,'strctGridFunc');

feval(strctGridFunc.m_strDraw2D, strctGridModel, handles.hGridAxes, handles.hGridAxesMenu);
astrctMesh = feval(strctGridFunc.m_strBuildMesh,strctGridModel, 1);
cla(handles.hGridAxes3D)
hold(handles.hGridAxes3D,'on')
a2fFlipZ = eye(4);
a2fFlipZ(1:3,1:3) = fnRotateVectorAboutAxis([1 0 0],pi);
astrctMesh = fnApplyTransformOnMesh(astrctMesh, a2fFlipZ);
fnDrawMeshIn3D(astrctMesh, handles.hGridAxes3D);
axis equal
% 



return;
%




function fnMouseMove(obj,eventdata,handles)

    
    pt2fPos = fnGetMouseCoordinate(handles.hGridAxes);
    
    strctGridModel = getappdata(handles.figure1,'strctGridModel');
    if isempty(strctGridModel)
        return;
    end;
    
    afDistToHoleMM = sqrt( (strctGridModel.m_afGridHolesX-pt2fPos(1)).^2+(strctGridModel.m_afGridHolesY-pt2fPos(2)).^2);
    [fMinDistMM, iHoleIndex] = min(afDistToHoleMM);
    
    fHoleDiameterMM = fnGetGridParameter(strctGridModel.m_strctGridParams,'HoleDiam');
    
    if fMinDistMM <= fHoleDiameterMM
        setappdata(handles.figure1,'iSelectedHole',iHoleIndex);
        % Highlight hole !
        % [iHoleIndex,strctGridModel.m_afGridHolesX(iHoleIndex),strctGridModel.m_afGridHolesY(iHoleIndex)]
        
        hHoleSelected = getappdata(handles.figure1,'hHoleSelected');
        if isempty(hHoleSelected) || (~isempty(hHoleSelected) && ~ishandle(hHoleSelected))
            hHoleSelected = plot(handles.hGridAxes,0,0,'g','uicontextmenu', handles.hGridAxesMenu);
            setappdata(handles.figure1,'hHoleSelected',hHoleSelected);
        end;
        afTheta = linspace(0,2*pi,20);
        afCos = cos(afTheta);
        afSin = sin(afTheta);
        set(hHoleSelected,...
            'xdata',strctGridModel.m_afGridHolesX(iHoleIndex) + afCos*fHoleDiameterMM/2,...
            'ydata',strctGridModel.m_afGridHolesY(iHoleIndex) + afSin*fHoleDiameterMM/2,...
            'visible','on','LineWidth',2);
    else
        setappdata(handles.figure1,'iSelectedHole',[]);
    end
return;



function fnMouseDown(obj,eventdata,handles)


strMouseClick = fnGetClickType(handles.figure1);
if strcmpi(strMouseClick,'left')
    iSelectedHole = getappdata(handles.figure1,'iSelectedHole');
    strctGridModel = getappdata(handles.figure1,'strctGridModel');
    if ~isempty(iSelectedHole)
        strctGridModel.m_strctGridParams.m_abSelectedHoles(iSelectedHole) = ~strctGridModel.m_strctGridParams.m_abSelectedHoles(iSelectedHole);
        setappdata(handles.figure1,'strctGridModel',strctGridModel);
        
        strctPlannerInfo = getappdata(handles.figure1,'strctPlannerInfo');
        feval(strctPlannerInfo.m_strCallback,'UpdateGridModel',strctGridModel);
        
        fnInvalidate(handles);
    end
end
return;


function pt2fMouseDownPosition = fnGetMouseCoordinate(hAxes)
pt2fMouseDownPosition = get(hAxes,'CurrentPoint');
if size(pt2fMouseDownPosition,2) ~= 3
    pt2fMouseDownPosition = [-1 -1];
else
    pt2fMouseDownPosition = [pt2fMouseDownPosition(1,1), pt2fMouseDownPosition(1,2)];
end;
return;

function strctNewGridModel = fnCopySelectedHolesFromAnotherModel(strctNewGridModel, strctOldGridModel, bHardCopy)
if isempty(strctOldGridModel.m_strctGridParams.m_abSelectedHoles)
    return;
end;

if bHardCopy && length(strctNewGridModel.m_strctGridParams.m_abSelectedHoles) == length(strctOldGridModel.m_strctGridParams.m_abSelectedHoles)
    strctNewGridModel.m_strctGridParams.m_abSelectedHoles = strctOldGridModel.m_strctGridParams.m_abSelectedHoles;
    return;
end

iNumHoles = length(strctNewGridModel.m_afGridHolesX);
for iHoleIter=1:iNumHoles
    % Find nearest hole in old model and decide whether it was selected or
    % not.... (kinda stupid....)
    [fDummy, iIndex] = min( (strctNewGridModel.m_afGridHolesX(iHoleIter) - strctOldGridModel.m_afGridHolesX).^2+...
        (strctNewGridModel.m_afGridHolesY(iHoleIter) - strctOldGridModel.m_afGridHolesY).^2);
    strctNewGridModel.m_strctGridParams.m_abSelectedHoles(iHoleIter) = strctOldGridModel.m_strctGridParams.m_abSelectedHoles(iIndex);
end

return;
