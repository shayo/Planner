function varargout = EarBarZeroRegGUI(varargin)
% EARBARZEROREGGUI MATLAB code for EarBarZeroRegGUI.fig
%      EARBARZEROREGGUI, by itself, creates a new EARBARZEROREGGUI or raises the existing
%      singleton*.
%
%      H = EARBARZEROREGGUI returns the handle to a new EARBARZEROREGGUI or the handle to
%      the existing singleton*.
%
%      EARBARZEROREGGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EARBARZEROREGGUI.M with the given input arguments.
%
%      EARBARZEROREGGUI('Property','Value',...) creates a new EARBARZEROREGGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before EarBarZeroRegGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to EarBarZeroRegGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help EarBarZeroRegGUI

% Last Modified by GUIDE v2.5 21-Dec-2012 21:47:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @EarBarZeroRegGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @EarBarZeroRegGUI_OutputFcn, ...
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


% --- Executes just before EarBarZeroRegGUI is made visible.
function EarBarZeroRegGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to EarBarZeroRegGUI (see VARARGIN)

% Choose default command line output for EarBarZeroRegGUI
handles.output = hObject;
strctAnatVol = varargin{1};
%strctHorizCrossSection = varargin{2};
setappdata(handles.figure1,'strctAnatVol',strctAnatVol);

setappdata(handles.figure1,'a2fOriginalRegMatrix',strctAnatVol.m_a2fReg);

strctRotationPoints.m_pt3fHorizontalRotationPoint = [0;0;0];
strctRotationPoints.m_pt3fSaggitalRotationPoint = [0;0;0];
strctRotationPoints.m_pt3fCoronalRotationPoint = [0;0;0];
setappdata(handles.figure1,'strctRotationPoints',strctRotationPoints);

a2fRegToEarBar = eye(4);
setappdata(handles.figure1,'a2fRegToEarBar',a2fRegToEarBar);

set(handles.figure1,'WindowButtonMotionFcn',{@fnMouseMove,handles});
set(handles.figure1,'WindowButtonDownFcn',{@fnMouseDown,handles});
set(handles.figure1,'WindowButtonUpFcn',{@fnMouseUp,handles});
set(handles.figure1,'WindowScrollWheelFcn',{@fnMouseWheel,handles});

setappdata(handles.figure1,'strMouseMode','TranslateVolume');

fnFirstInvalidate(handles);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes EarBarZeroRegGUI wait for user response (see UIRESUME)
uiwait(handles.figure1);

return;

function fnCallback(a,b,strWhat, handles)
switch strWhat
    case 'SetTranslateMode'
        setappdata(handles.figure1,'strMouseMode','TranslateVolume');
    case 'SetRotateMode'
            setappdata(handles.figure1,'strMouseMode','RotateVolume');
    case 'SetZoomMode'
        setappdata(handles.figure1,'strMouseMode','ZoomVolume');
    case 'SetPanMode'
        setappdata(handles.figure1,'strMouseMode','PanVolume');
    case 'SetRotatePivot'
        setappdata(handles.figure1,'strMouseMode','SetRotationPivot');
end;

return;



function fnMouseWheel(obj,eventdata, handles)
strctAnatVol = getappdata(handles.figure1,'strctAnatVol');
pt2fFigure = round(get(handles.figure1,'CurrentPoint'));

fDiff =  eventdata.VerticalScrollCount * 0.1;
 hAxes = fnGetActiveAxes(handles, pt2fFigure);
 if isempty(hAxes)
     return;
 end;
a2fTransMatrix = eye(4);
switch hAxes
    case handles.hHorizAxes
        afTransAddition = strctAnatVol.m_strctCrossSectionHoriz.m_a2fM(1:3,3) * fDiff;
        a2fTransMatrix = [eye(3), afTransAddition;0,0,0,1];
    case handles.hCoronalAxes
        afTransAddition = strctAnatVol.m_strctCrossSectionCoronal.m_a2fM(1:3,3) * fDiff;
        a2fTransMatrix = [eye(3), afTransAddition;0,0,0,1];
        
    case handles.hSaggitalAxes
        afTransAddition = strctAnatVol.m_strctCrossSectionSaggital.m_a2fM(1:3,3) * fDiff;
        a2fTransMatrix = [eye(3), afTransAddition;0,0,0,1];
end

strctAnatVol.m_a2fReg = strctAnatVol.m_a2fReg * a2fTransMatrix;
setappdata(handles.figure1,'strctAnatVol',strctAnatVol);
fnInvalidate(handles);
return;

function fnMouseUp(obj,eventdata, handles)
strctMouseOp.m_strButton = fnGetClickType(handles.figure1);
strctMouseOp.m_strButton = []; 
strctMouseOp.m_strAction = 'Move';
pt2fFigure = round(get(handles.figure1,'CurrentPoint'));
strctMouseOp.m_hAxes = fnGetActiveAxes(handles, pt2fFigure);
strctMouseOp.m_pt2fPos = fnGetMouseCoordinate(strctMouseOp.m_hAxes);
strctMouseOp.m_hObjectSelected = [];

setappdata(handles.figure1,'bMouseDown',false);
setappdata(handles.figure1,'strctMouseUp',strctMouseOp);
setappdata(handles.figure1,'strctMouseOp',strctMouseOp);
return;

function fnMouseDown(obj,eventdata, handles)
strctMouseOp.m_strButton = []; 
strctMouseOp.m_strButton = fnGetClickType(handles.figure1);

