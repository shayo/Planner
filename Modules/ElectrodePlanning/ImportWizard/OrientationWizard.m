function varargout = OrientationWizard(varargin)
% ORIENTATIONWIZARD M-file for OrientationWizard.fig
%      ORIENTATIONWIZARD, by itself, creates a new ORIENTATIONWIZARD or raises the existing
%      singleton*.
%
%      H = ORIENTATIONWIZARD returns the handle to a new ORIENTATIONWIZARD or the handle to
%      the existing singleton*.
%
%      ORIENTATIONWIZARD('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ORIENTATIONWIZARD.M with the given input arguments.
%
%      ORIENTATIONWIZARD('Property','Value',...) creates a new ORIENTATIONWIZARD or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before OrientationWizard_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to OrientationWizard_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help OrientationWizard

% Last Modified by GUIDE v2.5 11-Mar-2011 10:42:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @OrientationWizard_OpeningFcn, ...
                   'gui_OutputFcn',  @OrientationWizard_OutputFcn, ...
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


% --- Executes just before OrientationWizard is made visible.
function OrientationWizard_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to OrientationWizard (see VARARGIN)

% Choose default command line output for OrientationWizard
handles.output = hObject;
strctAnatVol = varargin{1};
setappdata(handles.figure1,'strctAnatVol',strctAnatVol);
aiImageRes = [256,256];
set(handles.hMoveMarkers,'value',1);
set(handles.hEarbarPanel,'Visible','off');
setappdata(handles.figure1,'bEarBarZeroStage',false);

set(handles.hInterPlaneDistanceSlider,'min',1,'max',10,'value',5);

set(handles.hInterauralDistSldier,'Min',0,'Max',50,'value',34);
set(handles.hInterauralDistText,'String','34');

setappdata(handles.figure1,'afZFlip',[1 1 1]);

set(handles.hSliderHoriz,'visible','off');
set(handles.hSliderSaggital,'visible','off');
set(handles.hSliderCoronal,'visible','off');
set(handles.hZeroHorizOffset,'visible','off');
set(handles.hZeroCoronalOffset,'visible','off');
set(handles.hZeroSaggitalOffset,'visible','off');

% Default: 
% Horiz = XY
% Saggital: YZ
% Coronal: XZ

strctCrossSectionHoriz = strctAnatVol.m_strctCrossSectionHoriz;
strctCrossSectionSaggital = strctAnatVol.m_strctCrossSectionSaggital;
strctCrossSectionCoronal = strctAnatVol.m_strctCrossSectionCoronal;


%setappdata(handles.figure1,'strctEB0',strctEB0);
setappdata(handles.figure1,'a2fReg',eye(4));
setappdata(handles.figure1,'strctCrossSectionHoriz',strctCrossSectionHoriz);
setappdata(handles.figure1,'strctCrossSectionSaggital',strctCrossSectionSaggital);
setappdata(handles.figure1,'strctCrossSectionCoronal',strctCrossSectionCoronal);
setappdata(handles.figure1,'strctLinearHistogramStretch',strctAnatVol.m_strctContrastTransform);

fnInvalidate(handles);
set(handles.figure1,'WindowScrollWheelFcn',{@fnMouseWheel,handles});
set(handles.figure1,'WindowButtonMotionFcn',{@fnMouseMove,handles});
set(handles.figure1,'WindowButtonDownFcn',{@fnMouseDown,handles});
set(handles.figure1,'WindowButtonUpFcn',{@fnMouseUp,handles});

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes OrientationWizard wait for user response (see UIRESUME)
 uiwait(handles.figure1);
return;


function fnMouseMove(obj,eventdata,handles)
bMouseDown = getappdata(handles.figure1,'bMouseDown');
strctPrevMouseOp = getappdata(handles.figure1,'strctPrevMouseOp');

if bMouseDown
    
    if (fnInsideImage(handles,handles.hAxesCoronal))
        Tmp = get(handles.hAxesCoronal,'CurrentPoint');
        strctMouseCurrent.m_pt2fPoint = Tmp(1,[1:2]);
         strctMouseCurrent.m_hAxes = handles.hAxesCoronal;
        
    elseif (fnInsideImage(handles,handles.hAxesSaggital))
        Tmp = get(handles.hAxesSaggital,'CurrentPoint');
        strctMouseCurrent.m_pt2fPoint = Tmp(1,[1:2]);

        strctMouseCurrent.m_hAxes = handles.hAxesSaggital;
    elseif (fnInsideImage(handles,handles.hAxesHoriz))
        Tmp = get(handles.hAxesHoriz,'CurrentPoint');
        strctMouseCurrent.m_pt2fPoint = Tmp(1,[1:2]);
        strctMouseCurrent.m_hAxes = handles.hAxesHoriz;
    else
        return;
    end
    
    if isempty(strctPrevMouseOp) || (~isempty(strctPrevMouseOp) && (isfield(strctPrevMouseOp,'m_strOp') && isempty(strctPrevMouseOp.m_strOp)))
        afDelta=  [0,0];
    else
        afDelta=  strctMouseCurrent.m_pt2fPoint - strctPrevMouseOp.m_pt2fPoint;
    end
    if get(handles.hMoveVolume,'value')
        afDelta = -afDelta;
    end;
 
    % Handle mouse move while clicked.
    strctMouseDownOp = getappdata(handles.figure1,'strctMouseDownOp');
    if ~isempty(strctMouseDownOp.m_strOp)
        switch lower(strctMouseDownOp.m_strOp)
            case 'point'
                
                
                strctCrossSectionHoriz = getappdata(handles.figure1,'strctCrossSectionHoriz');
                strctCrossSectionSaggital = getappdata(handles.figure1,'strctCrossSectionSaggital');
                strctCrossSectionCoronal = getappdata(handles.figure1,'strctCrossSectionCoronal');
             
                a2fEB0 = getappdata(handles.figure1,'a2fEB0');

                astrctCrossSections= [strctCrossSectionHoriz,strctCrossSectionSaggital,strctCrossSectionCoronal];
                   apt3fPoints = [-20,0,0,1; % Left
                    +20,0,0,1; % Right Ear
                    0,-20,0,1; % Posterior Commisure
                    0,+20,0,1; % Anterior Commisure
                    0,0,-20,1; % Ventral ML0
                    0,0,+20,1]; % Dorsal ML0
                
                apt3fPointsInSpace = fnCrop4(a2fEB0 * apt3fPoints');
                
                    
                a3iLines = zeros(2,2,3);
                a3iLines(:,:,1) = [1,2
                    3,4];
                a3iLines(:,:,2) = [3,4
                    5,6];
                a3iLines(:,:,3) = [1,2
                    5,6];
                
                a2iRelevantPoints = a3iLines(:,:,strctMouseDownOp.m_iSelectedAxes);
                [i,j]=find(a2iRelevantPoints == strctMouseDownOp.m_iSelectedPoint);
                iActualRotationPointIndex = a2iRelevantPoints(i, 3-j);
                
                %[apt3Projected] = apt3fPointsInSpace(:,iActualRotationPointIndex);
                pt3fPointMM = fnProjectPointOnCrossSection(astrctCrossSections(strctMouseDownOp.m_iSelectedAxes), apt3fPointsInSpace(:,iActualRotationPointIndex) );
                
                afRotateDir = astrctCrossSections(strctMouseDownOp.m_iSelectedAxes).m_a2fM(1:3,3);
                
                [fDummy,iIndex]=max(abs(afDelta));
                fRotAngleRad = -afDelta(iIndex)/180*pi;
                
a2fNegTrans = [1 0 0 -pt3fPointMM(1);
    0 1 0 -pt3fPointMM(2);
    0 0 1 -pt3fPointMM(3);
    0 0 0  1];

a2fPosTrans = [1 0 0 pt3fPointMM(1);
    0 1 0 pt3fPointMM(2);
    0 0 1 pt3fPointMM(3);
    0 0 0  1];

R = fnRotateVectorAboutAxis(afRotateDir, fRotAngleRad);
a2fRot = zeros(4,4);
a2fRot(1:3,1:3) = R;
a2fRot(4,4) = 1;
a2fTransformation = a2fPosTrans*a2fRot*a2fNegTrans;
                a2fEB0 = a2fTransformation*a2fEB0 ;
                setappdata(handles.figure1,'a2fEB0',a2fEB0);
                
                if get(handles.hMoveVolume,'value')
                    fnRealignToEB0(handles);
                end
                fnInvalidate(handles);                
                 
            case 'line'
                
                strctCrossSectionHoriz = getappdata(handles.figure1,'strctCrossSectionHoriz');
                strctCrossSectionSaggital = getappdata(handles.figure1,'strctCrossSectionSaggital');
                strctCrossSectionCoronal = getappdata(handles.figure1,'strctCrossSectionCoronal');
             
                a2fEB0 = getappdata(handles.figure1,'a2fEB0');

                astrctCrossSections= [strctCrossSectionHoriz,strctCrossSectionSaggital,strctCrossSectionCoronal];
                
                pt3fCurrPos = a2fEB0(1:3,4);
                fScale  = 1;
                
               pt3fNewPos = pt3fCurrPos + ...
                    fScale * afDelta(1) * astrctCrossSections(strctMouseDownOp.m_iSelectedAxes).m_a2fM(1:3,1) + ...
                    fScale * afDelta(2) * astrctCrossSections(strctMouseDownOp.m_iSelectedAxes).m_a2fM(1:3,2);
                
                a2fEB0(1:3,4) = pt3fNewPos;
                setappdata(handles.figure1,'a2fEB0',a2fEB0);
                
                if get(handles.hMoveVolume,'value')
                    fnRealignToEB0(handles);
                end
                
                fnInvalidate(handles);
                % Pan EB0
                
            case 'contrast'
                %fnSetNewContrastLevel(afDelta);
                if strcmp(strctMouseDownOp.m_strButton,'Right')
                    strctLinearHistogramStretch = getappdata(handles.figure1,'strctLinearHistogramStretch');
                    fMaxWidth = strctLinearHistogramStretch.m_fMax/2;%max(1,2*strctLinearHistogramStretch.m_fWidth);
                    strctLinearHistogramStretch.m_fWidth = min(fMaxWidth,max(0,...
                        strctLinearHistogramStretch.m_fWidth + afDelta(2)*fMaxWidth/200));
                    strctLinearHistogramStretch.m_fCenter = min(strctLinearHistogramStretch.m_fMax,...
                        max(strctLinearHistogramStretch.m_fMin,...
                        strctLinearHistogramStretch.m_fCenter + afDelta(1)*fMaxWidth/200));
                    setappdata(handles.figure1,'strctLinearHistogramStretch',strctLinearHistogramStretch);
                    fnFastInvalidateContrastOnly(handles);
                elseif strcmp(strctMouseDownOp.m_strButton,'Left')
                    % Scroll...
                    eventdata.VerticalScrollCount = afDelta(1);
                    fnMouseWheel([],eventdata,handles);
                    
                end
                
        end
    end
    
    setappdata(handles.figure1,'strctPrevMouseOp',strctMouseCurrent);
else
      
        
    
end

return;

function a2fT =fnTranslate(pt3fPoint)
a2fT = eye(4);
a2fT(1:3,4) = pt3fPoint;
return;

function a2fT =fnAppend4(a2fR)
a2fT = eye(4);
a2fT(1:3,1:3) = a2fR;
return;

function fnMouseUp(obj,eventdata,handles)
setappdata(handles.figure1,'bMouseDown',0);
return;

function fnMouseDown(obj,eventdata,handles)
a2hPointHandles = getappdata(handles.figure1,'a2hPointHandles');
a2hLineHandles = getappdata(handles.figure1,'a2hLineHandles');

currobj = get(handles.figure1,'currentobject');
ahAxes = [handles.hAxesHoriz, handles.hAxesSaggital,handles.hAxesCoronal];
  
setappdata(handles.figure1,'bMouseDown',1);
   
if sum(currobj == a2hPointHandles(:)) > 0
    [iSelectedAxes, iSelectedPoint]=find(a2hPointHandles==currobj);
    strctMouseOp.m_strOp = 'Point';
    Tmp= get(ahAxes(iSelectedAxes),'CurrentPoint');
    strctMouseOp.m_pt2fPoint = Tmp(1,[1,2]);
    strctMouseOp.m_iSelectedAxes = iSelectedAxes;
    strctMouseOp.m_iSelectedPoint = iSelectedPoint;
    strctMouseOp.m_strButton = fnGetClickType(handles.figure1);

    setappdata(handles.figure1,'strctMouseDownOp',strctMouseOp);
elseif sum(currobj == a2hLineHandles(:)) > 0
    [iSelectedLine ,iSelectedAxes]=find(a2hLineHandles==currobj);
    strctMouseOp.m_strOp = 'Line';
    Tmp= get(ahAxes(iSelectedAxes),'CurrentPoint');
    strctMouseOp.m_pt2fPoint = Tmp(1,[1,2]);
    strctMouseOp.m_iSelectedAxes = iSelectedAxes;
    strctMouseOp.m_iSelectedLine = iSelectedLine;
    strctMouseOp.m_strButton = fnGetClickType(handles.figure1);
    
    setappdata(handles.figure1,'strctMouseDownOp',strctMouseOp);
elseif fnInsideImage(handles,handles.hAxesCoronal)
        strctMouseOp.m_strOp = 'Contrast';
        Tmp = get(handles.hAxesCoronal,'CurrentPoint');
        strctMouseOp.m_pt2fPoint = Tmp(1,[1,2]);
        strctMouseOp.m_iSelectedAxes = 3;
    strctMouseOp.m_strButton = fnGetClickType(handles.figure1);
        
        setappdata(handles.figure1,'strctMouseDownOp',strctMouseOp);
elseif fnInsideImage(handles,handles.hAxesSaggital)
        strctMouseOp.m_strOp = 'Contrast';
        Tmp = get(handles.hAxesSaggital,'CurrentPoint');
        strctMouseOp.m_pt2fPoint = Tmp(1,[1,2]);
        strctMouseOp.m_iSelectedAxes = 2;
        strctMouseOp.m_strButton = fnGetClickType(handles.figure1);
        
        setappdata(handles.figure1,'strctMouseDownOp',strctMouseOp);
elseif fnInsideImage(handles,handles.hAxesHoriz)
        strctMouseOp.m_strOp = 'Contrast';
        Tmp = get(handles.hAxesHoriz,'CurrentPoint');
        strctMouseOp.m_pt2fPoint = Tmp(1,[1,2]);
        strctMouseOp.m_iSelectedAxes = 1;
        strctMouseOp.m_strButton = fnGetClickType(handles.figure1);
        setappdata(handles.figure1,'strctMouseDownOp',strctMouseOp);
else
    strctMouseOp.m_strOp = [];
    setappdata(handles.figure1,'strctMouseDownOp',strctMouseOp);
end
setappdata(handles.figure1,'strctPrevMouseOp',strctMouseOp);

return;

function fnInvalidate(handles)
strctAnatVol = getappdata(handles.figure1,'strctAnatVol');

a2fReg = getappdata(handles.figure1,'a2fReg');
strctCrossSectionHoriz = getappdata(handles.figure1,'strctCrossSectionHoriz');
strctCrossSectionSaggital = getappdata(handles.figure1,'strctCrossSectionSaggital');
strctCrossSectionCoronal = getappdata(handles.figure1,'strctCrossSectionCoronal');
strctLinearHistogramStretch = getappdata(handles.figure1,'strctLinearHistogramStretch');

%a2fM = strctAnatVol.m_strctFreeSurfer.tkrvox2ras;
a2fM = fnFreesurferToPlanner(strctAnatVol.m_strctFreeSurfer);

a2fXYZ_To_CRS = inv(a2fM) * inv(a2fReg);


strctCrossSectionHoriz.m_a2fM(1:3,4) = strctCrossSectionHoriz.m_a2fM(1:3,4) + strctCrossSectionHoriz.m_a2fM(1:3,3) * strctCrossSectionHoriz.m_fViewOffsetMM;
strctCrossSectionSaggital.m_a2fM(1:3,4) = strctCrossSectionSaggital.m_a2fM(1:3,4) + strctCrossSectionSaggital.m_a2fM(1:3,3) * strctCrossSectionSaggital.m_fViewOffsetMM;
strctCrossSectionCoronal.m_a2fM(1:3,4) = strctCrossSectionCoronal.m_a2fM(1:3,4) + strctCrossSectionCoronal.m_a2fM(1:3,3) * strctCrossSectionCoronal.m_fViewOffsetMM;

ahEB0TextHandles = getappdata(handles.figure1,'ahEB0TextHandles');
afZFlip = getappdata(handles.figure1,'afZFlip');
if ~isempty(ahEB0TextHandles)
    set(ahEB0TextHandles(1),'string',sprintf('AP: %.2f', afZFlip(3)*strctCrossSectionCoronal.m_fViewOffsetMM));
    set(ahEB0TextHandles(2),'string',sprintf('DV: %.2f', afZFlip(1)*strctCrossSectionHoriz.m_fViewOffsetMM));
    set(ahEB0TextHandles(3),'string',sprintf('ML: %.2f', afZFlip(2)*strctCrossSectionSaggital.m_fViewOffsetMM));
end


a2fCrossSectionHoriz    = fnResampleCrossSection(strctAnatVol.m_a3fVol, a2fXYZ_To_CRS, strctCrossSectionHoriz);
a2fCrossSectionSaggital = fnResampleCrossSection(strctAnatVol.m_a3fVol, a2fXYZ_To_CRS, strctCrossSectionSaggital);
a2fCrossSectionCoronal  = fnResampleCrossSection(strctAnatVol.m_a3fVol, a2fXYZ_To_CRS, strctCrossSectionCoronal);


setappdata(handles.figure1,'a2fCrossSectionHoriz',a2fCrossSectionHoriz);
setappdata(handles.figure1,'a2fCrossSectionSaggital',a2fCrossSectionSaggital);
setappdata(handles.figure1,'a2fCrossSectionCoronal',a2fCrossSectionCoronal);


a3fCoronalSlice = fnDup3(fnContrastTransform(a2fCrossSectionCoronal, strctLinearHistogramStretch));
a3fHorizSlice = fnDup3(fnContrastTransform(a2fCrossSectionHoriz, strctLinearHistogramStretch));
a3fSaggitalSlice = fnDup3(fnContrastTransform(a2fCrossSectionSaggital, strctLinearHistogramStretch));
setappdata(handles.figure1,'a3fCoronalSlice',a3fCoronalSlice);
setappdata(handles.figure1,'a3fHorizSlice',a3fHorizSlice);
setappdata(handles.figure1,'a3fSaggitalSlice',a3fSaggitalSlice);

% Horiz = XY
% Saggital: YZ
% Coronal: XZ

 
hImageCoronal=getappdata(handles.figure1,'hImageCoronal');
hImageSaggital = getappdata(handles.figure1,'hImageSaggital');
hImageHoriz = getappdata(handles.figure1,'hImageHoriz');

if isempty(hImageCoronal)
    fnGenerateImagesAndText(handles,a3fCoronalSlice,a3fHorizSlice, a3fSaggitalSlice,1 )
else
    set(hImageCoronal,'cdata',fnDup3(fnContrastTransform(a2fCrossSectionCoronal, strctLinearHistogramStretch)));
    set(hImageHoriz,'cdata',fnDup3(fnContrastTransform(a2fCrossSectionHoriz, strctLinearHistogramStretch)));
    set(hImageSaggital,'cdata',fnDup3(fnContrastTransform(a2fCrossSectionSaggital, strctLinearHistogramStretch)));
    
    ahZPosHandles = getappdata(handles.figure1,'ahZPosHandles');
    
    [fCoronalOffset,iIndex]=max(abs(strctCrossSectionCoronal.m_a2fM(1:3,4)));
    fCoronalOffset = strctCrossSectionCoronal.m_a2fM(iIndex,4);
    set(ahZPosHandles(1),'xdata',[0 -fCoronalOffset],'ydata',[0 fCoronalOffset],'Linestyle','-');
    [fSaggitalOffset,iIndex]=max(abs(strctCrossSectionSaggital.m_a2fM(1:3,4)));
    fSaggitalOffset = strctCrossSectionSaggital.m_a2fM(iIndex,4);
    set(ahZPosHandles(3),'xdata',[0 fSaggitalOffset],'ydata',[0 -fSaggitalOffset],'Linestyle','-');
    [fHorizOffset,iIndex]=max(abs(strctCrossSectionHoriz.m_a2fM(1:3,4)));
    fHorizOffset = strctCrossSectionHoriz.m_a2fM(iIndex,4);
    set(ahZPosHandles(2),'xdata',[0 fHorizOffset],'ydata',[0 -fHorizOffset],'Linestyle','-');
    
    bEarBarZeroStage = getappdata(handles.figure1,'bEarBarZeroStage');
    if bEarBarZeroStage
        fnInvalidateEarbarZero(handles)
    end
    
end

 
return;
   
function fnGenerateImagesAndText(handles,a3fCoronalSlice,a3fHorizSlice, a3fSaggitalSlice, bGenerateEar )
strctCrossSectionHoriz = getappdata(handles.figure1,'strctCrossSectionHoriz');
strctCrossSectionSaggital = getappdata(handles.figure1,'strctCrossSectionSaggital');
strctCrossSectionCoronal = getappdata(handles.figure1,'strctCrossSectionCoronal');
strctLinearHistogramStretch = getappdata(handles.figure1,'strctLinearHistogramStretch');

aiImageRes = [256,256];
afX = linspace(-strctCrossSectionHoriz.m_fHalfWidthMM,strctCrossSectionHoriz.m_fHalfWidthMM, aiImageRes(1));
afY = linspace(-strctCrossSectionSaggital.m_fHalfWidthMM,strctCrossSectionSaggital.m_fHalfWidthMM, aiImageRes(1));
afZ = linspace(-strctCrossSectionCoronal.m_fHalfWidthMM,strctCrossSectionCoronal.m_fHalfWidthMM, aiImageRes(1));
     
hImageCoronal = image(afX,afY,a3fCoronalSlice,'parent',handles.hAxesCoronal);
hold(handles.hAxesCoronal,'on');
ahTextHandles(1) = text(afX(5),afY(128),'L','fontsize',21,'color',[1 1 1],'parent',handles.hAxesCoronal);
ahTextHandles(2) = text(afX(235),afY(128),'R','fontsize',21,'color',[1 1 1],'parent',handles.hAxesCoronal);
ahTextHandles(3) = text(afX(128),afY(15),'D','fontsize',21,'color',[1 1 1],'parent',handles.hAxesCoronal);
ahTextHandles(4) = text(afX(128),afY(235),'V','fontsize',21,'color',[1 1 1],'parent',handles.hAxesCoronal);

ahTextHandles(5) = text(afX(5),afY(235),'A','fontsize',21,'color',[1 1 1],'parent',handles.hAxesCoronal);
ahTextHandles(6) = text(afX(235),afY(15),'P','fontsize',21,'color',[1 1 1],'parent',handles.hAxesCoronal);
ahLineHandles(1) = plot([afX(20) afX(end-20)],[afY(end-20) afY(20)],':','color',[1 1 1],'parent',handles.hAxesCoronal);
ahZPosHandles(1) = plot([afX(128) afX(128)],[afY(128) afY(128)],'o','color',[0 1 0],'parent',handles.hAxesCoronal);
setappdata(handles.figure1,'hImageCoronal',hImageCoronal);
set(handles.hAxesCoronal,'visible','off');

hImageHoriz = image(afY,afZ,a3fHorizSlice,'parent',handles.hAxesHoriz);
hold(handles.hAxesHoriz,'on');
set(handles.hAxesHoriz,'visible','off');
ahTextHandles(7) = text(afY(5),  afZ(128),'L','fontsize',21,'color',[1 1 1],'parent',handles.hAxesHoriz);
ahTextHandles(8) = text(afY(235),afZ(128),'R','fontsize',21,'color',[1 1 1],'parent',handles.hAxesHoriz);
ahTextHandles(9) = text(afY(128),afZ(15),'A','fontsize',21,'color',[1 1 1],'parent',handles.hAxesHoriz);
ahTextHandles(10) = text(afY(128),afZ(235),'P','fontsize',21,'color',[1 1 1],'parent',handles.hAxesHoriz);


ahTextHandles(11) = text(afX(5),afY(235),'D','fontsize',21,'color',[1 1 1],'parent',handles.hAxesHoriz);
ahTextHandles(12) = text(afX(235),afY(15),'V','fontsize',21,'color',[1 1 1],'parent',handles.hAxesHoriz);
ahLineHandles(2) = plot([afX(20) afX(end-20)],[afY(end-20) afY(20)],':','color',[1 1 1],'parent',handles.hAxesHoriz);
ahZPosHandles(2) = plot([afX(128) afX(128)],[afY(128) afY(128)],'o','color',[0 1 0],'parent',handles.hAxesHoriz);
setappdata(handles.figure1,'hImageHoriz',hImageHoriz);

hImageSaggital = image(afX,afZ,a3fSaggitalSlice,'parent',handles.hAxesSaggital);
set(handles.hAxesSaggital,'visible','off');
hold(handles.hAxesSaggital,'on');
ahTextHandles(13)  = text(afX(5),  afZ(128),'P','fontsize',21,'color',[1 1 1],'parent',handles.hAxesSaggital);
ahTextHandles(14) = text(afX(235),afZ(128),'A','fontsize',21,'color',[1 1 1],'parent',handles.hAxesSaggital);
ahTextHandles(15) = text(afX(128),afZ(15),'D','fontsize',21,'color',[1 1 1],'parent',handles.hAxesSaggital);
ahTextHandles(16) = text(afX(128),afZ(235),'V','fontsize',21,'color',[1 1 1],'parent',handles.hAxesSaggital);

ahTextHandles(17) = text(afX(5),afY(235),'R','fontsize',21,'color',[1 1 1],'parent',handles.hAxesSaggital);
ahTextHandles(18) = text(afX(235),afY(15),'L','fontsize',21,'color',[1 1 1],'parent',handles.hAxesSaggital);
ahLineHandles(3) = plot([afX(20) afX(end-20)],[afY(end-20) afY(20)],':','color',[1 1 1],'parent',handles.hAxesSaggital);
ahZPosHandles(3) = plot([afX(128) afX(128)],[afY(128) afY(128)],'o','color',[0 1 0],'parent',handles.hAxesSaggital);

setappdata(handles.figure1,'hImageSaggital',hImageSaggital);
setappdata(handles.figure1,'ahTextHandles',ahTextHandles);
setappdata(handles.figure1,'ahZPosHandles',ahZPosHandles);
setappdata(handles.figure1,'ahLineHandles',ahLineHandles);


if bGenerateEar
afX = linspace(-20,20, 65);
afY = linspace(-20,20, 65);

hImageLeftEar = image(afX,afY,zeros(65,65,3),'parent',handles.hAxesLeftEar);
hImageRightEar = image(afX,afY,zeros(65,65,3),'parent',handles.hAxesRightEar);
set(handles.hAxesLeftEar,'visible','off');
set(handles.hAxesRightEar,'visible','off');
hold(handles.hAxesLeftEar,'on');
hold(handles.hAxesRightEar,'on');
% Plot dotted lines
plot([afX(1) afX(65)],[afY(32) afY(32)],':','color',[1 1 1],'parent',handles.hAxesLeftEar);
plot([afX(32) afX(32)],[afY(1) afY(65)],':','color',[1 1 1],'parent',handles.hAxesLeftEar);

plot([afX(1) afX(65)],[afY(32) afY(32)],':','color',[1 1 1],'parent',handles.hAxesRightEar);
plot([afX(32) afX(32)],[afY(1) afY(65)],':','color',[1 1 1],'parent',handles.hAxesRightEar);

setappdata(handles.figure1,'hImageLeftEar',hImageLeftEar);
setappdata(handles.figure1,'hImageRightEar',hImageRightEar);
hold(handles.hAxesCoronal,'on');

end
return;
             
        
function fnInvalidateEarbarZero(handles)   

strctCrossSectionHoriz = getappdata(handles.figure1,'strctCrossSectionHoriz');
strctCrossSectionSaggital = getappdata(handles.figure1,'strctCrossSectionSaggital');
strctCrossSectionCoronal = getappdata(handles.figure1,'strctCrossSectionCoronal');

a2hPointHandles = getappdata(handles.figure1,'a2hPointHandles');
a2hLineHandles = getappdata(handles.figure1,'a2hLineHandles');

a2fEB0 = getappdata(handles.figure1,'a2fEB0');
apt3fPoints = [-20,0,0,1; % Left
    +20,0,0,1; % Right Ear
    0,-20,0,1; % Posterior Commisure
    0,+20,0,1; % Anterior Commisure
    0,0,-20,1; % Ventral ML0
    0,0,+20,1]; % Dorsal ML0

apt3fPointsInSpace = fnCrop4(a2fEB0 * apt3fPoints');
astrctCrossSections= [strctCrossSectionHoriz,strctCrossSectionSaggital,strctCrossSectionCoronal];
ahAxes = [handles.hAxesHoriz, handles.hAxesSaggital,handles.hAxesCoronal];
a2bPointsToDraw = [1 1 1 1 0 0;
    0 0 1 1 1 1;
    1 1 0 0 1 1];

a3iLines = zeros(2,2,3);
a3iLines(:,:,1) = [1,2
    3,4];
a3iLines(:,:,2) = [3,4
    5,6];
a3iLines(:,:,3) = [1,2
    5,6];

iNumPoints = 6;
a2fColors = [1 0 0;
    1 0 0;
    0 1 0;
    0 1 0;
    0 0 1;
    0 0 1];
for iAxesIter=1:3
    strctCrossSection = astrctCrossSections(iAxesIter);
    hParent = ahAxes(iAxesIter);
    
    apt2Projected = zeros(2,iNumPoints);
    for i=1:6
        [fDummy,apt2Projected(:,i)] = fnProjectPointOnCrossSection(strctCrossSection, apt3fPointsInSpace(:,i) );
        if a2bPointsToDraw(iAxesIter,i)
            set(a2hPointHandles(iAxesIter,i),'xdata',apt2Projected(1,i),'ydata',apt2Projected(2,i));
        end
    end
    % Lines
    for iLineIter=1:2
        iPoint1Ind = a3iLines(iLineIter,1, iAxesIter);
        iPoint2Ind = a3iLines(iLineIter,2, iAxesIter);
        
        afDir = apt2Projected(:,iPoint1Ind) - apt2Projected(:,iPoint2Ind);
        afDir = afDir/norm(afDir);
        pt2fStartFar = apt2Projected(:,iPoint1Ind) + afDir*40;
        pt2fEndFar = apt2Projected(:,iPoint2Ind) - afDir*40;
        
        set(a2hLineHandles(iLineIter, iAxesIter),'xdata',[pt2fStartFar(1), pt2fEndFar(1)],...
            'ydata',[pt2fStartFar(2), pt2fEndFar(2)]);
    end
end

% Update ear plots
strctAnatVol = getappdata(handles.figure1,'strctAnatVol');
fInterAuralDistMM = get(handles.hInterauralDistSldier,'value');
%a2fM = strctAnatVol.m_strctFreeSurfer.tkrvox2ras;

a2fM = fnFreesurferToPlanner(strctAnatVol.m_strctFreeSurfer);




a2fReg = getappdata(handles.figure1,'a2fReg');
a2fXYZ_To_CRS = inv(a2fM) * inv(a2fReg);

a2fLeftEar = a2fEB0;
a2fRightEar = a2fEB0;

a2fLeftEar(1:3,1:3) = a2fLeftEar(1:3,[2,3,1]);
a2fRightEar(1:3,1:3) = a2fRightEar(1:3,[2,3,1]);

a2fLeftEar(1:3,4) = a2fEB0(1:3,4);
a2fRightEar(1:3,4) = a2fEB0(1:3,4);
a2fLeftEar(1:3,4) = a2fLeftEar(1:3,4) +  a2fEB0(1:3,1) * fInterAuralDistMM;
a2fRightEar(1:3,4) =a2fRightEar(1:3,4) -  a2fEB0(1:3,1) * fInterAuralDistMM;

strctCrossSectionLeft = strctCrossSectionSaggital;
strctCrossSectionLeft.m_a2fM = a2fLeftEar;
strctCrossSectionLeft.m_fHalfHeightMM = 20;
strctCrossSectionLeft.m_fHalfWidthMM = 20;
strctCrossSectionLeft.m_iResHeight = 65;
strctCrossSectionLeft.m_iResWidth = 65;

strctCrossSectionRight = strctCrossSectionLeft;
strctCrossSectionRight.m_a2fM = a2fRightEar;

strctLinearHistogramStretch = getappdata(handles.figure1,'strctLinearHistogramStretch');
a2fLeftCrossSection = fnResampleCrossSection(strctAnatVol.m_a3fVol, a2fXYZ_To_CRS, strctCrossSectionLeft);
a2fRightCrossSection = fnResampleCrossSection(strctAnatVol.m_a3fVol, a2fXYZ_To_CRS, strctCrossSectionRight);
setappdata(handles.figure1,'a2fLeftCrossSection',a2fLeftCrossSection);
setappdata(handles.figure1,'a2fRightCrossSection',a2fRightCrossSection);

a2fLeft  = fnDup3(fnContrastTransform(a2fLeftCrossSection,strctLinearHistogramStretch));
a2fRight = fnDup3(fnContrastTransform(a2fRightCrossSection,strctLinearHistogramStretch));
hImageLeftEar = getappdata(handles.figure1,'hImageLeftEar');
hImageRightEar = getappdata(handles.figure1,'hImageRightEar');
set(hImageLeftEar,'cdata',a2fLeft );
set(hImageRightEar,'cdata',a2fRight);

return;

          
   
function fnGenerateEarbarZeroPlaneHandles(handles)

% Draw ear bar zero controls

strctCrossSectionHoriz = getappdata(handles.figure1,'strctCrossSectionHoriz');
strctCrossSectionSaggital = getappdata(handles.figure1,'strctCrossSectionSaggital');
strctCrossSectionCoronal = getappdata(handles.figure1,'strctCrossSectionCoronal');

% Default Ear-bar-zero plane 
a2fEB0 = strctCrossSectionHoriz.m_a2fM;
setappdata(handles.figure1,'a2fEB0',a2fEB0);

a2fEB0 = getappdata(handles.figure1,'a2fEB0');

apt3fPoints = [-20,0,0,1; % Left
    +20,0,0,1; % Right Ear
    0,-20,0,1; % Posterior Commisure
    0,+20,0,1; % Anterior Commisure
    0,0,-20,1; % Ventral ML0
    0,0,+20,1]; % Dorsal ML0

apt3fPointsInSpace = fnCrop4(a2fEB0 * apt3fPoints');


astrctCrossSections= [strctCrossSectionHoriz,strctCrossSectionSaggital,strctCrossSectionCoronal];
ahAxes = [handles.hAxesHoriz, handles.hAxesSaggital,handles.hAxesCoronal];

a2bPointsToDraw = [1 1 1 1 0 0;
    0 0 1 1 1 1;
    1 1 0 0 1 1];

a3iLines = zeros(2,2,3);
a3iLines(:,:,1) = [1,2
    3,4];
a3iLines(:,:,2) = [3,4
    5,6];
a3iLines(:,:,3) = [1,2
    5,6];


iNumPoints = 6;
a2fColors =  [0 1 0
    1 0 0;
    0 0 1
    0 1 0
    0 0 1
    1 0 0];

a2hPointHandles = zeros(3,iNumPoints);
a2hLineHandles = zeros(2,3);
for iAxesIter=1:3
    strctCrossSection = astrctCrossSections(iAxesIter);
    hParent = ahAxes(iAxesIter);
    
    apt2Projected = zeros(2,iNumPoints);
    for i=1:6
        [fDummy,apt2Projected(:,i)] = fnProjectPointOnCrossSection(strctCrossSection, apt3fPointsInSpace(:,i) );
        if a2bPointsToDraw(iAxesIter,i)
            a2hPointHandles(iAxesIter,i) = plot(apt2Projected(1,i),apt2Projected(2,i),'ro','LineWidth',2,'parent',hParent,'MarkerSize',11);
        end
    end
    % Lines
    for iLineIter=1:2
        
        
        iPoint1Ind = a3iLines(iLineIter,1, iAxesIter);
        iPoint2Ind = a3iLines(iLineIter,2, iAxesIter);
        
        afDir = apt2Projected(:,iPoint1Ind) - apt2Projected(:,iPoint2Ind);
        afDir = afDir/norm(afDir);
        pt2fStartFar = apt2Projected(:,iPoint1Ind) + afDir*40;
        pt2fEndFar = apt2Projected(:,iPoint2Ind) - afDir*40;
        
        a2hLineHandles(iLineIter, iAxesIter) = plot([pt2fStartFar(1), pt2fEndFar(1)],...
            [pt2fStartFar(2), pt2fEndFar(2)],'color',a2fColors(iLineIter+2*(iAxesIter-1),:),'LineWidth',1,'LineStyle','--','parent',hParent);
        
    end
    
end
setappdata(handles.figure1,'a2hPointHandles',a2hPointHandles);
setappdata(handles.figure1,'a2hLineHandles',a2hLineHandles);

set(handles.hSliderHoriz,'min',-500,'max',500,'value',0,'visible','on','SliderStep',[0.001 0.01]);
set(handles.hSliderSaggital,'min',-500,'max',500,'value',0,'visible','on','SliderStep',[0.001 0.01]);
set(handles.hSliderCoronal,'min',-500,'max',500,'value',0,'visible','on','SliderStep',[0.001 0.01]);

aiImageRes = [256,256];
afX = linspace(-strctCrossSectionHoriz.m_fHalfWidthMM,strctCrossSectionHoriz.m_fHalfWidthMM, aiImageRes(1));
afY = linspace(-strctCrossSectionSaggital.m_fHalfWidthMM,strctCrossSectionSaggital.m_fHalfWidthMM, aiImageRes(1));

ahEB0TextHandles(1) = text(afX(5),afY(15),'AP: +0','fontsize',21,'color',[1 1 1],'parent',handles.hAxesCoronal);
ahEB0TextHandles(2) = text(afX(5),afY(15),'DV: +0','fontsize',21,'color',[1 1 1],'parent',handles.hAxesHoriz);
ahEB0TextHandles(3) = text(afX(5),afY(15),'ML: +0','fontsize',21,'color',[1 1 1],'parent',handles.hAxesSaggital);
setappdata(handles.figure1,'ahEB0TextHandles',ahEB0TextHandles);
return;


function fnFastInvalidateContrastOnly(handles)
a2fCrossSectionHoriz = getappdata(handles.figure1,'a2fCrossSectionHoriz');
a2fCrossSectionSaggital = getappdata(handles.figure1,'a2fCrossSectionSaggital');
a2fCrossSectionCoronal = getappdata(handles.figure1,'a2fCrossSectionCoronal');
hImageCoronal = getappdata(handles.figure1,'hImageCoronal');
hImageHoriz = getappdata(handles.figure1,'hImageHoriz');
hImageSaggital = getappdata(handles.figure1,'hImageSaggital');

strctLinearHistogramStretch = getappdata(handles.figure1,'strctLinearHistogramStretch');
a3fCoronalSlice = fnDup3(fnContrastTransform(a2fCrossSectionCoronal, strctLinearHistogramStretch));
a3fHorizSlice = fnDup3(fnContrastTransform(a2fCrossSectionHoriz, strctLinearHistogramStretch));
a3fSaggitalSlice = fnDup3(fnContrastTransform(a2fCrossSectionSaggital, strctLinearHistogramStretch));

set(hImageCoronal,'cdata',a3fCoronalSlice);
set(hImageHoriz,'cdata',a3fHorizSlice);
set(hImageSaggital,'cdata',a3fSaggitalSlice);


a2fLeftCrossSection = getappdata(handles.figure1,'a2fLeftCrossSection');
a2fRightCrossSection = getappdata(handles.figure1,'a2fRightCrossSection');
if ~isempty(a2fLeftCrossSection)
a2fLeft  = fnDup3(fnContrastTransform(a2fLeftCrossSection,strctLinearHistogramStretch));
a2fRight = fnDup3(fnContrastTransform(a2fRightCrossSection,strctLinearHistogramStretch));
hImageLeftEar = getappdata(handles.figure1,'hImageLeftEar');
hImageRightEar = getappdata(handles.figure1,'hImageRightEar');
set(hImageLeftEar,'cdata',a2fLeft );
set(hImageRightEar,'cdata',a2fRight);
end

setappdata(handles.figure1,'a3fCoronalSlice',a3fCoronalSlice);
setappdata(handles.figure1,'a3fHorizSlice',a3fHorizSlice);
setappdata(handles.figure1,'a3fSaggitalSlice',a3fSaggitalSlice);

return;

function X=fnNormDir(X)
X= X/norm(X);
return;

function X=fnCrop4(X)
X=X(1:3,:);
return;
% 
% function bRightHandRule = fnRightHandSystem(strctCrossSection)
% bRightHandRule = ...
%     dot(cross(strctCrossSection.m_a2fM(1:3,1),strctCrossSection.m_a2fM(1:3,2)), -strctCrossSection.m_a2fM(1:3,3)) <  ...
%     dot(cross(strctCrossSection.m_a2fM(1:3,1),strctCrossSection.m_a2fM(1:3,2)), strctCrossSection.m_a2fM(1:3,3));
% return;


function [strctCrossSectionHoriz,strctCrossSectionSaggital,strctCrossSectionCoronal] = fnSetDefaultCrossSections(aiVolSize, a2fM,iResWidth,iResHeight )
% Project [0,0,0] and aiVolSize and find min and max
P = [0,0,0,1; 
     aiVolSize,1];
 
Pmm =  a2fM * P';

fRangeX = abs(Pmm(2,2)-Pmm(2,1));
fRangeY = abs(Pmm(1,2)-Pmm(1,1));
fRangeZ = abs(Pmm(3,2)-Pmm(3,1));

fHalfXYMM  =  max(fRangeX,fRangeY)/2;
fHalfYZMM  =  max(fRangeZ,fRangeY)/2;
fHalfXZMM =  max(fRangeX,fRangeZ)/2;
% prepare cross sections

% XY: sphenix
% strctCrossSectionHoriz.m_a2fM = [-1,0, 0  0;
%                                   0  0 1  0;
%                                   0  1  0  0;
%                                   0  0 0  1]; 

 strctCrossSectionHoriz.m_a2fM = [ 0, -1, 0  0;
                                   1  0  0  0;
                                   0  0  1  0;
                                   0  0 0  1]; 

strctCrossSectionHoriz.m_fHalfWidthMM = fHalfXYMM;
strctCrossSectionHoriz.m_fHalfHeightMM = fHalfXYMM; 
strctCrossSectionHoriz.m_iResWidth = iResWidth;
strctCrossSectionHoriz.m_iResHeight = iResHeight;
strctCrossSectionHoriz.m_fViewOffsetMM = 0;
strctCrossSectionHoriz.m_bZFlip = false;
strctCrossSectionHoriz.m_bLRFlip = false;
strctCrossSectionHoriz.m_bUDFlip = false;

% XZ
% strctCrossSectionSaggital.m_a2fM = [0, 0, -1  0;
%                                     0  1  0  0;
%                                    -1  0 0  0;
%                                     0 0 0  1]; % This gives coronal slice such that Y = 0 is superior
                                
strctCrossSectionSaggital.m_a2fM = [1, 0, 0  0;
                                    0  0  1  0;
                                    0  1  0  0;
                                    0  0  0  1]; % This gives coronal slice such that Y = 0 is superior
                                
strctCrossSectionSaggital.m_fHalfWidthMM =  fHalfXZMM;
strctCrossSectionSaggital.m_fHalfHeightMM =  fHalfXZMM;
strctCrossSectionSaggital.m_iResWidth = iResWidth;
strctCrossSectionSaggital.m_iResHeight = iResHeight;
strctCrossSectionSaggital.m_fViewOffsetMM = 0;
strctCrossSectionSaggital.m_bZFlip = false;
strctCrossSectionSaggital.m_bLRFlip = false;
strctCrossSectionSaggital.m_bUDFlip = false;

% YZ
% strctCrossSectionCoronal.m_a2fM = [-1 0 0  0;
%                                    0  1 0  0;
%                                    0, 0,1  0;
%                                    0 0 0  1]; % This gives coronal slice such that Y = 0 is superior

strctCrossSectionCoronal.m_a2fM = [0  0 1  0;
                                   -1 0 0  0;
                                   0, 1,0  0;
                                   0 0 0  1]; % This gives coronal slice such that Y = 0 is superior
                              
strctCrossSectionCoronal.m_fHalfWidthMM = fHalfYZMM;
strctCrossSectionCoronal.m_fHalfHeightMM = fHalfYZMM;
strctCrossSectionCoronal.m_iResWidth = iResWidth;
strctCrossSectionCoronal.m_iResHeight = iResHeight;
strctCrossSectionCoronal.m_fViewOffsetMM = 0;
strctCrossSectionCoronal.m_bZFlip = false;
strctCrossSectionCoronal.m_bLRFlip = false;
strctCrossSectionCoronal.m_bUDFlip = false;


return;
%%
function hFlipHorizontalSaggital_Callback(hObject, eventdata, handles)
strctCrossSectionHoriz = getappdata(handles.figure1,'strctCrossSectionHoriz');
strctCrossSectionSaggital = getappdata(handles.figure1,'strctCrossSectionSaggital');
Temp = strctCrossSectionHoriz;
strctCrossSectionHoriz = strctCrossSectionSaggital;
strctCrossSectionSaggital = Temp;
setappdata(handles.figure1,'strctCrossSectionHoriz',strctCrossSectionHoriz);
setappdata(handles.figure1,'strctCrossSectionSaggital',strctCrossSectionSaggital);

fnInvalidate(handles);
return;


function hFlipSaggitalCoronal_Callback(hObject, eventdata, handles)
strctCrossSectionCoronal = getappdata(handles.figure1,'strctCrossSectionCoronal');
strctCrossSectionSaggital = getappdata(handles.figure1,'strctCrossSectionSaggital');
Temp = strctCrossSectionCoronal;
strctCrossSectionCoronal = strctCrossSectionSaggital;
strctCrossSectionSaggital = Temp;
setappdata(handles.figure1,'strctCrossSectionCoronal',strctCrossSectionCoronal);
setappdata(handles.figure1,'strctCrossSectionSaggital',strctCrossSectionSaggital);

fnInvalidate(handles);
return;


%%

function hRotateRightHoriz_Callback(hObject, eventdata, handles)
strctCrossSectionHoriz = getappdata(handles.figure1,'strctCrossSectionHoriz');
a2fRot = fnRotateVectorAboutAxis([0 0 1],-pi/2);
strctCrossSectionHoriz.m_a2fM = strctCrossSectionHoriz.m_a2fM * [a2fRot,[0;0;0];[0,0,0,1];];
setappdata(handles.figure1,'strctCrossSectionHoriz',strctCrossSectionHoriz);
fnInvalidate(handles);
return;

function hRotateLeftHoriz_Callback(hObject, eventdata, handles)
strctCrossSectionHoriz = getappdata(handles.figure1,'strctCrossSectionHoriz');
a2fRot = fnRotateVectorAboutAxis([0 0 1],pi/2);
strctCrossSectionHoriz.m_a2fM = strctCrossSectionHoriz.m_a2fM * [a2fRot,[0;0;0];[0,0,0,1];];
setappdata(handles.figure1,'strctCrossSectionHoriz',strctCrossSectionHoriz);
fnInvalidate(handles);
return;

function hFlipLeftRightHoriz_Callback(hObject, eventdata, handles)
strctCrossSectionHoriz = getappdata(handles.figure1,'strctCrossSectionHoriz');
a2fRot = fnRotateVectorAboutAxis([0 1 0],pi);
strctCrossSectionHoriz.m_a2fM = strctCrossSectionHoriz.m_a2fM * [a2fRot,[0;0;0];[0,0,0,1];];
strctCrossSectionHoriz.m_bLRFlip = ~strctCrossSectionHoriz.m_bLRFlip;
setappdata(handles.figure1,'strctCrossSectionHoriz',strctCrossSectionHoriz);
fnInvalidate(handles);
return;


function hFlipUpDownHoriz_Callback(hObject, eventdata, handles)
strctCrossSectionHoriz = getappdata(handles.figure1,'strctCrossSectionHoriz');
a2fRot = fnRotateVectorAboutAxis([1 0 0],pi);
strctCrossSectionHoriz.m_a2fM = strctCrossSectionHoriz.m_a2fM * [a2fRot,[0;0;0];[0,0,0,1];];
strctCrossSectionHoriz.m_bUDFlip = ~strctCrossSectionHoriz.m_bUDFlip;
setappdata(handles.figure1,'strctCrossSectionHoriz',strctCrossSectionHoriz);
fnInvalidate(handles);
return;
%%

function hRotateRightCoronal_Callback(hObject, eventdata, handles)
strctCrossSectionCoronal = getappdata(handles.figure1,'strctCrossSectionCoronal');
a2fRot = fnRotateVectorAboutAxis([0 0 1],-pi/2);
strctCrossSectionCoronal.m_a2fM = strctCrossSectionCoronal.m_a2fM * [a2fRot,[0;0;0];[0,0,0,1];];
setappdata(handles.figure1,'strctCrossSectionCoronal',strctCrossSectionCoronal);
fnInvalidate(handles);
return;

function hRotateLeftCoronal_Callback(hObject, eventdata, handles)
strctCrossSectionCoronal = getappdata(handles.figure1,'strctCrossSectionCoronal');
a2fRot = fnRotateVectorAboutAxis([0 0 1],pi/2);
strctCrossSectionCoronal.m_a2fM = strctCrossSectionCoronal.m_a2fM * [a2fRot,[0;0;0];[0,0,0,1];];
setappdata(handles.figure1,'strctCrossSectionCoronal',strctCrossSectionCoronal);
fnInvalidate(handles);
return;

function hFlipLeftRightCoronal_Callback(hObject, eventdata, handles)
strctCrossSectionCoronal = getappdata(handles.figure1,'strctCrossSectionCoronal');
a2fRot = fnRotateVectorAboutAxis([0 1 0],pi);
strctCrossSectionCoronal.m_a2fM = strctCrossSectionCoronal.m_a2fM * [a2fRot,[0;0;0];[0,0,0,1];];
strctCrossSectionCoronal.m_bLRFlip = ~strctCrossSectionCoronal.m_bLRFlip;

setappdata(handles.figure1,'strctCrossSectionCoronal',strctCrossSectionCoronal);
fnInvalidate(handles);
return;


function hFlipUpDownCoronal_Callback(hObject, eventdata, handles)
strctCrossSectionCoronal = getappdata(handles.figure1,'strctCrossSectionCoronal');
a2fRot = fnRotateVectorAboutAxis([1 0 0],pi);
strctCrossSectionCoronal.m_a2fM = strctCrossSectionCoronal.m_a2fM * [a2fRot,[0;0;0];[0,0,0,1];];
strctCrossSectionCoronal.m_bUDFlip = ~strctCrossSectionCoronal.m_bUDFlip;

setappdata(handles.figure1,'strctCrossSectionCoronal',strctCrossSectionCoronal);
fnInvalidate(handles);
return;

%%


function hRotateRightSaggital_Callback(hObject, eventdata, handles)
strctCrossSectionSaggital = getappdata(handles.figure1,'strctCrossSectionSaggital');
a2fRot = fnRotateVectorAboutAxis([0 0 1],-pi/2);
strctCrossSectionSaggital.m_a2fM = strctCrossSectionSaggital.m_a2fM * [a2fRot,[0;0;0];[0,0,0,1];];
setappdata(handles.figure1,'strctCrossSectionSaggital',strctCrossSectionSaggital);
fnInvalidate(handles);
return;

function hRotateLeftSaggital_Callback(hObject, eventdata, handles)
strctCrossSectionSaggital = getappdata(handles.figure1,'strctCrossSectionSaggital');
a2fRot = fnRotateVectorAboutAxis([0 0 1],pi/2);
strctCrossSectionSaggital.m_a2fM = strctCrossSectionSaggital.m_a2fM * [a2fRot,[0;0;0];[0,0,0,1];];
setappdata(handles.figure1,'strctCrossSectionSaggital',strctCrossSectionSaggital);
fnInvalidate(handles);
return;

function hFlipLeftRightSaggital_Callback(hObject, eventdata, handles)
strctCrossSectionSaggital = getappdata(handles.figure1,'strctCrossSectionSaggital');
a2fRot = fnRotateVectorAboutAxis([0 1 0],pi);
strctCrossSectionSaggital.m_a2fM = strctCrossSectionSaggital.m_a2fM * [a2fRot,[0;0;0];[0,0,0,1];];
strctCrossSectionSaggital.m_bLRFlip = ~strctCrossSectionSaggital.m_bLRFlip;

setappdata(handles.figure1,'strctCrossSectionSaggital',strctCrossSectionSaggital);
fnInvalidate(handles);
return;


function hFlipUpDownSaggital_Callback(hObject, eventdata, handles)
strctCrossSectionSaggital = getappdata(handles.figure1,'strctCrossSectionSaggital');
a2fRot = fnRotateVectorAboutAxis([1 0 0],pi);
strctCrossSectionSaggital.m_a2fM = strctCrossSectionSaggital.m_a2fM * [a2fRot,[0;0;0];[0,0,0,1];];
strctCrossSectionSaggital.m_bUDFlip = ~strctCrossSectionSaggital.m_bUDFlip;

setappdata(handles.figure1,'strctCrossSectionSaggital',strctCrossSectionSaggital);
fnInvalidate(handles);
return;


%%

function hCancel_Callback(hObject, eventdata, handles)
global g_TMP
g_TMP = getappdata(handles.figure1,'strctAnatVol');
delete(gcbf);

function hSliderHoriz_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function hSliderSaggital_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function hSliderCoronal_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function hFlipZHoriz_Callback(hObject, eventdata, handles)
strctCrossSectionHoriz = getappdata(handles.figure1,'strctCrossSectionHoriz');
afZFlip = getappdata(handles.figure1,'afZFlip');
strctCrossSectionHoriz.m_a2fM(1:3,3) = -strctCrossSectionHoriz.m_a2fM(1:3,3);
strctCrossSectionHoriz.m_fViewOffsetMM = -strctCrossSectionHoriz.m_fViewOffsetMM;

strctCrossSectionHoriz.m_bZFlip = ~strctCrossSectionHoriz.m_bZFlip;
setappdata(handles.figure1,'strctCrossSectionHoriz',strctCrossSectionHoriz);
afZFlip(1) = -afZFlip(1);
setappdata(handles.figure1,'afZFlip',afZFlip);
ahTextHandles = getappdata(handles.figure1,'ahTextHandles');
S1 = get(ahTextHandles(11),'string');
S2 = get(ahTextHandles(12),'string');
set(ahTextHandles(11),'string',S2);
set(ahTextHandles(12),'string',S1);
fnInvalidate(handles);

return;

function hFlipZSaggital_Callback(hObject, eventdata, handles)
strctCrossSectionSaggital = getappdata(handles.figure1,'strctCrossSectionSaggital');
afZFlip = getappdata(handles.figure1,'afZFlip');
afZFlip(2) = -afZFlip(2);

strctCrossSectionSaggital.m_a2fM(1:3,3) = -strctCrossSectionSaggital.m_a2fM(1:3,3);
strctCrossSectionSaggital.m_fViewOffsetMM = -strctCrossSectionSaggital.m_fViewOffsetMM;

strctCrossSectionSaggital.m_bZFlip = ~strctCrossSectionSaggital.m_bZFlip;
setappdata(handles.figure1,'strctCrossSectionSaggital',strctCrossSectionSaggital);
ahTextHandles = getappdata(handles.figure1,'ahTextHandles');
S1 = get(ahTextHandles(17),'string');
S2 = get(ahTextHandles(18),'string');
set(ahTextHandles(17),'string',S2);
set(ahTextHandles(18),'string',S1);
setappdata(handles.figure1,'afZFlip',afZFlip);

fnInvalidate(handles);
return;

function hFlipZCoronal_Callback(hObject, eventdata, handles)
strctCrossSectionCoronal = getappdata(handles.figure1,'strctCrossSectionCoronal');
strctCrossSectionCoronal.m_a2fM(1:3,3) = -strctCrossSectionCoronal.m_a2fM(1:3,3);
strctCrossSectionCoronal.m_fViewOffsetMM = -strctCrossSectionCoronal.m_fViewOffsetMM;

strctCrossSectionCoronal.m_bZFlip = ~strctCrossSectionCoronal.m_bZFlip;
afZFlip = getappdata(handles.figure1,'afZFlip');
afZFlip(3) = -afZFlip(3);

ahTextHandles = getappdata(handles.figure1,'ahTextHandles');
S1 = get(ahTextHandles(5),'string');
S2 = get(ahTextHandles(6),'string');
set(ahTextHandles(5),'string',S2);
set(ahTextHandles(6),'string',S1);
setappdata(handles.figure1,'afZFlip',afZFlip);

setappdata(handles.figure1,'strctCrossSectionCoronal',strctCrossSectionCoronal);
fnInvalidate(handles);
return;

function fnMouseWheel(obj,eventdata,handles)
iScroll = eventdata.VerticalScrollCount;
strctAnatVol = getappdata(handles.figure1,'strctAnatVol');
a2fEB0 = getappdata(handles.figure1,'a2fEB0');
bEarBarZeroStage = getappdata(handles.figure1,'bEarBarZeroStage');

if (fnInsideImage(handles,handles.hAxesCoronal))
    % Move BOTH EB0 and cross section
    
    
    strctCrossSectionCoronal = getappdata(handles.figure1,'strctCrossSectionCoronal');
    afDirection = strctCrossSectionCoronal.m_a2fM(:,3);
    strctCrossSectionCoronal.m_fViewOffsetMM = strctCrossSectionCoronal.m_fViewOffsetMM + abs(dot(afDirection(1:3), strctAnatVol.m_strctFreeSurfer.volres)) * iScroll;
    
    setappdata(handles.figure1,'strctCrossSectionCoronal',strctCrossSectionCoronal);
    if bEarBarZeroStage
        a2fEB0(1:3,4) = a2fEB0(1:3,4) + afDirection(1:3) * abs(dot(afDirection(1:3), strctAnatVol.m_strctFreeSurfer.volres)) * iScroll;
        setappdata(handles.figure1,'a2fEB0',a2fEB0);
        if get(handles.hMoveVolume,'value')
            fnRealignToEB0(handles);
        end
    end

    fnInvalidate(handles);
elseif (fnInsideImage(handles,handles.hAxesHoriz))
    strctCrossSectionHoriz = getappdata(handles.figure1,'strctCrossSectionHoriz');
    
    afDirection = strctCrossSectionHoriz.m_a2fM(:,3);
    strctCrossSectionHoriz.m_fViewOffsetMM = strctCrossSectionHoriz.m_fViewOffsetMM + abs(dot(afDirection(1:3), strctAnatVol.m_strctFreeSurfer.volres)) * iScroll;
    
    setappdata(handles.figure1,'strctCrossSectionHoriz',strctCrossSectionHoriz);
    
    
   if bEarBarZeroStage
        a2fEB0(1:3,4) = a2fEB0(1:3,4) + afDirection(1:3) * abs(dot(afDirection(1:3), strctAnatVol.m_strctFreeSurfer.volres)) * iScroll;
        setappdata(handles.figure1,'a2fEB0',a2fEB0);
        if get(handles.hMoveVolume,'value')
            fnRealignToEB0(handles);
        end
    end
    
    fnInvalidate(handles);
elseif (fnInsideImage(handles,handles.hAxesSaggital))
    strctCrossSectionSaggital = getappdata(handles.figure1,'strctCrossSectionSaggital');
    
    afDirection = strctCrossSectionSaggital.m_a2fM(:,3);
    strctCrossSectionSaggital.m_fViewOffsetMM = strctCrossSectionSaggital.m_fViewOffsetMM + abs(dot(afDirection(1:3), strctAnatVol.m_strctFreeSurfer.volres)) * iScroll;
    
     setappdata(handles.figure1,'strctCrossSectionSaggital',strctCrossSectionSaggital);
   if bEarBarZeroStage
        a2fEB0(1:3,4) = a2fEB0(1:3,4) + afDirection(1:3) * abs(dot(afDirection(1:3), strctAnatVol.m_strctFreeSurfer.volres)) * iScroll;
        setappdata(handles.figure1,'a2fEB0',a2fEB0);
        if get(handles.hMoveVolume,'value')
            fnRealignToEB0(handles);
        end
    end

    fnInvalidate(handles);
end

return;








function fnRealignToEB0(handles)
a2fReg = getappdata(handles.figure1,'a2fReg');
a2fEB0 = getappdata(handles.figure1,'a2fEB0');
strctCrossSectionHoriz = getappdata(handles.figure1,'strctCrossSectionHoriz');
strctCrossSectionSaggital = getappdata(handles.figure1,'strctCrossSectionSaggital');
strctCrossSectionCoronal = getappdata(handles.figure1,'strctCrossSectionCoronal');


a2fReg(1:3,4) = a2fReg(1:3,4) + -a2fEB0(1:3,4);
a2fEB0(1:3,4) = 0;


strctCrossSectionHoriz.m_a2fM(1:3,4) = 0;
strctCrossSectionHoriz.m_a2fM(1:3,1:3) = a2fEB0(1:3,1:3);

% % Old code

strctCrossSectionCoronal.m_a2fM(1:3,4) = 0; % 3,1,2
strctCrossSectionCoronal.m_a2fM(1:3,1:3) = a2fEB0(1:3,[1 3 2]);
if strctCrossSectionHoriz.m_bZFlip %&& strctCrossSectionHoriz.m_bLRFlip
    strctCrossSectionCoronal.m_a2fM(1:3,2) = -strctCrossSectionCoronal.m_a2fM(1:3,2);
end

%     
%     
% else
%     strctCrossSectionCoronal.m_a2fM(1:3,4) = 0; % 3,1,2
%     strctCrossSectionCoronal.m_a2fM(1:3,1:3) = a2fEB0(1:3,1:3);
%     a2fRot = fnRotateVectorAboutAxis([0 1 0],pi/2) * fnRotateVectorAboutAxis([0 1 0],pi);
%     strctCrossSectionCoronal.m_a2fM = strctCrossSectionCoronal.m_a2fM * [a2fRot,[0;0;0];[0,0,0,1];];
%     %
% end

 strctCrossSectionSaggital.m_a2fM(1:3,4) = 0; % 3,1,2
strctCrossSectionSaggital.m_a2fM(1:3,1:3) = a2fEB0(1:3,[2 3 1]);
strctCrossSectionSaggital.m_a2fM(1:3,1) = -strctCrossSectionSaggital.m_a2fM(1:3,1);

strctCrossSectionSaggital.m_a2fM
if strctCrossSectionHoriz.m_bZFlip %&& strctCrossSectionHoriz.m_bLRFlip
    strctCrossSectionSaggital.m_a2fM(1:3,2) = -strctCrossSectionSaggital.m_a2fM(1:3,2);
end

    %strctCrossSectionSaggital.m_a2fM(1:3,1) = -strctCrossSectionSaggital.m_a2fM(1:3,1);

%strctCrossSectionSaggital.m_a2fM(1:3,3) = -strctCrossSectionSaggital.m_a2fM(1:3,3);



% New code


setappdata(handles.figure1,'a2fReg',a2fReg);
setappdata(handles.figure1,'a2fEB0',a2fEB0);


setappdata(handles.figure1,'strctCrossSectionHoriz',strctCrossSectionHoriz);
setappdata(handles.figure1,'strctCrossSectionSaggital',strctCrossSectionSaggital);
setappdata(handles.figure1,'strctCrossSectionCoronal',strctCrossSectionCoronal);
%fnInvalidate(handles);

return;


% --- Executes on button press in hReslice.
function hReslice_Callback(hObject, eventdata, handles)
fnRealignToEB0(handles);
fnInvalidate(handles);


function hSliderHoriz_Callback(hObject, eventdata, handles)
strctCrossSectionHoriz = getappdata(handles.figure1,'strctCrossSectionHoriz');
iNewDVValue = get(hObject,'value');
fStepMM = get(handles.hInterPlaneDistanceSlider,'value') / 10;
strctCrossSectionHoriz.m_fViewOffsetMM = iNewDVValue*fStepMM;
setappdata(handles.figure1,'strctCrossSectionHoriz',strctCrossSectionHoriz);
fnInvalidate(handles);
return;

function hSliderSaggital_Callback(hObject, eventdata, handles)
strctCrossSectionSaggital = getappdata(handles.figure1,'strctCrossSectionSaggital');
iNewDVValue = get(hObject,'value');
fStepMM = get(handles.hInterPlaneDistanceSlider,'value') / 10;
strctCrossSectionSaggital.m_fViewOffsetMM = iNewDVValue*fStepMM;
setappdata(handles.figure1,'strctCrossSectionSaggital',strctCrossSectionSaggital);
fnInvalidate(handles);
return;

function hSliderCoronal_Callback(hObject, eventdata, handles)
strctCrossSectionCoronal = getappdata(handles.figure1,'strctCrossSectionCoronal');
iNewDVValue = get(hObject,'value');
fStepMM = get(handles.hInterPlaneDistanceSlider,'value') / 10;

strctCrossSectionCoronal.m_fViewOffsetMM = iNewDVValue*fStepMM;
setappdata(handles.figure1,'strctCrossSectionCoronal',strctCrossSectionCoronal);
fnInvalidate(handles);
return;


% --- Executes on slider movement.
function hInterPlaneDistanceSlider_Callback(hObject, eventdata, handles)
fNewStepMM = get(hObject,'value')/10;
set(handles.hInterPlaneDistanceText,'String',sprintf('%.2f', fNewStepMM));
return;


% --- Executes during object creation, after setting all properties.
function hInterPlaneDistanceSlider_CreateFcn(hObject, eventdata, handles)
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function hInterauralDistSldier_Callback(hObject, eventdata, handles)
set(handles.hInterauralDistText,'String',get(hObject,'value'));
fnInvalidateEarbarZero(handles);

% --- Executes during object creation, after setting all properties.
function hInterauralDistSldier_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hInterauralDistSldier (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in hSphinxCorrection.
function hSphinxCorrection_Callback(hObject, eventdata, handles)
% hObject    handle to hSphinxCorrection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hFlipHorizontalSaggital_Callback(hObject, eventdata, handles);
hFlipSaggitalCoronal_Callback(hObject, eventdata, handles);
hFlipLeftRightHoriz_Callback(hObject, eventdata, handles);
hRotateLeftSaggital_Callback(hObject, eventdata, handles);
hFlipLeftRightSaggital_Callback(hObject, eventdata, handles);
hRotateRightCoronal_Callback(hObject, eventdata, handles);
hFlipLeftRightCoronal_Callback(hObject, eventdata, handles);
hFlipZCoronal_Callback(hObject, eventdata, handles);



% --- Executes on button press in pushbutton28.
function pushbutton28_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




function hVoxelSpacingXEdit_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function hVoxelSpacingYEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes during object creation, after setting all properties.
function hVoxelSpacingZEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Outputs from this function are returned to the command line.
function varargout = OrientationWizard_OutputFcn(hObject, eventdata, handles) 
global g_TMP
varargout{1} = g_TMP;
clear global g_TMP
return;

function hDone_Callback(hObject, eventdata, handles)

bEarBarZeroStage = getappdata(handles.figure1,'bEarBarZeroStage');
if bEarBarZeroStage == false
    setappdata(handles.figure1,'bEarBarZeroStage',1);
    set(handles.hEarbarPanel,'visible','on');
    
    strctCrossSectionHoriz = getappdata(handles.figure1,'strctCrossSectionHoriz');
    
    fnGenerateEarbarZeroPlaneHandles(handles);

    if strctCrossSectionHoriz.m_bZFlip %&& strctCrossSectionHoriz.m_bLRFlip
        hFlipZSaggital_Callback(hObject, eventdata, handles);
    end
    
    fnInvalidateEarbarZero(handles);
    fnRealignToEB0(handles);
    fnInvalidate(handles);
    set(handles.hZeroHorizOffset,'visible','on');
    set(handles.hZeroCoronalOffset,'visible','on');
    set(handles.hZeroSaggitalOffset,'visible','on');
    
else
    % End module
    global g_TMP
    fnRealignToEB0(handles);
    a2fReg = getappdata(handles.figure1,'a2fReg');
    a2fEB0 = getappdata(handles.figure1,'a2fEB0');
    a2fEB0(1:3,4) = -a2fReg(1:3,4);

    strctCrossSectionHoriz = getappdata(handles.figure1,'strctCrossSectionHoriz');
    strctCrossSectionSaggital = getappdata(handles.figure1,'strctCrossSectionSaggital');
    strctCrossSectionCoronal = getappdata(handles.figure1,'strctCrossSectionCoronal');
    strctCrossSectionHoriz.m_a2fM(1:3,4) = -a2fReg(1:3,4);
    strctCrossSectionSaggital.m_a2fM(1:3,4) = -a2fReg(1:3,4);
    strctCrossSectionCoronal.m_a2fM(1:3,4) = -a2fReg(1:3,4);
    
    strctAnatVol = getappdata(handles.figure1,'strctAnatVol');
    strctAnatVol.m_a2fEB0 = a2fEB0;
    strctAnatVol.m_strctCrossSectionHoriz = strctCrossSectionHoriz;
    strctAnatVol.m_strctCrossSectionSaggital = strctCrossSectionSaggital;
    strctAnatVol.m_strctCrossSectionCoronal = strctCrossSectionCoronal;
    
    g_TMP = strctAnatVol;
    delete(gcbf);
end


return;


% --- Executes on button press in hZeroHorizOffset.
function hZeroHorizOffset_Callback(hObject, eventdata, handles)
strctCrossSectionHoriz = getappdata(handles.figure1,'strctCrossSectionHoriz');
strctCrossSectionHoriz.m_fViewOffsetMM = 0;
setappdata(handles.figure1,'strctCrossSectionHoriz',strctCrossSectionHoriz);
fnInvalidate(handles);
return;

% --- Executes on button press in hZeroSaggitalOffset.
function hZeroSaggitalOffset_Callback(hObject, eventdata, handles)
strctCrossSectionSaggital = getappdata(handles.figure1,'strctCrossSectionSaggital');
strctCrossSectionSaggital.m_fViewOffsetMM = 0;
setappdata(handles.figure1,'strctCrossSectionHoriz',strctCrossSectionSaggital);
fnInvalidate(handles);
return;
% --- Executes on button press in hZeroCoronalOffset.
function hZeroCoronalOffset_Callback(hObject, eventdata, handles)
strctCrossSectionCoronal = getappdata(handles.figure1,'strctCrossSectionCoronal');
strctCrossSectionCoronal.m_fViewOffsetMM = 0;
setappdata(handles.figure1,'strctCrossSectionCoronal',strctCrossSectionCoronal);
fnInvalidate(handles);
return;

function fnUpdateScale(handles)
strctMRI = getappdata(handles.figure1,'strctMRI');

fNewZSpacingMM = str2double(get(handles.hVoxelSpacingZEdit,'string'));
fNewXSpacingMM = str2double(get(handles.hVoxelSpacingXEdit,'string'));
fNewYSpacingMM = str2double(get(handles.hVoxelSpacingYEdit,'string'));

strctMRI.tkrvox2ras = [-fNewXSpacingMM          0           0            fNewXSpacingMM * strctMRI.volsize(1)/2;
                              0                 0     fNewZSpacingMM    -fNewZSpacingMM * strctMRI.volsize(3)/2;
                              0          -fNewYSpacingMM    0            fNewYSpacingMM * strctMRI.volsize(2)/2;
                              0                 0           0                      1];
strctMRI.volres = [  fNewXSpacingMM,fNewYSpacingMM,fNewZSpacingMM];
setappdata(handles.figure1,'strctMRI',strctMRI);


aiImageRes = [256,256];
[strctCrossSectionHoriz,strctCrossSectionSaggital,strctCrossSectionCoronal] = fnSetDefaultCrossSections(strctMRI.volsize, strctMRI.tkrvox2ras, aiImageRes(1),aiImageRes(2));
setappdata(handles.figure1,'strctCrossSectionHoriz',strctCrossSectionHoriz);
setappdata(handles.figure1,'strctCrossSectionSaggital',strctCrossSectionSaggital);
setappdata(handles.figure1,'strctCrossSectionCoronal',strctCrossSectionCoronal);


hImageSaggital = getappdata(handles.figure1,'hImageSaggital');
hImageCoronal= getappdata(handles.figure1,'hImageCoronal');
hImageHoriz = getappdata(handles.figure1,'hImageHoriz');
delete([hImageHoriz hImageCoronal hImageSaggital ]);

ahTextHandles = getappdata(handles.figure1,'ahTextHandles');
ahZPosHandles = getappdata(handles.figure1,'ahZPosHandles');
ahLineHandles = getappdata(handles.figure1,'ahLineHandles');
delete([ahTextHandles ahZPosHandles ahLineHandles ]);

afX = linspace(-strctCrossSectionHoriz.m_fHalfWidthMM,strctCrossSectionHoriz.m_fHalfWidthMM, aiImageRes(1));
afY = linspace(-strctCrossSectionSaggital.m_fHalfWidthMM,strctCrossSectionSaggital.m_fHalfWidthMM, aiImageRes(1));
afZ = linspace(-strctCrossSectionCoronal.m_fHalfWidthMM,strctCrossSectionCoronal.m_fHalfWidthMM, aiImageRes(1));

set(handles.hAxesCoronal,'xlim',[afX(1),afX(end)],'ylim',[afY(1),afY(end)]);
set(handles.hAxesHoriz,'xlim',[afY(1),afY(end)],'ylim',[afZ(1),afZ(end)]);
set(handles.hAxesSaggital,'xlim',[afY(1),afY(end)],'ylim',[afZ(1),afZ(end)]);

fnGenerateImagesAndText(handles,zeros(256,256,3),zeros(256,256,3), zeros(256,256,3),0 );

fnInvalidate(handles);
return;

function hCorrectForSebastianScript_Callback(hObject, eventdata, handles)
hRotateLeftHoriz_Callback(hObject, eventdata, handles);
hFlipZHoriz_Callback(hObject, eventdata, handles);
hFlipLeftRightHoriz_Callback(hObject, eventdata, handles);


% --- Executes on button press in hAutoCorrect.
function hAutoCorrect_Callback(hObject, eventdata, handles)
% hObject    handle to hAutoCorrect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

hFlipSaggitalCoronal_Callback(hObject, eventdata, handles)
hFlipHorizontalSaggital_Callback(hObject, eventdata, handles);

hRotateLeftHoriz_Callback(hObject, eventdata, handles);
hRotateLeftHoriz_Callback(hObject, eventdata, handles);

hFlipZHoriz_Callback(hObject, eventdata, handles);
set(handles.hAutoCorrect,'enable','off');
