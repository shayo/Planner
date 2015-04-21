function varargout = ImageRegis(varargin)
% IMAGEREGIS MATLAB code for ImageRegis.fig
%      IMAGEREGIS, by itself, creates a new IMAGEREGIS or raises the existing
%      singleton*.
%
%      H = IMAGEREGIS returns the handle to a new IMAGEREGIS or the handle to
%      the existing singleton*.
%
%      IMAGEREGIS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMAGEREGIS.M with the given input arguments.
%
%      IMAGEREGIS('Property','Value',...) creates a new IMAGEREGIS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ImageRegis_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ImageRegis_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ImageRegis

% Last Modified by GUIDE v2.5 14-Jun-2013 14:17:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ImageRegis_OpeningFcn, ...
                   'gui_OutputFcn',  @ImageRegis_OutputFcn, ...
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


% --- Executes just before ImageRegis is made visible.
function ImageRegis_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ImageRegis (see VARARGIN)

% Choose default command line output for ImageRegis
handles.output = hObject;
set(handles.slider1,'min',0,'max',1,'value',0.5);
setappdata(handles.figure1,'iSelectedZ',1);
setappdata(handles.figure1,'bShowAnnotations',true);
fnOpenFigure(handles);
fnLoadDatabase(handles);
set(handles.figure1,'CloseRequestFcn',{@fnClose,handles});

% Update handles structure
guidata(hObject, handles);

function fnClose(hFig,b,handles)
hFig=getappdata(handles.figure1,'hFig');
answer = questdlg('Save changes?','Save Dialog','Yes','No','Yes');
if strcmp(answer,'Yes')
    fnSaveDatabase(handles);
end

try
    delete(hFig)
catch
end
delete(handles.figure1);
return;

% UIWAIT makes ImageRegis wait for user response (see UIRESUME)
% uiwait(handles.figure1);
function [hFig, hAxes,hImage,aiFigurePosition]=fnOpenFigure(handles)
hFig = figure;
%maximize_new(hFig);
drawnow
hAxes = axes('parent',hFig);
setappdata(handles.figure1,'strViewMode','TissueBlock');
setappdata(handles.figure1,'hFig',hFig);
setappdata(handles.figure1,'hAxes',hAxes);
set(hAxes,'units','pixels');
set(hFig,'units','pixels');
set(hFig,'toolBar','none')
set(hFig,'menuBar','none')
setappdata(hFig,'handles',handles);
set(hFig,'ResizeFcn',@fnResizeFig);
setappdata(handles.figure1,'strMouseMode','Zoom');

setappdata(handles.figure1,'bMouseDown',false);

set(hFig,'WindowButtonMotionFcn',{@fnMouseMove,handles});
set(hFig,'WindowButtonDownFcn',{@fnMouseDown,handles});
set(hFig,'WindowButtonUpFcn',{@fnMouseUp,handles});
set(hFig,'WindowScrollWheelFcn',{@fnMouseWheel,handles});
set(hFig,'KeyPressFcn',{@fnKeyDown,handles});
%set(hFig,'KeyReleaseFcn',@fnKeyUp);

aiFigurePosition = get(hFig,'position');
set(hAxes,'position',[0 0 aiFigurePosition(3) aiFigurePosition(4)]);
hImage = getappdata(handles.figure1,'hImage');

if ishandle(hImage)
    delete(hImage);
end;
hImage=image(0:aiFigurePosition(3)-1,0:aiFigurePosition(4)-1,zeros(aiFigurePosition(4),aiFigurePosition(3),3),'parent',hAxes);
axis(hAxes,'off');
hold(hAxes,'on');
setappdata(handles.figure1,'hImage',hImage);


hMenu = uicontextmenu();
uimenu(hMenu, 'Label', 'Reset View','Callback', {@fnImageRegisCallback,handles,'ResetView'});
uimenu(hMenu, 'Label', 'Reset Contrast','Callback', {@fnImageRegisCallback,handles,'ResetContrast'});

uimenu(hMenu, 'Label', 'Contrast Left','Callback', {@fnImageRegisCallback,handles,'ContrastLeft'});
uimenu(hMenu, 'Label', 'Contrast Right','Callback', {@fnImageRegisCallback,handles,'ContrastRight'});

uimenu(hMenu, 'Label', 'Pan','Callback', {@fnImageRegisCallback,handles,'Pan'});
uimenu(hMenu, 'Label', 'Zoom','Callback', {@fnImageRegisCallback,handles,'Zoom'});
uimenu(hMenu, 'Label', 'Rotate','Callback', {@fnImageRegisCallback,handles,'RotateView'});

uimenu(hMenu, 'Label', 'Focus','Callback', {@fnImageRegisCallback,handles,'Focus'});
uimenu(hMenu, 'Label', 'Annotate','Callback', {@fnImageRegisCallback,handles,'Annotate'},'separator','on');
uimenu(hMenu, 'Label', 'Reset Registration','Callback', {@fnImageRegisCallback,handles,'ResetReg'},'separator','on');

hHighMagMenu = uimenu(hMenu, 'Label', 'High Mag');

uimenu(hHighMagMenu, 'Label', 'Move','Callback', {@fnImageRegisCallback,handles,'MoveHighMag'});
uimenu(hHighMagMenu, 'Label', 'Rotate','Callback', {@fnImageRegisCallback,handles,'RotateHighMag'});
uimenu(hHighMagMenu, 'Label', 'Scale(Keep Aspect)','Callback', {@fnImageRegisCallback,handles,'ScaleHighMagKeepAspect'});
uimenu(hHighMagMenu, 'Label', 'Scale(No Aspect)','Callback', {@fnImageRegisCallback,handles,'ScaleHighMagDontKeepAspect'});

hWideFieldMenu= uimenu(hMenu, 'Label', 'Wide Field');

uimenu(hWideFieldMenu, 'Label', 'Move','Callback', {@fnImageRegisCallback,handles,'MoveWideField'});
uimenu(hWideFieldMenu, 'Label', 'Rotate','Callback', {@fnImageRegisCallback,handles,'RotateWideField'});
uimenu(hWideFieldMenu, 'Label', 'Scale(Keep Aspect)','Callback', {@fnImageRegisCallback,handles,'ScaleWideFieldKeepAspect'});
uimenu(hWideFieldMenu, 'Label', 'Scale(X)','Callback', {@fnImageRegisCallback,handles,'ScaleWideFieldX'});
uimenu(hWideFieldMenu, 'Label', 'Scale(Y)','Callback', {@fnImageRegisCallback,handles,'ScaleWideFieldY'});

uimenu(hWideFieldMenu, 'Label', 'Flip Horizonal','Callback', {@fnImageRegisCallback,handles,'FlipWideFieldHorizontal'});

set(hImage,'uicontextmenu',hMenu);
return;

function fnKeyDown(a,strctKey,handles)
if strcmpi(strctKey.Key,'comma')
    % Lower intensity
    fWeight=get(handles.slider1,'value');
    fWeight=max(0,fWeight-0.1);
    set(handles.slider1,'value',fWeight);
    fnInvalidate(handles);
end

if strcmpi(strctKey.Key,'period')
    % increase intensity
    fWeight=get(handles.slider1,'value');
    fWeight=min(1,fWeight+0.1);
    set(handles.slider1,'value',fWeight);
    fnInvalidate(handles);
end

if strcmpi(strctKey.Key,'space')
    % toggle overlay
    bShowAnnotations = getappdata(handles.figure1,'bShowAnnotations');
    if isempty(bShowAnnotations)
        bShowAnnotations= true;
    end;
    bShowAnnotations = ~bShowAnnotations;
    setappdata(handles.figure1,'bShowAnnotations',bShowAnnotations);
     fnInvalidate(handles);
end

return

function fnImageRegisCallback(hFig,b,handles,strCallback)
switch strCallback
    case 'Pan'
        setappdata(handles.figure1,'strMouseMode','Pan');
    case 'RotateView'
        setappdata(handles.figure1,'strMouseMode','RotateView');
    case 'Zoom'
        setappdata(handles.figure1,'strMouseMode','Zoom');
    case 'Focus'
        setappdata(handles.figure1,'strMouseMode','Focus');
    case 'ResetView'
        fnResetView(handles);
    case 'ContrastLeft'
        setappdata(handles.figure1,'strMouseMode','ContrastLeft');
    case 'ContrastRight'
        setappdata(handles.figure1,'strMouseMode','ContrastRight');
        
    case 'ScaleWideFieldKeepAspect'
        setappdata(handles.figure1,'strMouseMode','ScaleWideFieldKeepAspect');
    case 'ScaleWideFieldX'
        setappdata(handles.figure1,'strMouseMode','ScaleWideFieldX');
    case 'ScaleWideFieldY'
        setappdata(handles.figure1,'strMouseMode','ScaleWideFieldY');
        
    case 'RotateWideField'
        
        setappdata(handles.figure1,'strMouseMode','RotateWideField');
    case 'MoveWideField'
        setappdata(handles.figure1,'strMouseMode','MoveWideField');
        
    case 'FlipWideFieldHorizontal'
        fnFlipWideFieldHorizontal(handles);
    case 'ScaleHighMagKeepAspect'
        setappdata(handles.figure1,'strMouseMode','ScaleHighMagKeepAspect');
    case 'ScaleHighMagDontKeepAspect'
        setappdata(handles.figure1,'strMouseMode','ScaleHighMagDontKeepAspect');
    case 'RotateHighMag'
        setappdata(handles.figure1,'strMouseMode','RotateHighMag');
    case 'MoveHighMag'
        setappdata(handles.figure1,'strMouseMode','MoveHighMag');
    case 'ResetContrast'
        fnResetContrast(handles);
    case 'ResetReg'
        fnResetReg(handles);
    case 'Annotate'
        setappdata(handles.figure1,'strMouseMode','Annotate');        
end

return

function fnResetView(handles)
    hFig = getappdata(handles.figure1,'hFig');
    aiFigurePosition = get(hFig,'position');
    fScreenWidth = aiFigurePosition(3);
    fScreenHeight = aiFigurePosition(4);
    
    hAxes = getappdata(handles.figure1,'hAxes');
    set(hAxes,'xlim',[0 aiFigurePosition(3)],'ylim',[0 aiFigurePosition(4)]);
 
if get(handles.hTissueBlockVis,'value') > 0
    TissueBlockData= getappdata(handles.figure1,'TissueBlockData');
    fImageWidth = size(TissueBlockData,2);
    fImageHeight = size(TissueBlockData,1);
 
elseif get(handles.hWideFieldOnly,'value') > 0
    WideFieldData = getappdata(handles.figure1,'WideFieldData');
    fImageWidth = size(WideFieldData,2);
    fImageHeight = size(WideFieldData,1);
    
elseif get(handles.hCombinedView,'value') > 0
    WideFieldData = getappdata(handles.figure1,'WideFieldData');
    fImageWidth = size(WideFieldData,2);
    fImageHeight = size(WideFieldData,1);
else
    HighMagData = getappdata(handles.figure1,'HighMagData');
    fImageWidth = size(HighMagData,2);
    fImageHeight = size(HighMagData,1);
    
end

a2fViewTrans=fnResizeKeepAspect(fImageWidth,fImageHeight, fScreenWidth, fScreenHeight);
setappdata(handles.figure1,'a2fViewTrans',a2fViewTrans);
fnInvalidate(handles);
return


function pt2fMouseDownPosition = fnGetMouseCoordinate(hAxes)
pt2fMouseDownPosition = get(hAxes,'CurrentPoint');
if size(pt2fMouseDownPosition,2) ~= 3
    pt2fMouseDownPosition = [-1 -1];
