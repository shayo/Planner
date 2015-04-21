function varargout = StereotacticDesign(varargin)
% STEREOTACTICDESIGN M-file for StereotacticDesign.fig
%      STEREOTACTICDESIGN, by itself, creates a new STEREOTACTICDESIGN or raises the existing
%      singleton*.
%
%      H = STEREOTACTICDESIGN returns the handle to a new STEREOTACTICDESIGN or the handle to
%      the existing singleton*.
%
%      STEREOTACTICDESIGN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STEREOTACTICDESIGN.M with the given input arguments.
%
%      STEREOTACTICDESIGN('Property','Value',...) creates a new STEREOTACTICDESIGN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before StereotacticDesign_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to StereotacticDesign_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help StereotacticDesign

% Last Modified by GUIDE v2.5 13-Jul-2011 09:45:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @StereotacticDesign_OpeningFcn, ...
                   'gui_OutputFcn',  @StereotacticDesign_OutputFcn, ...
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


% --- Executes just before StereotacticDesign is made visible.
function StereotacticDesign_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to StereotacticDesign (see VARARGIN)

% Choose default command line output for StereotacticDesign
handles.output = hObject;
strctRobot = fnKopf1460RightArm();

a2cEye = cell(4,4);
a2fEye = eye(4);
for i=1:4
    for j=1:4
        a2cEye{i,j} = num2str(a2fEye(i,j));
    end
end
set(handles.hTableBase,'Data',a2cEye,'ColumnWidth',{40,40,40,40},'ColumnEditable',[true true true true]);
handles.hModelFig = figure;
set(handles.hModelFig,'Name','Stereotactic Model','NumberTitle','off','CloseRequestFcn',[],'ResizeFcn',{@fnResizeModelFig,handles});
cameratoolbar(handles.hModelFig,'show')


%strctRobot = [];
setappdata(handles.figure1,'strctRobot',strctRobot);
guidata(hObject, handles);
fnResizeModelFig([],[],handles);

fnInvalidateTableDH(handles);

set(handles.hModelName,'String','');
set(handles.figure1,'CloseRequestFcn',@fnCloseRequest);
set(handles.hTableDH,'UserData',handles);
set(handles.hTableBase,'UserData',handles);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes StereotacticDesign wait for user response (see UIRESUME)
% uiwait(handles.figure1);
function fnResizeModelFig(a,b, handles)

clf(handles.hModelFig);

strctRobot = getappdata(handles.figure1,'strctRobot');
hModelAxes = axes('units','normalized','parent',handles.hModelFig,'Position',[0.5 0 1 1]);
setappdata(handles.figure1,'hModelAxes',hModelAxes);
strctPanel.m_ahRightPanels(2) = uipanel('units','normalized','parent',handles.hModelFig,'Position',[0 0 0.5 1]);


set(strctPanel.m_ahRightPanels(2),'units','pixels');
strctPanel.m_aiRightPanelSize= get(strctPanel.m_ahRightPanels(2),'position');

if ~isempty(strctRobot)
    [strctControllers.m_ahLinkSlider, strctControllers.m_ahLinkEdit,...
        strctControllers.m_hTipPosition] = fnGenerateControllersForDesign(strctPanel,strctRobot.m_astrctJointsDescription,handles);
    setappdata(handles.figure1,'strctControllers',strctControllers);
end
fnClearStereoTactic(handles);
fnInvalidateModel(handles);
return;


function  fnCloseRequest(a,b)
% Send close command to current module
delete(get(0,'Children'));
return;


% --- Outputs from this function are returned to the command line.
function varargout = StereotacticDesign_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in hLoadModel.
function hLoadModel_Callback(hObject, eventdata, handles)
% hObject    handle to hLoadModel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in hSaveModel.
function hSaveModel_Callback(hObject, eventdata, handles)
% hObject    handle to hSaveModel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function a2fBase = fnGetBase(handles)
a2cData = get(handles.hTableBase,'Data');
a2fBase = eye(4);
for i=1:4
    for j=1:4
        [Dummy,a2fBase(i,j)] = evalc(a2cData{i,j});
    end
end
return;

