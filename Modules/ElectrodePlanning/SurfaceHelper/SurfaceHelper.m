function varargout = SurfaceHelper(varargin)
% SURFACEHELPER M-file for SurfaceHelper.fig
%      SURFACEHELPER, by itself, creates a new SURFACEHELPER or raises the existing
%      singleton*.
%
%      H = SURFACEHELPER returns the handle to a new SURFACEHELPER or the handle to
%      the existing singleton*.
%
%      SURFACEHELPER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SURFACEHELPER.M with the given input arguments.
%
%      SURFACEHELPER('Property','Value',...) creates a new SURFACEHELPER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SurfaceHelper_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SurfaceHelper_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SurfaceHelper

% Last Modified by GUIDE v2.5 28-Nov-2011 09:13:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @SurfaceHelper_OpeningFcn, ...
    'gui_OutputFcn',  @SurfaceHelper_OutputFcn, ...
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


% --- Executes just before SurfaceHelper is made visible.
function SurfaceHelper_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SurfaceHelper (see VARARGIN)

% Choose default command line output for SurfaceHelper
global g_handles

handles.output = hObject;
strctVol =varargin{1};
set(handles.hKeepLargest,'value',1);
%strctVol.m_strctSurface  = [];
setappdata(handles.figure1,'strctVol',strctVol );
g_handles = handles;
%set(handles.figure1,'CloseRequestFcn',@my_closereq)

a3bBrainMask=fnGetBrainMask();
setappdata(handles.figure1,'a3bBrainMask',a3bBrainMask);

fnFirstInvalidate(handles);
set(handles.figure1,'WindowScrollWheelFcn',{@fnMouseWheel,handles});
set(handles.figure1,'WindowButtonMotionFcn',{@fnMouseMove,handles});
set(handles.figure1,'WindowButtonDownFcn',{@fnMouseDown,handles});
set(handles.figure1,'WindowButtonUpFcn',{@fnMouseUp,handles});
setappdata(handles.figure1,'bMouseDown',0);
strctVol = getappdata(handles.figure1,'strctVol');
set(handles.hNext,'enable','off');
global g_TMP
g_TMP = strctVol;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SurfaceHelper wait for user response (see UIRESUME)
uiwait(handles.figure1);

function fnMouseWheel(obj,eventdata,handles)
iScroll = eventdata.VerticalScrollCount;
Tmp = get(handles.figure1,'CurrentPoint');
MousePos = Tmp(1,1:2);
if fnInsideImage(handles,handles.hAxesImage)
    strctVol = getappdata(handles.figure1,'strctVol');
    strctVol.m_strctCrossSectionHoriz.m_fViewOffsetMM = strctVol.m_strctCrossSectionHoriz.m_fViewOffsetMM + iScroll * 0.5;
    setappdata(handles.figure1,'strctVol',strctVol);
    fnInvalidate2D(handles);
end
return;


function fnFirstInvalidate(handles)
strctVol = getappdata(handles.figure1,'strctVol');

[strctHist.m_afHist,strctHist.m_afRange]=hist(strctVol.m_a3fVol(:),500);
fWidth = strctHist.m_afRange(end)-strctHist.m_afRange(1);
set(handles.hHistHorizSlider,'min',strctHist.m_afRange(1),'max',strctHist.m_afRange(end),'value',strctHist.m_afRange(250));
set(handles.hHistVertSlider,'min',50,'max',fWidth,'value',fWidth);

bar(strctHist.m_afRange,strctHist.m_afHist,'parent',handles.hAxesHist);
setappdata(handles.figure1,'strctHist',strctHist);
hold(handles.hAxesHist,'on');

set(handles.figure1,'visible','on');