strctMouseOp.m_strAction = 'Move';
pt2fFigure = round(get(handles.figure1,'CurrentPoint'));
strctMouseOp.m_hAxes = fnGetActiveAxes(handles, pt2fFigure);
strctMouseOp.m_pt2fPos = fnGetMouseCoordinate(strctMouseOp.m_hAxes);
strctMouseOp.m_hObjectSelected = [];

setappdata(handles.figure1,'bMouseDown',true);

setappdata(handles.figure1,'strctMouseDown',strctMouseOp);
setappdata(handles.figure1,'strctMouseOp',strctMouseOp);
setappdata(handles.figure1,'strctMouseOpMovePrev',strctMouseOp);

return;


function fnMouseMove(obj,eventdata, handles)
strMouseMode = getappdata(handles.figure1,'strMouseMode');
strctMouseOp = getappdata(handles.figure1,'strctMouseMove');
setappdata(handles.figure1,'strctMouseOpMovePrev',strctMouseOp);

strctMouseOp.m_strButton = [];
strctMouseOp.m_strAction = 'Move';
pt2fFigure = round(get(handles.figure1,'CurrentPoint'));
strctMouseOp.m_hAxes = fnGetActiveAxes(handles, pt2fFigure);
strctMouseOp.m_pt2fPos = fnGetMouseCoordinate(strctMouseOp.m_hAxes);
strctMouseOp.m_hObjectSelected = [];
setappdata(handles.figure1,'strctMouseMove',strctMouseOp);
setappdata(handles.figure1,'strctMouseOp',strctMouseOp);
%fprintf(' %.1f %.1f \n',strctMouseOp.m_pt2fPos(1),strctMouseOp.m_pt2fPos(2));

bMouseDown = getappdata(handles.figure1,'bMouseDown');
if bMouseDown
    switch strMouseMode
        case 'TranslateVolume'
            fnTranslateVolume(handles);
        case 'RotateVolume'
            fnRotateVolume(handles);
        case 'ZoomVolume'
            fnSetNewZoomLevel(handles);
        case 'PanVolume'
            fnSetNewPanLevel(handles);
        case 'SetRotationPivot'
            fnSetRotationPivot(handles);
    end
end
return;


function fnRotateVolume(handles)
strctMouseMove = getappdata(handles.figure1,'strctMouseMove');
strctMouseDown = getappdata(handles.figure1,'strctMouseDown');
strctMouseMovePrev = getappdata(handles.figure1,'strctMouseOpMovePrev');

if isempty(strctMouseDown.m_hAxes) || isempty(strctMouseMove.m_hAxes) || ...
    (~isempty(strctMouseDown.m_hAxes) && ~isempty(strctMouseMove.m_hAxes) && strctMouseDown.m_hAxes ~= strctMouseMove.m_hAxes )
    return;
end;
strctAnatVol = getappdata(handles.figure1,'strctAnatVol');
strctRotationPoints = getappdata(handles.figure1,'strctRotationPoints');
fScale = 0.01;
afDiff = fScale*(strctMouseMovePrev.m_pt2fPos - strctMouseMove.m_pt2fPos);

if max(abs(afDiff)) > 10
    return;
end;

fRotAngleRad = afDiff(1);
switch strctMouseDown.m_hAxes
    case handles.hHorizAxes
        afRotationVector = strctAnatVol.m_strctCrossSectionHoriz.m_a2fM(1:3,3);
        pt3fRotationPoint = strctRotationPoints.m_pt3fHorizontalRotationPoint';
    case handles.hCoronalAxes
        afRotationVector = strctAnatVol.m_strctCrossSectionCoronal.m_a2fM(1:3,3);
            pt3fRotationPoint = strctRotationPoints.m_pt3fCoronalRotationPoint';
    case handles.hSaggitalAxes
        afRotationVector = strctAnatVol.m_strctCrossSectionSaggital.m_a2fM(1:3,3);
            pt3fRotationPoint = strctRotationPoints.m_pt3fSaggitalRotationPoint';
end

a2fNegTrans = [1 0 0 -pt3fRotationPoint(1);
    0 1 0 -pt3fRotationPoint(2);
    0 0 1 -pt3fRotationPoint(3);
    0 0 0  1];

a2fPosTrans = [1 0 0 pt3fRotationPoint(1);
    0 1 0 pt3fRotationPoint(2);
    0 0 1 pt3fRotationPoint(3);
    0 0 0  1];

R = fnRotateVectorAboutAxis(afRotationVector, fRotAngleRad);
a2fRot = zeros(4,4);
a2fRot(1:3,1:3) = R;
a2fRot(4,4) = 1;

strctAnatVol.m_a2fReg = a2fPosTrans*a2fRot*a2fNegTrans*strctAnatVol.m_a2fReg ;
setappdata(handles.figure1,'strctAnatVol',strctAnatVol);
fnInvalidate(handles);

return;


function fnSetNewZoomLevel(handles)
% Do the diff between down and move ?
strctMouseMove = getappdata(handles.figure1,'strctMouseMove');
strctMouseDown = getappdata(handles.figure1,'strctMouseDown');
strctMouseMovePrev = getappdata(handles.figure1,'strctMouseOpMovePrev');

if isempty(strctMouseDown.m_hAxes) || isempty(strctMouseMove.m_hAxes) || ...
    (~isempty(strctMouseDown.m_hAxes) && ~isempty(strctMouseMove.m_hAxes) && strctMouseDown.m_hAxes ~= strctMouseMove.m_hAxes )
    return;
