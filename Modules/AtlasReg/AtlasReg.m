function varargout = AtlasReg(varargin)
% ATLASREG MATLAB code for AtlasReg.fig
%      ATLASREG, by itself, creates a new ATLASREG or raises the existing
%      singleton*.
%
%      H = ATLASREG returns the handle to a new ATLASREG or the handle to
%      the existing singleton*.
%
%      ATLASREG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ATLASREG.M with the given input arguments.
%
%      ATLASREG('Property','Value',...) creates a new ATLASREG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before AtlasReg_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to AtlasReg_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help AtlasReg

% Last Modified by GUIDE v2.5 28-May-2012 18:42:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @AtlasReg_OpeningFcn, ...
                   'gui_OutputFcn',  @AtlasReg_OutputFcn, ...
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


% --- Executes just before AtlasReg is made visible.
function AtlasReg_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to AtlasReg (see VARARGIN)

% Choose default command line output for AtlasReg
handles.output = hObject;
strFileName = varargin{1};
strctAnatVol = fnQuickAddVolume(strFileName);
[strFolder,strFile]=fileparts(strctAnatVol.m_strFileName);
if strFolder(end) ~= filesep
    strFolder(end+1) = filesep;
end;

strctAnatVol.m_a2fAtlasReg(1:3,1:3)=2*strctAnatVol.m_a2fAtlasReg(1:3,1:3);


if exist([strFolder,'wm.nii'],'file')
    strctAuxVol=fnQuickAddVolume([strFolder,'wm.nii']);
    set(handles.hShowAuxOverlay,'value',1);
else
    strctAuxVol = [];
end
setappdata(handles.figure1,'strctAuxVol',strctAuxVol);

if exist([strFolder,'control.dat'],'file')
    [A,B,C]=textread([strFolder,'control.dat'],'%d %d %d');
    apt3fControlPoints = [A,B,C];
    setappdata(handles.figure1,'apt3fControlPoints',apt3fControlPoints);
    fnUpdateControlPointList(handles,false);
else
    setappdata(handles.figure1,'apt3fControlPoints',zeros(1,3));

end


strctTmp=load('Saleem_Logothetis_Atlas.mat');
strctAtlas = strctTmp.strctAtlas;
set(handles.hRegionList,'string',strctAtlas.m_acRegions,'min',1,'max',length(strctAtlas.m_acRegions));

setappdata(handles.figure1,'strctAnatVol',strctAnatVol);
setappdata(handles.figure1,'a2fOriginalRegMatrix',strctAnatVol.m_a2fReg);
setappdata(handles.figure1,'strctAtlas',strctTmp.strctAtlas);

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

% UIWAIT makes AtlasReg wait for user response (see UIRESUME)
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
        
    case 'SetScaleMode'
        setappdata(handles.figure1,'strMouseMode','ScaleVolume');
    case 'SetControlPoints'
        setappdata(handles.figure1,'strMouseMode','SetControlPoints');
    case 'SetEraseMode'
        setappdata(handles.figure1,'strMouseMode','EraseVolume');
        
         case 'SetContrastMode'
        setappdata(handles.figure1,'strMouseMode','ContrastMode');
   
    case 'SetPanMode'
        setappdata(handles.figure1,'strMouseMode','PanVolume');
    case 'SetRotatePivot'
        setappdata(handles.figure1,'strMouseMode','SetRotationPivot');
end;

return;



function fnMouseWheel(obj,eventdata, handles)
strctAnatVol = getappdata(handles.figure1,'strctAnatVol');
pt2fFigure = round(get(handles.figure1,'CurrentPoint'));

fDiff =  eventdata.VerticalScrollCount * 0.5;
 hAxes = fnGetActiveAxes(handles, pt2fFigure);
 if isempty(hAxes)
     return;
 end;