else
    pt2fMouseDownPosition = [pt2fMouseDownPosition(1,1), pt2fMouseDownPosition(1,2)];
end;
return;

function fnMouseMove(obj,eventdata,handles)
if ~ishandle(handles.figure1)
    return;
end;
hAxes=getappdata(handles.figure1,'hAxes');
if ~ishandle(hAxes)
    return;
end;
hFig=getappdata(handles.figure1,'hFig');
strctMouseOp.m_strButton = []; 
strctMouseOp.m_strAction = 'Move';
strctMouseOp.m_pt2fPos = fnGetMouseCoordinate(hAxes);
setappdata(handles.figure1,'strctMouseOp',strctMouseOp);
bMouseDown=getappdata(handles.figure1,'bMouseDown');
if (bMouseDown)
    fnHandleMouseWhileMoving(handles);
end
setappdata(handles.figure1,'strctPrevMouseOp',strctMouseOp);
return;

function fnUpdateWideField(handles,strctWideField)
iActiveTissueBlock = get(handles.hTissueBlockList,'value');
astrctTissueBlock = getappdata(handles.figure1,'astrctTissueBlock');
iActiveWideField = get(handles.hWideFieldList,'value');
astrctTissueBlock(iActiveTissueBlock).m_astrctWideField(iActiveWideField) = strctWideField;
setappdata(handles.figure1,'astrctTissueBlock',astrctTissueBlock);
return;


function [strctWideField, a2fElectrodeLines] = fnGetActiveWideField(handles)
iActiveTissueBlock = get(handles.hTissueBlockList,'value');
astrctTissueBlock = getappdata(handles.figure1,'astrctTissueBlock');
iActiveWideField = get(handles.hWideFieldList,'value');

if isempty(iActiveWideField) || iActiveWideField == 0 || isempty(astrctTissueBlock(iActiveTissueBlock).m_astrctWideField)
    strctWideField  = [];
    a2fElectrodeLines =[];
else
    strctWideField = astrctTissueBlock(iActiveTissueBlock).m_astrctWideField(iActiveWideField);
    a2fElectrodeLines = astrctTissueBlock(iActiveTissueBlock).m_a2fElectrodeProjectionLines;
end
return;


function fnScaleHighMag(handles,bKeepAspect)
if ~(get(handles.hHighMagOnly,'value') >0 || get(handles.hCombinedView,'value') >0)
    return;
end
strctPrevMouseOp = getappdata(handles.figure1,'strctPrevMouseOp');
strctMouseOp = getappdata(handles.figure1,'strctMouseOp');
afDelta = strctPrevMouseOp.m_pt2fPos-strctMouseOp.m_pt2fPos;

strctWideField = fnGetActiveWideField(handles);
iSelectedHighMag = get(handles.hHighMagList,'value');
a2fReg = strctWideField.m_astrctHighMag(iSelectedHighMag).m_a2fRegToWideField;

if abs(afDelta(1)) > 3
if afDelta(1) > 0
    fAlphaX = 0.01;
else
    fAlphaX = -0.01;
end
else
    fAlphaX  =0;
end
if abs(afDelta(2)) > 3
if afDelta(2) > 0
    fAlphaY = 0.01;
else
    fAlphaY = -0.01;
end
else
    fAlphaY =0;
end
if bKeepAspect
    fAlphaY=fAlphaX;
end

strctWideField.m_astrctHighMag(iSelectedHighMag).m_a2fRegToWideField = [max(0.01,1+fAlphaX),0,0;0,max(0.01,1+fAlphaY),0;0,0,1]*a2fReg ;
fnUpdateWideField(handles,strctWideField);
fnInvalidate(handles);
return



function fnFlipWideFieldHorizontal(handles)
strctWideField = fnGetActiveWideField(handles);
strctWideField.m_a2fRegToTissueBlock(1,1) = -strctWideField.m_a2fRegToTissueBlock(1,1);
%strctWideField.m_a2fRegToTissueBlock(2,2) = -strctWideField.m_a2fRegToTissueBlock(2,2);
fnUpdateWideField(handles,strctWideField);
fnInvalidate(handles);
return

function fnScaleWideField(handles,strWhat)
strctPrevMouseOp = getappdata(handles.figure1,'strctPrevMouseOp');
strctMouseOp = getappdata(handles.figure1,'strctMouseOp');
afDelta = strctPrevMouseOp.m_pt2fPos-strctMouseOp.m_pt2fPos;

strctWideField = fnGetActiveWideField(handles);
a2fReg = strctWideField.m_a2fRegToTissueBlock;

    
    fHowMuch = 0.01;

if afDelta(1) > 0
    fAlphaX = fHowMuch;
else
    fAlphaX = -fHowMuch;
end

if afDelta(2) > 0
    fAlphaY = fHowMuch;
else
    fAlphaY = -fHowMuch;
end

if strcmpi(strWhat,'Both')
    fAlphaY=fAlphaX;
elseif strcmpi(strWhat,'X')
    fAlphaY = 0;
elseif strcmpi(strWhat,'Y')
    fAlphaX = 0;    
end

strctWideField.m_a2fRegToTissueBlock = [max(0.01,1+fAlphaX),0,0;0,max(0.01,1+fAlphaY),0;0,0,1]*a2fReg ;
fnUpdateWideField(handles,strctWideField);
fnInvalidate(handles);
return




function fnFocus(handles)
strctMouseOp = getappdata(handles.figure1,'strctMouseDownOp');
a2fViewTrans = getappdata(handles.figure1,'a2fViewTrans'); % Screen to image
% Screen To Image


WideFieldData = getappdata(handles.figure1,'WideFieldData');
hFig = getappdata(handles.figure1,'hFig');
aiFigurePosition = get(hFig,'position');

fImageWidth = size(WideFieldData,2);
fImageHeight = size(WideFieldData,1);
fScreenWidth = aiFigurePosition(3);
fScreenHeight = aiFigurePosition(4);

% First, 

Tmp = a2fViewTrans*[strctMouseOp.m_pt2fPos(:);1];

a2fPan = [1,0,-Tmp(1);
          0,1,-Tmp(2);
          0,0,1];
      
fAlpha = 2;

a2fViewTrans = inv(a2fPan)*[1+fAlpha,0,0;0,1+fAlpha,0;0,0,1]*(a2fPan)*a2fViewTrans ;
setappdata(handles.figure1,'a2fViewTrans',a2fViewTrans);
fnInvalidate(handles);
return

function fnZoom(handles)
strctPrevMouseOp = getappdata(handles.figure1,'strctPrevMouseOp');
strctMouseOp = getappdata(handles.figure1,'strctMouseOp');
afDelta = strctPrevMouseOp.m_pt2fPos-strctMouseOp.m_pt2fPos;
a2fViewTrans = getappdata(handles.figure1,'a2fViewTrans'); % Screen to image

Tmp = a2fViewTrans*[strctMouseOp.m_pt2fPos(:);1];
a2fPan = [1,0,-Tmp(1);
          0,1,-Tmp(2);
          0,0,1];
if afDelta(2) > 0
    fAlpha = 0.1;
else
    fAlpha = -0.1;
end
a2fViewTrans = inv(a2fPan)*[1+fAlpha,0,0;0,1+fAlpha,0;0,0,1]*(a2fPan)*a2fViewTrans ;
setappdata(handles.figure1,'a2fViewTrans',a2fViewTrans);
fnInvalidate(handles);
return




function fnResetContrast(handles)

if get(handles.hWideFieldOnly,'value')
    fnResetWideFieldContrast(handles);
elseif  get(handles.hHighMagOnly,'value')
    fnResetHighMagContrast(handles);
else
    fnResetWideFieldContrast(handles);
    fnResetHighMagContrast(handles);
end
fnInvalidate(handles);
return


function fnResetHighMagContrast(handles)
strctWideField = fnGetActiveWideField(handles);
iSelectedHighMag = get(handles.hHighMagList,'value');
aiSelectedChannels = get(handles.hHighMagChannels,'value');
for k=1:length(aiSelectedChannels)
    iChannel = aiSelectedChannels(k);
    if (iChannel > length(strctWideField.m_astrctHighMag(iSelectedHighMag).m_astrctChannels))
        continue;
    end;

    strctWideField.m_astrctHighMag(iSelectedHighMag).m_astrctChannels(iChannel).m_strctContrastTransform.m_fLeftX= ...
        strctWideField.m_astrctHighMag(iSelectedHighMag).m_astrctChannels(iChannel).m_strctContrastTransform.m_fMin;

    strctWideField.m_astrctHighMag(iSelectedHighMag).m_astrctChannels(iChannel).m_strctContrastTransform.m_fLeftY= 0;
    
    strctWideField.m_astrctHighMag(iSelectedHighMag).m_astrctChannels(iChannel).m_strctContrastTransform.m_fRightX= ...
        strctWideField.m_astrctHighMag(iSelectedHighMag).m_astrctChannels(iChannel).m_strctContrastTransform.m_fMax;

    strctWideField.m_astrctHighMag(iSelectedHighMag).m_astrctChannels(iChannel).m_strctContrastTransform.m_fRightY = 1;
    
    
end
fnUpdateWideField(handles,strctWideField);
return

function fnResetWideFieldContrast(handles)
strctWideField = fnGetActiveWideField(handles);
aiSelectedChannels = get(handles.hWideFieldChannels,'value');
for k=1:length(aiSelectedChannels)
    iChannel = aiSelectedChannels(k);
    if (iChannel > length(strctWideField.m_astrctChannels))
        continue;
    end;

    strctWideField.m_astrctChannels(iChannel).m_strctContrastTransform.m_LeftX = ...
        strctWideField.m_astrctChannels(iChannel).m_strctContrastTransform.m_fMin;

    strctWideField.m_astrctChannels(iChannel).m_strctContrastTransform.m_LeftY = 0;

    strctWideField.m_astrctChannels(iChannel).m_strctContrastTransform.m_RightX = ...
        strctWideField.m_astrctChannels(iChannel).m_strctContrastTransform.m_fMax;

    strctWideField.m_astrctChannels(iChannel).m_strctContrastTransform.m_RightY = 0;
    
end
fnUpdateWideField(handles,strctWideField);

return



function fnContrast(handles,bRight)
strctPrevMouseOp = getappdata(handles.figure1,'strctPrevMouseOp');
strctMouseOp = getappdata(handles.figure1,'strctMouseOp');
afDelta = strctPrevMouseOp.m_pt2fPos-strctMouseOp.m_pt2fPos;

if get(handles.hWideFieldOnly,'value')
    fnContrastWideField(handles, afDelta,bRight);
elseif  get(handles.hHighMagOnly,'value')
    fnContrastHighMag(handles, afDelta,bRight);
else
    fnContrastWideField(handles, afDelta,bRight);
    fnContrastHighMag(handles, afDelta,bRight);
end
fnInvalidate(handles);

return



function fnContrastHighMag(handles, afDelta,bRight)
strctWideField = fnGetActiveWideField(handles);
if isempty(strctWideField) || isempty(strctWideField.m_astrctHighMag)
    return;
end;

iSelectedHighMag = get(handles.hHighMagList,'value');
aiSelectedChannels = get(handles.hHighMagChannels,'value');

