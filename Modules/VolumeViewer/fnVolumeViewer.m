function varargout = fnVolumeViewer(varargin)
% This is the GUI handler that shows a volume and marks the position of
% large hessian values and of found blood vessels

gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @fnVolumeViewerOpeningFcn, ...
    'gui_OutputFcn',  @fnVolumeViewerOutputFcn, ...
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

function fnMouseWheel(hObject, eventdata, handles)
fnUpdateCrosshairPosition(handles, eventdata.VerticalScrollCount);
return;

function fnInitVolumeViewer(handles)
fnSetDefaultDynamicRange(handles);
setappdata(handles.figure1,'pt3fCrosshair',[1 1 1]);
setappdata(handles.figure1,'bShowHighlights', 1);
setappdata(handles.figure1,'iRotationAxis',3); % i.e., change Z initially
setappdata(handles.figure1,'strLeftOp','Slices');
setappdata(handles.figure1,'bMouseDown',0);
setappdata(handles.figure1,'strMouseMode','Slices');
fnAutoSelectColorScheme(handles);
fnFirstInvalidate(handles);
fnSetCallbacks(handles);
return;


function fnVolumeViewerOpeningFcn(hObject, eventdata, handles, varargin)
% Entry point
iNumArg = length(varargin);
assert(iNumArg > 0 && iNumArg <= 2,'Incorrect number of inputs');
a3MainVolume = varargin{1};
if iNumArg == 2
    a3bMaskVolume = varargin{2};
    assert(isa(a3bMaskVolume,'logical'),'Mask volume must be logical');
    assert( all(size(a3bMaskVolume) == size(a3MainVolume)),'Mask volume must have same size as main volume');  
else
    a3bMaskVolume = [];
end;

try
    A=fndllFastInterp3(rand(10,10,10),5,5,5);
    bFastInterp = true;
catch
    bFastInterp = false;
end

setappdata(handles.figure1, 'a3MainVolume', a3MainVolume);
setappdata(handles.figure1, 'a3bMaskVolume',a3bMaskVolume);
setappdata(handles.figure1, 'bFastInterp', bFastInterp);

fnInitVolumeViewer(handles);
fnInvalidate(handles);
handles.output = hObject;
guidata(hObject, handles);
return;


function fnFirstInvalidate(handles)
a3MainVolume = getappdata(handles.figure1,'a3MainVolume');
cla(handles.axes1);
a3fCdata = fnGenerateImageAccordingToColorScheme(handles);
hImage = image([], [], a3fCdata,  'Parent', handles.axes1);
setappdata(handles.figure1,'hImage',hImage);
hold(handles.axes1,'on');

hCrossHairVert = plot(handles.axes1,[1 1],[1 size(a3MainVolume,1)],'r');
hCrossHairHoriz = plot(handles.axes1,[1 size(a3MainVolume,2)],[1 1],'r');
setappdata(handles.figure1,'hCrossHairVert',hCrossHairVert);
setappdata(handles.figure1,'hCrossHairHoriz',hCrossHairHoriz);
set(handles.axes1,'Visible','off');
return;

function strMouseClick = fnGetClickType(hFigure)
strMouseType = get(hFigure,'selectiontype');
if (strcmp( strMouseType,'alt'))
    strMouseClick = 'Right';
end;
if (strcmp( strMouseType,'normal'))
    strMouseClick = 'Left';
end;
if (strcmp( strMouseType,'extend'))
    strMouseClick = 'Both';
end;
if (strcmp( strMouseType,'open'))
    strMouseClick = 'DoubleClick';
end;
return;


function fnSetNewMouseMode(a,b,handles, strOp)
fprintf('Setting mode : %s\n',strOp);
setappdata(handles.figure1,'strMouseMode',strOp);
return;

function axesXY_ButtonDownFcn(hObject, eventdata, handles)
setappdata(handles.figure1,'iRotationAxis',3);
fnInvalidate(handles);
return;
function axesYZ_ButtonDownFcn(hObject, eventdata, handles)
setappdata(handles.figure1,'iRotationAxis',2);
fnInvalidate(handles);
return;
function axesXZ_ButtonDownFcn(hObject, eventdata, handles)
setappdata(handles.figure1,'iRotationAxis',1);
fnInvalidate(handles);
return;