a2fTransMatrix = eye(4);
switch hAxes
    case handles.hHorizAxes
        afTransAddition = strctAnatVol.m_strctCrossSectionHoriz.m_a2fM(1:3,3) * fDiff;
        a2fTransMatrix = [eye(3), afTransAddition;0,0,0,1];
        strctAnatVol.m_strctCrossSectionHoriz.m_a2fM = a2fTransMatrix*strctAnatVol.m_strctCrossSectionHoriz.m_a2fM;
    case handles.hCoronalAxes
        afTransAddition = strctAnatVol.m_strctCrossSectionCoronal.m_a2fM(1:3,3) * fDiff;
        a2fTransMatrix = [eye(3), afTransAddition;0,0,0,1];
        strctAnatVol.m_strctCrossSectionCoronal.m_a2fM = a2fTransMatrix*strctAnatVol.m_strctCrossSectionCoronal.m_a2fM;
    case handles.hSaggitalAxes
        afTransAddition = strctAnatVol.m_strctCrossSectionSaggital.m_a2fM(1:3,3) * fDiff;
        a2fTransMatrix = [eye(3), afTransAddition;0,0,0,1];
        strctAnatVol.m_strctCrossSectionSaggital.m_a2fM = a2fTransMatrix*strctAnatVol.m_strctCrossSectionSaggital.m_a2fM;
end
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
strMouseMode = getappdata(handles.figure1,'strMouseMode');
if strcmp(strctMouseOp.m_strButton,'Left')
switch strMouseMode
    case 'SetControlPoints'
       fnAddControlPoint(handles,strctMouseOp); 
end
end
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
        case 'ScaleVolume'
            fnScaleVolume(handles);
        case 'SetRotationPivot'
            fnSetRotationPivot(handles);
        case 'ContrastMode'
            fnContrast(handles);
        case 'EraseVolume'
            fnEraseVolume();
    end
end
return;



function fnContrast(handles)
strctMouseMove = getappdata(handles.figure1,'strctMouseMove');
strctMouseDown = getappdata(handles.figure1,'strctMouseDown');
strctMouseMovePrev = getappdata(handles.figure1,'strctMouseOpMovePrev');

if isempty(strctMouseDown.m_hAxes) || isempty(strctMouseMove.m_hAxes) || ...
    (~isempty(strctMouseDown.m_hAxes) && ~isempty(strctMouseMove.m_hAxes) && strctMouseDown.m_hAxes ~= strctMouseMove.m_hAxes )
    return;
end;
strctAnatVol = getappdata(handles.figure1,'strctAnatVol');
fScale = 3;
afDelta = fScale*(strctMouseMovePrev.m_pt2fPos - strctMouseMove.m_pt2fPos);

strctLinearHistogramStretch = strctAnatVol.m_strctContrastTransform;

fMaxWidth = strctLinearHistogramStretch.m_fMax/2;%max(1,2*strctLinearHistogramStretch.m_fWidth);
strctLinearHistogramStretch.m_fWidth = min(fMaxWidth,max(0,...
    strctLinearHistogramStretch.m_fWidth + afDelta(2)*fMaxWidth/400));
strctLinearHistogramStretch.m_fCenter = min(strctLinearHistogramStretch.m_fMax,...
    max(strctLinearHistogramStretch.m_fMin,...
    strctLinearHistogramStretch.m_fCenter + afDelta(1)*fMaxWidth/400));


strctAnatVol.m_strctContrastTransform = strctLinearHistogramStretch;
setappdata(handles.figure1,'strctAnatVol',strctAnatVol);
fnInvalidate(handles);
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

strctAnatVol.m_a2fAtlasReg = a2fPosTrans*a2fRot*a2fNegTrans*strctAnatVol.m_a2fAtlasReg  ;
setappdata(handles.figure1,'strctAnatVol',strctAnatVol);
fnInvalidate(handles);

return;

function fnScaleVolume(handles)
strctMouseMove = getappdata(handles.figure1,'strctMouseMove');
strctMouseDown = getappdata(handles.figure1,'strctMouseDown');
strctMouseMovePrev = getappdata(handles.figure1,'strctMouseOpMovePrev');

if isempty(strctMouseDown.m_hAxes) || isempty(strctMouseMove.m_hAxes) || ...
    (~isempty(strctMouseDown.m_hAxes) && ~isempty(strctMouseMove.m_hAxes) && strctMouseDown.m_hAxes ~= strctMouseMove.m_hAxes )
    return;
end;
strctAnatVol = getappdata(handles.figure1,'strctAnatVol');
fScale = 0.01;
afDiff = -fScale*(strctMouseMovePrev.m_pt2fPos - strctMouseMove.m_pt2fPos);

if max(abs(afDiff)) > 10
    return;
end;

fScale1 = 1+ afDiff(1);
fScale2 =1+afDiff(2);

