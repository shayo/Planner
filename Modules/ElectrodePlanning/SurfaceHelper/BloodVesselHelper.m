function varargout = BloodVesselHelper(varargin)
% BLOODVESSELHELPER M-file for BloodVesselHelper.fig
%      BLOODVESSELHELPER, by itself, creates a new BLOODVESSELHELPER or raises the existing
%      singleton*.
%
%      H = BLOODVESSELHELPER returns the handle to a new BLOODVESSELHELPER or the handle to
%      the existing singleton*.
%
%      BLOODVESSELHELPER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BLOODVESSELHELPER.M with the given input
%      arguments.
%
%      BLOODVESSELHELPER('Property','Value',...) creates a new BLOODVESSELHELPER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before BloodVesselHelper_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to BloodVesselHelper_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help BloodVesselHelper

% Last Modified by GUIDE v2.5 09-Nov-2011 17:13:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @BloodVesselHelper_OpeningFcn, ...
    'gui_OutputFcn',  @BloodVesselHelper_OutputFcn, ...
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


% --- Executes just before BloodVesselHelper is made visible.
function BloodVesselHelper_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to BloodVesselHelper (see VARARGIN)

% Choose default command line output for BloodVesselHelper
global g_handles

handles.output = hObject;
strctVol =varargin{1};
strctVol.m_strctBloodSurface  = [];
g_handles = handles;
%set(handles.figure1,'CloseRequestFcn',@my_closereq)
strctVol.m_strctFrangiParam= fnGetDefaultFrangiParamters();

setappdata(handles.figure1,'strctVol',strctVol );

set(handles.hAxesImage,'visible','off');
set(handles.hAxes3D,'visible','off');
set(handles.hAxesHist,'visible','off');
set(handles.hNext,'enable','off');
set(handles.hGenerateSurface,'enable','off');
set(handles.hHistHorizSlider,'visible','off');
set(handles.hHistVertSlider,'visible','off');
set(handles.hParamPanel,'visible','off');

set(handles.hNumberOfFaces,'String', num2str(strctVol.m_strctFrangiParam.NumberOfFaces));

setappdata(handles.figure1,'bMouseDown',0);
strctVol = getappdata(handles.figure1,'strctVol');
global g_TMP
g_TMP = strctVol;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes BloodVesselHelper wait for user response (see UIRESUME)
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
global g_strctModule
strctVol = getappdata(handles.figure1,'strctVol');
bCropUsingAtlas = get(handles.hUseAtlas,'value') >0;

set(handles.figure1,'visible','on');
drawnow


% a3fVesselness=1e4*FrangiFilter3D(strctVol.m_a3fVol,strctFrangiParam); 
% 
% 
% setappdata(handles.figure1,'a3fVesselness',a3fVesselness);
 a2fXYZ_To_CRS = inv(strctVol.m_a2fM) * inv(strctVol.m_a2fReg);
   
 strctCrossSectionHoriz = strctVol.m_strctCrossSectionHoriz;
 strctCrossSectionHoriz.m_a2fM(1:3,4)    = strctCrossSectionHoriz.m_a2fM(1:3,4) + strctCrossSectionHoriz.m_a2fM(1:3,3) * strctCrossSectionHoriz.m_fViewOffsetMM;

a3fVesselness = 1e4*FrangiFilter3D(strctVol.m_a3fVol,strctVol.m_strctFrangiParam); 

if bCropUsingAtlas
  a3bBrainMask=fnGetBrainMask();
%        a3bBrainMaskDilated = fnMyDilate(a3bBrainMask,1);
       a3fVesselness(~a3bBrainMask ) = 0;
end

setappdata(handles.figure1,'a3fVesselness',a3fVesselness);
a2fHoriz    = fnResampleCrossSection(a3fVesselness, a2fXYZ_To_CRS, strctCrossSectionHoriz);

afValues = a3fVesselness(a3fVesselness > 0);
[strctHist.m_afHist,strctHist.m_afRange]=hist(afValues(:),1500);

plot(log10(strctHist.m_afRange),log10(strctHist.m_afHist),'parent',handles.hAxesHist);
setappdata(handles.figure1,'strctHist',strctHist);
hold(handles.hAxesHist,'on');


iIndex = find(cumsum(strctHist.m_afHist) / sum(strctHist.m_afHist) > 0.995,1,'first');

setappdata(handles.figure1,'a2fHoriz',a2fHoriz);

% setappdata(handles.figure1,'astrctControllers',strctThresholdController);
strctVol.m_strctFrangiParam.fVesselnessThreshold = strctHist.m_afRange(iIndex);

setappdata(handles.figure1,'strctVol',strctVol);