function fnUpdateCrosshairPosition(handles, fDelta)
iRotationAxis = getappdata(handles.figure1,'iRotationAxis');
pt3fCrosshair = getappdata(handles.figure1,'pt3fCrosshair');
a3MainVolume = getappdata(handles.figure1,'a3MainVolume');
pt3fCrosshair(iRotationAxis) = pt3fCrosshair(iRotationAxis) + fDelta;
pt3fCrosshair = max([1,1,1],min(pt3fCrosshair, size(a3MainVolume)));
setappdata(handles.figure1,'pt3fCrosshair',pt3fCrosshair);
fnInvalidate(handles);
fnUpdateStatusLine(handles);
return;

function hPrevSlice_Callback(hObject, eventdata, handles)
fnUpdateCrosshairPosition(handles, -1);
return;

function hNextSlice_Callback(hObject, eventdata, handles)
fnUpdateCrosshairPosition(handles, +1);
return;

function fnSetCallbacks(handles)
hMenu = uicontextmenu;
uimenu(hMenu, 'Label', 'Scroll', 'Callback', {@fnSetNewMouseMode,handles,'Slices'});
uimenu(hMenu, 'Label', 'Contrast', 'Callback', {@fnSetNewMouseMode,handles,'Contrast'});
uimenu(hMenu, 'Label', 'Zoom', 'Callback', {@fnSetNewMouseMode,handles,'Zoom'});
uimenu(hMenu, 'Label', 'Pan', 'Callback', {@fnSetNewMouseMode,handles,'Pan'});
uimenu(hMenu, 'Label', 'Crosshair', 'Callback', {@fnSetNewMouseMode,handles,'Crosshair'});

hItem = uimenu(hMenu, 'Label', 'Colormap', 'Separator','on');
uimenu(hItem, 'Label', 'Grey','Callback', {@fnSetNewColorMap,handles,'Grey'});
uimenu(hItem, 'Label', 'Jet','Callback', {@fnSetNewColorMap,handles,'Jet'});
uimenu(hItem, 'Label', 'Labels','Callback', {@fnSetNewColorMap,handles,'Label2D'});
hImage = getappdata(handles.figure1,'hImage');
set(hImage, 'UIContextMenu', hMenu);

set(handles.figure1,'WindowButtonMotionFcn',{@fnMouseMove,handles});
set(handles.figure1,'WindowButtonDownFcn',{@fnMouseDown,handles});
set(handles.figure1,'WindowButtonUpFcn',{@fnMouseUp,handles});
set(handles.figure1,'WindowScrollWheelFcn',{@fnMouseWheel,handles});
return;

function fnSetNewColorMap(a,b,handles, strOp)
setappdata(handles.figure1,'strColorScheme',strOp);
fnInvalidate(handles);
return;

function fnSetDefaultDynamicRange(handles)
% This function sets the default dynamic range
a3MainVolume = getappdata(handles.figure1,'a3MainVolume');
fMin = min(a3MainVolume(:));
fMax = max(a3MainVolume(:));
assert(fMin ~= fMax,'Input volume has only one value????');

strctHistogramStretch.m_fMin = double(fMin);
strctHistogramStretch.m_fMax = double(fMax);
strctHistogramStretch.m_fRange = double(fMax-fMin);
strctHistogramStretch.m_fCenter = double(fMin + (fMax-fMin)/2);
strctHistogramStretch.m_fWidth  = double(fMax-fMin);
setappdata(handles.figure1,'strctHistogramStretch',strctHistogramStretch);
return;

function strColorScheme = fnAutoSelectColorScheme(handles)
a3Volume = getappdata(handles.figure1,'a3MainVolume');
if isa(a3Volume,'single') || isa(a3Volume,'double') || isa(a3Volume,'logical')
    strColorScheme = 'Grey';
elseif isa(a3Volume,'uint8')
    strColorScheme = 'Label2D';
elseif isa(a3Volume,'uint16') || isa(a3Volume,'uint32')
    strColorScheme = 'Label3D';
else % default
    strColorScheme = 'Grey';
end;
setappdata(handles.figure1,'strColorScheme',strColorScheme);
return;