% --- Executes on button press in hAddJoint.
function hAddJoint_Callback(hObject, eventdata, handles)
strctRobot = getappdata(handles.figure1,'strctRobot');
if isempty(strctRobot)
    a2fBase = fnGetBase(handles);
    a2fDH = zeros(1,6);
    a2fEarBarZeroToFrame = [];
    strName = get(handles.hModelName,'String');
    
    astrctJointDescirptions(1).m_strName = 'New Joint';
    astrctJointDescirptions(1).m_bFixed = false;
    astrctJointDescirptions(1).m_fValue = 0;
    astrctJointDescirptions(1).m_fMin = -Inf;
    astrctJointDescirptions(1).m_fMax = Inf;
    astrctJointDescirptions(1).m_afDiscreteValues = [];
    
    strctRobot = fnRobotCreate(a2fDH, a2fBase, eye(4),strName,astrctJointDescirptions);
    setappdata(handles.figure1,'strctRobot',strctRobot);
    
    fnInvalidateTableDH(handles);
else
    
end
return;

function fnInvalidateTableDH(handles)
strctRobot = getappdata(handles.figure1,'strctRobot');
iNumJoints = size(strctRobot.m_a2fDH,1);
acColumns = {'Name','Alpha','A/r','Theta','D','Rotatory','Offset','Min','Max'};

a2cTableData = cell(iNumJoints, length(acColumns));
for iJointIter=1:iNumJoints
    a2cTableData{iJointIter,1} = strctRobot.m_astrctJointsDescription(iJointIter).m_strName;
    a2cTableData{iJointIter,2} = num2str(strctRobot.m_a2fDH(iJointIter,1));
    a2cTableData{iJointIter,3} = num2str(strctRobot.m_a2fDH(iJointIter,2));
    a2cTableData{iJointIter,4} = num2str(strctRobot.m_a2fDH(iJointIter,3));
    a2cTableData{iJointIter,5} = num2str(strctRobot.m_a2fDH(iJointIter,4));
    a2cTableData{iJointIter,6} = strctRobot.m_a2fDH(iJointIter,5)>0;
    a2cTableData{iJointIter,7} = num2str(strctRobot.m_a2fDH(iJointIter,6));
    a2cTableData{iJointIter,8} = num2str(strctRobot.m_astrctJointsDescription(iJointIter).m_fMin);
    a2cTableData{iJointIter,9} = num2str(strctRobot.m_astrctJointsDescription(iJointIter).m_fMax);
end

% acColumns = {'Name','Alpha','A/r','Theta','D','Rotatory','Offset','Min','Max'};
set(handles.hTableDH,'ColumnName',acColumns,...
    'ColumnFormat',{'char','char','char','char','char','logical','char','char','char'},'Data',a2cTableData,...
    'ColumnEditable',ones(1,9)>0,'CellEditCallback',@fnCellEditCallback);

fnInvalidateModel(handles);
return;

function fnCellEditCallback(hTable,strctTmp)
handles = get(hTable,'UserData');
strctRobot = getappdata(handles.figure1,'strctRobot');
iLinkIndex = strctTmp.Indices(1,1);
iDHIndex = strctTmp.Indices(1,2);
switch iDHIndex
    case 1
        % Name changed
        strctRobot.m_astrctJointsDescription(iLinkIndex).m_strName = strctTmp.NewData;
    case 2
        % Alpha
        [Dummy, Value]=evalc(strctTmp.NewData); 
        strctRobot.m_a2fDH(iLinkIndex,1) = Value;
    case 3
        % A/r
        [Dummy, Value]=evalc(strctTmp.NewData); 
        strctRobot.m_a2fDH(iLinkIndex,2) = Value;
    case 4
        % Theta
        [Dummy, Value]=evalc(strctTmp.NewData); 
        strctRobot.m_a2fDH(iLinkIndex,3) = Value;
    case 5
        % D
        [Dummy, Value]=evalc(strctTmp.NewData); 
        strctRobot.m_a2fDH(iLinkIndex,4) = Value;
    case 6
        % Rotatory
        strctRobot.m_a2fDH(iLinkIndex,5) = strctTmp.NewData > 0;
    case 7
        % Offset
        [Dummy, Value]=evalc(strctTmp.NewData); 
        strctRobot.m_a2fDH(iLinkIndex,6) = Value;
    case 8
        % min
        [Dummy, Value]=evalc(strctTmp.NewData); 
        strctRobot.m_astrctJointsDescription(iLinkIndex).m_fMin = Value;
    case 9
        % max
        [Dummy, Value]=evalc(strctTmp.NewData); 
        strctRobot.m_astrctJointsDescription(iLinkIndex).m_fMax = Value;