for k=1:length(aiSelectedChannels)
    iChannel = aiSelectedChannels(k);
    
    if (iChannel > length(strctWideField.m_astrctHighMag(iSelectedHighMag).m_astrctChannels))
        continue;
    end;
    
   strctLinearHistogramStretch= strctWideField.m_astrctHighMag(iSelectedHighMag).m_astrctChannels(iChannel).m_strctContrastTransform;
   
   fRange = (strctLinearHistogramStretch.m_fMax-strctLinearHistogramStretch.m_fMin);
   
   if bRight
       strctLinearHistogramStretch.m_fRightX = min(2*strctLinearHistogramStretch.m_fMax, max(strctLinearHistogramStretch.m_fLeftX, strctLinearHistogramStretch.m_fRightX - afDelta(1)*fRange/200));
       strctLinearHistogramStretch.m_fRightY = max(0,min(1,strctLinearHistogramStretch.m_fRightY + afDelta(2)*0.01));
   else
       strctLinearHistogramStretch.m_fLeftX = max(strctLinearHistogramStretch.m_fMin, min(strctLinearHistogramStretch.m_fRightX, strctLinearHistogramStretch.m_fLeftX - afDelta(1)*fRange/200));
       strctLinearHistogramStretch.m_fLeftY = max(0,min(1,strctLinearHistogramStretch.m_fLeftY + afDelta(2)*0.01));
       
   end
   
   strctWideField.m_astrctHighMag(iSelectedHighMag).m_astrctChannels(iChannel).m_strctContrastTransform=strctLinearHistogramStretch;
   
end
fnUpdateWideField(handles,strctWideField);
return

function fnContrastWideField(handles, afDelta,bRight)
astrctWideField = fnGetActiveWideField(handles);
if isempty(astrctWideField)
    return;
end;

aiSelectedChannels = get(handles.hWideFieldChannels,'value');
for k=1:length(aiSelectedChannels)
    iChannel = aiSelectedChannels(k);
    if (iChannel > length(astrctWideField.m_astrctChannels))
        continue;
    end;
    
   strctLinearHistogramStretch= astrctWideField.m_astrctChannels(iChannel).m_strctContrastTransform;
   
   fRange = (strctLinearHistogramStretch.m_fMax-strctLinearHistogramStretch.m_fMin);
   
   if bRight
       strctLinearHistogramStretch.m_fRightX = min(strctLinearHistogramStretch.m_fMax, max(strctLinearHistogramStretch.m_fLeftX, strctLinearHistogramStretch.m_fRightX - afDelta(1)*fRange/200));
       strctLinearHistogramStretch.m_fRightY = max(0,min(1,strctLinearHistogramStretch.m_fRightY + afDelta(2)*0.01));
   else
       strctLinearHistogramStretch.m_fLeftX = max(strctLinearHistogramStretch.m_fMin, min(strctLinearHistogramStretch.m_fRightX, strctLinearHistogramStretch.m_fLeftX - afDelta(1)*fRange/200));
       strctLinearHistogramStretch.m_fLeftY = max(0,min(1,strctLinearHistogramStretch.m_fLeftY + afDelta(2)*0.01));
       
   end
   
   
   astrctWideField.m_astrctChannels(iChannel).m_strctContrastTransform=strctLinearHistogramStretch;

end

fnUpdateWideField(handles,astrctWideField);
return



function fnRotateHighMag(handles)
if ~(get(handles.hHighMagOnly,'value') >0 || get(handles.hCombinedView,'value') >0)
    return;
end
strctPrevMouseOp = getappdata(handles.figure1,'strctPrevMouseOp');
strctMouseOp = getappdata(handles.figure1,'strctMouseOp');
afDelta = strctPrevMouseOp.m_pt2fPos-strctMouseOp.m_pt2fPos;
a2fViewTrans = getappdata(handles.figure1,'a2fViewTrans');

strctWideField = fnGetActiveWideField(handles);
iSelectedHighMag = get(handles.hHighMagList,'value');
HighMagData = getappdata(handles.figure1,'HighMagData');

a2fReg = strctWideField.m_astrctHighMag(iSelectedHighMag).m_a2fRegToWideField;
% Find the center of rotation in screen coordinates
pt2fCenter = inv(a2fReg) * inv(a2fViewTrans) * [size(HighMagData,2)/2;size(HighMagData,1)/2;1];


dx = afDelta(1);
dy = afDelta(2);

fAlpha = -dx / 1000 * pi;
a2fRot = [cos(fAlpha) sin(fAlpha) 0;
          -sin(fAlpha) cos(fAlpha) 0;
          0           0           1];

a2fCenter =[1,0,-pt2fCenter(1);
             0,1,-pt2fCenter(2);
             0,0,1];
    
         
 strctWideField.m_astrctHighMag(iSelectedHighMag).m_a2fRegToWideField  = ...
     strctWideField.m_astrctHighMag(iSelectedHighMag).m_a2fRegToWideField * inv(a2fCenter) * a2fRot * a2fCenter ;

 fnUpdateWideField(handles,strctWideField);
fnInvalidate(handles);
return




function fnRotateWideField(handles)
strctPrevMouseOp = getappdata(handles.figure1,'strctPrevMouseOp');
strctMouseOp = getappdata(handles.figure1,'strctMouseOp');
afDelta = strctPrevMouseOp.m_pt2fPos-strctMouseOp.m_pt2fPos;
a2fViewTrans = getappdata(handles.figure1,'a2fViewTrans');
WideFieldData = getappdata(handles.figure1,'WideFieldData');
strctWideField = fnGetActiveWideField(handles);

a2fReg = strctWideField.m_a2fRegToTissueBlock;
% Find the center of rotation in screen coordinates
pt2fCenter = inv(a2fReg) * inv(a2fViewTrans) * [size(WideFieldData,2)/2;size(WideFieldData,1)/2;1];


dx = afDelta(1);
dy = afDelta(2);

fAlpha = -dx / 500 * pi;
a2fRot = [cos(fAlpha) sin(fAlpha) 0;
          -sin(fAlpha) cos(fAlpha) 0;
          0           0           1];

a2fCenter =[1,0,-pt2fCenter(1);
             0,1,-pt2fCenter(2);
             0,0,1];
    
         
 strctWideField.m_a2fRegToTissueBlock  = ...
     strctWideField.m_a2fRegToTissueBlock * inv(a2fCenter) * a2fRot * a2fCenter ;

 fnUpdateWideField(handles,strctWideField);
fnInvalidate(handles);
return




function fnMoveHighMag(handles)
if ~(get(handles.hHighMagOnly,'value') >0 || get(handles.hCombinedView,'value') >0)
    return;
end
strctMouseOp = getappdata(handles.figure1,'strctMouseOp');
strctPrevMouseOp = getappdata(handles.figure1,'strctPrevMouseOp');
afDelta = strctPrevMouseOp.m_pt2fPos-strctMouseOp.m_pt2fPos;

strctWideField = fnGetActiveWideField(handles);
iSelectedHighMag = get(handles.hHighMagList,'value');
fScale = 10;
dx = afDelta(1)*fScale;
dy = afDelta(2)*fScale;
                           
strctWideField.m_astrctHighMag(iSelectedHighMag).m_a2fRegToWideField = ...
    strctWideField.m_astrctHighMag(iSelectedHighMag).m_a2fRegToWideField * ...
        [1,0,dx;
         0,1,dy;
         0,0,1];


fnUpdateWideField(handles,strctWideField);
fnInvalidate(handles);
return



function fnMoveWideField(handles)
strctPrevMouseOp = getappdata(handles.figure1,'strctPrevMouseOp');
strctMouseOp = getappdata(handles.figure1,'strctMouseOp');
afDelta = strctPrevMouseOp.m_pt2fPos-strctMouseOp.m_pt2fPos;

strctWideField = fnGetActiveWideField(handles);
WideFieldData = getappdata(handles.figure1,'WideFieldData');

if isstruct(WideFieldData)
    dx = afDelta(1)*15;
dy = -afDelta(2)*15;

else
    
dx = afDelta(1)/5;
dy = afDelta(2)/5;
end                       
strctWideField.m_a2fRegToTissueBlock = ...
    strctWideField.m_a2fRegToTissueBlock * ...
        [1,0,dx;
         0,1,dy;
         0,0,1];

fnUpdateWideField(handles,strctWideField);
fnInvalidate(handles);
return


function fnRotateView(handles)
strctPrevMouseOp = getappdata(handles.figure1,'strctPrevMouseOp');
strctMouseOp = getappdata(handles.figure1,'strctMouseOp');
afDelta = strctPrevMouseOp.m_pt2fPos-strctMouseOp.m_pt2fPos;
a2fViewTrans = getappdata(handles.figure1,'a2fViewTrans');



pt2fCenter = [0,0];%a2fViewTrans(:,3);

dx = afDelta(1);


fAlpha = -dx / 1000 * pi;
a2fRot = [cos(fAlpha) sin(fAlpha) 0;
          -sin(fAlpha) cos(fAlpha) 0;
          0           0           1];

a2fCenter =[1,0,-pt2fCenter(1);
             0,1,-pt2fCenter(2);
             0,0,1];
    
         
 a2fViewTrans = a2fViewTrans *inv(a2fCenter) * a2fRot * a2fCenter ;

 setappdata(handles.figure1,'a2fViewTrans',a2fViewTrans);
fnInvalidate(handles);
return

function fnPan(handles)
strctPrevMouseOp = getappdata(handles.figure1,'strctPrevMouseOp');
strctMouseOp = getappdata(handles.figure1,'strctMouseOp');
afDelta = strctPrevMouseOp.m_pt2fPos-strctMouseOp.m_pt2fPos;
a2fViewTrans = getappdata(handles.figure1,'a2fViewTrans');
dx = afDelta(1);
dy = afDelta(2);
a2fViewTrans = a2fViewTrans * [1,0,dx;
                               0,1,dy;
                               0,0,1];
setappdata(handles.figure1,'a2fViewTrans',a2fViewTrans);
fnInvalidate(handles);
return


function fnHandleMouseWhileMoving(handles)
strMouseMode=getappdata(handles.figure1,'strMouseMode');
switch lower(strMouseMode)
    case 'zoom'
        fnZoom(handles);
    case 'pan'
        fnPan(handles);
    case 'rotateview'
        fnRotateView(handles);
    case 'contrastleft'
        fnContrast(handles,0);
    case 'contrastright'
        fnContrast(handles,1);
        
    case 'scalehighmagkeepaspect'
        fnScaleHighMag(handles,1);
    case 'scalehighmagdontkeepaspect'
        fnScaleHighMag(handles,0);
    case 'rotatehighmag'
        fnRotateHighMag(handles);
    case 'movehighmag'
        fnMoveHighMag(handles);

    case 'scalewidefieldkeepaspect'
        fnScaleWideField(handles,'both');
    case 'scalewidefieldx'
        fnScaleWideField(handles,'x');
    case 'scalewidefieldy'
        fnScaleWideField(handles,'y');
    case 'rotatewidefield'
        fnRotateWideField(handles);
    case 'movewidefield'
        fnMoveWideField(handles);
        
end
return



function fnMouseDown(obj,eventdata,handles)
hFig=getappdata(handles.figure1,'hFig');
hAxes=getappdata(handles.figure1,'hAxes');
strctMouseOp.m_strButton = fnGetClickType(hFig);
strctMouseOp.m_strAction = 'Down';
strctMouseOp.m_pt2fPos = fnGetMouseCoordinate(hAxes);
setappdata(handles.figure1,'strctMouseDownOp',strctMouseOp);
setappdata(handles.figure1,'bMouseDown',true);
setappdata(handles.figure1,'strctPrevMouseOp',strctMouseOp);
strMouseMode = getappdata(handles.figure1,'strMouseMode');
if strcmpi(strMouseMode,'Focus')
    fnFocus(handles);
    setappdata(handles.figure1,'strMouseMode','Zoom');
elseif strcmpi(strMouseMode,'Annotate')
    fnAddAnnotation(handles);
end

return;