function pt2fMouseDownPosition = fnGetMouseCoordinate(hAxes)
pt2fMouseDownPosition = get(hAxes,'CurrentPoint');
if size(pt2fMouseDownPosition,2) ~= 3
    pt2fMouseDownPosition = [-1 -1];
else
    pt2fMouseDownPosition = [pt2fMouseDownPosition(1,1), pt2fMouseDownPosition(1,2)];
end;
return;

function fnPrintMouseOp(strctMouseOp)
fprintf('%s %s in %s window, Pos [%.2f %.2f]\n',...
    strctMouseOp.m_strButton, strctMouseOp.m_strAction, ...
    strctMouseOp.m_strWindow,strctMouseOp.m_pt2fPos(1),strctMouseOp.m_pt2fPos(2));
return;

function [hAxes,strActiveWindow] = fnGetActiveWindow(handles)
if (fnInsideImage(handles,handles.axes1))
    hAxes = handles.axes1;
    strActiveWindow = 'XY';
else
    hAxes = [];
    strActiveWindow = [];
end;

return;

function fnHandleMouseDownEvent(strctMouseOp,handles)
if ~isempty(strctMouseOp.m_hAxes) && strctMouseOp.m_hAxes == handles.axes1 && ...
    strcmp(strctMouseOp.m_strModeWhenDown,'Crosshair')

    fnSetNewCrossHair(handles, strctMouseOp);
    fnInvalidate(handles);
end;
return;

function fnMouseDown(obj,eventdata,handles)
strctMouseOp.m_strButton = fnGetClickType(handles.figure1);
strctMouseOp.m_strAction = 'Down';
[strctMouseOp.m_hAxes, strctMouseOp.m_strWindow] = fnGetActiveWindow(handles);
strctMouseOp.m_pt2fPos = fnGetMouseCoordinate(strctMouseOp.m_hAxes);
strctMouseOp.m_strModeWhenDown = getappdata(handles.figure1,'strMouseMode');

fnPrintMouseOp(strctMouseOp);

setappdata(handles.figure1,'bMouseDown',true);

setappdata(handles.figure1,'strctMouseDown',strctMouseOp);
setappdata(handles.figure1,'strctMouseCurr',strctMouseOp);
fnHandleMouseDownEvent(strctMouseOp,handles);
set(handles.figure1, 'Pointer', 'crosshair');
return;

function fnMouseMove(obj,eventdata,handles)
bMouseDown = getappdata(handles.figure1,'bMouseDown');
strctMouseOp.m_strButton = fnGetClickType(handles.figure1);
strctMouseOp.m_strAction = 'Move';
[strctMouseOp.m_hAxes, strctMouseOp.m_strWindow] = fnGetActiveWindow(handles);
strctMouseOp.m_pt2fPos = fnGetMouseCoordinate(strctMouseOp.m_hAxes);
strctPrevMouseOp = getappdata(handles.figure1,'strctMouseCurr');
setappdata(handles.figure1,'strctMouseCurr', strctMouseOp);
strctMouseDown = getappdata(handles.figure1,'strctMouseDown');

if  ~isempty(strctMouseOp.m_hAxes) 
    if bMouseDown
        fnHandleMouseMoveWhileDown(strctPrevMouseOp, strctMouseOp, handles);
    else
        fnUpdateStatusLine(handles);
    end;
end;

return;



function fnMouseUp(obj,eventdata,handles)
setappdata(handles.figure1,'bMouseDown',0);
strctMouseOp.m_strButton = fnGetClickType(handles.figure1);
strctMouseOp.m_strAction = 'Up';
[strctMouseOp.m_hAxes, strctMouseOp.m_strWindow] = fnGetActiveWindow(handles);
strctMouseOp.m_pt2fPos = fnGetMouseCoordinate(strctMouseOp.m_hAxes);

fnPrintMouseOp(strctMouseOp);
setappdata(handles.figure1,'strctMouseCurr',strctMouseOp);
setappdata(handles.figure1,'strctMouseUp',strctMouseOp);

strSavedMouseMode = getappdata(handles.figure1,'strSavedMouseMode');
if ~isempty(strSavedMouseMode)
    fprintf('Setting Mouse mode back to %s\n',strSavedMouseMode);
    setappdata(handles.figure1,'strMouseMoveMode',strSavedMouseMode);
    setappdata(handles.figure1,'strSavedMouseMode',[]);