end

setappdata(handles.figure1,'strctRobot',strctRobot);
fnInvalidateModel(handles);
return;

function fnInvalidateModel(handles)
strctRobot = getappdata(handles.figure1,'strctRobot');
hModelAxes = getappdata(handles.figure1,'hModelAxes');
iNumJoints = size(strctRobot.m_a2fDH,1);
% afConf = zeros(1,iNumJoints);
% for iJointIter=1:iNumJoints
%     afConf(iJointIter) = strctRobot.m_astrctJointsDescription(iJointIter).m_fValue;
% end
ahRobotHandles = getappdata(handles.figure1,'ahRobotHandles');
try
delete(ahRobotHandles);
catch
end

afConf = fnRobotGetConfFromRobotStruct(strctRobot);

ahRobotHandles = fnRobotDraw(strctRobot, afConf, hModelAxes, 1);
fnUpdateTipPosition(handles);
setappdata(handles.figure1,'ahRobotHandles',ahRobotHandles);
axis(hModelAxes,'equal');


return;


function hModelName_Callback(hObject, eventdata, handles)
% hObject    handle to hModelName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of hModelName as text
%        str2double(get(hObject,'String')) returns contents of hModelName as a double


% --- Executes during object creation, after setting all properties.
function hModelName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hModelName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function [ahLinkSlider, ahLinkEdit,hTipPosition] = fnGenerateControllersForDesign(strctPanel,strctVirtualArm,handles)
yStartY = 0;
iNumLinks = length(strctVirtualArm);
ahLinkFixed = zeros(1,iNumLinks);
ahLinkSlider = zeros(1,iNumLinks);
ahLinkEdit = zeros(1,iNumLinks);
for k=1:iNumLinks
    
ahLinkFixed(k) = uicontrol('style','text','String',...
    strctVirtualArm(k).m_strName,...
    'HorizontalAlignment','left',...
    'Position',[10 strctPanel.m_aiRightPanelSize(4)-yStartY-k*30 200 15],...
    'parent',strctPanel.m_ahRightPanels(2),'FontSize',10);

    
if ~isempty(strctVirtualArm(k).m_afDiscreteValues)
    iIndex = find(strctVirtualArm(k).m_afDiscreteValues == strctVirtualArm(k).m_fValue);
    iNumPosValues= length(strctVirtualArm(k).m_afDiscreteValues);
ahLinkSlider(k) = uicontrol('style','slider','units','pixels','position',...
    [150 strctPanel.m_aiRightPanelSize(4)-yStartY-k*30 150 15],...
    'parent',strctPanel.m_ahRightPanels(2),...
    'min',1,...
    'max',iNumPosValues,...
    'SliderStep',[1/iNumPosValues 1/iNumPosValues],...
    'value',iIndex,...
    'callback', {@fnCallback,'LinkSliderValue',k,handles},'visible','on');
else
    fRange = strctVirtualArm(k).m_fMax-strctVirtualArm(k).m_fMin;
    ahLinkSlider(k) = uicontrol('style','slider','units','pixels','position',...
        [150 strctPanel.m_aiRightPanelSize(4)-yStartY-k*30 150 15],...
        'parent',strctPanel.m_ahRightPanels(2),...
        'min',strctVirtualArm(k).m_fMin,...
        'max',strctVirtualArm(k).m_fMax,...
        'SliderStep',[1/fRange 1/fRange*10],'callback', {@fnCallback,'LinkSliderValue',k,handles},'visible','on');
end

ahLinkEdit(k) = uicontrol('style','edit','units','pixels','position',...
    [340 strctPanel.m_aiRightPanelSize(4)-yStartY-k*30 60 15],...
    'parent',strctPanel.m_ahRightPanels(2),...
    'String',sprintf('%.2f',strctVirtualArm(k).m_fValue),...
    'backgroundcolor',[1 1 1],'fontsize',9,...
    'callback', {@fnCallback,'LinkEditValue',k,handles},'visible','on');