function fnAddAnnotation(handles)
strctMouseOp=getappdata(handles.figure1,'strctMouseDownOp');
a2fViewTrans = getappdata(handles.figure1,'a2fViewTrans');

strctWideField = fnGetActiveWideField(handles);
iSelectedHighMag = get(handles.hHighMagList,'value');
iSelectedZ = getappdata(handles.figure1,'iSelectedZ');
bAdd = strcmpi(strctMouseOp.m_strButton,'Left');
if ~bAdd
    return
end

if get(handles.hNeuN,'value')
    strDescription = 'NeuN';
elseif get(handles.hYFP,'value')
    strDescription = 'EYFP';
elseif get(handles.hYFP_CamKII,'value')
    strDescription = 'YFP+CamKII';
elseif get(handles.hYFP_PV,'value')
    strDescription = 'YFP+PV';
end

if get(handles.hWideFieldOnly,'value')
         if isempty(iSelectedZ)
            iSelectedZ = 1;
        end
        pt2fCoordinates = a2fViewTrans * [strctMouseOp.m_pt2fPos(:);1];
        strctAnnotation.m_pt3fPosition = [pt2fCoordinates(1),pt2fCoordinates(2),iSelectedZ]; % Assume single plane for wide field?
        strctAnnotation.m_strDescription = strDescription;
        iNumAnnontations = length(strctWideField.m_astrctAnnoation);
        if (iNumAnnontations == 0)
            strctWideField.m_astrctAnnoation = strctAnnotation;
        else
            strctWideField.m_astrctAnnoation(iNumAnnontations+1) = strctAnnotation;
        end
        fnUpdateWideField(handles,strctWideField);
        fnInvalidateAnnotationList(handles);
        fnInvalidate(handles);
elseif  get(handles.hHighMagOnly,'value')
        %a2fReg = strctWideField.m_astrctHighMag(iSelectedHighMag).m_a2fRegToWideField;
        pt2fCoordinatesHighMag = a2fViewTrans * [strctMouseOp.m_pt2fPos(:);1];
        strctAnnotation.m_pt3fPosition = [pt2fCoordinatesHighMag(1),pt2fCoordinatesHighMag(2),iSelectedZ];
        strctAnnotation.m_strDescription = strDescription;
        iNumAnnontations = length(strctWideField.m_astrctHighMag(iSelectedHighMag).m_astrctAnnoation);
        if (iNumAnnontations == 0)
            strctWideField.m_astrctHighMag(iSelectedHighMag).m_astrctAnnoation = strctAnnotation;
        else
            strctWideField.m_astrctHighMag(iSelectedHighMag).m_astrctAnnoation(iNumAnnontations+1) = strctAnnotation;
        end
        fnUpdateWideField(handles,strctWideField);
        fnInvalidateAnnotationList(handles);
        fnInvalidate(handles);
end
return


function fnInvalidateAnnotationList(handles,iNewSel)
if ~exist('iNewSel','var')
    iNewSel = [];
end
strctWideField = fnGetActiveWideField(handles);
iSelectedHighMag = get(handles.hHighMagList,'value');

if get(handles.hWideFieldOnly,'value')
    iNumEntries = length(strctWideField.m_astrctAnnoation);
    acName = cell(1,iNumEntries);
    for k=1:iNumEntries
        ptPos = strctWideField.m_astrctAnnoation(k).m_pt3fPosition;
       acName{k} = sprintf('%d [%d %d %s]',k,round(ptPos(1)),round(ptPos(2)),strctWideField.m_astrctAnnoation(k).m_strDescription);
    end
    set(handles.hAnnotationList,'string', acName,'value',iNumEntries,'min',1,'max',iNumEntries);
elseif  get(handles.hHighMagOnly,'value')
    if isempty(strctWideField.m_astrctHighMag)
        set(handles.hAnnotationList,'string', '','value',0);
    else
    iNumEntries = length(strctWideField.m_astrctHighMag(iSelectedHighMag).m_astrctAnnoation);
    acName = cell(1,iNumEntries);
    for k=1:iNumEntries
        ptPos = strctWideField.m_astrctHighMag(iSelectedHighMag).m_astrctAnnoation(k).m_pt3fPosition;
       acName{k} = sprintf('%d [%d %d %s]',k,round(ptPos(1)),round(ptPos(2)),strctWideField.m_astrctHighMag(iSelectedHighMag).m_astrctAnnoation(k).m_strDescription);
    end
    set(handles.hAnnotationList,'string', acName,'value',iNumEntries,'min',1,'max',iNumEntries);
    if ~isempty(iNewSel)
        set(handles.hAnnotationList,'value',iNewSel);
    end
    end
else
    
end


return


function fnMouseUp(obj,eventdata,handles)
hFig=getappdata(handles.figure1,'hFig');
hAxes=getappdata(handles.figure1,'hAxes');
strctMouseOp.m_strButton = fnGetClickType(hFig);
strctMouseOp.m_strAction = 'Up';
strctMouseOp.m_pt2fPos = fnGetMouseCoordinate(hAxes);
setappdata(handles.figure1,'strctMouseUpOp',strctMouseOp);
setappdata(handles.figure1,'bMouseDown',false);
return;


function fnMouseWheel(obj,eventdata,handles)
% hFig=getappdata(handles.figure1,'hFig');
% hAxes=getappdata(handles.figure1,'hAxes');
% strctMouseOp.m_strButton = fnGetClickType(hFig);
strctMouseOp.m_strAction = 'Wheel';
strctMouseOp.m_iScroll = eventdata.VerticalScrollCount;
iSelectedZ = getappdata(handles.figure1,'iSelectedZ');
iSelectedZ = iSelectedZ + strctMouseOp.m_iScroll;
HighMagData = getappdata(handles.figure1,'HighMagData');
if iSelectedZ < 1
    iSelectedZ = size(HighMagData,4);
end

if iSelectedZ > size(HighMagData,4)
    iSelectedZ = 1;
end
setappdata(handles.figure1,'iSelectedZ',iSelectedZ);
fnInvalidate(handles);
return;


function fnResizeFig(hFig,b)
handles=getappdata(hFig,'handles');
fnFirstInvalidate(handles)
return


function fnSaveDatabase(handles)
% for k=1:length(astrctTissueBlock)
%     if ~isempty(astrctTissueBlock(k).m_astrctWideField)
%         if ~isempty(astrctTissueBlock(k).m_astrctWideField(1).m_astrctHighMag)
%             for j=1:length(astrctTissueBlock(k).m_astrctWideField(1).m_astrctHighMag(1).m_astrctAnnoation)
%             astrctTissueBlock(k).m_astrctWideField(1).m_astrctHighMag(1).m_astrctAnnoation(j).m_strDescription = 'YFP';
%             end
%         end
%     end
% end
%     

fprintf('Saving data base to cache...');
astrctTissueBlock = getappdata(handles.figure1,'astrctTissueBlock');
save('ImageRegisCache.mat','astrctTissueBlock');
fprintf('Done!\n');
%setappdata(handles.figure1,'astrctTissueBlock',astrctTissueBlock);
return

function fnLoadDatabase(handles)
if exist('ImageRegisCache.mat','file')
    strctTmp = load('ImageRegisCache.mat');
    astrctTissueBlock =strctTmp.astrctTissueBlock;
else
    astrctTissueBlock = [];
end

setappdata(handles.figure1,'astrctTissueBlock',astrctTissueBlock);
fnInvalidateTissueBlockList(handles, length(astrctTissueBlock));
fnSetActiveTissueBlock(handles, length(astrctTissueBlock));

 
function fnFirstInvalidate(handles)
WideFieldData = getappdata(handles.figure1,'WideFieldData');
if isempty(WideFieldData)
    return;
end;
hFig = getappdata(handles.figure1,'hFig');
try
    get(hFig,'Position');
    hFig = getappdata(handles.figure1,'hFig');
    aiFigurePosition = get(hFig,'position');
    hAxes = getappdata(handles.figure1,'hAxes');
    set(hAxes,'position',[0 0 aiFigurePosition(3) aiFigurePosition(4)]);
    set(hAxes,'xlim',[0 aiFigurePosition(3)],'ylim',[0 aiFigurePosition(4)]);
    
    hImage = getappdata(handles.figure1,'hImage');
     set(hImage,'XData',[1:aiFigurePosition(3)],'YData',1:aiFigurePosition(4));
catch
    [hFig, hAxes,hImage,aiFigurePosition ] = fnOpenFigure(handles);
end

% Viewing transformation....
% Apply a transformation and then sample coordinates.
% Default view transformation will fit the entire image to the screen.
if isstruct(WideFieldData)
    apt2fPoints = cat(1,WideFieldData.m_apt2fPoints);
    fImageWidth = max(apt2fPoints(:,2))-min(apt2fPoints(:,2));
    fImageHeight = max(apt2fPoints(:,1))-min(apt2fPoints(:,1));
    
    fScreenWidth = aiFigurePosition(3);
    fScreenHeight = aiFigurePosition(4);
    a2fViewTrans = getappdata(handles.figure1,'a2fViewTrans');
    if isempty(a2fViewTrans)
        a2fViewTrans=fnResizeKeepAspect(fImageWidth,fImageHeight, fScreenWidth, fScreenHeight);
        setappdata(handles.figure1,'a2fViewTrans',a2fViewTrans);
    end
    
else
    fImageWidth = size(WideFieldData,2);
    fImageHeight = size(WideFieldData,1);
    fScreenWidth = aiFigurePosition(3);
    fScreenHeight = aiFigurePosition(4);
    a2fViewTrans = getappdata(handles.figure1,'a2fViewTrans');
    if isempty(a2fViewTrans)
        a2fViewTrans=fnResizeKeepAspect(fImageWidth,fImageHeight, fScreenWidth, fScreenHeight);
        setappdata(handles.figure1,'a2fViewTrans',a2fViewTrans);
    end
end

fnInvalidate(handles);


function a2fTranI = fnApplyContrast(a2fI, strctTransform)
a2fTranI= (a2fI-strctTransform.m_fLeftX)/(strctTransform.m_fRightX-strctTransform.m_fLeftX) * (strctTransform.m_fRightY-strctTransform.m_fLeftY)+strctTransform.m_fLeftY;
a2fTranI(a2fI < strctTransform.m_fLeftX) = strctTransform.m_fLeftY;
a2fTranI(a2fI > strctTransform.m_fRightX) = strctTransform.m_fRightY;
return;

function fnResetReg(handles)
strctWideField = fnGetActiveWideField(handles);
if get(handles.hTissueBlockVis,'value')
    strctWideField.m_a2fRegToTissueBlock = eye(3);
elseif get(handles.hWideFieldOnly,'value')
    iSelectedHighMag = get(handles.hHighMagList,'value');
    if isfield(strctWideField,'m_astrctHighMag')
        strctWideField.m_astrctHighMag(iSelectedHighMag).m_a2fRegToWideField = eye(3);
    end
elseif  get(handles.hHighMagOnly,'value')
    
else
    
end
fnUpdateWideField(handles,strctWideField);
fnInvalidate(handles);
return;    