end;
strctAnatVol = getappdata(handles.figure1,'strctAnatVol');
fScale = 1;
afDiff = fScale*(strctMouseMovePrev.m_pt2fPos - strctMouseMove.m_pt2fPos);
fDiff = -afDiff(2);
if abs(fDiff) > 10
    return;
end;

    switch strctMouseDown.m_hAxes
        
        case  handles.hHorizAxes
            
            strctAnatVol.m_strctCrossSectionHoriz.m_fHalfWidthMM =max(1,strctAnatVol.m_strctCrossSectionHoriz.m_fHalfWidthMM + fDiff);
            strctAnatVol.m_strctCrossSectionHoriz.m_fHalfHeightMM =max(1,strctAnatVol.m_strctCrossSectionHoriz.m_fHalfHeightMM + fDiff);
        case handles.hCoronalAxes
            strctAnatVol.m_strctCrossSectionCoronal.m_fHalfWidthMM =max(1,strctAnatVol.m_strctCrossSectionCoronal.m_fHalfWidthMM + fDiff);
            strctAnatVol.m_strctCrossSectionCoronal.m_fHalfHeightMM =max(1,strctAnatVol.m_strctCrossSectionCoronal.m_fHalfHeightMM + fDiff);
        case  handles.hSaggitalAxes
            strctAnatVol.m_strctCrossSectionSaggital.m_fHalfWidthMM =max(1,strctAnatVol.m_strctCrossSectionSaggital.m_fHalfWidthMM + fDiff);
            strctAnatVol.m_strctCrossSectionSaggital.m_fHalfHeightMM =max(1,strctAnatVol.m_strctCrossSectionSaggital.m_fHalfHeightMM + fDiff);
    end;
setappdata(handles.figure1,'strctAnatVol',strctAnatVol);

fnInvalidate(handles);
return;




function fnSetNewPanLevel(handles)
% Do the diff between down and move ?
strctMouseMove = getappdata(handles.figure1,'strctMouseMove');
strctMouseDown = getappdata(handles.figure1,'strctMouseDown');
strctMouseMovePrev = getappdata(handles.figure1,'strctMouseOpMovePrev');

if isempty(strctMouseDown.m_hAxes) || isempty(strctMouseMove.m_hAxes) || ...
    (~isempty(strctMouseDown.m_hAxes) && ~isempty(strctMouseMove.m_hAxes) && strctMouseDown.m_hAxes ~= strctMouseMove.m_hAxes )
    return;
end;
strctAnatVol = getappdata(handles.figure1,'strctAnatVol');
fScale = 1;
afDiff = -fScale*(strctMouseMovePrev.m_pt2fPos - strctMouseMove.m_pt2fPos);
if max(abs(afDiff)) > 30
    return;
end;

    switch strctMouseDown.m_hAxes
        
        case  handles.hHorizAxes
        pt3fCurrPos = strctAnatVol.m_strctCrossSectionHoriz.m_a2fM(1:3,4);
        pt3fNewPos = pt3fCurrPos + ...
        -afDiff(1) * strctAnatVol.m_strctCrossSectionHoriz.m_a2fM(1:3,1) + ...
        -afDiff(2) * strctAnatVol.m_strctCrossSectionHoriz.m_a2fM(1:3,2);
        strctAnatVol.m_strctCrossSectionHoriz.m_a2fM(1:3,4) = pt3fNewPos;
            
        case handles.hCoronalAxes
        pt3fCurrPos = strctAnatVol.m_strctCrossSectionCoronal.m_a2fM(1:3,4);
        pt3fNewPos = pt3fCurrPos + ...
        -afDiff(1) * strctAnatVol.m_strctCrossSectionCoronal.m_a2fM(1:3,1) + ...
        -afDiff(2) * strctAnatVol.m_strctCrossSectionCoronal.m_a2fM(1:3,2);
        strctAnatVol.m_strctCrossSectionCoronal.m_a2fM(1:3,4) = pt3fNewPos;
        case  handles.hSaggitalAxes
     pt3fCurrPos = strctAnatVol.m_strctCrossSectionSaggital.m_a2fM(1:3,4);
        pt3fNewPos = pt3fCurrPos + ...
        -afDiff(1) * strctAnatVol.m_strctCrossSectionSaggital.m_a2fM(1:3,1) + ...
        -afDiff(2) * strctAnatVol.m_strctCrossSectionSaggital.m_a2fM(1:3,2);
        strctAnatVol.m_strctCrossSectionSaggital.m_a2fM(1:3,4) = pt3fNewPos;
    end;
setappdata(handles.figure1,'strctAnatVol',strctAnatVol);

fnInvalidate(handles);
return;

function fnSetRotationPivot(handles)
% Do the diff between down and move ?
strctMouseDown= getappdata(handles.figure1,'strctMouseDown');
strctMouseMove = getappdata(handles.figure1,'strctMouseMove');
strctRotationPoints = getappdata(handles.figure1,'strctRotationPoints');

if isempty(strctMouseDown.m_hAxes) || isempty(strctMouseMove.m_hAxes) || ...
    (~isempty(strctMouseDown.m_hAxes) && ~isempty(strctMouseMove.m_hAxes) && strctMouseDown.m_hAxes ~= strctMouseMove.m_hAxes )
    return;
end;
strctAnatVol = getappdata(handles.figure1,'strctAnatVol');