end
iNextY = strctPanel.m_aiRightPanelSize(4)-yStartY-(iNumLinks+1)*30-40;
hTipPosition = uicontrol('style','text','position',[0,iNextY, 250 30],'String','Tip Position : ','parent',...
    strctPanel.m_ahRightPanels(2),'HorizontalAlignment','left','Fontsize',12);
return;




function fnClearStereoTactic(handles)

hModelAxes = getappdata(handles.figure1,'hModelAxes');
fDistanceBetweenArms = 17.75;
fDistanceToPole = 23.317;
fPoleDiameter = 2.552;
fPoleHeight = 14;
% axes(handles.hModelAxes);
hold(hModelAxes,'on');
% set(handles.hModelAxes,'visible','on');
% cla(handles.hModelAxes);

% Plot other stuff around...
[a2fY,a2fZ]=meshgrid([-5,25],[-10,25]);
s=surf(zeros(size(a2fY)),a2fY,a2fZ);
set(s,'facecolor',[0.5 0.5 0.5],'facealpha',0.5);

fAPBarWidth = 1.782;
a2fRotAP = eye(4);
a2fRotAP(1:3,1:3) = fnRotateVectorAboutAxis([0 0 1],pi/4);
a2fRotAP(1,4) = -1/sqrt(2)*fAPBarWidth;
a2fTrans = eye(4);
a2fTrans(2,4) = fDistanceBetweenArms;
astrctMesh = fnApplyTransformOnMesh(fnBuildCubeMesh(0,0,0,fAPBarWidth/2,fAPBarWidth/2,10, [0.8 0 0]),a2fRotAP);
fnDrawMeshIn3D(astrctMesh,hModelAxes);
plot3([0 0],[0 0],[-10 10],'r','linewidth',3); % left arm

fnDrawMeshIn3D(fnApplyTransformOnMesh(astrctMesh,a2fTrans),hModelAxes);
plot3([0 0],fDistanceBetweenArms*[1 1],[-10 10],'r','linewidth',3); % right arm

[X,Y,Z]=cylinder2P(fPoleDiameter/2,20,[0 fDistanceBetweenArms/2 fDistanceToPole],[fPoleHeight fDistanceBetweenArms/2 fDistanceToPole]);

s=surf(X,Y,Z,'facecolor','r');
set(hModelAxes,'xlim',[-1 20],'ylim',[-5 25],'zlim',[-10 25],...
	'CameraPosition',[134.566 329.707 -212.812],...
	'CameraTarget', [3.87543 10 6.84314],...
	'CameraUpVector' , [0.947588 -0.270007 0.170803],...
	'CameraViewAngle', [6.60861]);

return;

function strctMesh = fnBuildCubeMesh(X0,Y0,Z0,fHalfWidth,fHalfHeight,fHalfDepth, afColor)
strctMesh.m_a2fVertices = [...
    X0-fHalfWidth,Y0-fHalfHeight,Z0-fHalfDepth;
    X0-fHalfWidth,Y0-fHalfHeight,Z0+fHalfDepth;
    X0-fHalfWidth,Y0+fHalfHeight,Z0-fHalfDepth;
    X0-fHalfWidth,Y0+fHalfHeight,Z0+fHalfDepth;
    X0+fHalfWidth,Y0-fHalfHeight,Z0-fHalfDepth;
    X0+fHalfWidth,Y0-fHalfHeight,Z0+fHalfDepth;
    X0+fHalfWidth,Y0+fHalfHeight,Z0-fHalfDepth;
    X0+fHalfWidth,Y0+fHalfHeight,Z0+fHalfDepth]';
    
strctMesh.m_a2iFaces = [...
 1,2,5;
 2,6,5;
 4,3,7;
 7,8,4;
 6,8,7;
 7,5,6;
 1,3,2;
 3,4,2;
 1,5,7;
 7,3,1;
 4,8,6;
 6,2,4 ]';
strctMesh.m_afColor = afColor;        
strctMesh.m_fOpacity = 0.6;
return;




function fnCallback(a,b,strEvent,iLink,handles)
switch strEvent
   case 'LinkEditValue'
        fnLinkEditValue(handles,iLink);
    case 'LinkSliderValue'
        fnLinkSliderValue(handles,iLink);
end
return;