hThreshold = plot(log10([strctVol.m_strctFrangiParam.fVesselnessThreshold strctVol.m_strctFrangiParam.fVesselnessThreshold]),[0 log10(max(strctHist.m_afHist))],'r','LineWidth',2,'parent',handles.hAxesHist);
setappdata(handles.figure1,'hThreshold',hThreshold);

hImageHoriz = image(zeros(256,256,3),'parent',handles.hAxesImage);
setappdata(handles.figure1,'hImageHoriz',hImageHoriz);
set(handles.hAxesImage,'visible','off');
hold(handles.hAxesImage,'on');
fnInvalidate2D(handles);

return;

% function a3fCdata=fnJetTransform(a2fSlice)
% colormapjet = colormap('jet');
% a2fSlice(isnan(a2fSlice)) = 0;
% a2fSlice(isinf(a2fSlice)) = 1;
% a2fSliceEq = (a2fSlice - min(a2fSlice(:))) / (eps+max(a2fSlice(:))-min(a2fSlice(:)));
% iNumColors = size(colormapjet,1);
% ColorIndices = round(1+ a2fSliceEq*(iNumColors-1));
% a3fCdata = zeros([size(a2fSliceEq),3]);
% a3fCdata(:,:,1) = reshape(colormapjet(ColorIndices,1),size(a2fSliceEq));
% a3fCdata(:,:,2) = reshape(colormapjet(ColorIndices,2),size(a2fSliceEq));
% a3fCdata(:,:,3) = reshape(colormapjet(ColorIndices,3),size(a2fSliceEq));
% return;

function a2iOutput=fnMyErode(a2iInput,fSize)
a2iOutput = bwdist(~a2iInput)>fSize;
function a2iOutput=fnMyDilate(a2iInput,fSize)
a2iOutput = bwdist(a2iInput)<fSize;
function a2iOut=fnMyClose(a2iInput,fSize)
a2iOut = fnMyErode(fnMyDilate(a2iInput,fSize-0.0001),fSize-0.0001);
function a2iOutput=fnMyOpen(a2iInput,fSize)
a2iOutput = fnMyDilate(fnMyErode(a2iInput,fSize+0.0001),fSize+0.0001);

function fnInvalidate2D(handles)
strctVol = getappdata(handles.figure1,'strctVol');
a3fVesselness = getappdata(handles.figure1,'a3fVesselness');
hImageHoriz = getappdata(handles.figure1,'hImageHoriz');

strctCrossSectionHoriz = strctVol.m_strctCrossSectionHoriz;
strctCrossSectionHoriz.m_a2fM(1:3,4)    = strctCrossSectionHoriz.m_a2fM(1:3,4) + strctCrossSectionHoriz.m_a2fM(1:3,3) * strctCrossSectionHoriz.m_fViewOffsetMM;
a2fXYZ_To_CRS = inv(strctVol.m_a2fM) * inv(strctVol.m_a2fReg);
a2fHorizVessel    = fnResampleCrossSection(a3fVesselness, a2fXYZ_To_CRS, strctCrossSectionHoriz);
a2fHoriz          = fnResampleCrossSection(strctVol.m_a3fVol, a2fXYZ_To_CRS, strctCrossSectionHoriz);
a2bBlood = a2fHorizVessel    > strctVol.m_strctFrangiParam.fVesselnessThreshold;
a3fHoriz = fnDup3(fnContrastTransform(a2fHoriz, strctVol.m_strctContrastTransform));
X=a3fHoriz(:,:,1);
X(a2bBlood) = 0.5;
a3fHoriz(:,:,1)=X;
set(hImageHoriz,'cdata',a3fHoriz);

return;


% --- Outputs from this function are returned to the command line.
function varargout = BloodVesselHelper_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure

global g_TMP
varargout{1} = g_TMP;
clear global g_TMP

return;


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
hThreshold = getappdata(handles.figure1,'hThreshold');

hBloodVolSurface = getappdata(handles.figure1,'hBloodVolSurface');
hImageHoriz = getappdata(handles.figure1,'hImageHoriz');

if currobj == hThreshold
    setappdata(handles.figure1,'strMouseOp','Threshold');
elseif ~isempty(hBloodVolSurface) && currobj == hBloodVolSurface
    setappdata(handles.figure1,'strMouseOp','Rotate');
    Tmp = get(handles.figure1,'CurrentPoint');
    setappdata(handles.figure1,'PrevMousePos',Tmp(1,1:2));
end


return;
 

function fnMouseUp(obj,eventdata,handles)
setappdata(handles.figure1,'bMouseDown',0);
setappdata(handles.figure1,'strMouseOp','');



function fnMouseMove(obj,eventdata,handles)
strMouseOp = getappdata(handles.figure1,'strMouseOp');
bMouseDown = getappdata(handles.figure1,'bMouseDown');
hThreshold = getappdata(handles.figure1,'hThreshold');