switch strctMouseDown.m_hAxes
    case  handles.hCoronalAxes
          a2fScaleMatrix = [fScale1 0 0 0;
                                         0       1 0 0;
                                    0         0      fScale2 0;
                          0         0       0 1];
        
    case handles.hHorizAxes
       
        a2fScaleMatrix = [fScale1 0 0 0;
                          0       fScale2 0 0;
                          0         0      1 0;
                          0         0       0 1];
        
    case  handles.hSaggitalAxes    
         a2fScaleMatrix = [1 0 0 0;
                          0       fScale1 0 0;
                          0         0      fScale2 0;
                          0         0       0 1];
    
end
strctAnatVol.m_a2fAtlasReg = a2fScaleMatrix * strctAnatVol.m_a2fAtlasReg;
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
fScale = 0.3;
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

strctAnatVol.m_a2fAtlasReg = a2fTransMatrix*strctAnatVol.m_a2fAtlasReg;
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

% 
% function fnMouseDown(obj,eventdata)
% return;
% 
% function fnMouseUp(obj,eventdata)
% return;

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
uimenu(hMenu, 'Label', 'Scale', 'Callback', {@fnCallback,'SetScaleMode',handles});


uimenu(hMenu, 'Label', 'Contrast', 'Callback', {@fnCallback,'SetContrastMode',handles});
uimenu(hMenu, 'Label', 'Place WM Control Points', 'Callback', {@fnCallback,'SetControlPoints',handles});

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
strctRotationPoints = getappdata(handles.figure1,'strctRotationPoints');
strctAnatVol = getappdata(handles.figure1,'strctAnatVol');
strctAuxVol = getappdata(handles.figure1,'strctAuxVol');
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

if ~isempty(strctAuxVol) && get(handles.hShowAuxOverlay,'value') > 0
    a2fXYZ_To_CRS_Aux = inv(strctAuxVol.m_a2fM) * inv(strctAuxVol.m_a2fReg); %#ok

    [a2fCrossSectionXY_Aux] = fnResampleCrossSection(strctAuxVol.m_a3fVol, a2fXYZ_To_CRS_Aux, strctAnatVol.m_strctCrossSectionHoriz); 
    [a2fCrossSectionYZ_Aux] = fnResampleCrossSection(strctAuxVol.m_a3fVol, a2fXYZ_To_CRS_Aux, strctAnatVol.m_strctCrossSectionSaggital); %#ok
    [a2fCrossSectionXZ_Aux] = fnResampleCrossSection(strctAuxVol.m_a3fVol, a2fXYZ_To_CRS_Aux, strctAnatVol.m_strctCrossSectionCoronal); %#ok
    
    a3fCrossSectionXY(:,:,2)=(1 - 0.4 * single(a2fCrossSectionXY_Aux>90)) .* a3fCrossSectionXY(:,:,2);
    a3fCrossSectionXY(:,:,3)=(1 - 0.4 * single(a2fCrossSectionXY_Aux>90)) .* a3fCrossSectionXY(:,:,3);

    a3fCrossSectionYZ(:,:,2)=(1 - 0.4 * single(a2fCrossSectionYZ_Aux>90)) .* a3fCrossSectionYZ(:,:,2);
    a3fCrossSectionYZ(:,:,3)=(1 - 0.4 * single(a2fCrossSectionYZ_Aux>90)) .* a3fCrossSectionYZ(:,:,3);

    a3fCrossSectionXZ(:,:,2)=(1 - 0.4 * single(a2fCrossSectionXZ_Aux>90)) .* a3fCrossSectionXZ(:,:,2);
    a3fCrossSectionXZ(:,:,3)=(1 - 0.4 * single(a2fCrossSectionXZ_Aux>90)) .* a3fCrossSectionXZ(:,:,3);
    
end

        
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

if get(handles.hAtlasOutline,'value') > 0
     fnUpdateAtlasContours(handles);
else
    ahAtlas = getappdata(handles.figure1,'ahAtlas');
    delete(ahAtlas);
    ahAtlas = [];
    setappdata(handles.figure1,'ahAtlas',ahAtlas );