[a2fXmm,a2fYmm] = meshgrid(...
    linspace(-strctVol.m_strctCrossSectionHoriz.m_fHalfWidthMM, strctVol.m_strctCrossSectionHoriz.m_fHalfWidthMM, strctVol.m_strctCrossSectionHoriz.m_iResWidth),...
    linspace(-strctVol.m_strctCrossSectionHoriz.m_fHalfHeightMM, strctVol.m_strctCrossSectionHoriz.m_fHalfHeightMM, strctVol.m_strctCrossSectionHoriz.m_iResHeight));

[a2fHoriz, a2fSaggital, a2fCoronal, a3fHoriz, a3fSaggital, a3fCoronal] = fnGetVolumeCrossSections(strctVol);

setappdata(handles.figure1,'a2fHoriz',a2fHoriz);

% setappdata(handles.figure1,'astrctControllers',strctThresholdController);

if length(strctHist.m_afRange) == 2
    strctIsoSurfParam.m_fLeftThreshold = 0;
    strctIsoSurfParam.m_fRightThreshold = 1;
else
    strctIsoSurfParam.m_fLeftThreshold = strctHist.m_afRange(10);
    strctIsoSurfParam.m_fRightThreshold = strctHist.m_afRange(20);
end

strctIsoSurfParam.m_fLeftThreshold  = 50;
strctIsoSurfParam.m_fRightThreshold = 300;

strctIsoSurfParam.m_iLargeCCSize = 30;
strctIsoSurfParam.m_iNumFaces = 20000;
strctIsoSurfParam.m_fSurfaceOpacity = 0.3;
strctIsoSurfParam.m_afSurfaceColor = [ 1 1 0];
strctIsoSurfParam.m_bDisplay = true;
strctVol.m_strctIsoSurfParam = strctIsoSurfParam;
set(handles.hNumberOfFaces,'String',num2str(strctVol.m_strctIsoSurfParam.m_iNumFaces));
setappdata(handles.figure1,'strctVol',strctVol);

hLeftThreshold = plot([strctIsoSurfParam.m_fLeftThreshold strctIsoSurfParam.m_fLeftThreshold],[0 max(strctHist.m_afHist)],'r','LineWidth',2,'parent',handles.hAxesHist);
hRightThreshold = plot([strctIsoSurfParam.m_fRightThreshold strctIsoSurfParam.m_fRightThreshold],[0 max(strctHist.m_afHist)],'g','LineWidth',2,'parent',handles.hAxesHist);
setappdata(handles.figure1,'ahThresholds',[hLeftThreshold,hRightThreshold]);


a2bSlice = a2fHoriz>=strctIsoSurfParam.m_fLeftThreshold & a2fHoriz<=strctIsoSurfParam.m_fRightThreshold;
X = a3fHoriz(:,:,1);
X(a2bSlice) = 0.2;
a3fHoriz(:,:,1) = X;
hImageHoriz = image(a3fHoriz,'parent',handles.hAxesImage);
setappdata(handles.figure1,'hImageHoriz',hImageHoriz);
set(handles.hAxesImage,'visible','off');
hold(handles.hAxesImage,'on');

fnInvalidate2D(handles);
return;

function a2iOutput=fnMyErode(a2iInput,fSize)
a2iOutput = bwdist(~a2iInput)>fSize;
function a2iOutput=fnMyDilate(a2iInput,fSize)
a2iOutput = bwdist(a2iInput)<fSize;
function a2iOut=fnMyClose(a2iInput,fSize)
a2iOut = fnMyErode(fnMyDilate(a2iInput,fSize-0.0001),fSize-0.0001);
function a2iOutput=fnMyOpen(a2iInput,fSize)
a2iOutput = fnMyDilate(fnMyErode(a2iInput,fSize+0.0001),fSize+0.0001);

function fnInvalidate2D(handles)
ahBoundaries = getappdata(handles.figure1,'ahBoundaries');
delete(ahBoundaries(ishandle(ahBoundaries)));