end;
set(handles.figure1, 'Pointer', 'arrow');

return;

function varargout = fnVolumeViewerOutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;
return;

function [bInside] = fnInsideImage(handles, window_handle)
set(handles.figure1,'Units','pixels');
set(window_handle,'Units','pixels');
MousePos = get(handles.figure1,'CurrentPoint');
AxesRect = get(window_handle,'Position');
bInside =  (MousePos(1) > AxesRect(1) && ...
    MousePos(1) < AxesRect(1)+AxesRect(3) && ...
    MousePos(2) > AxesRect(2) &&  ...
    MousePos(2) < AxesRect(2)+AxesRect(4));
return;


function a2I = fnGetVolSlice(iRotationAxis, a3Vol, iSlice)
if isempty(a3Vol)
    a2I = [];
    return;
end;

switch (iRotationAxis)
    case 3 
        a2I = squeeze(a3Vol(:,:,iSlice));
    case 2        
        a2I = squeeze(a3Vol(:,iSlice,:))';
    case 1
        a2I = squeeze(a3Vol(iSlice,:,:))';
end;
return;



function I = fnIntensityWindowTransform(I, fCPos, fWPos)
a = 1 / (2*fWPos);
b = -a * (fCPos-fWPos);
I = a*I + b;
I(I <= (fCPos-fWPos)) = 0;
I(I >=(fCPos+fWPos)) = 1;
return;


%% Below this point is old code (!!!)

function a3fCdata = fnGenerateImageAccordingToColorScheme(handles)
a3MainVolume = getappdata(handles.figure1,'a3MainVolume');
a3bMaskVolume = getappdata(handles.figure1,'a3bMaskVolume');
iRotationAxis = getappdata(handles.figure1,'iRotationAxis');
bShowHighlights = getappdata(handles.figure1,'bShowHighlights');
pt3fCrosshair = getappdata(handles.figure1,'pt3fCrosshair');

a2bMask = fnGetVolSlice(iRotationAxis, a3bMaskVolume,round(pt3fCrosshair(iRotationAxis)));
a2fSlice = single(fnGetVolSlice(iRotationAxis, a3MainVolume,round(pt3fCrosshair(iRotationAxis))));
strctHistogramStretch = getappdata(handles.figure1,'strctHistogramStretch');

strColorScheme = getappdata(handles.figure1,'strColorScheme');
  
switch strColorScheme
    case 'Grey'
        a2fSliceTrans = fnIntensityWindowTransform(a2fSlice, ...
            strctHistogramStretch.m_fCenter, strctHistogramStretch.m_fWidth);
        a3fCdata = repmat(a2fSliceTrans,[1 1 3]);

        if ~isempty(a2bMask) && bShowHighlights
            a3fCdata(:,:,2)=(1 - 0.4 * single(a2bMask)) .* a2fSliceTrans;
            a3fCdata(:,:,3)=(1 - 0.4 * single(a2bMask)) .* a2fSliceTrans;
        end;
        
    case 'Jet'
        colormapjet = colormap('jet');
        a2fSlice(isnan(a2fSlice)) = 0;
        a2fSlice(isinf(a2fSlice)) = 1;
        a2fSliceEq = (a2fSlice - strctHistogramStretch.m_fMin) / strctHistogramStretch.m_fRange;
        iNumColors = size(colormapjet,1);
        ColorIndices = round(1+ a2fSliceEq*(iNumColors-1));
        a3fCdata = zeros([size(a2fSliceEq),3]);
        a3fCdata(:,:,1) = reshape(colormapjet(ColorIndices,1),size(a2fSliceEq));
        a3fCdata(:,:,2) = reshape(colormapjet(ColorIndices,2),size(a2fSliceEq));
        a3fCdata(:,:,3) = reshape(colormapjet(ColorIndices,3),size(a2fSliceEq));
        
    case 'Label2D'
        a2iSlice = uint16(round(double(a2fSlice)));
        a2iSlice(1,1) = uint16(round(strctHistogramStretch.m_fMax));
        a3fCdata = double(label2rgb(a2iSlice))/255;
        
    case 'Label3D'
           a2iSlice = uint16(round(double(a2fSlice)));
        a2iSlice(1,1) = uint16(round(strctHistogramStretch.m_fMax));
        a3fCdata = label2rgb(a2iSlice);

        