switch strctMouseDown.m_hAxes
    case handles.hHorizAxes
        strctRotationPoints.m_pt3fHorizontalRotationPoint= fnCrossSection_Image_To_MM_3D(strctAnatVol.m_strctCrossSectionHoriz, strctMouseMove.m_pt2fPos);
    case handles.hCoronalAxes
        strctRotationPoints.m_pt3fCoronalRotationPoint= fnCrossSection_Image_To_MM_3D(strctAnatVol.m_strctCrossSectionCoronal, strctMouseMove.m_pt2fPos);
    case handles.hSaggitalAxes
        strctRotationPoints.m_pt3fSaggitalRotationPoint= fnCrossSection_Image_To_MM_3D(strctAnatVol.m_strctCrossSectionSaggital, strctMouseMove.m_pt2fPos);
end
setappdata(handles.figure1,'strctRotationPoints',strctRotationPoints);
fnInvalidate(handles);
return;


function fnTranslateVolume(handles)
% Do the diff between down and move ?
strctMouseMove = getappdata(handles.figure1,'strctMouseMove');
strctMouseDown = getappdata(handles.figure1,'strctMouseDown');
strctMouseMovePrev = getappdata(handles.figure1,'strctMouseOpMovePrev');

if isempty(strctMouseDown.m_hAxes) || isempty(strctMouseMove.m_hAxes) || ...
    (~isempty(strctMouseDown.m_hAxes) && ~isempty(strctMouseMove.m_hAxes) && strctMouseDown.m_hAxes ~= strctMouseMove.m_hAxes )
    return;
end;
strctAnatVol = getappdata(handles.figure1,'strctAnatVol');
fScale = 0.1;
afDiff = fScale*(strctMouseMovePrev.m_pt2fPos - strctMouseMove.m_pt2fPos);
if max(abs(afDiff)) > 30
    return;
end;
a2fTransMatrix = eye(4);
switch strctMouseDown.m_hAxes
    case handles.hHorizAxes
        afTransAddition = strctAnatVol.m_strctCrossSectionHoriz.m_a2fM(1:3,1) * -afDiff(1) + ...
                                        strctAnatVol.m_strctCrossSectionHoriz.m_a2fM(1:3,2) * -afDiff(2);
        a2fTransMatrix = [eye(3), afTransAddition;0,0,0,1];
    case handles.hCoronalAxes
        afTransAddition = strctAnatVol.m_strctCrossSectionCoronal.m_a2fM(1:3,1) * -afDiff(1) + ...
                                        strctAnatVol.m_strctCrossSectionCoronal.m_a2fM(1:3,2) * -afDiff(2);
        a2fTransMatrix = [eye(3), afTransAddition;0,0,0,1];
        
    case handles.hSaggitalAxes
        afTransAddition = strctAnatVol.m_strctCrossSectionSaggital.m_a2fM(1:3,1) * -afDiff(1) + ...
                                        strctAnatVol.m_strctCrossSectionSaggital.m_a2fM(1:3,2) * -afDiff(2);
        a2fTransMatrix = [eye(3), afTransAddition;0,0,0,1];
        
end

strctAnatVol.m_a2fReg = a2fTransMatrix*strctAnatVol.m_a2fReg ;
setappdata(handles.figure1,'strctAnatVol',strctAnatVol);
fnInvalidate(handles);
return;


function pt2fMouseDownPosition = fnGetMouseCoordinate(hAxes)
pt2fMouseDownPosition = get(hAxes,'CurrentPoint');
if size(pt2fMouseDownPosition,2) ~= 3
    pt2fMouseDownPosition = [-1 -1];
else
    pt2fMouseDownPosition = [pt2fMouseDownPosition(1,1), pt2fMouseDownPosition(1,2)];
end;
return;


function hAxes = fnGetActiveAxes(handles,MousePos)
ahAxes = [handles.hCoronalAxes,handles.hHorizAxes,handles.hSaggitalAxes];
hAxes = [];
for k=1:length(ahAxes)
    set(ahAxes(k),'units','characters');
        aiAxesRect = get(ahAxes(k),'position');
        set(ahAxes(k),'units','normalized');
        
bInside =  (MousePos(1) > aiAxesRect(1) && ...
    MousePos(1) < aiAxesRect(1)+aiAxesRect(3) && ...
    MousePos(2) > aiAxesRect(2) &&  ...
    MousePos(2) < aiAxesRect(2)+aiAxesRect(4));
    if bInside
        hAxes = ahAxes(k);
        return;
    end;
end;

return;


function fnMouseDown(obj,eventdata)
return;

function fnMouseUp(obj,eventdata)
return;

function fnFirstInvalidate(handles)
strctAnatVol = getappdata(handles.figure1,'strctAnatVol');
% XY = Horiz
% YZ = Saggital ?
% XZ = Coronal.



% XY crosshairs:
[pt2fXY_YZ_1, pt2fXY_YZ_2] = fnCrossSectionIntersection(strctAnatVol.m_strctCrossSectionHoriz, strctAnatVol.m_strctCrossSectionSaggital);
[pt2fXY_XZ_1, pt2fXY_XZ_2] = fnCrossSectionIntersection(strctAnatVol.m_strctCrossSectionHoriz, strctAnatVol.m_strctCrossSectionCoronal);
% XZ crosshairs:
[pt2fXZ_YZ_1, pt2fXZ_YZ_2] = fnCrossSectionIntersection(strctAnatVol.m_strctCrossSectionCoronal, strctAnatVol.m_strctCrossSectionSaggital);
[ pt2fXZ_XY_1, pt2fXZ_XY_2] = fnCrossSectionIntersection(strctAnatVol.m_strctCrossSectionCoronal, strctAnatVol.m_strctCrossSectionHoriz);
% YZ crosshairs:
[ pt2fYZ_XY_1, pt2fYZ_XY_2] = fnCrossSectionIntersection(strctAnatVol.m_strctCrossSectionSaggital, strctAnatVol.m_strctCrossSectionHoriz);
[ pt2fYZ_XZ_1, pt2fYZ_XZ_2] = fnCrossSectionIntersection(strctAnatVol.m_strctCrossSectionSaggital,strctAnatVol.m_strctCrossSectionCoronal);