strctVol = getappdata(handles.figure1,'strctVol');
% [a2fHoriz, a2fSaggital, a2fCoronal, a3fHoriz, a3fSaggital, a3fCoronal] = fnGetVolumeCrossSections(strctVol);
hImageHoriz = getappdata(handles.figure1,'hImageHoriz');

a3bBrainMask = getappdata(handles.figure1,'a3bBrainMask');
bUseMask = get(handles.hUseAtlas,'value') > 0;
% 


strctVol.m_strctCrossSectionHoriz.m_a2fM(1:3,4)    = strctVol.m_strctCrossSectionHoriz.m_a2fM(1:3,4) + strctVol.m_strctCrossSectionHoriz.m_a2fM(1:3,3) * strctVol.m_strctCrossSectionHoriz.m_fViewOffsetMM;
a2fXYZ_To_CRS = inv(strctVol.m_a2fM) * inv(strctVol.m_a2fReg);
a2fBrainMask= fnResampleCrossSection(a3bBrainMask, a2fXYZ_To_CRS, strctVol.m_strctCrossSectionHoriz);
a2fHorizRAW = fnResampleCrossSection(strctVol.m_a3fVol, a2fXYZ_To_CRS, strctVol.m_strctCrossSectionHoriz);

a2bSlice = a2fHorizRAW>=strctVol.m_strctIsoSurfParam.m_fLeftThreshold & a2fHorizRAW<=strctVol.m_strctIsoSurfParam.m_fRightThreshold;
if bUseMask
    a2fHorizRAW(~a2fBrainMask) = 0;
    a2bSlice(~a2fBrainMask) = 0;
end
a2fHoriz= fnContrastTransform(a2fHorizRAW, strctVol.m_strctContrastTransform);
setappdata(handles.figure1,'a2fHoriz',a2fHoriz);

a3fHoriz = fnDup3(a2fHoriz);

X = a3fHoriz(:,:,1);
X(a2bSlice) = 0.3;
a3fHoriz(:,:,1) = X;
set(hImageHoriz,'cdata',a3fHoriz);

return;


% --- Outputs from this function are returned to the command line.
function varargout = SurfaceHelper_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure

global g_TMP
varargout{1} = g_TMP;
clear global g_TMP

return;




% --- Executes on selection change in hQuantMenu.
function hQuantMenu_Callback(hObject, eventdata, handles)
% hObject    handle to hQuantMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns hQuantMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from hQuantMenu
strctVol = getappdata(handles.figure1,'strctVol');

afQuan = [1,2,4,6,8];
iSelected = get(hObject,'value');
iNewQuan = afQuan(iSelected);
strctIsoSurfParam = getappdata(handles.figure1,'strctIsoSurfParam');
strctIsoSurfParam.m_iSubSampleX = iNewQuan;
strctIsoSurfParam.m_iSubSampleY = iNewQuan;
strctIsoSurfParam.m_iSubSampleZ = iNewQuan;
setappdata(handles.figure1,'strctIsoSurfParam',strctIsoSurfParam);
a3fConvSub = fnSubSample(strctVol.m_a3fVol,strctIsoSurfParam);
setappdata(handles.figure1,'a3fConvSub',a3fConvSub);

fnInvalidate(handles)

% --- Executes during object creation, after setting all properties.
function hQuantMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hQuantMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function hLargeCCEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hLargeCCEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function fnMouseDown(obj,eventdata,handles)
currobj = get(handles.figure1,'currentobject');
setappdata(handles.figure1,'bMouseDown',1);
strMouseOp = getappdata(handles.figure1,'strMouseOp');
ahThresholds = getappdata(handles.figure1,'ahThresholds');
hMainVolSurface = getappdata(handles.figure1,'hMainVolSurface');
hImageHoriz = getappdata(handles.figure1,'hImageHoriz');
if currobj == ahThresholds(1)
    setappdata(handles.figure1,'strMouseOp','LeftThreshold');
elseif currobj == ahThresholds(2)
    setappdata(handles.figure1,'strMouseOp','RightThreshold');