end
return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function fnInvalidate(handles)
a3fCdata=fnGenerateImageAccordingToColorScheme(handles);
hImage=getappdata(handles.figure1,'hImage');
bShowHighlights = getappdata(handles.figure1,'bShowHighlights');

iRotationAxis = getappdata(handles.figure1,'iRotationAxis');
pt3fCrosshair = getappdata(handles.figure1,'pt3fCrosshair');
hCrossHairVert=getappdata(handles.figure1,'hCrossHairVert');
hCrossHairHoriz=getappdata(handles.figure1,'hCrossHairHoriz');

switch iRotationAxis
    case 1
        set(hCrossHairVert,'xdata',[pt3fCrosshair(3) pt3fCrosshair(3)]); 
        set(hCrossHairHoriz,'ydata',[pt3fCrosshair(2) pt3fCrosshair(2)]); 
    case 2
        set(hCrossHairVert,'xdata',[pt3fCrosshair(1) pt3fCrosshair(1)]); 
        set(hCrossHairHoriz,'ydata',[pt3fCrosshair(3) pt3fCrosshair(3)]); 
    case 3
        set(hCrossHairVert,'xdata',[pt3fCrosshair(1) pt3fCrosshair(1)]); 
        set(hCrossHairHoriz,'ydata',[pt3fCrosshair(2) pt3fCrosshair(2)]); 
end;

if bShowHighlights
    set(hCrossHairHoriz,'visible','on');
    set(hCrossHairVert,'visible','on');    
else
    set(hCrossHairHoriz,'visible','off');
    set(hCrossHairVert,'visible','off');    
end;

if (ishandle(hImage))
    set(hImage,'CData',min(1,max(0,a3fCdata)));
end;

fnUpdateStatusLine(handles);
drawnow
return;

function fnSetNewContrastLevel(handles, afDelta)
strctHistogramStretch = getappdata(handles.figure1,'strctHistogramStretch');
fMaxWidth = 2*strctHistogramStretch.m_fWidth;
strctHistogramStretch.m_fWidth = min(fMaxWidth,max(0,strctHistogramStretch.m_fWidth + afDelta(2)*fMaxWidth/400));
strctHistogramStretch.m_fCenter = min(strctHistogramStretch.m_fMax,...
    max(strctHistogramStretch.m_fMin,strctHistogramStretch.m_fCenter + afDelta(1)*fMaxWidth/400));
setappdata(handles.figure1,'strctHistogramStretch',strctHistogramStretch);
return;

function fnSetNewZoomLevel(handles, afDelta)
if abs(afDelta(2)) < 200
    afXlim = get(handles.axes1,'xlim');
    afYlim = get(handles.axes1,'ylim');
    set(handles.axes1,'xlim',[afXlim(1)+afDelta(2), afXlim(2)-afDelta(2)]);
    set(handles.axes1,'ylim',[afYlim(1)+afDelta(2), afYlim(2)-afDelta(2)]);
end;
return;

function fnSetNewPanLevel(handles, afDelta)
afXlim = get(handles.axes1,'xlim');
afYlim = get(handles.axes1,'ylim');
set(handles.axes1,'xlim',afXlim + afDelta(1));
set(handles.axes1,'ylim',afYlim + afDelta(2));
return;
        

function fnSetNewCrossHair(handles, strctMouseOp)

iRotationAxis = getappdata(handles.figure1,'iRotationAxis');
pt3fCrosshair = getappdata(handles.figure1,'pt3fCrosshair');

switch iRotationAxis
    case 3
         pt3fCrosshair(1) = strctMouseOp.m_pt2fPos(1);
         pt3fCrosshair(2) = strctMouseOp.m_pt2fPos(2);         
     case 2
         pt3fCrosshair(1) = strctMouseOp.m_pt2fPos(1);         
         pt3fCrosshair(3) = strctMouseOp.m_pt2fPos(2);
    case 1
         pt3fCrosshair(3) = strctMouseOp.m_pt2fPos(1);         
         pt3fCrosshair(2) = strctMouseOp.m_pt2fPos(2);