hMenu = uicontextmenu;
uimenu(hMenu, 'Label', 'Translate', 'Callback', {@fnCallback,'SetTranslateMode',handles});
uimenu(hMenu, 'Label', 'Rotate', 'Callback', {@fnCallback,'SetRotateMode',handles});
uimenu(hMenu, 'Label', 'Set Rotation Pivot', 'Callback', {@fnCallback,'SetRotatePivot',handles});
uimenu(hMenu, 'Label', 'Zoom', 'Callback', {@fnCallback,'SetZoomMode',handles});
uimenu(hMenu, 'Label', 'Pan', 'Callback', {@fnCallback,'SetPanMode',handles});

aiImageRes = [256,256,3];
strctXY.m_hImage = image([],[],zeros(aiImageRes),'parent',handles.hHorizAxes, 'UIContextMenu', hMenu);
strctYZ.m_hImage = image([],[],zeros(aiImageRes),'parent',handles.hSaggitalAxes, 'UIContextMenu', hMenu);
strctXZ.m_hImage = image([],[],zeros(aiImageRes),'parent',handles.hCoronalAxes, 'UIContextMenu', hMenu);




set(handles.hHorizAxes,'Visible','off');
hold(handles.hHorizAxes,'on');
set(handles.hSaggitalAxes,'Visible','off');
hold(handles.hSaggitalAxes,'on');

set(handles.hCoronalAxes,'Visible','off');
hold(handles.hCoronalAxes,'on');

strctXY.m_hLineYZ = plot(handles.hHorizAxes, [pt2fXY_YZ_1(1),pt2fXY_YZ_2(1)],[pt2fXY_YZ_1(2),pt2fXY_YZ_2(2)],'r');
strctXY.m_hLineXZ = plot(handles.hHorizAxes, [pt2fXY_XZ_1(1),pt2fXY_XZ_2(1)],[pt2fXY_XZ_1(2),pt2fXY_XZ_2(2)],'g');
strctXZ.m_hLineYZ = plot(handles.hCoronalAxes, [pt2fXZ_YZ_1(1),pt2fXZ_YZ_2(1)],[pt2fXZ_YZ_1(2),pt2fXZ_YZ_2(2)],'r');
strctXZ.m_hLineXY = plot(handles.hCoronalAxes, [pt2fXZ_XY_1(1),pt2fXZ_XY_2(1)],[pt2fXZ_XY_1(2),pt2fXZ_XY_2(2)],'b');
strctYZ.m_hLineXY = plot(handles.hSaggitalAxes, [pt2fYZ_XY_1(1),pt2fYZ_XY_2(1)],[pt2fYZ_XY_1(2),pt2fYZ_XY_2(2)],'b');
strctYZ.m_hLineXZ = plot(handles.hSaggitalAxes, [pt2fYZ_XZ_1(1),pt2fYZ_XZ_2(1)],[pt2fYZ_XZ_1(2),pt2fYZ_XZ_2(2)],'g');
strctXY.m_hRotationPoint = plot(handles.hHorizAxes, aiImageRes(1)/2,aiImageRes(2)/2,'c.','MarkerSize',21);
strctYZ.m_hRotationPoint = plot(handles.hSaggitalAxes, aiImageRes(1)/2,aiImageRes(2)/2,'c.','MarkerSize',21);
strctXZ.m_hRotationPoint = plot(handles.hCoronalAxes, aiImageRes(1)/2,aiImageRes(2)/2,'c.','MarkerSize',21);


setappdata(handles.figure1,'strctYZ',strctYZ);
setappdata(handles.figure1,'strctXZ',strctXZ);
setappdata(handles.figure1,'strctXY',strctXY);
fnInvalidate(handles);
return;


function fnInvalidate(handles)
global g_strctModule
strctRotationPoints = getappdata(handles.figure1,'strctRotationPoints');
strctAnatVol = getappdata(handles.figure1,'strctAnatVol');
strctYZ=getappdata(handles.figure1,'strctYZ');
strctXZ=getappdata(handles.figure1,'strctXZ');
strctXY=getappdata(handles.figure1,'strctXY');

a2fXYZ_To_CRS = inv(strctAnatVol.m_a2fM) * inv(strctAnatVol.m_a2fReg); %#ok
[a2fCrossSectionXY, apt3fPlanePointsXY] = fnResampleCrossSection(strctAnatVol.m_a3fVol, a2fXYZ_To_CRS, strctAnatVol.m_strctCrossSectionHoriz); %#ok
[a2fCrossSectionYZ, apt3fPlanePointsYZ] = fnResampleCrossSection(strctAnatVol.m_a3fVol, a2fXYZ_To_CRS, strctAnatVol.m_strctCrossSectionSaggital); %#ok
[a2fCrossSectionXZ, apt3fPlanePointsXZ] = fnResampleCrossSection(strctAnatVol.m_a3fVol, a2fXYZ_To_CRS, strctAnatVol.m_strctCrossSectionCoronal); %#ok