elseif ~isempty(hMainVolSurface) && currobj == hMainVolSurface
    setappdata(handles.figure1,'strMouseOp','Rotate');
    
    Tmp = get(handles.figure1,'CurrentPoint');
    setappdata(handles.figure1,'PrevMousePos',Tmp(1,1:2));
    
elseif strcmp(strMouseOp,'SampleLeft')
        if currobj == hImageHoriz
            setappdata(handles.figure1,'strMouseOp','');
            set(handles.figure1,'Pointer','arrow');
            Tmp = get(handles.hAxesImage,'CurrentPoint');
            a2fHoriz = getappdata(handles.figure1,'a2fHoriz');
            
            strctVol = getappdata(handles.figure1,'strctVol');
            strctVol.m_strctIsoSurfParam.m_fLeftThreshold = a2fHoriz(round(Tmp(1)),round(Tmp(2)));
            setappdata(handles.figure1,'strctVol',strctVol);
            ahThresholds = getappdata(handles.figure1,'ahThresholds');
     set(ahThresholds(1),'xdata',[strctVol.m_strctIsoSurfParam.m_fLeftThreshold strctVol.m_strctIsoSurfParam.m_fLeftThreshold]);
      
             fnInvalidate2D(handles);
        end
elseif strcmp(strMouseOp,'SampleRight')

         if currobj == hImageHoriz
            setappdata(handles.figure1,'strMouseOp','');
            set(handles.figure1,'Pointer','arrow');
            Tmp = get(handles.hAxesImage,'CurrentPoint');
            a2fHoriz = getappdata(handles.figure1,'a2fHoriz');
            strctVol = getappdata(handles.figure1,'strctVol');
            ahThresholds = getappdata(handles.figure1,'ahThresholds');
            strctVol.m_strctIsoSurfParam.m_fRightThreshold = a2fHoriz(round(Tmp(1)),round(Tmp(2)))
            set(ahThresholds(2),'xdata',[strctVol.m_strctIsoSurfParam.m_fRightThreshold strctVol.m_strctIsoSurfParam.m_fRightThreshold]);
      
            setappdata(handles.figure1,'strctVol',strctVol);

            fnInvalidate2D(handles);
        end
        
end


return;
 

function fnMouseUp(obj,eventdata,handles)
setappdata(handles.figure1,'bMouseDown',0);
%strMouseOp = getappdata(handles.figure1,'strMouseOp');
%currobj = get(handles.figure1,'currentobject');
setappdata(handles.figure1,'strMouseOp','');



function fnMouseMove(obj,eventdata,handles)
strMouseOp = getappdata(handles.figure1,'strMouseOp');
bMouseDown = getappdata(handles.figure1,'bMouseDown');
ahThresholds = getappdata(handles.figure1,'ahThresholds');

if bMouseDown && ~isempty(strMouseOp) && strcmp(strMouseOp,'LeftThreshold')
    Tmp = get(handles.hAxesHist,'CurrentPoint');
    fNewLeftThreshold = Tmp(1,1);
    strctVol = getappdata(handles.figure1,'strctVol');
    strctVol.m_strctIsoSurfParam.m_fLeftThreshold = min(strctVol.m_strctIsoSurfParam.m_fRightThreshold, fNewLeftThreshold);
    setappdata(handles.figure1,'strctVol',strctVol);    
    set(ahThresholds(1),'xdata',[strctVol.m_strctIsoSurfParam.m_fLeftThreshold strctVol.m_strctIsoSurfParam.m_fLeftThreshold]);
    fnInvalidate2D(handles);