function fnLinkEditValue(handles,iLinkIndex)
strctControllers = getappdata(handles.figure1,'strctControllers');
strctRobot = getappdata(handles.figure1,'strctRobot');
hModelAxes = getappdata(handles.figure1,'hModelAxes');
fNewValue = get(strctControllers.m_ahLinkEdit(iLinkIndex),'string');
if ischar(fNewValue)
    fNewValue= str2num(fNewValue);
end;

if isempty(fNewValue) || ~isreal(fNewValue)
    % recover old value...
    set(strctControllers.m_ahLinkEdit(iLinkIndex),'string',sprintf('%.2f',strctRobot.m_astrctJointsDescription(iLinkIndex).m_fValue));
    return;
end

fNewValue = min(max(fNewValue,strctRobot.m_astrctJointsDescription(iLinkIndex).m_fMin),strctRobot.m_astrctJointsDescription(iLinkIndex).m_fMax);
strctRobot.m_astrctJointsDescription(iLinkIndex).m_fValue = fNewValue;
if ~isempty(strctRobot.m_astrctJointsDescription(iLinkIndex).m_afDiscreteValues)
else
    % Simple case.
    set(strctControllers.m_ahLinkSlider(iLinkIndex),'value',fNewValue);
end

setappdata(handles.figure1,'strctRobot',strctRobot);

afConf = fnRobotGetConfFromRobotStruct(strctRobot);

ahRobotHandles = getappdata(handles.figure1,'ahRobotHandles');
delete(ahRobotHandles);

ahRobotHandles = fnRobotDraw(strctRobot,afConf,...
    hModelAxes,1);

setappdata(handles.figure1,'ahRobotHandles',ahRobotHandles);

fnUpdateTipPosition(handles)

return

function fnLinkSliderValue(handles,iLinkIndex)
strctControllers = getappdata(handles.figure1,'strctControllers');
strctRobot = getappdata(handles.figure1,'strctRobot');
hModelAxes = getappdata(handles.figure1,'hModelAxes');
fNewValue = get(strctControllers.m_ahLinkSlider(iLinkIndex),'value');
if ~isempty(strctRobot.m_astrctJointsDescription(iLinkIndex).m_afDiscreteValues)
    fNewValue = strctRobot.m_astrctJointsDescription(iLinkIndex).m_afDiscreteValues(round(fNewValue));
    strctRobot.m_astrctJointsDescription(iLinkIndex).m_fValue = fNewValue;
else
    strctRobot.m_astrctJointsDescription(iLinkIndex).m_fValue = fNewValue;
end
set(strctControllers.m_ahLinkEdit(iLinkIndex),'String',sprintf('%.2f',fNewValue));
setappdata(handles.figure1,'strctRobot',strctRobot);

afConf = fnRobotGetConfFromRobotStruct(strctRobot);

ahRobotHandles = getappdata(handles.figure1,'ahRobotHandles');
delete(ahRobotHandles);

ahRobotHandles = fnRobotDraw(strctRobot,afConf,...
    hModelAxes,1);

setappdata(handles.figure1,'ahRobotHandles',ahRobotHandles);

fnUpdateTipPosition(handles)
return;


function fnUpdateTipPosition(handles)
strctControllers = getappdata(handles.figure1,'strctControllers');
strctRobot = getappdata(handles.figure1,'strctRobot');
afConf = fnRobotGetConfFromRobotStruct(strctRobot);
a2fT = fnRobotForward(strctRobot,afConf);
set(strctControllers.m_hTipPosition,'String',...
    sprintf('Tip Position: %.2f,%.2f,%.2f',a2fT(1,4),a2fT(2,4),a2fT(3,4)));


% iNumJoints = size(strctRobot.m_a2fDH,1);
% 
% a2fT = strctRobot.m_a2fBase;
% a3fTipPos = zeros(iNumJoints,3);
% for iLinkIter=1:iNumJoints  
%     a2fLink = fnRobotLinkTransformation( strctRobot.m_a2fDH(iLinkIter,:), afConf(iLinkIter));
%     a2fT = a2fT* a2fLink;
%     a3fTipPos(iLinkIter,:) = a2fT(1:3,4);
% end
% a3fTipPos
return;


% --- Executes on button press in hRemoveJoints.
function hRemoveJoints_Callback(hObject, eventdata, handles)