a2fCrossSectionXY_Trans = fnContrastTransform(a2fCrossSectionXY, strctAnatVol.m_strctContrastTransform);
a2fCrossSectionYZ_Trans = fnContrastTransform(a2fCrossSectionYZ, strctAnatVol.m_strctContrastTransform);
a2fCrossSectionXZ_Trans = fnContrastTransform(a2fCrossSectionXZ, strctAnatVol.m_strctContrastTransform);
        a3fCrossSectionXY = fnDup3(a2fCrossSectionXY_Trans);
        a3fCrossSectionYZ = fnDup3(a2fCrossSectionYZ_Trans);
        a3fCrossSectionXZ = fnDup3(a2fCrossSectionXZ_Trans);

        
set(strctXY.m_hImage,'cdata',a3fCrossSectionXY);
set(strctYZ.m_hImage,'cdata',a3fCrossSectionYZ);
set(strctXZ.m_hImage,'cdata',a3fCrossSectionXZ);


  % XY crosshairs:
[pt2fXY_YZ_1, pt2fXY_YZ_2] = fnCrossSectionIntersection(strctAnatVol.m_strctCrossSectionHoriz, strctAnatVol.m_strctCrossSectionSaggital);
[pt2fXY_XZ_1, pt2fXY_XZ_2] = fnCrossSectionIntersection(strctAnatVol.m_strctCrossSectionHoriz, strctAnatVol.m_strctCrossSectionCoronal);
% XZ crosshairs:
[pt2fXZ_YZ_1, pt2fXZ_YZ_2] = fnCrossSectionIntersection(strctAnatVol.m_strctCrossSectionCoronal, strctAnatVol.m_strctCrossSectionSaggital);
[ pt2fXZ_XY_1, pt2fXZ_XY_2] = fnCrossSectionIntersection(strctAnatVol.m_strctCrossSectionCoronal, strctAnatVol.m_strctCrossSectionHoriz);
% YZ crosshairs:
[ pt2fYZ_XY_1, pt2fYZ_XY_2] = fnCrossSectionIntersection(strctAnatVol.m_strctCrossSectionSaggital, strctAnatVol.m_strctCrossSectionHoriz);
[ pt2fYZ_XZ_1, pt2fYZ_XZ_2] = fnCrossSectionIntersection(strctAnatVol.m_strctCrossSectionSaggital,strctAnatVol.m_strctCrossSectionCoronal);
    
    set(strctXY.m_hLineYZ,'Xdata',[pt2fXY_YZ_1(1),pt2fXY_YZ_2(1)],'YData',[pt2fXY_YZ_1(2),pt2fXY_YZ_2(2)]);
    set(strctXY.m_hLineXZ,'Xdata',[pt2fXY_XZ_1(1),pt2fXY_XZ_2(1)],'YData',[pt2fXY_XZ_1(2),pt2fXY_XZ_2(2)]);
    set(strctXZ.m_hLineYZ,'Xdata',[pt2fXZ_YZ_1(1),pt2fXZ_YZ_2(1)],'YData',[pt2fXZ_YZ_1(2),pt2fXZ_YZ_2(2)]);
    set(strctXZ.m_hLineXY,'Xdata',[pt2fXZ_XY_1(1),pt2fXZ_XY_2(1)],'YData',[pt2fXZ_XY_1(2),pt2fXZ_XY_2(2)]);
    set(strctYZ.m_hLineXY,'Xdata',[pt2fYZ_XY_1(1),pt2fYZ_XY_2(1)],'YData',[pt2fYZ_XY_1(2),pt2fYZ_XY_2(2)]);
     set(strctYZ.m_hLineXZ,'Xdata',[pt2fYZ_XZ_1(1),pt2fYZ_XZ_2(1)],'YData',[pt2fYZ_XZ_1(2),pt2fYZ_XZ_2(2)]);

     
 [~, pt2fImageMM] = fnProjectPointOnCrossSection(strctAnatVol.m_strctCrossSectionHoriz, strctRotationPoints.m_pt3fHorizontalRotationPoint);     