elseif bMouseDown && ~isempty(strMouseOp) && strcmp(strMouseOp,'RightThreshold')
    Tmp = get(handles.hAxesHist,'CurrentPoint');
    fNewRightThreshold = Tmp(1,1);
    strctVol = getappdata(handles.figure1,'strctVol');
    strctVol.m_strctIsoSurfParam.m_fRightThreshold = max(strctVol.m_strctIsoSurfParam.m_fLeftThreshold, fNewRightThreshold);
    setappdata(handles.figure1,'strctVol',strctVol);    
    set(ahThresholds(2),'xdata',[strctVol.m_strctIsoSurfParam.m_fRightThreshold strctVol.m_strctIsoSurfParam.m_fRightThreshold]);
    fnInvalidate2D(handles);
elseif  bMouseDown && ~isempty(strMouseOp) && strcmp(strMouseOp,'Rotate')
    PrevMousePos = getappdata(handles.figure1,'PrevMousePos');
    Tmp = get(handles.figure1,'CurrentPoint');
    CurrMousPos = Tmp(1,1:2);
    if isempty(PrevMousePos)
        afDiffScr = [0 0];
    else
        afDiffScr = CurrMousPos-PrevMousePos;
    end
    camorbit(handles.hAxes3D, -afDiffScr(1),-afDiffScr(2), 'none');
    setappdata(handles.figure1,'PrevMousePos',CurrMousPos);
end
   
return;


% --- Executes on button press in hSampleLeft.
function hSampleLeft_Callback(hObject, eventdata, handles)
setappdata(handles.figure1,'strMouseOp','SampleLeft');
set(handles.figure1,'Pointer','crosshair');

function hSampleRight_Callback(hObject, eventdata, handles)
setappdata(handles.figure1,'strMouseOp','SampleRight');
set(handles.figure1,'Pointer','crosshair');



% --- Executes on button press in hGenerateSurface.
function hGenerateSurface_Callback(hObject, eventdata, handles)
set(handles.hGenerateSurface,'enable','off');
set(handles.hNext,'enable','off');
drawnow

strctVol = getappdata(handles.figure1,'strctVol');
% a3fConvSub = fnSubSample(strctVol.m_a3fVol,strctVol.m_strctIsoSurfParam);


   
% HERE
a3bBrainMask = getappdata(handles.figure1,'a3bBrainMask');
bUseMask = get(handles.hUseAtlas,'value') > 0;
bPickLargest = get(handles.hKeepLargest,'value') > 0;
if bUseMask
    [strctVol.m_strctSurface, strctVol.m_a3bSurfaceVolume] = fnComputeIsoSurfaceNew(strctVol,a3bBrainMask,bPickLargest);
else
    [strctVol.m_strctSurface, strctVol.m_a3bSurfaceVolume] = fnComputeIsoSurfaceNew(strctVol,[],bPickLargest);
end


hMainVolSurface = getappdata(handles.figure1,'hMainVolSurface');

if ishandle(hMainVolSurface)
    delete(hMainVolSurface);
end

axes(handles.hAxes3D);
cla(handles.hAxes3D);
hMainVolSurface = patch(strctVol.m_strctSurface, 'parent',handles.hAxes3D,'visible','on');
set(hMainVolSurface,'FaceColor','y','EdgeColor','none','facealpha',0.6);
setappdata(handles.figure1,'hMainVolSurface',hMainVolSurface);
axis equal
camlight('left')
lighting('gouraud');

setappdata(handles.figure1,'strctVol',strctVol);
set(handles.hNext,'enable','on');
set(handles.hGenerateSurface,'enable','on');

return;

function [bInside] = fnInsideAxes(window_handle,MousePos)
AxesRect = get(window_handle,'Position');
bInside =  (MousePos(1) > AxesRect(1) && ...
    MousePos(1) < AxesRect(1)+AxesRect(3) && ...
    MousePos(2) > AxesRect(2) &&  ...
    MousePos(2) < AxesRect(2)+AxesRect(4));
return;