function a3fRGB=fnGenerateHighResImage(handles,P,aiImageSize, bRegToWideField)
a2fViewTrans = getappdata(handles.figure1,'a2fViewTrans');
  
    strctWideField = fnGetActiveWideField(handles);
   a3fRGB = zeros([aiImageSize 3]);
    
    iSelectedHighMag = get(handles.hHighMagList,'value');
    HighMagData = getappdata(handles.figure1,'HighMagData');
    if isempty(HighMagData) || ~isfield(strctWideField,'m_astrctHighMag') || iSelectedHighMag == 0 || isempty(strctWideField.m_astrctHighMag)
        return;
    end;

     
    
    
    if bRegToWideField
    a2fReg = strctWideField.m_astrctHighMag(iSelectedHighMag).m_a2fRegToWideField;
    apt2fSamplingCoords = a2fReg*a2fViewTrans*P;
    else
    a2fReg = eye(3);
    apt2fSamplingCoords = a2fReg*a2fViewTrans*P;
    end
    
       % Generate Scale bar
    if mod(size(HighMagData,1),800) == 0
        fPixelToUm = 1272/800;
    else
        fPixelToUm = 1272/1024;
    end
    afDiffUm = (max(apt2fSamplingCoords,[],2)-min(apt2fSamplingCoords,[],2)) *  fPixelToUm;
    afScreenSize = max(P,[],2);
    
    
    % Let's have a 10 um scale bar
    fScaleBarUm = 1000;
    fScaleBarSizeOnScreenWidth = round(fScaleBarUm/afDiffUm(1) * afScreenSize(1));

    
iSelectedZ = getappdata(handles.figure1,'iSelectedZ');

    
   aiSelectedChannels = get(handles.hHighMagChannels,'value');
    for k=1:length(aiSelectedChannels)
        iChannel = aiSelectedChannels(k);
        if (iChannel > size(HighMagData,3))
            continue;
        end;
    	a2fDataSampled= reshape(fndllFastInterp2(HighMagData(:,:,iChannel,iSelectedZ),...
                           1+apt2fSamplingCoords(1,:),1+apt2fSamplingCoords(2,:),NaN), aiImageSize);
                       
        % Apply contrast transform.
        a2fContrastTrans = fnApplyContrast(a2fDataSampled, strctWideField.m_astrctHighMag(iSelectedHighMag).m_astrctChannels(iChannel).m_strctContrastTransform);
        a3fRGB(:,:,1) = a3fRGB(:,:,1)+a2fContrastTrans * strctWideField.m_astrctHighMag(iSelectedHighMag).m_astrctChannels(iChannel).m_afColorMap(1);
        a3fRGB(:,:,2) = a3fRGB(:,:,2)+a2fContrastTrans * strctWideField.m_astrctHighMag(iSelectedHighMag).m_astrctChannels(iChannel).m_afColorMap(2);
        a3fRGB(:,:,3) = a3fRGB(:,:,3)+a2fContrastTrans * strctWideField.m_astrctHighMag(iSelectedHighMag).m_astrctChannels(iChannel).m_afColorMap(3);
        
   plot(handles.axes2, [strctWideField.m_astrctHighMag(iSelectedHighMag).m_astrctChannels(iChannel).m_strctContrastTransform.m_fLeftX strctWideField.m_astrctHighMag(iSelectedHighMag).m_astrctChannels(iChannel).m_strctContrastTransform.m_fRightX],...
                       [strctWideField.m_astrctHighMag(iSelectedHighMag).m_astrctChannels(iChannel).m_strctContrastTransform.m_fLeftY strctWideField.m_astrctHighMag(iSelectedHighMag).m_astrctChannels(iChannel).m_strctContrastTransform.m_fRightY],'color',strctWideField.m_astrctHighMag(iSelectedHighMag).m_astrctChannels(iChannel).m_afColorMap,'LineWidth',2,'LineStyle','--');
   
         
    end
    a3fRGB(a3fRGB>1)=1;
    a3fRGB(20:30,50 : 50+fScaleBarSizeOnScreenWidth,:) = 1;
%    save('CamKII4','a3fRGB');
%save('YFP4_PV_CamKII','a3fRGB');
return

function a3fRGB=fnGenerateTissueBlockImage(handles,P,aiImageSize)
TissueBlockData= getappdata(handles.figure1,'TissueBlockData');
a2fViewTrans = getappdata(handles.figure1,'a2fViewTrans');
a3fRGB = zeros([aiImageSize 3]);
% For each channel, apply the contrast transform and then map to
% colors.
apt2fSamplingCoords = a2fViewTrans*P; % Screen to image
for k=1:3
    a3fRGB(:,:,k) =  reshape(fndllFastInterp2(TissueBlockData(:,:,k),...
        1+apt2fSamplingCoords(1,:),1+apt2fSamplingCoords(2,:),NaN), aiImageSize);
end

return;

function a3fRGB=fnGenerateWideFieldImage(handles,P,aiImageSize, bRegisterToWideField)
strctWideField = fnGetActiveWideField(handles);
if isempty(strctWideField)
    a3fRGB = ones([aiImageSize,3])*NaN;
    return;
end
WideFieldData = getappdata(handles.figure1,'WideFieldData');
a2fViewTrans = getappdata(handles.figure1,'a2fViewTrans');
 if bRegisterToWideField
    apt2fSamplingCoords = strctWideField.m_a2fRegToTissueBlock*a2fViewTrans*P;
 else
     apt2fSamplingCoords = a2fViewTrans*P;
 end
 
 
 
 
    
    fPixelToUm = 1272/1024;
    afDiffUm = (max(apt2fSamplingCoords,[],2)-min(apt2fSamplingCoords,[],2)) *  fPixelToUm;
    afScreenSize = max(P,[],2);
    
    
    % Let's have a 10 um scale bar
    fScaleBarUm = 500;
    fScaleBarSizeOnScreenHeight = round(fScaleBarUm/afDiffUm(2) * afScreenSize(2));


 
 
 
a3fRGB = zeros([aiImageSize 3]);
% For each channel, apply the contrast transform and then map to
% colors.
iSelectedZ=1;
aiSelectedChannels = get(handles.hWideFieldChannels,'value');
for k=1:length(aiSelectedChannels)
    iChannel = aiSelectedChannels(k);
    if (iChannel > size(WideFieldData,3))
        continue;
    end;
    a2fDataSampled= reshape(fndllFastInterp2(WideFieldData(:,:,iChannel,iSelectedZ),...
        1+apt2fSamplingCoords(1,:),1+apt2fSamplingCoords(2,:),NaN), aiImageSize);
    
    % Apply contrast transform.
    a2fContrastTrans = fnApplyContrast(a2fDataSampled, strctWideField.m_astrctChannels(iChannel).m_strctContrastTransform);
    a3fRGB(:,:,1) = a3fRGB(:,:,1)+a2fContrastTrans * strctWideField.m_astrctChannels(iChannel).m_afColorMap(1);
    a3fRGB(:,:,2) = a3fRGB(:,:,2)+a2fContrastTrans * strctWideField.m_astrctChannels(iChannel).m_afColorMap(2);
    a3fRGB(:,:,3) = a3fRGB(:,:,3)+a2fContrastTrans * strctWideField.m_astrctChannels(iChannel).m_afColorMap(3);
    
    plot(handles.axes2, [strctWideField.m_astrctChannels(iChannel).m_strctContrastTransform.m_fLeftX strctWideField.m_astrctChannels(iChannel).m_strctContrastTransform.m_fRightX],...
        [strctWideField.m_astrctChannels(iChannel).m_strctContrastTransform.m_fLeftY strctWideField.m_astrctChannels(iChannel).m_strctContrastTransform.m_fRightY],'color',strctWideField.m_astrctChannels(iChannel).m_afColorMap,'LineWidth',2);
    
end
a3fRGB(a3fRGB>1)=1;
   a3fRGB(50 : fScaleBarSizeOnScreenHeight,20:30,:) = 1;
%
% save('Layers2_YFP&DAPI','a3fRGB');
% fprintf('Saved\n');
return

function ahAnnotations = fnDrawWideFieldAnnotations(handles,bApplyRegToTissueBlock)
hFig = getappdata(handles.figure1,'hFig');
aiFigurePosition = get(hFig,'position');
fScreenWidth = aiFigurePosition(3);
fScreenHeight = aiFigurePosition(4);
bShowAnnotations = getappdata(handles.figure1,'bShowAnnotations');