end;
setappdata(handles.figure1,'pt3fCrosshair',pt3fCrosshair);
fprintf('%.2f %.2f %.2f\n',pt3fCrosshair(1),pt3fCrosshair(2),pt3fCrosshair(3));
return;


function fnHandleMouseMoveWhileDown(strctPrevMouseOp, strctMouseOp, handles)
%fnPrintMouseOp(strctMouseOp);

strMouseMode = getappdata(handles.figure1,'strMouseMode');
strctMouseDown = getappdata(handles.figure1,'strctMouseDown');

 afDelta= strctMouseOp.m_pt2fPos - strctPrevMouseOp.m_pt2fPos;
 afDiff = strctMouseDown.m_pt2fPos - strctMouseOp.m_pt2fPos;

 switch strMouseMode
     case 'Slices'
         pt3fCrosshair = getappdata(handles.figure1,'pt3fCrosshair');
         iRotationAxis = getappdata(handles.figure1,'iRotationAxis');
         a3MainVolume = getappdata(handles.figure1,'a3MainVolume');
         pt3fCrosshair(iRotationAxis) = pt3fCrosshair(iRotationAxis) + afDelta(2);
         pt3fCrosshair = max([1,1,1],min(pt3fCrosshair, size(a3MainVolume)));
         setappdata(handles.figure1,'pt3fCrosshair',pt3fCrosshair);
     case 'Contrast'
         fnSetNewContrastLevel(handles,afDelta);
     case 'Zoom'
         fnSetNewZoomLevel(handles, afDelta);
     case 'Pan'
         fnSetNewPanLevel(handles, afDiff);
     case 'Crosshair'
         fnSetNewCrossHair(handles, strctMouseOp);
 end;
fnInvalidate(handles);
return;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function fnUpdateStatusLine(handles)
Tmp = get(handles.axes1,'CurrentPoint');
bFastInterp = getappdata(handles.figure1,'bFastInterp');

pt2fMousePos = [Tmp(1,1), Tmp(1,2)];
pt3fCrosshair = getappdata(handles.figure1,'pt3fCrosshair');
iRotationAxis = getappdata(handles.figure1,'iRotationAxis');

switch iRotationAxis
    case 3
        pt3iPos = [pt2fMousePos(1), pt2fMousePos(2), pt3fCrosshair(3)];
    case 2
        pt3iPos = [pt3fCrosshair(1), pt2fMousePos(1), pt2fMousePos(2)];
    case 1
        pt3iPos = [pt2fMousePos(1), pt3fCrosshair(2), pt2fMousePos(2)];
end;
a3MainVolume = getappdata(handles.figure1,'a3MainVolume');
if fnInsideImage(handles,handles.axes1) && all(pt3iPos >= 1) && all(pt3iPos([2,1,3]) <= size(a3MainVolume))
    if bFastInterp
        fValue = fndllFastInterp3(a3MainVolume, pt3iPos(1),pt3iPos(2),pt3iPos(3));
    else
        fValue = a3MainVolume(round(pt3iPos(2)),round(pt3iPos(1)), round(pt3iPos(3)));
    end;
else
    fValue = NaN;
end
strStatusLine = sprintf('[%.2f %.2f %.2f] = %.4f. [%d %d %d] = %.4f',...
    pt3iPos(1),pt3iPos(2),pt3iPos(3),fValue,round(pt3iPos(1)),round(pt3iPos(2)),round(pt3iPos(3)),fValue);
set(handles.hStatusLine,'String',strStatusLine);
return;

% --- Executes on button press in hShowHideHighLights.
function hShowHideHighLights_Callback(hObject, eventdata, handles)
bShowHighlights = getappdata(handles.figure1,'bShowHighlights');
bShowHighlights = ~bShowHighlights;
setappdata(handles.figure1,'bShowHighlights',bShowHighlights);
fnInvalidate(handles);


% --- Executes on button press in hUserCallback.
function hUserCallback_Callback(hObject, eventdata, handles)
% hObject    handle to hUserCallback (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_3_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_4_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function Untitled_1_Callback(hObject, eventdata, handles)