% --- Executes on slider movement.
function hHistHorizSlider_Callback(hObject, eventdata, handles)
% hObject    handle to hHistHorizSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function hHistHorizSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hHistHorizSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function hHistVertSlider_Callback(hObject, eventdata, handles)
% hObject    handle to hHistVertSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function hHistVertSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hHistVertSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in hSkip.
function hSkip_Callback(hObject, eventdata, handles)
global g_TMP
strctVol = getappdata(handles.figure1,'strctVol');
strctVol.m_strctIsoSurfParam.m_bDisplay = false;
g_TMP = strctVol;
delete(gcbf);


function [strctSurface, a3bVolume] = fnComputeIsoSurfaceNew(strctVol,  a3bBrainMask, bPickLargest)
if ~exist('a3bBrainMask','var')
    a3bBrainMask = [];
end
if ~exist('bPickLargest','var')
    bPickLargest = true;
end

a3bVol= strctVol.m_a3fVol > strctVol.m_strctIsoSurfParam.m_fLeftThreshold & strctVol.m_a3fVol <= strctVol.m_strctIsoSurfParam.m_fRightThreshold;

if ~isempty(a3bBrainMask)
    a3bVol(~a3bBrainMask) = 0;
else
    
    a3bVolOpen = fnMyOpen(a3bVol,1);
    strctVol.m_strctIsoSurfParam.m_iLargeCCSize=5000;
    if strctVol.m_strctIsoSurfParam.m_iLargeCCSize > 0
        [a3iLabeled,iNumCC] = bwlabeln(a3bVolOpen);
        aiHist = histc(a3iLabeled(:),1:iNumCC);
        if bPickLargest
            % Pick biggest one
            [fDummy, iIndex]=max(aiHist);
            %a3bVol = fndllSelectLabels(uint16(a3iLabeled), uint16(find(aiHist > strctVol.m_strctIsoSurfParam.m_iLargeCCSize))) > 0;
            a3bVol =a3iLabeled == iIndex;
        else
            a3bVol = fndllSelectLabels(uint16(a3iLabeled),uint16(find(aiHist(2:end)>strctVol.m_strctIsoSurfParam.m_iLargeCCSize))) > 0;
        end
        
    else
        a3bVol = a3bVolOpen;
    end
end
a3bVolume = a3bVol;

a3bVolSub = a3bVol(1:2:end,1:2:end,1:2:end);
aiVolSize = size(a3bVol);
[a3iX,a3iY, a3iZ] = ...
    meshgrid([0:2:aiVolSize(2)-1],...
    [0:2:aiVolSize(1)-1],...
    [0:2:aiVolSize(3)-1]);


strctSurfaceLargeMesh = isosurface(a3iX,a3iY, a3iZ,a3bVolSub, 0.5);
strctSurface = reducepatch(strctSurfaceLargeMesh, strctVol.m_strctIsoSurfParam.m_iNumFaces);

return;





% --- Executes on button press in hNext.
function hNext_Callback(hObject, eventdata, handles)
global g_TMP
strctVol = getappdata(handles.figure1,'strctVol');
strctVol.m_strctIsoSurfParam.m_bDisplay = true;
g_TMP = strctVol;
delete(gcbf);



function hNumberOfFaces_Callback(hObject, eventdata, handles)
strctVol = getappdata(handles.figure1,'strctVol');
strctVol.m_strctIsoSurfParam.m_iNumFaces = str2double(get(handles.hNumberOfFaces,'String'));
setappdata(handles.figure1,'strctVol',strctVol);
hGenerateSurface_Callback(hObject, eventdata, handles);
return;


% --- Executes during object creation, after setting all properties.
function hNumberOfFaces_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hNumberOfFaces (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in hUseAtlas.
function hUseAtlas_Callback(hObject, eventdata, handles)
% hObject    handle to hUseAtlas (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of hUseAtlas
 fnInvalidate2D(handles);


% --- Executes on button press in hKeepLargest.
function hKeepLargest_Callback(hObject, eventdata, handles)
% hObject    handle to hKeepLargest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of hKeepLargest