pt2fPt= fnCrossSection_MM_To_Image(strctAnatVol.m_strctCrossSectionHoriz, pt2fImageMM');
set(strctXY.m_hRotationPoint,'xdata',pt2fPt(1),'ydata',pt2fPt(2));

[~, pt2fImageMM] = fnProjectPointOnCrossSection(strctAnatVol.m_strctCrossSectionSaggital, strctRotationPoints.m_pt3fSaggitalRotationPoint);     
pt2fPt= fnCrossSection_MM_To_Image(strctAnatVol.m_strctCrossSectionSaggital, pt2fImageMM');
set(strctYZ.m_hRotationPoint,'xdata',pt2fPt(1),'ydata',pt2fPt(2));

[~, pt2fImageMM] = fnProjectPointOnCrossSection(strctAnatVol.m_strctCrossSectionCoronal, strctRotationPoints.m_pt3fCoronalRotationPoint);     
pt2fPt= fnCrossSection_MM_To_Image(strctAnatVol.m_strctCrossSectionCoronal, pt2fImageMM');
set(strctXZ.m_hRotationPoint,'xdata',pt2fPt(1),'ydata',pt2fPt(2));

     
bDrawAtlas = get(handles.ToggleAtlas,'value');
if bDrawAtlas

            ahHandles=getappdata(handles.figure1,'ahHandles');
            try
            delete(ahHandles);
            catch
            end
            
    aiVisibleRegions = find(cat(1,g_strctModule.m_strctAtlas.m_astrctMesh.visible));

ahHandles = [];
for iRegionIter=1:length(aiVisibleRegions)
    
    iRegion = aiVisibleRegions(iRegionIter);
    
    if ~isempty(g_strctModule.m_strctAtlas.m_astrctMesh(iRegion).vertices)
        % Apply the transformation
        P = [g_strctModule.m_strctAtlas.m_astrctMesh(iRegion).vertices'; ...
            ones(1,size(g_strctModule.m_strctAtlas.m_astrctMesh(iRegion).vertices,1))];
        Pt = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fAtlasReg * P;
        strctMeshRegion.m_a2fVertices = Pt(1:3,:);
        strctMeshRegion.m_a2iFaces = g_strctModule.m_strctAtlas.m_astrctMesh(iRegion).faces';
        strctMeshRegion.m_afColor = g_strctModule.m_strctAtlas.m_astrctMesh(iRegion).color;
        strctMeshRegion.m_fOpacity = 0.6;
        
        a2fLinesPix = fnMeshCrossSectionIntersection(strctMeshRegion, strctAnatVol.m_strctCrossSectionHoriz );
        if ~isempty(a2fLinesPix)
            ahHandles(end+1) = fnPlotLinesAsSinglePatch(handles.hHorizAxes, a2fLinesPix, ...
                g_strctModule.m_strctAtlas.m_astrctMesh(iRegion).color); %#ok
        end;

        a2fLinesPix = fnMeshCrossSectionIntersection(strctMeshRegion, strctAnatVol.m_strctCrossSectionSaggital );
        if ~isempty(a2fLinesPix)
            ahHandles(end+1) = fnPlotLinesAsSinglePatch(handles.hSaggitalAxes, a2fLinesPix, ...
                g_strctModule.m_strctAtlas.m_astrctMesh(iRegion).color); %#ok
        end;
        
        a2fLinesPix = fnMeshCrossSectionIntersection(strctMeshRegion, strctAnatVol.m_strctCrossSectionCoronal );
        if ~isempty(a2fLinesPix)
            ahHandles(end+1) = fnPlotLinesAsSinglePatch(handles.hCoronalAxes, a2fLinesPix, ...
                g_strctModule.m_strctAtlas.m_astrctMesh(iRegion).color); %#ok
        end;
        
            setappdata(handles.figure1,'ahHandles',ahHandles);
    end
  %    ahHandles = [ahHandles,fnDrawMeshIn3D( strctMeshRegion ,g_strctModule.m_strctPanel.m_strct3D.m_hAxes)];

end

    
end
return;        

% --- Outputs from this function are returned to the command line.
function varargout = EarBarZeroRegGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
if ~isempty(handles)
    varargout{1} = handles.output;
else
    varargout{1} = [];
end


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in hSave.
function hSave_Callback(hObject, eventdata, handles)
handles.output=  {getappdata(handles.figure1,'strctAnatVol'), handles.figure1};
guidata(hObject, handles);
uiresume(handles.figure1);

% --- Executes on button press in hCancel.
function hCancel_Callback(hObject, eventdata, handles)
delete(handles.figure1);

% --- Executes on button press in hExport.
function hExport_Callback(hObject, eventdata, handles)
strctAnatVol = getappdata(handles.figure1,'strctAnatVol');
[strFile, strPath] = uiputfile('*.reg','Select transformation file');
if strFile(1) == 0
    return;
end;
strFilename =fullfile(strPath,strFile);
strVolType = 'round'; % make it compatible with FSL ?!?!??!
afVoxelSpacing = strctAnatVol.m_afVoxelSpacing;
fnWriteRegisteration(strFilename,strctAnatVol.m_a2fReg, 'Unknown', strVolType,afVoxelSpacing);
h=msgbox('Saved');
waitfor(h);
return;


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in ToggleAtlas.
function ToggleAtlas_Callback(hObject, eventdata, handles)
  fnInvalidate(handles);
            


function SagRotatePos_Callback(hObject, eventdata, handles)
strctAnatVol = getappdata(handles.figure1,'strctAnatVol');
strctAnatVol.m_a2fReg = fnRotateVectorAboutAxis4D(strctAnatVol.m_strctCrossSectionSaggital.m_a2fM(1:3,3),pi/2)*strctAnatVol.m_a2fReg;
setappdata(handles.figure1,'strctAnatVol',strctAnatVol);
fnInvalidate(handles)


% --- Executes on button press in SagRotateNeg.
function SagRotateNeg_Callback(hObject, eventdata, handles)
strctAnatVol = getappdata(handles.figure1,'strctAnatVol');
strctAnatVol.m_a2fReg = fnRotateVectorAboutAxis4D(strctAnatVol.m_strctCrossSectionSaggital.m_a2fM(1:3,3),-pi/2)*strctAnatVol.m_a2fReg;
setappdata(handles.figure1,'strctAnatVol',strctAnatVol);
fnInvalidate(handles)

% --- Executes on button press in CoronalRotatePos.
function CoronalRotatePos_Callback(hObject, eventdata, handles)
strctAnatVol = getappdata(handles.figure1,'strctAnatVol');
strctAnatVol.m_a2fReg = fnRotateVectorAboutAxis4D(strctAnatVol.m_strctCrossSectionCoronal.m_a2fM(1:3,3),pi/2)*strctAnatVol.m_a2fReg;
setappdata(handles.figure1,'strctAnatVol',strctAnatVol);
fnInvalidate(handles)



% --- Executes on button press in CoronalRotateNeg.
function CoronalRotateNeg_Callback(hObject, eventdata, handles)
strctAnatVol = getappdata(handles.figure1,'strctAnatVol');
strctAnatVol.m_a2fReg = fnRotateVectorAboutAxis4D(strctAnatVol.m_strctCrossSectionCoronal.m_a2fM(1:3,3),-pi/2)*strctAnatVol.m_a2fReg;
setappdata(handles.figure1,'strctAnatVol',strctAnatVol);
fnInvalidate(handles)





% --- Executes on button press in MirrorHorizX.

% --- Executes on button press in FlipSag.
function FlipSag_Callback(hObject, eventdata, handles)
strctAnatVol = getappdata(handles.figure1,'strctAnatVol');
strctAnatVol.m_a2fReg = fnRotateVectorAboutAxis4D([0 1 0],pi/2)*strctAnatVol.m_a2fReg;
setappdata(handles.figure1,'strctAnatVol',strctAnatVol);
fnInvalidate(handles)


% --- Executes on button press in MirrorSagX.
function MirrorSagX_Callback(hObject, eventdata, handles)
strctAnatVol = getappdata(handles.figure1,'strctAnatVol');
strctAnatVol.m_strctCrossSectionSaggital.m_a2fM(1:3,1) = -strctAnatVol.m_strctCrossSectionSaggital.m_a2fM(1:3,1);
setappdata(handles.figure1,'strctAnatVol',strctAnatVol);
fnInvalidate(handles);


% --- Executes on button press in FlipCoronal.
function FlipCoronal_Callback(hObject, eventdata, handles)
strctAnatVol = getappdata(handles.figure1,'strctAnatVol');
strctAnatVol.m_a2fReg = fnRotateVectorAboutAxis4D([0 0 1],pi/2)*strctAnatVol.m_a2fReg;
setappdata(handles.figure1,'strctAnatVol',strctAnatVol);
fnInvalidate(handles)


% --- Executes on button press in MirrorCoronalX.
function MirrorCoronalX_Callback(hObject, eventdata, handles)
strctAnatVol = getappdata(handles.figure1,'strctAnatVol');
strctAnatVol.m_strctCrossSectionCoronal.m_a2fM(1:3,1) = -strctAnatVol.m_strctCrossSectionCoronal.m_a2fM(1:3,1);
setappdata(handles.figure1,'strctAnatVol',strctAnatVol);
fnInvalidate(handles);
return;

% --- Executes on button press in MirrorHorizY.
function MirrorHorizY_Callback(hObject, eventdata, handles)
strctAnatVol = getappdata(handles.figure1,'strctAnatVol');
strctAnatVol.m_strctCrossSectionHoriz.m_a2fM(1:3,2) = -strctAnatVol.m_strctCrossSectionHoriz.m_a2fM(1:3,2);
setappdata(handles.figure1,'strctAnatVol',strctAnatVol);
fnInvalidate(handles);
return;

function MirrorHorizX_Callback(hObject, eventdata, handles)
strctAnatVol = getappdata(handles.figure1,'strctAnatVol');
strctAnatVol.m_strctCrossSectionHoriz.m_a2fM(1:3,1) = -strctAnatVol.m_strctCrossSectionHoriz.m_a2fM(1:3,1);
setappdata(handles.figure1,'strctAnatVol',strctAnatVol);
fnInvalidate(handles)
return;

% --- Executes on button press in FlipHoriz.
function FlipHoriz_Callback(hObject, eventdata, handles)
strctAnatVol = getappdata(handles.figure1,'strctAnatVol');
strctAnatVol.m_a2fReg = fnRotateVectorAboutAxis4D(strctAnatVol.m_a2fReg(1:3,1),pi/2)*strctAnatVol.m_a2fReg;
setappdata(handles.figure1,'strctAnatVol',strctAnatVol);
fnInvalidate(handles)


% --- Executes on button press in HorizRotatePos.
function HorizRotatePos_Callback(hObject, eventdata, handles)
strctAnatVol = getappdata(handles.figure1,'strctAnatVol');
strctAnatVol.m_a2fReg = fnRotateVectorAboutAxis4D(strctAnatVol.m_strctCrossSectionHoriz.m_a2fM(1:3,3),pi/2)*strctAnatVol.m_a2fReg;
setappdata(handles.figure1,'strctAnatVol',strctAnatVol);
fnInvalidate(handles)

function HorizRotateNeg_Callback(hObject, eventdata, handles)
strctAnatVol = getappdata(handles.figure1,'strctAnatVol');
strctAnatVol.m_a2fReg = fnRotateVectorAboutAxis4D(strctAnatVol.m_strctCrossSectionHoriz.m_a2fM(1:3,3),-pi/2)*strctAnatVol.m_a2fReg;
setappdata(handles.figure1,'strctAnatVol',strctAnatVol);
fnInvalidate(handles)


% --- Executes on button press in MirrorSagY.
function MirrorSagY_Callback(hObject, eventdata, handles)
strctAnatVol = getappdata(handles.figure1,'strctAnatVol');
strctAnatVol.m_strctCrossSectionSaggital.m_a2fM(1:3,2) = -strctAnatVol.m_strctCrossSectionSaggital.m_a2fM(1:3,2);
setappdata(handles.figure1,'strctAnatVol',strctAnatVol);
fnInvalidate(handles);
return;


% --- Executes on button press in MirrorCoronalY.
function MirrorCoronalY_Callback(hObject, eventdata, handles)
strctAnatVol = getappdata(handles.figure1,'strctAnatVol');



strctAnatVol.m_strctCrossSectionCoronal.m_a2fM(1:3,2) = -strctAnatVol.m_strctCrossSectionCoronal.m_a2fM(1:3,2);
setappdata(handles.figure1,'strctAnatVol',strctAnatVol);
fnInvalidate(handles);
return;