end  
% Draw control points?
ahControlPoints = getappdata(handles.figure1,'ahControlPoints');
delete( ahControlPoints);
ahControlPoints = [];
apt3fControlPoints=getappdata(handles.figure1,'apt3fControlPoints');
a2fCRS_To_XYZ = strctAnatVol.m_a2fReg*strctAnatVol.m_a2fM;
apt3fControlPointsMM = a2fCRS_To_XYZ*[apt3fControlPoints'; ones(1,size(apt3fControlPoints,1))];
iCounter = 1;
for k=1:size(apt3fControlPoints,1)
    [pt3fNearestPointOnPlane, pt2fImageMM,Dist] = fnProjectPointOnCrossSection(strctAnatVol.m_strctCrossSectionHoriz, apt3fControlPointsMM(1:3,k));
    if abs(Dist) < 0.75
     apt2iPointPix = fnCrossSection_MM_To_Image(strctAnatVol.m_strctCrossSectionHoriz, pt2fImageMM');
     ahControlPoints(iCounter) = plot(handles.hHorizAxes,apt2iPointPix(1),apt2iPointPix(2),'co');
     iCounter=iCounter+1;
    end
end

setappdata(handles.figure1,'ahControlPoints',ahControlPoints);

return;        

% --- Outputs from this function are returned to the command line.
function varargout = AtlasReg_OutputFcn(hObject, eventdata, handles) 
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




function fnUpdateAtlasContours(handles)
ahAtlas = getappdata(handles.figure1,'ahAtlas');
delete(ahAtlas);
strctAnatVol =getappdata(handles.figure1,'strctAnatVol');
strctAtlas = getappdata(handles.figure1,'strctAtlas');

ahAxes = [handles.hHorizAxes, handles.hSaggitalAxes,handles.hCoronalAxes,];
astrctCrossSection = [ strctAnatVol.m_strctCrossSectionHoriz,   strctAnatVol.m_strctCrossSectionSaggital,  strctAnatVol.m_strctCrossSectionCoronal];
aiVisibleRegions =1;%:length(strctAtlas.m_astrctMesh);

ahHandles = [];

for iRegionIter=1:length(aiVisibleRegions)
    
    iRegion = aiVisibleRegions(iRegionIter);
    
    if ~isempty(strctAtlas.m_astrctMesh(iRegion).vertices)
        % Apply the transformation+
        P = [strctAtlas.m_astrctMesh(iRegion).vertices'; ...
            ones(1,size(strctAtlas.m_astrctMesh(iRegion).vertices,1))];
        Pt = strctAnatVol.m_a2fAtlasReg * P;
        
        strctMeshRegion.m_a2fVertices = Pt(1:3,:);
        strctMeshRegion.m_a2iFaces = strctAtlas.m_astrctMesh(iRegion).faces';
        strctMeshRegion.m_afColor = strctAtlas.m_astrctMesh(iRegion).color;
        strctMeshRegion.m_fOpacity = 0.6;
        for iAxesIter=1:3
            a2fLinesPix = fnMeshCrossSectionIntersection(strctMeshRegion, astrctCrossSection(iAxesIter) );
            if ~isempty(a2fLinesPix)
                ahHandles(end+1) = fnPlotLinesAsSinglePatch(ahAxes(iAxesIter), a2fLinesPix, ...
                    strctAtlas.m_astrctMesh(iRegion).color); %#ok
            end;
        end;
    end
end

setappdata(handles.figure1,'ahAtlas',ahHandles);

return;


% --- Executes on button press in hRemoveSkull.
function hRemoveSkull_Callback(hObject, eventdata, handles)
% hObject    handle to hRemoveSkull (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in hAdjust.
function hAdjust_Callback(hObject, eventdata, handles)
% hObject    handle to hAdjust (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes on selection change in hRegionList.
function hRegionList_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function hRegionList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hRegionList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in hAtlasOutline.
function hAtlasOutline_Callback(hObject, eventdata, handles)
 fnInvalidate(handles)

% --- Executes on button press in hShowAuxOverlay.
function hShowAuxOverlay_Callback(hObject, eventdata, handles)
 fnInvalidate(handles)
% --- Executes on button press in hShowAtlasFilled.
function hShowAtlasFilled_Callback(hObject, eventdata, handles)
 fnInvalidate(handles)
% --- Executes on selection change in hControlPointList.
function hControlPointList_Callback(hObject, eventdata, handles)
% hObject    handle to hControlPointList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns hControlPointList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from hControlPointList


% --- Executes during object creation, after setting all properties.
function hControlPointList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hControlPointList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in hSegmentWhiteMatter.
function hSegmentWhiteMatter_Callback(hObject, eventdata, handles)
% Assume input volume is nu.mgz
strctAnatVol = getappdata(handles.figure1,'strctAnatVol');
[strFolder,strFile]=fileparts(strctAnatVol.m_strFileName);
if strFolder(end) ~= filesep
    strFolder(end+1) = filesep;
end;
fnUpdateControlPointList(handles); % write to disk
strNormCmd =['mri_normalize -f ',strFolder,'control.dat ',strctAnatVol.m_strFileName,' ',strFolder,'T1.mgz'];
strMaskCmd = ['mri_mask ',strFolder,'T1.mgz ',strFolder,'brainmask.mgz ',strFolder,'brain.mgz'];
strMaskCmd2 = ['mri_convert ',strFolder,'brain.mgz ',strFolder,'brain.nii  -odt uchar'];
strSegment = ['mri_segment -v -fillv -fillbg -wlo 100 -ghi 105 -n 2 ',strFolder,'brain.nii ',strFolder,'wm.nii'];
system(strNormCmd);
system(strMaskCmd);
system(strMaskCmd2);
system(strSegment);


strctAuxVol=fnQuickAddVolume([strFolder,'wm.nii']);
setappdata(handles.figure1,'strctAuxVol',strctAuxVol);
set(handles.hShowAuxOverlay,'value',1);
fnInvalidate(handles);

return;



function fnAddControlPoint(handles,strctMouseDown)
strctAnatVol = getappdata(handles.figure1,'strctAnatVol');

a2fXYZ_To_CRS = inv(strctAnatVol.m_a2fM) * inv(strctAnatVol.m_a2fReg);  
if isempty(strctMouseDown.m_hAxes)
    return;
end;
switch strctMouseDown.m_hAxes
    case handles.hHorizAxes
        strctCrossSection= strctAnatVol.m_strctCrossSectionHoriz;
    case handles.hCoronalAxes
        strctCrossSection = strctAnatVol.m_strctCrossSectionCoronal;
    case handles.hSaggitalAxes
        strctCrossSection = strctAnatVol.m_strctCrossSectionSaggital;
end

% Transform the clicked point to 3D coordinates
pt2fPosMM = fnCrossSection_Image_To_MM(strctCrossSection, strctMouseDown.m_pt2fPos);
pt3fPosMMOnPlane = [pt2fPosMM,0,1]';
pt3fPosInVol = strctCrossSection.m_a2fM*pt3fPosMMOnPlane;
pt3fPosVoxel = round(a2fXYZ_To_CRS * pt3fPosInVol);

apt3fControlPoints=getappdata(handles.figure1,'apt3fControlPoints');
apt3fControlPoints(end+1,:) = pt3fPosVoxel(1:3)';
setappdata(handles.figure1,'apt3fControlPoints',apt3fControlPoints);
fnUpdateControlPointList(handles);
fnInvalidate(handles);

return;


% --- Executes on button press in hRemoveControlPoints.
function hRemoveControlPoints_Callback(hObject, eventdata, handles)
apt3fControlPoints=getappdata(handles.figure1,'apt3fControlPoints');
aiSelected = get(handles.hControlPointList,'value');
if aiSelected == 0
    return;
end;
apt3fControlPoints(aiSelected,:) = [];
setappdata(handles.figure1,'apt3fControlPoints',apt3fControlPoints);
fnUpdateControlPointList(handles);
fnInvalidate(handles);
return;


function fnUpdateControlPointList(handles,bWriteToDisk)
apt3fControlPoints=getappdata(handles.figure1,'apt3fControlPoints');
iNumPoints = size(apt3fControlPoints,1);
acControlCoord = cell(1,iNumPoints);
for k=1:iNumPoints
    acControlCoord{k} = sprintf('[%d %d %d]',apt3fControlPoints(k,1),apt3fControlPoints(k,2),apt3fControlPoints(k,3));
end
set(handles.hControlPointList,'string',acControlCoord,'min',1,'max',iNumPoints,'value',iNumPoints);
% Write this to disk as well!
if ~exist('bWriteToDisk','var')
    bWriteToDisk = true;
end;
if bWriteToDisk
strctAnatVol = getappdata(handles.figure1,'strctAnatVol');
[strFolder,strFile]=fileparts(strctAnatVol.m_strFileName);
if strFolder(end) ~= filesep
    strFolder(end+1) = filesep;
end;
hFileID=fopen([strFolder,'control.dat'],'w+');
for k=1:iNumPoints
    fprintf(hFileID,'%d %d %d\n',apt3fControlPoints(k,1),apt3fControlPoints(k,2),apt3fControlPoints(k,3));
end
fclose(hFileID);
end
return;





% --- Executes on button press in hRemoveRegions.
function hRemoveRegions_Callback(hObject, eventdata, handles)
strctAnatVol = getappdata(handles.figure1,'strctAnatVol');
strctAuxVol = getappdata(handles.figure1,'strctAuxVol');

strctAtlas =  getappdata(handles.figure1,'strctAtlas');

aiSelected = get(handles.hRegionList,'value');
acSelectedRegions = strctAtlas.m_acRegions(aiSelected);
acSelectedRegions = {'Cerebellum','Brainstem'};

afAtlasDVRange = cat(1,strctAtlas.m_astrctSlices.m_fPositionMM);

fRangeX_MM = abs(strctAtlas.m_afXPixelToMM(end)-strctAtlas.m_afXPixelToMM(1));
fRangeY_MM = abs(strctAtlas.m_afYPixelToMM(end)-strctAtlas.m_afYPixelToMM(1));
iNumXPix = length(strctAtlas.m_afXPixelToMM);
iNumYPix = length(strctAtlas.m_afYPixelToMM);

strctAnatVol.m_a2fAtlasCRS_To_XYZ = [fRangeX_MM/(iNumXPix-1) 0 0 strctAtlas.m_afXPixelToMM(1)-fRangeX_MM/(iNumXPix-1);
                                                                     0 -fRangeY_MM/(iNumYPix-1) 0 strctAtlas.m_afYPixelToMM(1)-fRangeY_MM/(iNumYPix-1);
                                                                     0 0 1 afAtlasDVRange(1)-1;
                                                                     0 0 0 1];
                                                                 
% Now, generate the  the binary volume 


a3bRegionOfInterest = zeros(iNumYPix,iNumXPix, length(afAtlasDVRange),'uint8');

for iSliceIter=1:length(strctAtlas.m_astrctSlices)
    for iRegionIter=1:length(strctAtlas.m_astrctSlices(iSliceIter).m_acRegions)
        if ismember(strctAtlas.m_astrctSlices(iSliceIter).m_acRegions{iRegionIter}.m_strName, acSelectedRegions)
            afXpix =strctAtlas.m_astrctSlices(iSliceIter).m_acRegions{iRegionIter}.m_apt2fCoordinates(:,1);
            afYpix = strctAtlas.m_astrctSlices(iSliceIter).m_acRegions{iRegionIter}.m_apt2fCoordinates(:,2);
             %First, generate the closed polygon.
              a2bI = zeros(iNumYPix,iNumXPix,'uint8')>0;
                BW = roipoly(a2bI, afXpix,afYpix);
             % Convert to mm
             a3bRegionOfInterest(:,:,iSliceIter) = a3bRegionOfInterest(:,:,iSliceIter) | BW; 
          end
    end
end

%%
[a2fXvox,a2fYvox,a2fZvox]=meshgrid(1:strctAuxVol.m_aiVolSize(2),1:strctAuxVol.m_aiVolSize(1),1:strctAuxVol.m_aiVolSize(3));
% now, convert these to mm.
a2fXYZ_To_CRS = inv(strctAuxVol.m_a2fM) * inv(strctAuxVol.m_a2fReg); %#ok
a2fCRS_To_XYZ = strctAuxVol.m_a2fReg*strctAuxVol.m_a2fM;
P=[a2fXvox(:),a2fYvox(:),a2fZvox(:),ones(size(a2fXvox(:)))]';
% Now, transform these back to atlas pixel coordinates.


Tmp=inv(strctAnatVol.m_a2fAtlasCRS_To_XYZ)*inv(strctAnatVol.m_a2fAtlasReg)*a2fCRS_To_XYZ*P;
 abValues = fndllFastInterp3(a3bRegionOfInterest,Tmp(1,:),Tmp(2,:),Tmp(3,:))>0;

 strctAuxVol.m_a3fVol(abValues) = 0;
% Rewrite wm.nii
setappdata(handles.figure1,'strctAuxVol',strctAuxVol);

fnInvalidate(handles);

X=strctAuxVol.m_strctFreeSurfer;
X.vol = strctAuxVol.m_a3fVol;
MRIwrite(X,strctAuxVol.m_strFileName);

return;