[strctWideField,a2fLinesTissueBlockPix] = fnGetActiveWideField(handles);
if ~isempty(strctWideField) 
    
    hAxes = getappdata(handles.figure1,'hAxes');
    a2fViewTrans = getappdata(handles.figure1,'a2fViewTrans');
    if ~isempty(strctWideField.m_astrctAnnoation)
    apt3fAnnotations = cat(1,strctWideField.m_astrctAnnoation.m_pt3fPosition)';
    apt3fAnnotations(3,:) = 1;
    % Convert back to screen coordinates.
    if bApplyRegToTissueBlock
        apt2fScreenCoords = inv(a2fViewTrans)* inv(strctWideField.m_a2fRegToTissueBlock) * apt3fAnnotations;
    else
        apt2fScreenCoords = inv(a2fViewTrans)* apt3fAnnotations;
    end
    abInside = apt2fScreenCoords(1,:) >= 0 & apt2fScreenCoords(1,:) <= fScreenWidth & ...
               apt2fScreenCoords(2,:) >= 0 & apt2fScreenCoords(2,:) <= fScreenHeight;
    ahAnnotations = plot(hAxes,apt2fScreenCoords(1,abInside),apt2fScreenCoords(2,abInside),'w*');
    else
        ahAnnotations = [];
    end
    
    
    iNumLines = size(a2fLinesTissueBlockPix,1);
    
    if iNumLines > 0 && bShowAnnotations
     if bApplyRegToTissueBlock
        
        a2fLinesP1 = inv(a2fViewTrans)*[a2fLinesTissueBlockPix(:,1:2)'; ones(1,iNumLines)];
        a2fLinesP2 = inv(a2fViewTrans)*[a2fLinesTissueBlockPix(:,3:4)'; ones(1,iNumLines)];
     else
         % Wide field view...
        a2fLinesP1 = inv(a2fViewTrans)*strctWideField.m_a2fRegToTissueBlock*[a2fLinesTissueBlockPix(:,1:2)'; ones(1,iNumLines)];
        a2fLinesP2 = inv(a2fViewTrans)*strctWideField.m_a2fRegToTissueBlock*[a2fLinesTissueBlockPix(:,3:4)'; ones(1,iNumLines)];
         
     end
    
        a2fLinesScreenCoords =  [a2fLinesP1(1,:)',a2fLinesP1(2,:)',a2fLinesP2(1,:)',a2fLinesP2(2,:)'];
        
        ahLines = fnPlotLinesAsSinglePatch(hAxes, a2fLinesScreenCoords, a2fLinesTissueBlockPix(:,5:7)); %#ok
        ahAnnotations = [ahAnnotations,ahLines];
    end
else
    ahAnnotations =[];
end
return



function ahAnnotations = fnDrawHighMagAnnotations(handles,bApplyRegToWideField)
[strctWideField,a2fLinesTissueBlockPix] = fnGetActiveWideField(handles);

iActiveHighMag = get(handles.hHighMagList,'value');
hFig = getappdata(handles.figure1,'hFig');
aiFigurePosition = get(hFig,'position');
fScreenWidth = aiFigurePosition(3);
fScreenHeight = aiFigurePosition(4);

   bShowAnnotations = getappdata(handles.figure1,'bShowAnnotations');
    if isempty(bShowAnnotations)
        bShowAnnotations= true;
    end;

    
if get(handles.hNeuN,'value')
    strDescription = 'NeuN';
elseif get(handles.hYFP,'value')
    strDescription = 'EYFP';
elseif get(handles.hYFP_CamKII,'value')
    strDescription = 'YFP+CamKII';
elseif get(handles.hYFP_PV,'value')
    strDescription = 'YFP+PV';
end
    
    
if ~isempty(strctWideField) && ~isempty(strctWideField.m_astrctHighMag) 
    hAxes = getappdata(handles.figure1,'hAxes');
    a2fViewTrans = getappdata(handles.figure1,'a2fViewTrans');
    
    if ~isempty(strctWideField.m_astrctHighMag(iActiveHighMag).m_astrctAnnoation) && bShowAnnotations
        
        aiSelectedAnnotation = get(handles.hAnnotationList,'value');

        if aiSelectedAnnotation(1) > 0
        apt3fAnnotations = cat(1,strctWideField.m_astrctHighMag(iActiveHighMag).m_astrctAnnoation.m_pt3fPosition)';
        abRelevantAnnotations = (ismember({strctWideField.m_astrctHighMag(iActiveHighMag).m_astrctAnnoation.m_strDescription},strDescription));
        
        
        apt3fAnnotations(3,:) = 1;
        
        % Convert back to screen coordinates.
        if bApplyRegToWideField
%            apt2fScreenCoords = inv(a2fViewTrans)*inv(strctWideField.m_a2fRegToTissueBlock) *inv(strctWideField.m_astrctHighMag(iActiveHighMag).m_a2fRegToWideField) * apt3fAnnotations;
            apt2fScreenCoords = inv(a2fViewTrans)*inv(strctWideField.m_astrctHighMag(iActiveHighMag).m_a2fRegToWideField) * apt3fAnnotations;
        else
 %           apt2fScreenCoords = inv(a2fViewTrans)*inv(strctWideField.m_astrctHighMag(iActiveHighMag).m_a2fRegToWideField) * apt3fAnnotations;
            apt2fScreenCoords = inv(a2fViewTrans)* apt3fAnnotations;
        end
        abInside = apt2fScreenCoords(1,:) >= 0 & apt2fScreenCoords(1,:) <= fScreenWidth & ...
            apt2fScreenCoords(2,:) >= 0 & apt2fScreenCoords(2,:) <= fScreenHeight;
        ahAnnotations = plot(hAxes,apt2fScreenCoords(1,abInside & abRelevantAnnotations),apt2fScreenCoords(2,abInside & abRelevantAnnotations),'w*');
        
        ahAnnotations = [ahAnnotations,plot(hAxes,apt2fScreenCoords(1,aiSelectedAnnotation ),apt2fScreenCoords(2,aiSelectedAnnotation),'mo','MarkerSize',11)];
        else
            ahAnnotations = [];
        end
    else
        ahAnnotations = [];
    end
    
    
    
    
    
    iNumLines = size(a2fLinesTissueBlockPix,1);
    if iNumLines > 0 && bShowAnnotations
    if bApplyRegToWideField
        
        a2fLinesP1 = inv(a2fViewTrans)*inv(strctWideField.m_astrctHighMag(iActiveHighMag).m_a2fRegToWideField)*[a2fLinesTissueBlockPix(:,1:2)'; ones(1,iNumLines)];
        a2fLinesP2 = inv(a2fViewTrans)*inv(strctWideField.m_astrctHighMag(iActiveHighMag).m_a2fRegToWideField)*[a2fLinesTissueBlockPix(:,3:4)'; ones(1,iNumLines)];
    else
        % Wide field view...
        a2fLinesP1 = inv(a2fViewTrans)*(strctWideField.m_astrctHighMag(iActiveHighMag).m_a2fRegToWideField)*strctWideField.m_a2fRegToTissueBlock*[a2fLinesTissueBlockPix(:,1:2)'; ones(1,iNumLines)];
        a2fLinesP2 = inv(a2fViewTrans)*(strctWideField.m_astrctHighMag(iActiveHighMag).m_a2fRegToWideField)*strctWideField.m_a2fRegToTissueBlock*[a2fLinesTissueBlockPix(:,3:4)'; ones(1,iNumLines)];
        
    end
    
    a2fLinesScreenCoords =  [a2fLinesP1(1,:)',a2fLinesP1(2,:)',a2fLinesP2(1,:)',a2fLinesP2(2,:)'];
    ahLines = fnPlotLinesAsSinglePatch(hAxes, a2fLinesScreenCoords, a2fLinesTissueBlockPix(:,5:7)); %#ok
    ahAnnotations = [ahAnnotations,ahLines];
    end
    
else
    ahAnnotations =[];
end
return

function ahAnnotations = fnDrawWideFieldContour(handles)
WideFieldData = getappdata(handles.figure1,'WideFieldData');
strctWideField = fnGetActiveWideField(handles);
a2fViewTrans = getappdata(handles.figure1,'a2fViewTrans');
hAxes = getappdata(handles.figure1,'hAxes');
iNumconouts = length(WideFieldData);
ahAnnotations = zeros(1,iNumconouts);
for k=1:iNumconouts
    iNumPoints = size(WideFieldData(k).m_apt2fPoints,1);
    P=[WideFieldData(k).m_apt2fPoints'; ones(1,iNumPoints)];
    apt2fScreenCoords = inv(a2fViewTrans)*strctWideField.m_a2fRegToTissueBlock*P;
    ahAnnotations(k) = plot(hAxes,apt2fScreenCoords(1,:),apt2fScreenCoords(2,:),'r');    
end
    
return




function ahAnnotations = fnDrawWideFieldAnnotationsFromNeuroLucida(handles)
hFig = getappdata(handles.figure1,'hFig');
aiFigurePosition = get(hFig,'position');
fScreenWidth = aiFigurePosition(3);
fScreenHeight = aiFigurePosition(4);
bShowAnnotations = getappdata(handles.figure1,'bShowAnnotations');

[strctWideField,a2fLinesTissueBlockPix] = fnGetActiveWideField(handles);
if ~isempty(strctWideField) 
    
    hAxes = getappdata(handles.figure1,'hAxes');
    a2fViewTrans = getappdata(handles.figure1,'a2fViewTrans');
    if ~isempty(strctWideField.m_astrctAnnoation)
    apt3fAnnotations = cat(1,strctWideField.m_astrctAnnoation.m_pt3fPosition)';
    apt3fAnnotations(3,:) = 1;
    % Convert back to screen coordinates.
    apt2fScreenCoords = inv(a2fViewTrans)* strctWideField.m_a2fRegToTissueBlock * apt3fAnnotations;
    abInside = apt2fScreenCoords(1,:) >= 0 & apt2fScreenCoords(1,:) <= fScreenWidth & ...
               apt2fScreenCoords(2,:) >= 0 & apt2fScreenCoords(2,:) <= fScreenHeight;
    ahAnnotations = plot(hAxes,apt2fScreenCoords(1,abInside),apt2fScreenCoords(2,abInside),'g*');
    else
        ahAnnotations = [];
    end
   
else
    ahAnnotations =[];
end
return

function fnInvalidate(handles)
hImage = getappdata(handles.figure1,'hImage');
hFig = getappdata(handles.figure1,'hFig');
aiFigurePosition = get(hFig,'position');
[a2iX, a2iY] = meshgrid(0:aiFigurePosition(3)-1,0:aiFigurePosition(4)-1);
aiImageSize = size(a2iX);
WideFieldData = getappdata(handles.figure1,'WideFieldData');
P=[a2iX(:)';a2iY(:)';ones(size(a2iX(:)'))];

strViewMode = getappdata(handles.figure1,'strViewMode');
cla(handles.axes2);
hold(handles.axes2,'on');
set(handles.axes2,'xlim',[0 4096],'ylim',[0 1]);

ahAnnotations = getappdata(handles.figure1,'ahAnnotations');
delete(ahAnnotations(ishandle(ahAnnotations)));
ahAnnotations = [];

if strcmpi(strViewMode,'TissueBlock')
    a3fRGB1=fnGenerateTissueBlockImage(handles,P,aiImageSize);
    if isstruct(WideFieldData)
        set(hImage,'cdata',a3fRGB1);
        ahAnnotations = [ahAnnotations,fnDrawWideFieldContour(handles)];
        ahAnnotations = [ahAnnotations,fnDrawWideFieldAnnotationsFromNeuroLucida(handles);];
    else
        a3fRGB2=fnGenerateWideFieldImage(handles,P,aiImageSize,true);
        a3fRGB=fnMergeImages(handles,a3fRGB1, a3fRGB2);
        set(hImage,'cdata',a3fRGB);
        ahAnnotations = [ahAnnotations,fnDrawWideFieldAnnotations(handles,true)];
    end
    
elseif strcmpi(strViewMode,'WideField')
  if ~isstruct(WideFieldData)
       
    a3fRGB=fnGenerateWideFieldImage(handles,P,aiImageSize,false);
    set(hImage,'cdata',a3fRGB);
    ahAnnotations = [ahAnnotations,fnDrawWideFieldAnnotations(handles,false)];
  end
elseif strcmpi(strViewMode,'HighMag')
    a3fRGB=fnGenerateHighResImage(handles,P,aiImageSize,false);
    set(hImage,'cdata',a3fRGB);
     ahAnnotations = [ahAnnotations,fnDrawHighMagAnnotations(handles,false)];
     
elseif strcmpi(strViewMode,'Combined')
     if ~isstruct(WideFieldData)
  
    a3fRGB1=fnGenerateHighResImage(handles,P,aiImageSize,true);
    a3fRGB2=fnGenerateWideFieldImage(handles,P,aiImageSize,false);
    
    a3fRGB=fnMergeImages(handles,a3fRGB1, a3fRGB2);
    set(hImage,'cdata',a3fRGB);
    
    ahAnnotations = [ahAnnotations,fnDrawWideFieldAnnotations(handles,false)];
     ahAnnotations = [ahAnnotations,fnDrawHighMagAnnotations(handles,true)];
     end
end
setappdata(handles.figure1,'ahAnnotations',ahAnnotations);
    

return




% --- Outputs from this function are returned to the command line.
function varargout = ImageRegis_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in hWideFieldList.
function hWideFieldList_Callback(hObject, eventdata, handles)
iSelectedWideField = get(handles.hWideFieldList,'value');

SetActiveWideField(handles,iSelectedWideField);



% --- Executes during object creation, after setting all properties.
function hWideFieldList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hWideFieldList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in hHighMagList.
function hHighMagList_Callback(hObject, eventdata, handles)
iHighMag = get(handles.hHighMagList,'value');
fnSetActiveHighMag(handles,iHighMag);


% --- Executes during object creation, after setting all properties.
function hHighMagList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hHighMagList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes during object creation, after setting all properties.
function hAnnotationList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hAnnotationList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function hAddWideField_Callback(hObject, eventdata, handles)
astrctTissueBlock=getappdata(handles.figure1,'astrctTissueBlock');
if isempty(astrctTissueBlock)
    return;
end;

[strFile,strPath]=uigetfile('D:\Photos\Work Related\Bert Confocal\Widefield Series 2 (NeuN, GFAP)\*.tif;*.jpg;*.oib;*.mat;*.xml');
if strFile(1) == 0
    return;
end;
[~,~,strType]=fileparts(strFile);
strctWideField.m_strFullPath = [strPath,strFile];
strctWideField.m_strName = strFile;
strctWideField.m_astrctAnnoation = [];
strctWideField.m_astrctHighMag = [];
if strcmpi(strType,'.xml')
    % Read file and find default transformation....
    fprintf('Reading XML...\n');
  strctXml = xml2struct(strctWideField.m_strFullPath);
    clear astrctContours
    a2fContourPoints = zeros(0,2);
    for k=1:length(strctXml.Children)
       if strcmpi(strctXml.Children(k).Name,'contour')
           % New contour found!
           for j=1:length(strctXml.Children(k).Children)
               if strcmpi(strctXml.Children(k).Children(j).Name,'point')
                   x = str2num(strctXml.Children(k).Children(j).Attributes(2).Value);
                   y = str2num(strctXml.Children(k).Children(j).Attributes(3).Value);
                   a2fContourPoints(end+1,:)=[x,y];
               end
           end
       end
    end    
    X0=min(a2fContourPoints(:,1));
    X1=max(a2fContourPoints(:,1));
    Y0=min(a2fContourPoints(:,2));
    Y1=max(a2fContourPoints(:,2));
    
    fContourWidth = X1-X0;
    fContourHeight = Y1-Y0;
    % Map this to the tissue block image
    TissueBlockData= getappdata(handles.figure1,'TissueBlockData');
    fImageWidth = size(TissueBlockData,2);
    fImageHeight = size(TissueBlockData,1);
    
    a_x = -fImageWidth/fContourWidth; % Mirror X!
    b_x = -X0*a_x +fImageWidth;
     
    a_y = fImageHeight/fContourHeight;
    b_y = -Y0*a_y;
    
    strctWideField.m_a2fRegToTissueBlock = [a_x, 0, b_x;
                                            0    a_y, b_y;
                                            0,0,1];
else
    strctWideField.m_a2fRegToTissueBlock = eye(3);
end
strctWideField.m_astrctChannels = [];

iActiveTissueBlock = get(handles.hTissueBlockList,'value');
astrctTissueBlock = getappdata(handles.figure1,'astrctTissueBlock');

if isempty(astrctTissueBlock(iActiveTissueBlock).m_astrctWideField)
    astrctTissueBlock(iActiveTissueBlock).m_astrctWideField = strctWideField;
else
    astrctTissueBlock(iActiveTissueBlock).m_astrctWideField(end+1) = strctWideField;
end
setappdata(handles.figure1,'astrctTissueBlock',astrctTissueBlock);
% Update lists.
fnInvalidateWideFieldList(handles,length(astrctTissueBlock(iActiveTissueBlock).m_astrctWideField));
SetActiveWideField(handles,length(astrctTissueBlock(iActiveTissueBlock).m_astrctWideField));

function fnInvalidateWideFieldList(handles,iActive)
astrctTissueBlock = getappdata(handles.figure1,'astrctTissueBlock');
iActiveTissueBlock = get(handles.hTissueBlockList,'value');
astrctWideField = astrctTissueBlock(iActiveTissueBlock).m_astrctWideField;
iNumWideField = length(astrctWideField);
acNames = cell(1,iNumWideField);
for k=1:iNumWideField
    acNames{k} = astrctWideField(k).m_strName;
end
if exist('iActive','var')
    set(handles.hWideFieldList,'string',acNames,'value',iActive);
else
    set(handles.hWideFieldList,'string',acNames);
end
fnInvalidateHighMagList(handles);
return;

function fnInvalidateHighMagList(handles)
strctWideField=fnGetActiveWideField(handles);
if isempty(strctWideField)
    set(handles.hHighMagList,'string',[]);
    return;
end;

iNumMatchedHighRes = length(strctWideField.m_astrctHighMag);
acHighResNames = cell(1,iNumMatchedHighRes);
for k=1:iNumMatchedHighRes
    acHighResNames{k} = strctWideField.m_astrctHighMag(k).m_strName;
end
set(handles.hHighMagList,'string',acHighResNames,'value',1);
return;

function fnSetActiveHighMag(handles,iActiveHighMag)
if iActiveHighMag== 0
    return;
end;
strctWideField = fnGetActiveWideField(handles);

[strPath,strFile,strExt]=fileparts(strctWideField.m_astrctHighMag(iActiveHighMag).m_strFullPath);
switch lower(strExt)
    case '.mat'
        fprintf('Loading %s',strctWideField.m_astrctHighMag(iActiveHighMag).m_strFullPath);
        strctTmp = load(strctWideField.m_astrctHighMag(iActiveHighMag).m_strFullPath);
        fprintf('Done!\n');
        if ~isfield(strctTmp,'a4fTile')            
            strctTmp.a4fTile = strctTmp.a4fTile1;
        end
        setappdata(handles.figure1,'HighMagData',strctTmp.a4fTile);
        
%         acAttributes = fnSplitString(strctTmp.strMetaData,',')
%         for k=1:length(acAttributes)
%             fprintf('%s\n',acAttributes{k});
%         end;
%         
        
        if ~isfield(strctWideField.m_astrctHighMag(iActiveHighMag),'m_astrctChannels') || ...
            isfield(strctWideField.m_astrctHighMag(iActiveHighMag),'m_astrctChannels') && isempty(strctWideField.m_astrctHighMag(iActiveHighMag).m_astrctChannels)
            strctWideField.m_astrctHighMag(iActiveHighMag).m_astrctChannels = fnSetDefaultChannelsInfo(strctTmp.strMetaData,strctTmp.a4fTile);
        end
        fnUpdateWideField(handles,strctWideField);

        % Update Lsitbox
        
        % Update Lsitbox
        acChannelNames = {strctWideField.m_astrctHighMag(iActiveHighMag).m_astrctChannels.m_strName};
        if length(acChannelNames) == 2
            acChannelNames{3} = '';
        end
        set(handles.hHighMagChannels,'String',acChannelNames,'min',1,'max',length(acChannelNames),'value',1:length(acChannelNames));
end
set(handles.hHighMagList,'value',iActiveHighMag)

setappdata(handles.figure1,'iSelectedZ',1);
fnInvalidateAnnotationList(handles);
fnInvalidate(handles);
return;


function SetActiveWideField(handles,iActiveWideField)
% 1. Load the wide field image into memory...
if iActiveWideField == 0
        setappdata(handles.figure1,'WideFieldData',[]);

    return;
end;
strctWideField = fnGetActiveWideField(handles);
if isempty(strctWideField)
    setappdata(handles.figure1,'WideFieldData',[]);
    return;
end;
% Assume wide field does not have a z-stack, so 3rd dimension are channels.
% Extract from meta data channel names
[strP,strF,strType]=fileparts(strctWideField.m_strFullPath);
if strcmpi(strType,'.xml')
    fprintf('Reading XML File...\n');
    strctXml = xml2struct(strctWideField.m_strFullPath);
    clear astrctContours
    iCounter=1;
    strctWideField.m_astrctAnnoation = [];
    for k=1:length(strctXml.Children)
       if strcmpi(strctXml.Children(k).Name,'contour')
           % New contour found!
           a2fContourPoints = zeros(0,2);
           for j=1:length(strctXml.Children(k).Children)
               if strcmpi(strctXml.Children(k).Children(j).Name,'point')
                   x = str2num(strctXml.Children(k).Children(j).Attributes(2).Value);
                   y = str2num(strctXml.Children(k).Children(j).Attributes(3).Value);
                   a2fContourPoints(end+1,:)=[x,y];
               end
           end
           astrctContours(iCounter).m_apt2fPoints = a2fContourPoints;
           iCounter=iCounter+1;
       elseif strcmpi(strctXml.Children(k).Name,'marker')
 %          a2fAnnotationPoints = zeros(0,2);
           for j=1:length(strctXml.Children(k).Children)
               if strcmpi(strctXml.Children(k).Children(j).Name,'point')
                   x = str2num(strctXml.Children(k).Children(j).Attributes(2).Value);
                   y = str2num(strctXml.Children(k).Children(j).Attributes(3).Value);
                   if isempty(strctWideField.m_astrctAnnoation)
                       strctWideField.m_astrctAnnoation.m_pt3fPosition = [x,y,1]; % Assume single plane for wide field?
                       strctWideField.m_astrctAnnoation.m_strDescription = strctXml.Children(k).Attributes(2).Value;
                   else
                       strctWideField.m_astrctAnnoation(end+1).m_pt3fPosition = [x,y,1]; % Assume single plane for wide field?
                       strctWideField.m_astrctAnnoation(end).m_strDescription = strctXml.Children(k).Attributes(2).Value;
                   end
%                   a2fAnnotationPoints(end+1,:)=[x,y];
               end
           end
       end
    end
    a4fData = astrctContours;
    
else
    [a4fData, astrctChannels] = fnReadWideFieldFluoresenceImage(strctWideField.m_strFullPath);
    
    if ~isfield(strctWideField,'m_astrctChannels') || ...
            (isfield(strctWideField,'m_astrctChannels') && isempty(strctWideField.m_astrctChannels))
        strctWideField.m_astrctChannels = astrctChannels;
    end
end
% Update Lsitbox

if isempty(strctWideField.m_astrctChannels)
    set(handles.hWideFieldChannels,'String','','value',0);
else    
acChannelNames = {strctWideField.m_astrctChannels.m_strName};
if length(acChannelNames) == 2
    acChannelNames{3} = '';
end
set(handles.hWideFieldChannels,'String',acChannelNames,'min',1,'max',length(acChannelNames),'value',1:length(acChannelNames));
end

fnUpdateWideField(handles,strctWideField);
setappdata(handles.figure1,'WideFieldData',a4fData);
setappdata(handles.figure1,'iSelectedZ',1);
% Assume 
fnInvalidateAnnotationList(handles);
fnInvalidateHighMagList(handles);
if ~isempty(strctWideField.m_astrctHighMag)
    fnSetActiveHighMag(handles,1);
end
set(handles.hAnnotationList,'value',1);
fnFirstInvalidate(handles);




% --- Executes on button press in hAddHighMag.
function hAddHighMag_Callback(hObject, eventdata, handles)
strctWideField=fnGetActiveWideField(handles);
if isempty(strctWideField)
    fprintf('Cannot add high magnification if a wide field is not loaded...\n');
    return;
end;

[strFile,strPath]=uigetfile('D:\Photos\Work Related\Bert Confocal\High Mag Seroes 2 (NeuN, YFP)\*.tif;*.jpg;*.oib;*.mat');
if strFile(1) == 0
    return;
end;
strctHighMag.m_strFullPath = [strPath,strFile];
strctHighMag.m_strName = strFile;
strctHighMag.m_astrctAnnoation = [];
strctHighMag.m_a2fRegToWideField = eye(3);
strctHighMag.m_astrctChannels = [];
if isempty(strctWideField.m_astrctHighMag)
    strctWideField.m_astrctHighMag = strctHighMag;
    iNumHighMag = 1;
else
    iNumHighMag = 1+length(strctWideField.m_astrctHighMag);
    strctWideField.m_astrctHighMag(iNumHighMag) = strctHighMag;
end

fnUpdateWideField(handles,strctWideField);
% Load high magnification image....
fnSetActiveHighMag(handles,iNumHighMag);

% Update lists.
fnInvalidateHighMagList(handles);




% --- Executes on button press in hNeuN.
function hNeuN_Callback(hObject, eventdata, handles)
% hObject    handle to hNeuN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of hNeuN


% --- Executes on button press in hYFP.
function hYFP_Callback(hObject, eventdata, handles)
% hObject    handle to hYFP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of hYFP


% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton4


% --- Executes on button press in radiobutton5.
function radiobutton5_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton5


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in hWideFieldOnly.
function hWideFieldOnly_Callback(hObject, eventdata, handles)
setappdata(handles.figure1,'strViewMode','WideField');
fnInvalidate(handles);

function hHighMagOnly_Callback(hObject, eventdata, handles)
setappdata(handles.figure1,'strViewMode','HighMag');
fnInvalidate(handles);

function hCombinedView_Callback(hObject, eventdata, handles)
setappdata(handles.figure1,'strViewMode','Combined');
fnInvalidate(handles);


% --- Executes when selected object is changed in VisGroup.
function VisGroup_SelectionChangeFcn(hObject, eventdata, handles)
if get(handles.hTissueBlockVis,'value')
    setappdata(handles.figure1,'strViewMode','TissueBlock');
elseif get(handles.hWideFieldOnly,'value')
    setappdata(handles.figure1,'strViewMode','WideField');
elseif  get(handles.hHighMagOnly,'value')
    setappdata(handles.figure1,'strViewMode','HighMag');
else
    setappdata(handles.figure1,'strViewMode','Combined');
end
fnInvalidateAnnotationList(handles);
fnInvalidate(handles);


% --- Executes on selection change in hWideFieldChannels.
function hWideFieldChannels_Callback(hObject, eventdata, handles)
fnInvalidate(handles);

% --- Executes during object creation, after setting all properties.
function hWideFieldChannels_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hWideFieldChannels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in hHighMagChannels.
function hHighMagChannels_Callback(hObject, eventdata, handles)
fnInvalidate(handles);

% --- Executes during object creation, after setting all properties.
function hHighMagChannels_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hHighMagChannels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
fnInvalidate(handles);

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on selection change in hTissueBlockList.
function hTissueBlockList_Callback(hObject, eventdata, handles)
iSelectedTissueBlock = get(handles.hTissueBlockList,'value');
fnSetActiveTissueBlock(handles,iSelectedTissueBlock);
return;


% --- Executes during object creation, after setting all properties.
function hTissueBlockList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hTissueBlockList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in hAddTissueBlock.
function hAddTissueBlock_Callback(hObject, eventdata, handles)
[strFile,strPath]=uigetfile('D:\Photos\Work Related\Bert Histology Organized\*.tif;*.jpg;','MultiSelect','on');
if ~iscell(strFile) && strFile(1) == 0
    return;
end;
if ~iscell(strFile)
    strFile = {strFile};
end

for k=1:length(strFile)
    strctTissueBlock.m_strFullPath = [strPath,strFile{k}];
    strctTissueBlock.m_strName = strFile{k};
    strctTissueBlock.m_astrctWideField= [];
    strctTissueBlock.m_a2fElectrodeProjectionLines = [];
    astrctTissueBlock=getappdata(handles.figure1,'astrctTissueBlock');
    if isempty(astrctTissueBlock)
        astrctTissueBlock = strctTissueBlock;
    else
        astrctTissueBlock(end+1) = strctTissueBlock;
    end
    setappdata(handles.figure1,'astrctTissueBlock',astrctTissueBlock);
    % Update lists.
    fnInvalidateTissueBlockList(handles,length(astrctTissueBlock));
end

fnSetActiveTissueBlock(handles,length(astrctTissueBlock));

return;



function fnSetActiveTissueBlock(handles, iTissueBlockIndex)
if iTissueBlockIndex == 0
    return;
end;
% Load the tissue block image
astrctTissueBlock=getappdata(handles.figure1,'astrctTissueBlock');
fprintf('Loading Tissue block %s\n',astrctTissueBlock(iTissueBlockIndex).m_strFullPath);
TissueBlockData=im2double(imread(astrctTissueBlock(iTissueBlockIndex).m_strFullPath));
setappdata(handles.figure1,'TissueBlockData',TissueBlockData);

fnInvalidateWideFieldList(handles,length(astrctTissueBlock(iTissueBlockIndex).m_astrctWideField));
SetActiveWideField(handles,length(astrctTissueBlock(iTissueBlockIndex).m_astrctWideField));
if ~isempty(astrctTissueBlock(iTissueBlockIndex).m_astrctWideField) && ~isempty(astrctTissueBlock(iTissueBlockIndex).m_astrctWideField(length(astrctTissueBlock(iTissueBlockIndex).m_astrctWideField)).m_astrctHighMag)
    fnSetActiveHighMag(handles, 1);
end

hFig = getappdata(handles.figure1,'hFig');
if ~ishandle(hFig)
    fnOpenFigure(handles);
end
aiFigurePosition = get(hFig,'position');

fImageWidth = size(TissueBlockData,2);
fImageHeight = size(TissueBlockData,1);
fScreenWidth = aiFigurePosition(3);
fScreenHeight = aiFigurePosition(4);

a2fViewTrans=fnResizeKeepAspect(fImageWidth,fImageHeight, fScreenWidth, fScreenHeight); 
setappdata(handles.figure1,'a2fViewTrans',a2fViewTrans);

fnInvalidate(handles);
return
 
function fnInvalidateTissueBlockList(handles, iSetActiveBlock)
astrctTissueBlock = getappdata(handles.figure1,'astrctTissueBlock');
if isempty(astrctTissueBlock)
    set(handles.hTissueBlockList,'String','','Value',0);
    set(handles.hWideFieldList,'String','','Value',0);
    set(handles.hHighMagList,'String','','Value',0);
    set(handles.hAnnotationList,'String','','Value',0);
    return;
end
set(handles.hTissueBlockList,'String',{astrctTissueBlock.m_strName},'Value',iSetActiveBlock);
return;


function a3fRGB=fnMergeImages(handles,a3fRGB1, a3fRGB2)
bChecker = get(handles.hCheckerOverlay,'value');
if (bChecker)
    a3fRGB = fnMergeImagesCheckerboard(a3fRGB1, a3fRGB2);
else
    a3fRGB=fnMergeImagesSlider(handles,a3fRGB1, a3fRGB2);
end

return


function a3fRGB=fnMergeImagesSlider(handles,a3fRGB1, a3fRGB2)
a3bInvalid1 = isnan(a3fRGB1);
a3bInvalid2 = isnan(a3fRGB2);

fWeight=get(handles.slider1,'value');
a3fRGB=fWeight*a3fRGB1+(1-fWeight)*a3fRGB2;
a3fRGB(a3bInvalid1 &  ~a3bInvalid2) = (1-fWeight)*a3fRGB2(a3bInvalid1&  ~a3bInvalid2);
a3fRGB(a3bInvalid2 & ~a3bInvalid1) = (fWeight)*a3fRGB1(a3bInvalid2 & ~a3bInvalid1);
return

function a3fRGB = fnMergeImagesCheckerboard(a3fRGB1, a3fRGB2)
iHeight = size(a3fRGB1,1);
iWidth = size(a3fRGB1,2);
a3fRGB  = zeros(iHeight,iWidth,3);

iNumPixelsPerSquare = ceil(max(iHeight,iWidth)/20);
a2fCheckerBoard = checkerboard(iNumPixelsPerSquare, ceil(iHeight/iNumPixelsPerSquare), ceil(iWidth/iNumPixelsPerSquare));
a2bCheckerSmall = double(a2fCheckerBoard(1:iHeight,1:iWidth) > 0);
for k=1:3
    A = a3fRGB1(:,:,k);
    B = a3fRGB2(:,:,k);
    An = ~isnan(A) & a2bCheckerSmall;
    Bn = ~isnan(B) & ~a2bCheckerSmall;
    Tmp = zeros(iHeight,iWidth);
    Tmp(An)= A(An);
    Tmp(Bn) = B(Bn);
    
    a3fRGB(:,:,k) =  Tmp;
end
return


% --- Executes on button press in hCheckerOverlay.
function hCheckerOverlay_Callback(hObject, eventdata, handles)
fnInvalidate(handles);


% --- Executes on button press in hSave.
function hSave_Callback(hObject, eventdata, handles)
fnSaveDatabase(handles);


% --- Executes on key press with focus on hAnnotationList and none of its controls.
function hAnnotationList_KeyPressFcn(hObject, eventdata, handles)
iEntry = get(hObject,'value');
if strcmpi(eventdata.Key,'delete')
    % Delete annotation...
    
    strctWideField = fnGetActiveWideField(handles);
    iSelectedHighMag = get(handles.hHighMagList,'value');
    
    if get(handles.hWideFieldOnly,'value')
        strctWideField.m_astrctAnnoation(iEntry) = [];
        fnUpdateWideField(handles,strctWideField);
        fnInvalidateAnnotationList(handles);
        fnInvalidate(handles);
    elseif  get(handles.hHighMagOnly,'value')
        strctWideField.m_astrctHighMag(iSelectedHighMag).m_astrctAnnoation(iEntry) = [];
        fnUpdateWideField(handles,strctWideField);
        fnInvalidateAnnotationList(handles);
        fnInvalidate(handles);
    else
        
        
        
    end
end

return;


function hAnnotationList_Callback(hObject, eventdata, handles)
aiSelectedAnnotation = get(handles.hAnnotationList,'value');
iSelectedAnnotation=aiSelectedAnnotation(1);
%%
strctWideField = fnGetActiveWideField(handles);

iActiveHighMag = get(handles.hHighMagList,'value');

hFig = getappdata(handles.figure1,'hFig');
if ~ishandle(hFig)
    fnOpenFigure(handles);
    hFig = getappdata(handles.figure1,'hFig');
end
aiFigurePosition = get(hFig,'position');
fScreenWidth = aiFigurePosition(3);
fScreenHeight = aiFigurePosition(4);

    
a2fViewTrans = getappdata(handles.figure1,'a2fViewTrans');

if (iSelectedAnnotation > 0)
pt2fAnnotation = strctWideField.m_astrctHighMag(iActiveHighMag).m_astrctAnnoation(iSelectedAnnotation).m_pt3fPosition;
pt2fAnnotation(3)=1;

afShift = pt2fAnnotation' - (a2fViewTrans * [fScreenWidth/2;fScreenHeight/2;1]);

afShift(3) = 1;
pt2fShift= inv(a2fViewTrans)* afShift;      

a2fViewTrans(1,3) = a2fViewTrans(1,3) + afShift(1);
a2fViewTrans(2,3) = a2fViewTrans(2,3) + afShift(2);
%%
setappdata(handles.figure1,'a2fViewTrans',a2fViewTrans);
end

fnInvalidate(handles);
return

function hDeleteAnnotation_Callback(hObject, eventdata, handles)
iSelectedAnnotation = get(handles.hAnnotationList,'value');
if iSelectedAnnotation(1) == 0
    return
end
strctWideField = fnGetActiveWideField(handles);
if get(handles.hWideFieldOnly,'value')
if length(strctWideField.m_astrctAnnoation) >= iSelectedAnnotation
    strctWideField.m_astrctAnnoation(iSelectedAnnotation) = [];
    fnUpdateWideField(handles,strctWideField);
    fnInvalidateAnnotationList(handles);
    fnInvalidate(handles);
end
elseif get(handles.hHighMagOnly,'value')
    iActiveHighMag = get(handles.hHighMagList,'value');
    strctWideField.m_astrctHighMag(iActiveHighMag).m_astrctAnnoation(iSelectedAnnotation) = [];
    for k=1:length(strctWideField.m_astrctHighMag(iActiveHighMag).m_astrctAnnoation)
        strctWideField.m_astrctHighMag(iActiveHighMag).m_astrctAnnoation(k).m_strDescription = 'EYFP';
    end
     fnUpdateWideField(handles,strctWideField);
    if iSelectedAnnotation(1)-1 > 0
        fnInvalidateAnnotationList(handles,iSelectedAnnotation-1);
    else
        fnInvalidateAnnotationList(handles);
    end
    hAnnotationList_Callback([], [], handles);
    fnInvalidate(handles);

end


% --- Executes when selected object is changed in uipanel6.
function uipanel6_SelectionChangeFcn(hObject, eventdata, handles)
fnInvalidate(handles);


% --- Executes on button press in hRemoveWideField.
function hRemoveWideField_Callback(hObject, eventdata, handles)


% --- Executes on button press in hReloadData.
function hReloadData_Callback(hObject, eventdata, handles)
fprintf('Loading database from cache...');
load('ImageRegisCache.mat');
setappdata(handles.figure1,'astrctTissueBlock',astrctTissueBlock);
fprintf('Done!\n');
fnInvalidate(handles);