if bMouseDown && ~isempty(strMouseOp) && strcmp(strMouseOp,'Threshold')
    Tmp = get(handles.hAxesHist,'CurrentPoint');
    fNewThreshold = Tmp(1,1);
    strctVol = getappdata(handles.figure1,'strctVol');
    
    strctVol.m_strctFrangiParam.fVesselnessThreshold = 10^fNewThreshold;
    
    setappdata(handles.figure1,'strctVol',strctVol);    
    set(hThreshold,'xdata',[fNewThreshold fNewThreshold]);
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



% --- Executes on button press in hGenerateSurface.
function hGenerateSurface_Callback(hObject, eventdata, handles)
% set(handles.hGenerateSurface,'enable','off');
set(handles.hNext,'enable','off');
drawnow

strctVol = getappdata(handles.figure1,'strctVol');
% a3fConvSub = fnSubSample(strctVol.m_a3fVol,strctVol.m_strctIsoSurfParam);
a3fVesselness = getappdata(handles.figure1,'a3fVesselness');
[strctVol.m_strctBloodSurface,strctVol.m_a3bBloodVolume] = fnComputeBloodSurfaceNew(strctVol,a3fVesselness);

hBloodVolSurface = getappdata(handles.figure1,'hBloodVolSurface');

if ishandle(hBloodVolSurface)
    delete(hBloodVolSurface);
end

axes(handles.hAxes3D);
cla(handles.hAxes3D);
hBloodVolSurface = patch(strctVol.m_strctBloodSurface, 'parent',handles.hAxes3D,'visible','on');
set(hBloodVolSurface,'FaceColor','r','EdgeColor','none','facealpha',0.6);
setappdata(handles.figure1,'hBloodVolSurface',hBloodVolSurface);
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
strctVol.m_strctFrangiParam.m_bDisplay = false;
g_TMP = strctVol;
delete(gcbf);


function [strctSurface,a3bVolume] = fnComputeBloodSurfaceNew(strctVol,a3fVesselness)
a3bVolumeRAW = a3fVesselness >= strctVol.m_strctFrangiParam.fVesselnessThreshold;
% Morphological stuff
a3bClosed = fnMyClose(a3bVolumeRAW, 5);
a3iLabeled = uint16(bwlabeln(a3bClosed));
aiHist = histc(a3iLabeled(:), 0:max(a3iLabeled(:)));
%aiHist = fndllLabelsHist((a3iLabeled));
aiSelected = find(aiHist(2:end) > 5);
a3bVolume = fndllSelectLabels(a3iLabeled,uint16(aiSelected)) > 0;
%
strctSurfaceLargeMesh = isosurface(a3bVolume,0.5);%a3iX,a3iY, a3iZ,a3bVolSub, 0.5);
strctSurface = reducepatch(strctSurfaceLargeMesh, strctVol.m_strctFrangiParam.NumberOfFaces);

return;



% --- Executes on button press in hNext.
function hNext_Callback(hObject, eventdata, handles)
global g_TMP
strctVol = getappdata(handles.figure1,'strctVol');

strctVol.m_strctFrangiParam.m_bDisplay = true;
g_TMP = strctVol;
delete(gcbf);



function hNumberOfFaces_Callback(hObject, eventdata, handles)
strctVol = getappdata(handles.figure1,'strctVol');
strctVol.m_strctFrangiParam.NumberOfFaces = str2double(get(hObject,'String'));
setappdata(handles.figure1,'strctVol',strctVol);
return;


function hNumberOfFaces_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function hFindVessels_Callback(hObject, eventdata, handles)
set(handles.hSkip,'enable','off');
set(handles.hFindVessels,'enable','off');

drawnow
fnFirstInvalidate(handles);

set(handles.hAxesImage,'visible','on');
set(handles.hAxes3D,'visible','on');
set(handles.hAxesHist,'visible','on');
set(handles.hGenerateSurface,'enable','on');
set(handles.hHistHorizSlider,'visible','on');
set(handles.hHistVertSlider,'visible','on');
set(handles.hParamPanel,'visible','on');
set(handles.hFindVessels,'enable','on');

set(handles.figure1,'WindowScrollWheelFcn',{@fnMouseWheel,handles});
set(handles.figure1,'WindowButtonMotionFcn',{@fnMouseMove,handles});
set(handles.figure1,'WindowButtonDownFcn',{@fnMouseDown,handles});
set(handles.figure1,'WindowButtonUpFcn',{@fnMouseUp,handles});

return;


% --- Executes on button press in hUseAtlas.
function hUseAtlas_Callback(hObject, eventdata, handles)
