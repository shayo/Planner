function fnRegisterationCallback(strCallback, varargin)
global g_strctWindows g_strctModule
switch strCallback
    case 'RunFLIRT'
        fnRunFLIRT();
    case 'ResetReg'
        fnResetReg();
    case 'SolveMarkers'
        fnSolveMarkers();
    case 'DelMarker'
        fnDelMarker();
    case 'SelectMarker'
        fnSelectMarker();
    case 'UpdateMarker'
        fnUpdateMarker();
    case 'SetContrastMode'
        g_strctModule.m_strMouseMode = 'Contrast';
    case 'AddMarker'
        fnAddMarker();
    case 'MouseMove'
        strctMouseOp = varargin{1};
        fnMouseMove(strctMouseOp);
    case 'MouseUp'
        strctMouseOp = varargin{1};
        fnMouseUp(strctMouseOp);
    case 'MouseDown'
        strctMouseOp = varargin{1};
        fnMouseDown(strctMouseOp);
    case 'MouseWheel'
        strctMouseOp = varargin{1};
        fnMouseWheel(strctMouseOp);
    case 'Invalidate'
        fnInvalidate();
    case 'SetTranslateMovable'
        fnSetTranslateMovable();
    case 'SetSlicesMode'
        fnSetSliceMode();
%     case 'SetContrastMode'
%        fnSetContrastMode();
    case 'SetZoomMode'
        g_strctModule.m_strMouseMode = 'Zoom';
    case 'SetZoomLinkedMode'
        g_strctModule.m_strMouseMode = 'ZoomLink';
    case 'SetPanMode'
        fnSetPanMode();
    case 'SetCrosshairMode'
        fnSetCrosshairMode();
    case 'SetDefaultView'
        fnSetDefaultCrossSections2();
        fnInvalidate();
    case 'LoadStationary'
        fnLoadStationary();
   case 'LoadMovable'
        fnLoadMovable();
   case 'ShowHideCrosshairs'
        fnHideShowPlanes2D();
    case 'SetFocus'
        fnSetFocus();
    case 'SetRotate2DMode'
        fnSetRotateMovable();
    case 'SetContrastModeStationary'
        fnSetContrastModeStationary();
    case 'SetContrastModeMovable'
        fnSetContrastModeMovable();
    case 'SaveReg'
        fnSaveReg();
    case 'LoadReg'
        fnLoadreg();
    case 'AutoReg'
        fnAutoReg();
    case 'KeyDown'
        fnKeyDown(varargin{1});
    case 'KeyUp'
        fnKeyUp(varargin{1});
    case 'SaveSession'
        fnSaveSession();
    case 'LoadSession'
        fnLoadSession();
    case 'Undo'
        fnUndoReg();
    otherwise
        dbg = 1;
end

return;

function fnRunFLIRT()
return;


function fnKeyDown(strctKey)
global g_strctModule
if strcmpi(strctKey.Key,'space')
    if g_strctModule.m_bDrawMovInStat == false
    g_strctModule.m_bDrawMovInStat = true;
    fnInvalidate(1);
    drawnow
    end
    % Flip ?
end

return;

function fnKeyUp(strctKey)
global g_strctModule


if strcmpi(strctKey.Key,'space')
g_strctModule.m_bDrawMovInStat = false;
fnInvalidate(1);
drawnow
    
   % fnToggleFlip();
    % Flip ?
end

return;

function fnToggleFlip()
global g_strctModule

if ~isfield(g_strctModule,'m_bToggleFlip')
    g_strctModule.m_bToggleFlip = false;
end;
g_strctModule.m_bToggleFlip = ~g_strctModule.m_bToggleFlip;
if g_strctModule.m_bToggleFlip
    % Just turned on. Start timer
%     g_strctModule.m_hToggleFlipTimer = timer('TimerFcn',@fnFlipAndInvalidate, 'Period', 0.1,'ExecutionMode','fixedDelay');
%     start(g_strctModule.m_hToggleFlipTimer);
else
    % Just turned off. Stop timer
%     stop(g_strctModule.m_hToggleFlipTimer);
end

return;

function fnFlipAndInvalidate(a,b)
global g_strctModule
if ~isfield(g_strctModule,'m_bDrawMovInStat')
    g_strctModule.m_bDrawMovInStat = false;
end;
g_strctModule.m_bDrawMovInStat = ~g_strctModule.m_bDrawMovInStat;
fnInvalidate(1);
drawnow
return;



function fnResetReg()
fnModifyReg(eye(4));
fnInvalidate(1);
return;


function fnSolveMarkers()
global g_strctModule
% Convert markers to XYZ (mm)

a2fCRS_To_XYZ_Stat = g_strctModule.m_strctStationaryVol.m_a2fM; 
a2fCRS_To_XYZ_Mov =  g_strctModule.m_strctMovableVol.m_a2fM; 

apt3fMarkersStatMM = a2fCRS_To_XYZ_Stat * [g_strctModule.m_a2fMarkersStat'; ones(1,size(g_strctModule.m_a2fMarkersStat,1))];
apt3fMarkersMovMM = a2fCRS_To_XYZ_Mov * [g_strctModule.m_a2fMarkersMov'; ones(1,size(g_strctModule.m_a2fMarkersMov,1))];


[s, R, T, err] = fnAbsoluteOrientation(apt3fMarkersStatMM(1:3,:), apt3fMarkersMovMM(1:3,:), 0, 1);
a2fTrans = [s*R, T;0,0,0,1];
fnModifyReg(inv(a2fTrans));
fnInvalidate(1);
return;


function fnDelMarker()
global g_strctModule
iNumEntries = size(g_strctModule.m_a2fMarkersStat,1);
iSelectedMarker = get(g_strctModule.m_strctPanel.m_hMarkersList,'value');
if iNumEntries == 0
    return;
end;

g_strctModule.m_a2fMarkersStat(iSelectedMarker,:) = [];
g_strctModule.m_a2fMarkersMov(iSelectedMarker,:) = [];
fnUpdateMarkersList();

return;

function fnShiftMovCrossHairsToLocation(pt3fMovMarker_XYZ_mm)
global g_strctModule
for k=1:3
    N1 = g_strctModule.m_astrctMovCrossSection(k).m_a2fM(1:3,3);
    d1 = -g_strctModule.m_astrctMovCrossSection(k).m_a2fM(1:3,4)' * N1;
    t1 = N1' * pt3fMovMarker_XYZ_mm(1:3) + d1;
    g_strctModule.m_astrctMovCrossSection(k).m_a2fM(1:3,4) = g_strctModule.m_astrctMovCrossSection(k).m_a2fM(1:3,4) + t1 * N1;
end
return;


function fnShiftStatCrossHairsToLocation(pt3fStatMarker_XYZ_mm)
global g_strctModule
for k=1:3
    N1 = g_strctModule.m_astrctStatCrossSection(k).m_a2fM(1:3,3);
    d1 = -g_strctModule.m_astrctStatCrossSection(k).m_a2fM(1:3,4)' * N1;
    t1 = N1' * pt3fStatMarker_XYZ_mm(1:3) + d1;
    g_strctModule.m_astrctStatCrossSection(k).m_a2fM(1:3,4) = g_strctModule.m_astrctStatCrossSection(k).m_a2fM(1:3,4) + t1 * N1;
 end
return;

function fnSelectMarker()
global g_strctModule
iNumEntries = size(g_strctModule.m_a2fMarkersStat,1);
iSelectedMarker = get(g_strctModule.m_strctPanel.m_hMarkersList,'value');
if iNumEntries == 0
    return;
end;

a2fReg = fnGetCurrentReg();

a2fCRS_To_XYZ_Stat = g_strctModule.m_strctStationaryVol.m_a2fReg * g_strctModule.m_strctStationaryVol.m_a2fM; 
a2fCRS_To_XYZ_Mov =  a2fReg * g_strctModule.m_strctMovableVol.m_a2fM; 

pt3fStatMarker_XYZ_mm = a2fCRS_To_XYZ_Stat * [g_strctModule.m_a2fMarkersStat(iSelectedMarker,:),1]';
pt3fMovMarker_XYZ_mm = a2fCRS_To_XYZ_Mov * [g_strctModule.m_a2fMarkersMov(iSelectedMarker,:),1]';

% There are infinite ways to move the viewing planes such that
% they will intersect at the desired points. 
% we choose the current combination that is being displayed.
% that is, we will only translate the planes along their vector such that
% they reach the desired point. 
fnShiftMovCrossHairsToLocation(pt3fMovMarker_XYZ_mm);
fnShiftStatCrossHairsToLocation(pt3fStatMarker_XYZ_mm);
% pt3fStatIntersectionXYZ_MM = ThreePlaneIntersection(g_strctModule.m_astrctStatCrossSection);
% pt3fMovIntersectionXYZ_MM = ThreePlaneIntersection(g_strctModule.m_astrctMovCrossSection);

fnInvalidate(1);

return;


function pt3fIntersectionXYZ_MM = ThreePlaneIntersection(astrctCrossSecions)
% Compute the intersection of all three planes
N1 = astrctCrossSecions(1).m_a2fM(1:3,3);
N2 = astrctCrossSecions(2).m_a2fM(1:3,3);
N3 = astrctCrossSecions(3).m_a2fM(1:3,3);
d1 = astrctCrossSecions(1).m_a2fM(1:3,4)' * N1;
d2 = astrctCrossSecions(2).m_a2fM(1:3,4)' * N2;
d3 = astrctCrossSecions(3).m_a2fM(1:3,4)' * N3;
pt3fIntersectionXYZ_MM = (d1 * cross(N2,N3) + d2 * cross(N3,N1) + d3 * cross(N1,N2)) / (N1' * cross(N2,N3));
return;

function fnUpdateMarker()
global g_strctModule
iNumEntries = size(g_strctModule.m_a2fMarkersStat,1);
iSelectedMarker = get(g_strctModule.m_strctPanel.m_hMarkersList,'value');
if iNumEntries == 0
    return;
end;
pt3fStatIntersectionXYZ_MM = ThreePlaneIntersection(g_strctModule.m_astrctStatCrossSection);
pt3fMovIntersectionXYZ_MM = ThreePlaneIntersection(g_strctModule.m_astrctMovCrossSection);
% Transform to volume coordinates
a2fReg = fnGetCurrentReg();
a2fXYZ_To_CRS_Stat = inv(g_strctModule.m_strctStationaryVol.m_a2fM) * inv(g_strctModule.m_strctStationaryVol.m_a2fReg); 
a2fXYZ_To_CRS_Mov = inv(g_strctModule.m_strctMovableVol.m_a2fM) * inv(a2fReg); 
pt3fStatIntersectionCRS = a2fXYZ_To_CRS_Stat*[pt3fStatIntersectionXYZ_MM;1];
pt3fMovIntersectionCRS = a2fXYZ_To_CRS_Mov*[pt3fMovIntersectionXYZ_MM;1];

g_strctModule.m_a2fMarkersStat(iSelectedMarker,:) = pt3fStatIntersectionCRS(1:3);
g_strctModule.m_a2fMarkersMov(iSelectedMarker,:) = pt3fMovIntersectionCRS(1:3);
return;


function fnAddMarker()
global g_strctModule
if isempty(g_strctModule.m_strctStationaryVol) || isempty(g_strctModule.m_strctMovableVol) 
    return;
end;
pt3fStatIntersectionXYZ_MM = ThreePlaneIntersection(g_strctModule.m_astrctStatCrossSection);
pt3fMovIntersectionXYZ_MM = ThreePlaneIntersection(g_strctModule.m_astrctMovCrossSection);
% Transform to volume coordinates
a2fReg = fnGetCurrentReg();
a2fXYZ_To_CRS_Stat = inv(g_strctModule.m_strctStationaryVol.m_a2fM) * inv(g_strctModule.m_strctStationaryVol.m_a2fReg); 
a2fXYZ_To_CRS_Mov = inv(g_strctModule.m_strctMovableVol.m_a2fM) * inv(a2fReg); 
pt3fStatIntersectionCRS = a2fXYZ_To_CRS_Stat*[pt3fStatIntersectionXYZ_MM;1];
pt3fMovIntersectionCRS = a2fXYZ_To_CRS_Mov*[pt3fMovIntersectionXYZ_MM;1];

iNewEntry = size(g_strctModule.m_a2fMarkersStat,1) + 1;
g_strctModule.m_a2fMarkersStat(iNewEntry,:) = pt3fStatIntersectionCRS(1:3);
g_strctModule.m_a2fMarkersMov(iNewEntry,:) = pt3fMovIntersectionCRS(1:3);

fnUpdateMarkersList();

return;

function fnUpdateMarkersList()
global g_strctModule
% Update marker list
iNumMarkers = size(g_strctModule.m_a2fMarkersStat,1);
acMarkerName = cell(1,iNumMarkers);
for k=1:iNumMarkers
    acMarkerName{k} = sprintf('Marker %d',k);
end;
set(g_strctModule.m_strctPanel.m_hMarkersList,'string',char(acMarkerName),'value',iNumMarkers);
return;

function fnAutoReg()
global g_strctModule

return;

function fnSaveReg()
global g_strctModule
if isempty(g_strctModule.m_strctMovableVol) || isempty(g_strctModule.m_strctStationaryVol)
    return;
end;
[strPath,strMovName] = fileparts(g_strctModule.m_strctMovableVol.m_strFileName);
[strPath,strStatName] = fileparts(g_strctModule.m_strctStationaryVol.m_strFileName);
[strFile,strPath] = uiputfile(['Reg_',strMovName,'_To_',strStatName,'.reg']);
if strFile(1) == 0
    return;
end;
a2fReg = fnGetCurrentReg();
fnWriteRegisteration([strPath, strFile],a2fReg,'Subject-Unknown',...
    'round',g_strctModule.m_strctMovableVol.m_afVoxelSpacing);
return;

function fnLoadreg()
global g_strctModule
[strFile,strPath] = uigetfile('*.reg');
if strFile(1) == 0
    return;
end;
a2fReg = fnReadRegisteration([strPath, strFile]);
fnModifyReg(a2fReg);
fnInvalidate(1);
return;

function fnSetRotateMovable()
global g_strctModule
g_strctModule.m_strMouseMode = 'RotateMovable';

return;

% function fnSetFocus()
% global g_strctModule
% hAxes  = g_strctModule.m_strctMouseOpMenu.m_hAxes;
% if isempty(hAxes)
%     return;
% end;
% 
% switch hAxes 
%     case g_strctModule.m_strctPanel.m_strctXY.m_hAxes
%         % Transform the clicked point to 3D coordinates
%         pt2fPosMM = fnCrossSection_Image_To_MM(g_strctModule.m_strctCrossSectionXY, g_strctModule.m_strctMouseOpMenu.m_pt2fPos);
%         pt3fPosMMOnPlane = [pt2fPosMM,0,1]';
%         pt3fPosInVol = g_strctModule.m_strctCrossSectionXY.m_a2fM*pt3fPosMMOnPlane;
%    
%     case g_strctModule.m_strctPanel.m_strctYZ.m_hAxes
%         pt2fPosMM = fnCrossSection_Image_To_MM(g_strctModule.m_strctCrossSectionYZ, g_strctModule.m_strctMouseOpMenu.m_pt2fPos);
%         pt3fPosMMOnPlane = [pt2fPosMM,0,1]';
%         pt3fPosInVol = g_strctModule.m_strctCrossSectionYZ.m_a2fM*pt3fPosMMOnPlane;
%     case g_strctModule.m_strctPanel.m_strctXZ.m_hAxes        
%          pt2fPosMM = fnCrossSection_Image_To_MM(g_strctModule.m_strctCrossSectionXZ, g_strctModule.m_strctMouseOpMenu.m_pt2fPos);
%         pt3fPosMMOnPlane = [pt2fPosMM,0,1]';
%         pt3fPosInVol = g_strctModule.m_strctCrossSectionXZ.m_a2fM*pt3fPosMMOnPlane;
% end;
%  g_strctModule.m_strctCrossSectionXY.m_fHalfWidthMM = 15;
%  g_strctModule.m_strctCrossSectionXY.m_fHalfHeightMM = 15;
%  g_strctModule.m_strctCrossSectionXZ.m_fHalfWidthMM = 15;
%  g_strctModule.m_strctCrossSectionXZ.m_fHalfHeightMM = 15;
%  g_strctModule.m_strctCrossSectionYZ.m_fHalfWidthMM = 15;
%  g_strctModule.m_strctCrossSectionYZ.m_fHalfHeightMM = 15;
%  g_strctModule.m_strctCrossSectionXY.m_a2fM(1:3,4) = pt3fPosInVol(1:3);
%  g_strctModule.m_strctCrossSectionYZ.m_a2fM(1:3,4) = pt3fPosInVol(1:3);
%  g_strctModule.m_strctCrossSectionXZ.m_a2fM(1:3,4) = pt3fPosInVol(1:3);
% fnInvalidate(1);
% return;

function fnSetTranslateMovable()
global g_strctModule
g_strctModule.m_strMouseMode = 'TranslateMovable';
return;

function fnSaveSession()
global g_strctModule
[strFile,strPath]=uiputfile('RegisterationSession.mat');
if strFile(1) == 0
    return;
end;
save([strPath,strFile],'g_strctModule');
msgbox('Session Saved');
return;

function fnLoadSession()
global g_strctModule
[strFile,strPath]=uigetfile('*.mat');
if strFile(1) == 0
    return;
end;
strctSavedSession= load([strPath,strFile]);
fnUpdateMarkersList();
fnInvalidate(true);
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
return;


function fnHideShowPlanes2D()
global g_strctModule
g_strctModule.m_strctGUIOptions.m_bShow2DPlanes = ~g_strctModule.m_strctGUIOptions.m_bShow2DPlanes;

if g_strctModule.m_strctGUIOptions.m_bShow2DPlanes
    set(g_strctModule.m_strctPanel.m_a2hStatCrossHairLines(:),'visible','on')
else
    set(g_strctModule.m_strctPanel.m_a2hStatCrossHairLines(:),'visible','off')
end;

fnInvalidate();
return;



function strctAnatVol = fnCreateAnatVolStructure(strInputfile)
AnatVol = MRIread(strInputfile);
if size(AnatVol.vol,4) > 1
    % This is a 4D Volume. Probably trying to register functional scan to
    % anatomical scan. 
    % Let's take the mean value...
    AnatVol.vol = mean(AnatVol.vol,4);
end

strctAnatVol.m_strFileName = strInputfile;
[strPath,strFile] = fileparts(strInputfile);
strctAnatVol.m_strName = strFile;
strctAnatVol.m_afVoxelSpacing = AnatVol.volres;
strctAnatVol.m_aiVolSize = size(AnatVol.vol);%[256 256 256]; %row, col, slice
strctAnatVol.m_a3fVol = AnatVol.vol;
strctAnatVol.m_a2fM = AnatVol.vox2ras0; %AnatVol.tkrvox2ras;
strctAnatVol.m_a2fReg = eye(4);

afCoord0 =  strctAnatVol.m_a2fReg *strctAnatVol.m_a2fM * [0,0,0,1]';
afCoordMax =  strctAnatVol.m_a2fReg *strctAnatVol.m_a2fM * [strctAnatVol.m_aiVolSize([2,1,3]),1]';
strctAnatVol.m_afRangeMM = [min(afCoord0(1:3),afCoordMax(1:3)), max(afCoord0(1:3),afCoordMax(1:3))];

fMin = min(strctAnatVol.m_a3fVol(:));
fMax = max(strctAnatVol.m_a3fVol(:));

strctLinearHistogramStretch.m_strType = 'Linear';
strctLinearHistogramStretch.m_fMin = double(fMin);
strctLinearHistogramStretch.m_fMax = double(fMax);
strctLinearHistogramStretch.m_fRange = double(fMax-fMin);
strctLinearHistogramStretch.m_fCenter = double(fMin + (fMax-fMin)/2);
strctLinearHistogramStretch.m_fWidth  = double(fMax-fMin);
strctAnatVol.m_strctContrastTransform = strctLinearHistogramStretch;


return;


function fnSetDefaultCrossSections2( )
global g_strctModule
% prepare cross sections
iResWidth = g_strctModule.m_strctPanel.m_aiImageRes(2);
iResHeight = g_strctModule.m_strctPanel.m_aiImageRes(1);
a2fXY =  [1,0,0  0;
    0 -1 0  0;
    0 0 1  0;
    0 0 0  1];

a2fXZ = [1,0,0  0;
    0 0 1  0;
    0 -1 0  0;
    0 0 0  1]; % This gives coronal slice such that Y = 0 is superior

a2fYZ = [0 0 1  0;
    1 0 0  0;
    0,-1,0  0;
    0 0 0  1]; % This gives coronal slice such that Y = 0 is superior

a3fDefaultView(:,:,1) = a2fXY;
a3fDefaultView(:,:,2) = a2fXZ;
a3fDefaultView(:,:,3) = a2fYZ;

if isfield(g_strctModule,'m_strctStationaryVol') && ~isempty(g_strctModule.m_strctStationaryVol)
    fWidth = (g_strctModule.m_strctStationaryVol.m_afRangeMM(1,2)-...
        g_strctModule.m_strctStationaryVol.m_afRangeMM(1,1))/2 -1;
    fHeight = (g_strctModule.m_strctStationaryVol.m_afRangeMM(2,2)-...
        g_strctModule.m_strctStationaryVol.m_afRangeMM(2,1))/2 - 1;
    
    for iIter=1:3
        astrctStatCrossSection(iIter).m_a2fM = a3fDefaultView(:,:,iIter);
        astrctStatCrossSection(iIter).m_fHalfWidthMM = max(fWidth,fHeight);
        astrctStatCrossSection(iIter).m_fHalfHeightMM = max(fWidth,fHeight);
        astrctStatCrossSection(iIter).m_iResWidth = iResWidth;
        astrctStatCrossSection(iIter).m_iResHeight = iResHeight;
    end
    g_strctModule.m_astrctStatCrossSection = astrctStatCrossSection;
    
end

%%
if isfield(g_strctModule,'m_strctMovableVol') && ~isempty(g_strctModule.m_strctMovableVol)
    fWidth = (g_strctModule.m_strctMovableVol.m_afRangeMM(1,2)-...
        g_strctModule.m_strctMovableVol.m_afRangeMM(1,1))/2 -1;
    fHeight = (g_strctModule.m_strctMovableVol.m_afRangeMM(2,2)-...
        g_strctModule.m_strctMovableVol.m_afRangeMM(2,1))/2 - 1;
    
    for iIter=1:3
        astrctStatCrossSection(iIter).m_a2fM = a3fDefaultView(:,:,iIter);
        astrctStatCrossSection(iIter).m_fHalfWidthMM = max(fWidth,fHeight);
        astrctStatCrossSection(iIter).m_fHalfHeightMM = max(fWidth,fHeight);
        astrctStatCrossSection(iIter).m_iResWidth = iResWidth;
        astrctStatCrossSection(iIter).m_iResHeight = iResHeight;
    end
    g_strctModule.m_astrctMovCrossSection = astrctStatCrossSection;
end
return;

function fnLoadStationary()
global g_strctModule
    
[strFile, strPath] = uigetfile([g_strctModule.m_strDefaultFilesFolder,'*.mgz;*.nii']);
if strFile(1) == 0
    return;
end;
strInputfile = [strPath,strFile];
g_strctModule.m_strctStationaryVol = fnCreateAnatVolStructure(strInputfile);
set(g_strctModule.m_strctPanel.m_hLoadMovableVolBut,'enable','on');
fnInvalidate(1);
return;


function fnModifyReg(a2fNewReg)
global g_strctModule
g_strctModule.m_a3fPrevReg(:,:,g_strctModule.m_iUndoIndex) = a2fNewReg;
g_strctModule.m_iUndoIndex = g_strctModule.m_iUndoIndex + 1;
if g_strctModule.m_iUndoIndex > g_strctModule.m_iNumUndoOpBuffer
    g_strctModule.m_iUndoIndex = g_strctModule.m_iNumUndoOpBuffer;
    % rotate buffer (and loose first entry)
    g_strctModule.m_a3fPrevReg(:,:,1:g_strctModule.m_iNumUndoOpBuffer-1) = g_strctModule.m_a3fPrevReg(:,:,2:g_strctModule.m_iNumUndoOpBuffer);
end
return;

function a2fReg = fnGetCurrentReg()
global g_strctModule
a2fReg = g_strctModule.m_a3fPrevReg(:,:,g_strctModule.m_iUndoIndex-1);
return;


function fnUndoReg()
global g_strctModule
if g_strctModule.m_iUndoIndex > 2
    g_strctModule.m_iUndoIndex = g_strctModule.m_iUndoIndex - 1;
    fnInvalidate();
end
return;

function fnEraseUndoHistory()
global g_strctModule
g_strctModule.m_iUndoIndex = 2;
g_strctModule.m_a3fPrevReg(:,:,1) = eye(4);
return;

function fnLoadMovable()
global g_strctModule
% if isfield(g_strctModule,'m_strctStationaryVol') && isempty(g_strctModule.m_strctStationaryVol)
%     msgbox('Please load the stationary volume first.');
%     return;
% end;
[strFile, strPath] = uigetfile([g_strctModule.m_strDefaultFilesFolder,'*.mgz;*.nii']);
if strFile(1) == 0
    return;
end;
strInputfile = [strPath,strFile];
g_strctModule.m_strctMovableVol = fnCreateAnatVolStructure(strInputfile);
g_strctModule.m_bVolumeLoaded = true;
fnSetDefaultCrossSections2();
fnEraseUndoHistory();
fnInvalidate(1);

return;



function fScale = fnGetAxesScaleFactor(hAxes)
global g_strctModule

iIndex = find(hAxes==cat(1,g_strctModule.m_strctPanel.m_astrctCrossSection.m_hAxes));
if iIndex <= 3
    fScale =  g_strctModule.m_astrctMovCrossSection(iIndex).m_iResHeight/  (2*g_strctModule.m_astrctMovCrossSection(iIndex).m_fHalfHeightMM);
else
    fScale =  g_strctModule.m_astrctStatCrossSection(iIndex-3).m_iResHeight/  (2*g_strctModule.m_astrctStatCrossSection(iIndex-3).m_fHalfHeightMM);
end


return

function fnHandleMouseMoveWhileDown(strctPrevMouseOp, strctMouseOp)

global g_strctModule
afDelta= strctMouseOp.m_pt2fPos - strctPrevMouseOp.m_pt2fPos;
afDiff = g_strctModule.m_strctLastMouseDown.m_pt2fPos - strctMouseOp.m_pt2fPos;

% If user press cross section lines:
if ~isempty(g_strctModule.m_strctLastMouseDown.m_hAxesSelected) && isfield(g_strctModule.m_strctLastMouseDown,'m_strAxisOp')
    bPan = strcmp(g_strctModule.m_strctLastMouseDown.m_strAxisOp,'Pan');
    fScale = fnGetAxesScaleFactor(g_strctModule.m_strctLastMouseDown.m_hAxes);
    
    
    
    ahAxes = cat(1,g_strctModule.m_strctPanel.m_astrctCrossSection.m_hAxes);
    iAxesIndex = find(g_strctModule.m_strctLastMouseDown.m_hAxesSelected == ahAxes(:));
    a2iLookupTable = [3,2;3,1;1,2];
    if iAxesIndex <=3
        % Movable
        % Axes, Line -> Which plane to move
        iPlaneIndexToMove = a2iLookupTable(iAxesIndex, g_strctModule.m_strctLastMouseDown.m_iLineIndexSelected);
    else
        % Stationary
        iPlaneIndexToMove = 3+a2iLookupTable(iAxesIndex-3, g_strctModule.m_strctLastMouseDown.m_iLineIndexSelected);
    end
      
    if bPan
        if iAxesIndex == 2 || iAxesIndex == 5
            afDelta  = -afDelta ;
        end
        
       fnShiftPlane(ahAxes(iPlaneIndexToMove), (1/fScale)*sum(afDelta .* g_strctModule.m_strctLastMouseDown.m_afAxesPen));
    else
        %fnRotatePlane(ahAxes(iPlaneIndexToMove), (1/fScale)*sum(-afDelta .* g_strctModule.m_strctLastMouseDown.m_afAxesPen));
    end;   
    fnInvalidate();
    return;
end;

ahAxes = cat(1,g_strctModule.m_strctPanel.m_astrctCrossSection.m_hAxes);
iAxesIndex = find(ahAxes == strctMouseOp.m_hAxes);
    
switch g_strctModule.m_strMouseMode
    case 'Scroll'
    case 'Contrast'
        if ~isempty(iAxesIndex)
            if iAxesIndex <= 3
                fnSetNewContrastLevelMovable(afDelta);
            else
                fnSetNewContrastLevelStationary(afDelta);
            end
        end
%     case 'Rotate2D'
%         fnRotateAxesInPlane(g_strctModule.m_strctLastMouseDown.m_hAxes,afDelta);
    case 'Zoom'
        fnSetNewZoomLevel(g_strctModule.m_strctLastMouseDown.m_hAxes,afDelta,false);
    case 'ZoomLink'
        fnSetNewZoomLevel(g_strctModule.m_strctLastMouseDown.m_hAxes,afDelta,true);
    case 'Pan'
         if ~isempty(iAxesIndex)
            if iAxesIndex <= 3
                fnTranslateMovableAux(iAxesIndex,afDelta);
            else
                % Do not move stationary....
            end
        end
     case 'RotateMovable'
        if ~isempty(iAxesIndex)
            if iAxesIndex <= 3
                if iAxesIndex == 3
                    afDelta = -afDelta;
                end
                
                fnRotateAxesInPlane(iAxesIndex,afDelta/4);
            else
                % Do not move stationary....
            end
        end
end;
return;


function fnTranslateMovableAux(iAxesIndex, afDelta)
global g_strctModule
    a2iLookupTable = [3,2;
                      3,1;
                      2,1];

                  
a2fReg = fnGetCurrentReg();
pt3fCurrPos = a2fReg(1:3,4);
pt3fNewPos = pt3fCurrPos + ...
                +afDelta(1) * g_strctModule.m_astrctMovCrossSection( a2iLookupTable(iAxesIndex,1)).m_a2fM(1:3,3) + ...
                -afDelta(2) * g_strctModule.m_astrctMovCrossSection( a2iLookupTable(iAxesIndex,2)).m_a2fM(1:3,3);
a2fReg(1:3,4) = pt3fNewPos;
 fnModifyReg(a2fReg);
 fnInvalidate(1);
 
 
%     
%     switch hAxes
%         
%         case g_strctModule.m_strctPanel.m_strctXY.m_hAxes
%             pt3fNewPos = pt3fCurrPos + ...
%                 -afDelta(1) * g_strctModule.m_strctCrossSectionXY.m_a2fM(1:3,1) + ...
%                 -afDelta(2) * g_strctModule.m_strctCrossSectionXY.m_a2fM(1:3,2);
%             g_strctModule.m_strctMovableVol.m_a2fReg(1:3,4) = pt3fNewPos;
%         case g_strctModule.m_strctPanel.m_strctYZ.m_hAxes
%             pt3fNewPos = pt3fCurrPos + ...
%                 -afDelta(1) * g_strctModule.m_strctCrossSectionYZ.m_a2fM(1:3,1) + ...
%                 -afDelta(2) * g_strctModule.m_strctCrossSectionYZ.m_a2fM(1:3,2);
%             g_strctModule.m_strctMovableVol.m_a2fReg(1:3,4) = pt3fNewPos;
%         case g_strctModule.m_strctPanel.m_strctXZ.m_hAxes
%             pt3fNewPos = pt3fCurrPos + ...
%                 -afDelta(1) * g_strctModule.m_strctCrossSectionXZ.m_a2fM(1:3,1) + ...
%                 -afDelta(2) * g_strctModule.m_strctCrossSectionXZ.m_a2fM(1:3,2);
%             g_strctModule.m_strctMovableVol.m_a2fReg(1:3,4) = pt3fNewPos;
%     end;



return;


function fnSetNewZoomLevel(hAxes, afDelta,bLinked)
global g_strctModule
fDiff = -afDelta(2)/2;
if ~isempty(hAxes)
    ahAxes = cat(1,g_strctModule.m_strctPanel.m_astrctCrossSection.m_hAxes);
    iAxesIndex = find(hAxes == ahAxes);
    if ~isempty(iAxesIndex)
        if iAxesIndex <= 3 % Mov

            if bLinked
                aiAxesToZoom = 1:3;
            else
                aiAxesToZoom = iAxesIndex;
            end
            
            for j=1:length(aiAxesToZoom)
                g_strctModule.m_astrctMovCrossSection(aiAxesToZoom(j)).m_fHalfWidthMM = g_strctModule.m_astrctMovCrossSection(aiAxesToZoom(j)).m_fHalfWidthMM + fDiff;
                g_strctModule.m_astrctMovCrossSection(aiAxesToZoom(j)).m_fHalfHeightMM = g_strctModule.m_astrctMovCrossSection(aiAxesToZoom(j)).m_fHalfHeightMM + fDiff;
            end
            
        else

            if bLinked
                aiAxesToZoom = 1:3;
            else
                aiAxesToZoom = iAxesIndex-3;
            end
            for j=1:length(aiAxesToZoom)
                g_strctModule.m_astrctStatCrossSection(aiAxesToZoom(j)).m_fHalfWidthMM = g_strctModule.m_astrctStatCrossSection(aiAxesToZoom(j)).m_fHalfWidthMM + fDiff;
                g_strctModule.m_astrctStatCrossSection(aiAxesToZoom(j)).m_fHalfHeightMM = g_strctModule.m_astrctStatCrossSection(aiAxesToZoom(j)).m_fHalfHeightMM + fDiff;            
            end
               
        end
    end
end;

fnInvalidate();
return;



function fnSetNewPanLevel(hAxes, afDelta)
global g_strctModule
if ~isempty(hAxes)
switch hAxes
    case g_strctModule.m_strctPanel.m_strctXY.m_hAxes
        pt3fCurrPos = g_strctModule.m_strctCrossSectionXY.m_a2fM(1:3,4);
        pt3fNewPos = pt3fCurrPos + ...
        -afDelta(1) * g_strctModule.m_strctCrossSectionXY.m_a2fM(1:3,1) + ...
        -afDelta(2) * g_strctModule.m_strctCrossSectionXY.m_a2fM(1:3,2);
        g_strctModule.m_strctCrossSectionXY.m_a2fM(1:3,4) = pt3fNewPos;
    case g_strctModule.m_strctPanel.m_strctYZ.m_hAxes
        pt3fCurrPos = g_strctModule.m_strctCrossSectionYZ.m_a2fM(1:3,4);
        pt3fNewPos = pt3fCurrPos + ...
        -afDelta(1) * g_strctModule.m_strctCrossSectionYZ.m_a2fM(1:3,1) + ...
        -afDelta(2) * g_strctModule.m_strctCrossSectionYZ.m_a2fM(1:3,2);
        g_strctModule.m_strctCrossSectionYZ.m_a2fM(1:3,4) = pt3fNewPos;
    case g_strctModule.m_strctPanel.m_strctXZ.m_hAxes
       pt3fCurrPos = g_strctModule.m_strctCrossSectionXZ.m_a2fM(1:3,4);
        pt3fNewPos = pt3fCurrPos + ...
        -afDelta(1) * g_strctModule.m_strctCrossSectionXZ.m_a2fM(1:3,1) + ...
        -afDelta(2) * g_strctModule.m_strctCrossSectionXZ.m_a2fM(1:3,2);
        g_strctModule.m_strctCrossSectionXZ.m_a2fM(1:3,4) = pt3fNewPos;
end;

fnInvalidate();
end;
return;

function fnSetNewContrastLevelStationary(afDelta)
global g_strctModule

strctLinearHistogramStretch = g_strctModule.m_strctStationaryVol.m_strctContrastTransform;

fMaxWidth = 1255;%max(1,2*strctLinearHistogramStretch.m_fWidth);
strctLinearHistogramStretch.m_fWidth = min(fMaxWidth,max(0,...
    strctLinearHistogramStretch.m_fWidth + afDelta(2)*fMaxWidth/400));
strctLinearHistogramStretch.m_fCenter = min(strctLinearHistogramStretch.m_fMax,...
    max(strctLinearHistogramStretch.m_fMin,...
    strctLinearHistogramStretch.m_fCenter + afDelta(1)*fMaxWidth/400));

g_strctModule.m_strctStationaryVol.m_strctContrastTransform = strctLinearHistogramStretch;
fnInvalidate();
return;

function fnSetNewContrastLevelMovable(afDelta)
global g_strctModule

strctLinearHistogramStretch = g_strctModule.m_strctMovableVol.m_strctContrastTransform;

fMaxWidth = 1255;%max(1,2*strctLinearHistogramStretch.m_fWidth);
strctLinearHistogramStretch.m_fWidth = min(fMaxWidth,max(0,...
    strctLinearHistogramStretch.m_fWidth + afDelta(2)*fMaxWidth/400));
strctLinearHistogramStretch.m_fCenter = min(strctLinearHistogramStretch.m_fMax,...
    max(strctLinearHistogramStretch.m_fMin,...
    strctLinearHistogramStretch.m_fCenter + afDelta(1)*fMaxWidth/400));

g_strctModule.m_strctMovableVol.m_strctContrastTransform = strctLinearHistogramStretch;
fnInvalidate();
return;

function fnUpdateStatusLine(strctMouseOp)
global g_strctModule

% if ~isempty(strctMouseOp.m_pt2fPos)
%     set(g_strctModule.m_strctPanel.m_hStatusLine,'string',sprintf('Mouse at [%.0f %.0f] in %.5f',...
%         strctMouseOp.m_pt2fPos(1),strctMouseOp.m_pt2fPos(2), strctMouseOp.m_hAxes));
% end;

return;

function [hAxes,bCloseToCenter, afPenDir,iLineIndex] = fnIntersectAxis(strctMouseOp)
global g_strctModule g_strctWindows
hAxes = [];
iLineIndex = [];
fThreshold = 5;
afXLim = get(g_strctModule.m_strctPanel.m_astrctCrossSection(1).m_hAxes,'xlim');
iWindowSize = (afXLim(2)-afXLim(1));
fCenterDist = 0.8*(iWindowSize/2);
bCloseToCenter = false;
afPenDir = [];


if ~isempty(strctMouseOp.m_hAxes)
    
    ahAxes = cat(1,g_strctModule.m_strctPanel.m_astrctCrossSection.m_hAxes);
    iAxesIndex = find(strctMouseOp.m_hAxes == ahAxes);
    if iAxesIndex <= 3
        % Movable
        
    [fDist1, fDistFromCenter1,afPenDir1] =fnGetDistanceToLine(strctMouseOp.m_pt2fPos,  g_strctModule.m_strctPanel.m_a2hMovCrossHairLines(iAxesIndex,1));
    [fDist2, fDistFromCenter2,afPenDir2] =fnGetDistanceToLine(strctMouseOp.m_pt2fPos,  g_strctModule.m_strctPanel.m_a2hMovCrossHairLines(iAxesIndex,2));
    else
        
        % Stationary
        iAxesIndex = iAxesIndex-3;
        
    [fDist1, fDistFromCenter1,afPenDir1] =fnGetDistanceToLine(strctMouseOp.m_pt2fPos,  g_strctModule.m_strctPanel.m_a2hStatCrossHairLines(iAxesIndex,1));
    [fDist2, fDistFromCenter2,afPenDir2] =fnGetDistanceToLine(strctMouseOp.m_pt2fPos,  g_strctModule.m_strctPanel.m_a2hStatCrossHairLines(iAxesIndex,2));
   end
    
    
    if fDist1 < fDist2
        if fDist1 < fThreshold
            bCloseToCenter = fDistFromCenter1 < fCenterDist;
            afPenDir = afPenDir1;
            iLineIndex = 1;
            hAxes = strctMouseOp.m_hAxes;
        end
    else
        if fDist2 < fThreshold
            bCloseToCenter = fDistFromCenter2 < fCenterDist;
            afPenDir = afPenDir2;
            iLineIndex = 2;
            hAxes = strctMouseOp.m_hAxes;
        end
        
    end
    
end
%
if ~isempty(hAxes)
    if bCloseToCenter
       set(g_strctWindows.m_hFigure,'Pointer','crosshair');
    else
        set(g_strctWindows.m_hFigure,'Pointer','topl');
    end;
else
    set(g_strctWindows.m_hFigure,'Pointer','arrow');
end;
%topl - diagonal

%       rosshair | {arrow} | watch | topl | 
%topr | botl | botr | circle | cross | 
%fleur | left | right | top | bottom | 
%fullcrosshair | ibeam | custom | hand

return;
        

function [fDist, fDistFromCenter,afPenDir] = fnGetDistanceToLine(pt2fPos, hAxes)
afX = get(hAxes,'xdata');
afY = get(hAxes,'ydata');
fDist = abs(((afX(2)-afX(1)) * (afY(1)-pt2fPos(2)) - (afX(1)-pt2fPos(1))*(afY(2)-afY(1))) / sqrt( (afX(2)-afX(1))^2 + (afY(2)-afY(1))^2));
fDistFromCenter = sqrt( (mean(afX) - pt2fPos(1))^2 + (mean(afY) - pt2fPos(2))^2);
afPenDir = [afY(1)-afY(2), afX(2)-afX(1)] ./ sqrt((afX(2)-afX(1)).^2+ (afY(2)-afY(1)).^2);
return;


function fnMouseMove(strctMouseOp)
global g_strctModule g_strctWindows
if ~g_strctModule.m_bVolumeLoaded
    return;
end;

if isempty(g_strctModule.m_strctPrevMouseOp)
    g_strctModule.m_strctPrevMouseOp = strctMouseOp;
end;
 
% if strcmp(g_strctModule.m_strMouseMode,'TranslateMovable')
%     set(g_strctWindows.m_hFigure,'Pointer','fleur');
% else
%     set(g_strctWindows.m_hFigure,'Pointer','arrow');
% end;

 if ~g_strctModule.m_bFirstInvalidate && g_strctModule.m_strctGUIOptions.m_bShow2DPlanes && ~g_strctModule.m_bMouseDown
     fnIntersectAxis(strctMouseOp);  % Change mouse cursor
 end;


if  ~isempty(strctMouseOp.m_hAxes) 
    if g_strctModule.m_bMouseDown
        fnHandleMouseMoveWhileDown(g_strctModule.m_strctPrevMouseOp, strctMouseOp);
%     else
%         fnUpdateStatusLine(strctMouseOp);
    end;
end;
g_strctModule.m_strctPrevMouseOp = strctMouseOp;
return;

function fnSetAllWindowsMode(strMode)
global g_strctModule            
set(g_strctModule.m_strctPanel.m_strctXY.m_hPanel,'visible',strMode);
set(g_strctModule.m_strctPanel.m_strctYZ.m_hPanel,'visible',strMode);
set(g_strctModule.m_strctPanel.m_strctXZ.m_hPanel,'visible',strMode);
set(g_strctModule.m_strctPanel.m_strctDF.m_hPanel,'visible',strMode);
return;

function fnZoomAxesAux(strField)
global g_strctModule            

iMaxRectSize =  min(g_strctModule.m_strctPanel.m_aiWindowsPanelSize(3:4))-30;
aiZoomPos = [g_strctModule.m_strctPanel.m_aiWindowsPanelSize(1:2), iMaxRectSize,iMaxRectSize];

strctAxes = getfield(g_strctModule.m_strctPanel,strField);
aiCurrPosition = get(strctAxes.m_hPanel,'Position');
if  all(strctAxes.m_aiPos-aiCurrPosition == 0)
    % Zoom in, hide all other windows
    fnSetAllWindowsMode('off');
    set(strctAxes.m_hPanel,'Position',aiZoomPos,'visible','on');
    set(strctAxes.m_hAxes,'Position',aiZoomPos);
else
    % set back to normal size
    fnSetAllWindowsMode('on');
    
   set(strctAxes.m_hPanel,'Position',strctAxes.m_aiPos,'visible','on');
    set(strctAxes.m_hAxes,'Position',g_strctModule.m_strctPanel.m_aiAxesSize);
    
 end;
return;

function fnZoomAxes(hAxes)
global g_strctModule 
if ~isempty(hAxes)
switch hAxes
    case g_strctModule.m_strctPanel.m_strctXY.m_hAxes
        fnZoomAxesAux('m_strctXY');
    case g_strctModule.m_strctPanel.m_strctXZ.m_hAxes
        fnZoomAxesAux('m_strctXZ');
    case g_strctModule.m_strctPanel.m_strctYZ.m_hAxes
        fnZoomAxesAux('m_strctYZ');
    case g_strctModule.m_strctPanel.m_strctDF.m_hAxes
        fnZoomAxesAux('m_strctDF');
end;   
end;
    
return;

function fnMouseDown(strctMouseOp)
global g_strctModule
if ~g_strctModule.m_bVolumeLoaded
    return;
end;

if strcmpi(strctMouseOp.m_strButton,'DoubleClick') && strcmpi(g_strctModule.m_strMouseMode,'Scroll');
    % Move all cross hairs to this position
    
    iIndex = find(strctMouseOp.m_hAxes == cat(1,g_strctModule.m_strctPanel.m_astrctCrossSection.m_hAxes));
    if ~isempty(iIndex)
        if iIndex <= 3
            % Movable
            pt2fPosMM = fnCrossSection_Image_To_MM(g_strctModule.m_astrctMovCrossSection(iIndex), strctMouseOp.m_pt2fPos);
            pt3fPosMMOnPlane = [pt2fPosMM,0,1]';
            pt3fMovMarker_XYZ_mm = g_strctModule.m_astrctMovCrossSection(iIndex).m_a2fM*pt3fPosMMOnPlane;
            fnShiftMovCrossHairsToLocation(pt3fMovMarker_XYZ_mm);
        else
            % Stationary
            pt2fPosMM = fnCrossSection_Image_To_MM(g_strctModule.m_astrctStatCrossSection(iIndex-3), strctMouseOp.m_pt2fPos);
            pt3fPosMMOnPlane = [pt2fPosMM,0,1]';
            pt3fStatMarker_XYZ_mm = g_strctModule.m_astrctStatCrossSection(iIndex-3).m_a2fM*pt3fPosMMOnPlane;
            fnShiftStatCrossHairsToLocation(pt3fStatMarker_XYZ_mm);
            
        end
        fnInvalidate(1);
    end
    return;
end;

if g_strctModule.m_strctGUIOptions.m_bShow2DPlanes
    [strctMouseOp.m_hAxesSelected,bCloseToCenter,afPenDir,strctMouseOp.m_iLineIndexSelected] = fnIntersectAxis(strctMouseOp);
    if bCloseToCenter
        strctMouseOp.m_strAxisOp = 'Pan';
    else
        if strcmpi(g_strctModule.m_strMouseMode,'Pan')
            fnTinyPlaneShift(strctMouseOp.m_hAxesSelected,strctMouseOp.m_iLineIndexSelected,strctMouseOp);
        end
        if strcmpi(g_strctModule.m_strMouseMode,'RotateMovable')
            fnTinyPlaneRotate(strctMouseOp.m_hAxesSelected,strctMouseOp.m_iLineIndexSelected,strctMouseOp);
        end
        
    end;
    strctMouseOp.m_afAxesPen = afPenDir; % Penpendicular direction to selected axes
else
    strctMouseOp.m_hAxesSelected = [];
    strctMouseOp.m_hAxesLineSelected = [];
    strctMouseOp.m_afAxesPen = [];
end;

g_strctModule.m_strctLastMouseDown = strctMouseOp;
g_strctModule.m_bMouseDown = true;


return;
       
function fnMouseUp(strctMouseOp)
global g_strctModule
g_strctModule.m_strctLastMouseUp = strctMouseOp;
g_strctModule.m_bMouseDown = false;

return;

 
function fnMouseWheel(strctMouseOp)
global g_strctModule
if isempty(strctMouseOp.m_hAxes) || ~g_strctModule.m_bVolumeLoaded || isempty(g_strctModule.m_strctMovableVol)
    return;
end;
% g_strctModule.m_iDisplayMode = g_strctModule.m_iDisplayMode + strctMouseOp.m_iScroll;
% if g_strctModule.m_iDisplayMode > g_strctModule.m_iNumDisplayModes 
%     g_strctModule.m_iDisplayMode = 1;
% end;
% if g_strctModule.m_iDisplayMode <= 0
%     g_strctModule.m_iDisplayMode = g_strctModule.m_iNumDisplayModes;
% end;

fnInvalidate();
% if strctMouseOp.m_hAxes  == g_strctModule.m_strctPanel.m_strctXY.m_hAxes
%     strctMouseOp.m_iScroll = -strctMouseOp.m_iScroll;
% end;
% 
% fnShiftPlane(strctMouseOp.m_hAxes , 0.5*strctMouseOp.m_iScroll)

return;


function fnRotateAxesInPlane(iAxesIndex,afDelta)
global g_strctModule
a2iLookupTable = [3,2;3,1;1,2];

% Find rotation axis
N1 = g_strctModule.m_astrctMovCrossSection(a2iLookupTable(iAxesIndex,1)).m_a2fM(1:3,3);
N2 = g_strctModule.m_astrctMovCrossSection(a2iLookupTable(iAxesIndex,2)).m_a2fM(1:3,3);

afRotateDir = cross(N1,N2);

% Find rotation point
pt3fPointMM = ThreePlaneIntersection(g_strctModule.m_astrctMovCrossSection);

% Now, build the following transformation:
% Translation^-1 -> Rotation -> Translation
fRotAngleRad = afDelta(1)/100*pi;

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

a2fReg = fnGetCurrentReg();
a2fNewReg = a2fTransformation * a2fReg;
fnModifyReg(a2fNewReg)
fnInvalidate(1);
return;



% switch hAxes
%     case g_strctModule.m_strctPanel.m_strctXY.m_hAxes
%         g_strctModule.m_strctCrossSectionXY = ...
%             fnRotateInPlaneCrossSectionAux(g_strctModule.m_strctCrossSectionXY, afDelta(1)/100*pi);
%     case g_strctModule.m_strctPanel.m_strctYZ.m_hAxes
%         g_strctModule.m_strctCrossSectionYZ = ...
%             fnRotateInPlaneCrossSectionAux(g_strctModule.m_strctCrossSectionYZ, afDelta(1)/100*pi);
%     case g_strctModule.m_strctPanel.m_strctXZ.m_hAxes
%         g_strctModule.m_strctCrossSectionXZ = ...
%             fnRotateInPlaneCrossSectionAux(g_strctModule.m_strctCrossSectionXZ, -afDelta(1)/100*pi);
% end;

fnInvalidate();


return;

% 
% 
% function fnRotatePlane(hAxes, fDiff)
% global g_strctModule
% switch hAxes
%     
%     case g_strctModule.m_strctPanel.m_strctXY.m_hLineYZ % bottom left, red
%         g_strctModule.m_strctCrossSectionYZ = fnRotateCrossSectionAux(...
%             g_strctModule.m_strctCrossSectionYZ, g_strctModule.m_strctCrossSectionXZ, -fDiff/100/2*pi);
%         
%     case g_strctModule.m_strctPanel.m_strctXY.m_hLineXZ % bottom left, green
%         
%         g_strctModule.m_strctCrossSectionXZ = fnRotateCrossSectionAux(...
%             g_strctModule.m_strctCrossSectionXZ, g_strctModule.m_strctCrossSectionYZ, -fDiff/100/2*pi);
%         
%     case g_strctModule.m_strctPanel.m_strctXZ.m_hLineYZ % top right , red
%         g_strctModule.m_strctCrossSectionYZ = fnRotateCrossSectionAux(...
%             g_strctModule.m_strctCrossSectionYZ, g_strctModule.m_strctCrossSectionXY, -fDiff/100/2*pi);
%         
%     case g_strctModule.m_strctPanel.m_strctXZ.m_hLineXY % top right , blue
%         
%         g_strctModule.m_strctCrossSectionXY = fnRotateCrossSectionAux(...
%             g_strctModule.m_strctCrossSectionXY, g_strctModule.m_strctCrossSectionYZ, -fDiff/100/2*pi);
%         
%     case g_strctModule.m_strctPanel.m_strctYZ.m_hLineXY % % top left, blue
%         g_strctModule.m_strctCrossSectionXY = fnRotateCrossSectionAux(...
%             g_strctModule.m_strctCrossSectionXY, g_strctModule.m_strctCrossSectionXZ, -fDiff/100/2*pi);
%     case g_strctModule.m_strctPanel.m_strctYZ.m_hLineXZ % top left, green
%         g_strctModule.m_strctCrossSectionXZ = fnRotateCrossSectionAux(...
%             g_strctModule.m_strctCrossSectionXZ, g_strctModule.m_strctCrossSectionXY, -fDiff/100/2*pi);
% end;
% fnInvalidate();
% 
% return;

function fnTinyPlaneShift(hAxes,iLineSelected,strctMouseOp)
global g_strctModule
if isempty(hAxes)
    return;
end
ahAxes = cat(1,g_strctModule.m_strctPanel.m_astrctCrossSection.m_hAxes);
iIndex = find(hAxes == ahAxes);
a2iLookupTable = [2, 3;  1, 3; 2, 1];
% 1 = B
% 2 = G
% 3 = R
if ~isempty(iIndex)
    if iIndex <= 3
        % Movable
        pt2fPosMM = fnCrossSection_Image_To_MM(g_strctModule.m_astrctMovCrossSection(iIndex), strctMouseOp.m_pt2fPos);
        pt3fPosMMOnPlane = [pt2fPosMM,0,1]';
        pt3fMovMarker_XYZ_mm = g_strctModule.m_astrctMovCrossSection(iIndex).m_a2fM*pt3fPosMMOnPlane;
        
        iPlaneToUse = a2iLookupTable(iIndex,iLineSelected);
        N1 = g_strctModule.m_astrctMovCrossSection(iPlaneToUse).m_a2fM(1:3,3);
        d1 = N1'*g_strctModule.m_astrctMovCrossSection(iPlaneToUse).m_a2fM(1:3,4);
        fDirection = sign(N1' * pt3fMovMarker_XYZ_mm(1:3) + d1);
        
        fMove = min(g_strctModule.m_strctMovableVol.m_afVoxelSpacing) / 5; 
        
        % Now, move plane...
        a2fReg = fnGetCurrentReg();
        a2fReg(1:3,4) =  a2fReg(1:3,4) + fMove * N1 * fDirection;
        fnModifyReg(a2fReg);
        fnInvalidate(1);
    end
    
end


return;


function fnTinyPlaneRotate(hAxes,iLineSelected,strctMouseOp)
global g_strctModule
if isempty(hAxes)
    return;
end
ahAxes = cat(1,g_strctModule.m_strctPanel.m_astrctCrossSection.m_hAxes);
iIndex = find(hAxes == ahAxes);
a2iLookupTable = [2, 3;  1, 3; 2, 1];
% 1 = B
% 2 = G
% 3 = R
if ~isempty(iIndex)
    if iIndex <= 3
        % Movable
        pt2fPosMM = fnCrossSection_Image_To_MM(g_strctModule.m_astrctMovCrossSection(iIndex), strctMouseOp.m_pt2fPos);
        pt3fPosMMOnPlane = [pt2fPosMM,0,1]';
        pt3fMovMarker_XYZ_mm = g_strctModule.m_astrctMovCrossSection(iIndex).m_a2fM*pt3fPosMMOnPlane;
        
        iPlaneToUse = a2iLookupTable(iIndex,iLineSelected);
        N1 = g_strctModule.m_astrctMovCrossSection(iPlaneToUse).m_a2fM(1:3,3);
        d1 = N1'*g_strctModule.m_astrctMovCrossSection(iPlaneToUse).m_a2fM(1:3,4);
        fDirection = sign(N1' * pt3fMovMarker_XYZ_mm(1:3) + d1);
        if iIndex == 3
            fDirection = -fDirection;
        end
        % Now, Rotate plane...
        fRotRad = 0.1 / 180 * pi * -fDirection; 
        fnRotateAxesInPlane(iIndex,fRotRad/pi*100);
        fnInvalidate(1);
    end
    
end


return;

function fnShiftPlane(hAxes, fDiff)
global g_strctModule

iIndex = find(hAxes==cat(1,g_strctModule.m_strctPanel.m_astrctCrossSection.m_hAxes));

if iIndex <= 3
%    aiPermutedIndex = [
    afCurrPos = g_strctModule.m_astrctMovCrossSection(iIndex).m_a2fM(1:3,4);
    afDirection = g_strctModule.m_astrctMovCrossSection(iIndex).m_a2fM(:,3);
    afNewPos = afCurrPos + afDirection(1:3) * fDiff;
    afNewPosCropped = min( max(afNewPos, g_strctModule.m_strctMovableVol.m_afRangeMM(:,1)), ...
        g_strctModule.m_strctMovableVol.m_afRangeMM(:,2));
    g_strctModule.m_astrctMovCrossSection(iIndex).m_a2fM(1:3,4) = afNewPosCropped;
else
    afCurrPos = g_strctModule.m_astrctStatCrossSection(iIndex-3).m_a2fM(1:3,4);
    afDirection = g_strctModule.m_astrctStatCrossSection(iIndex-3).m_a2fM(:,3);
    afNewPos = afCurrPos + afDirection(1:3) * fDiff;
    afNewPosCropped = min( max(afNewPos, g_strctModule.m_strctStationaryVol.m_afRangeMM(:,1)), ...
        g_strctModule.m_strctStationaryVol.m_afRangeMM(:,2));
    g_strctModule.m_astrctStatCrossSection(iIndex-3).m_a2fM(1:3,4) = afNewPosCropped;
end
fnInvalidate();



return;

function fnSetSliceMode()
global g_strctModule
g_strctModule.m_strMouseMode = 'Scroll';
return;

function fnSetContrastMode()
global g_strctModule
g_strctModule.m_strMouseMode = 'Contrast';
return;

function fnSetRotate2DMode()
global g_strctModule
g_strctModule.m_strMouseMode = 'Rotate2D';
return;


function fnSetZoomMode()
global g_strctModule
g_strctModule.m_strMouseMode = 'Zoom';
return;

function fnSetPanMode()
global g_strctModule
g_strctModule.m_strMouseMode = 'Pan';
return;

function fnSetCrosshairMode()
global g_strctModule
g_strctModule.m_strMouseMode = 'Crosshair';
return;

function B=fnRep3(A)
B = zeros(size(A,1),size(A,2),3);
B(:,:,1) = A;
B(:,:,2) = A;
B(:,:,3) = A;
return;

function fnFirstInvalidate()
global g_strctModule
a4fStatLinesPix = fnComputeCrossSectionIntersections(g_strctModule.m_astrctStatCrossSection);
a4fMovLinesPix = fnComputeCrossSectionIntersections(g_strctModule.m_astrctMovCrossSection);

% Generate cross hair lines
afCol = 'rgrbbg';
afColWin = 'bgr';
for k=1:3
    g_strctModule.m_strctPanel.m_a2hStatCrossHairLines(k,1) = plot(g_strctModule.m_strctPanel.m_astrctCrossSection(3+k).m_hAxes,...
    [a4fStatLinesPix(1,1,1,k),a4fStatLinesPix(2,1,1,k)],[a4fStatLinesPix(1,2,1,k),a4fStatLinesPix(2,2,1,k)],afCol(2*(k-1)+1));

    g_strctModule.m_strctPanel.m_a2hStatCrossHairLines(k,2) = plot(g_strctModule.m_strctPanel.m_astrctCrossSection(3+k).m_hAxes,...
    [a4fStatLinesPix(1,1,2,k),a4fStatLinesPix(2,1,2,k)],[a4fStatLinesPix(1,2,2,k),a4fStatLinesPix(2,2,2,k)],afCol(2*(k-1)+2));

    g_strctModule.m_strctPanel.m_a2hMovCrossHairLines(k,1) = plot(g_strctModule.m_strctPanel.m_astrctCrossSection(k).m_hAxes,...
    [a4fMovLinesPix(1,1,1,k),a4fMovLinesPix(2,1,1,k)],[a4fMovLinesPix(1,2,1,k),a4fMovLinesPix(2,2,1,k)],afCol(2*(k-1)+1));

    g_strctModule.m_strctPanel.m_a2hMovCrossHairLines(k,2) = plot(g_strctModule.m_strctPanel.m_astrctCrossSection(k).m_hAxes,...
    [a4fMovLinesPix(1,1,2,k),a4fMovLinesPix(2,1,2,k)],[a4fMovLinesPix(1,2,2,k),a4fMovLinesPix(2,2,2,k)],afCol(2*(k-1)+2));

%   Draw boxes
    afAxisRange = axis(g_strctModule.m_strctPanel.m_astrctCrossSection(k).m_hAxes);
    fOffset = 4;
    g_strctModule.m_strctPanel.m_ahBoxHandle(k) =  plot(g_strctModule.m_strctPanel.m_astrctCrossSection(k).m_hAxes,...
        [afAxisRange(1)+0       afAxisRange(2)-fOffset afAxisRange(2)-fOffset afAxisRange(1)+0 afAxisRange(1)+0],...
        [afAxisRange(3)+fOffset afAxisRange(3)+fOffset afAxisRange(4) afAxisRange(4) afAxisRange(3)+fOffset],afColWin(k),'LineWidth',2);
    
    g_strctModule.m_strctPanel.m_ahBoxHandle(3+k) =  plot(g_strctModule.m_strctPanel.m_astrctCrossSection(3+k).m_hAxes,...
        [afAxisRange(1)+0       afAxisRange(2)-fOffset afAxisRange(2)-fOffset afAxisRange(1)+0 afAxisRange(1)+0],...
        [afAxisRange(3)+fOffset afAxisRange(3)+fOffset afAxisRange(4) afAxisRange(4) afAxisRange(3)+fOffset],afColWin(k),'LineWidth',2);
    
        
end


set(g_strctModule.m_strctPanel.m_hWindowsPanel,'visible','on');
g_strctModule.m_bFirstInvalidate = false;
 return;
 
function [a4fLinesPix]= fnComputeCrossSectionIntersections(astrctCrossSections)
a2iTable(:,:,1) = [1,3
                   1,2];
a2iTable(:,:,2) = [2,3
                   2,1];      
a2iTable(:,:,3) = [3,1
                   3,2];            

a4fLinesPix = zeros(2,2,2,3); % X,Y,Line Index, CrossPlaneIndex
for k=1:3
    a2iIndices = a2iTable(:,:,k);
    [L1_Pt1, L1_Pt2] = fnCrossSectionIntersection(astrctCrossSections(a2iIndices(1,1)),astrctCrossSections(a2iIndices(1,2)));
    [L2_Pt1, L2_Pt2] = fnCrossSectionIntersection(astrctCrossSections(a2iIndices(2,1)),astrctCrossSections(a2iIndices(2,2)));
    a4fLinesPix(:,:,1,k) = [L1_Pt1;L1_Pt2];
    a4fLinesPix(:,:,2,k) = [L2_Pt1;L2_Pt2];
end

return;        
% 
% function [a3fHeat, a2fAlpha] = fnOverlayContrastTransform(a2fI)
% global g_strctModule
% 
% fWidth = g_strctModule.m_strctOverlay.m_pt2fRight(1)-g_strctModule.m_strctOverlay.m_pt2fLeft(1);
% fHeight = abs(g_strctModule.m_strctOverlay.m_pt2fRight(2)-g_strctModule.m_strctOverlay.m_pt2fLeft(2));
% 
% a2fTmp = (a2fI - g_strctModule.m_strctOverlay.m_pt2fLeft(1)) / fWidth;
% a2fTmp(a2fI < g_strctModule.m_strctOverlay.m_pt2fLeft(1)) = 0;
% a2fTmp(a2fI > g_strctModule.m_strctOverlay.m_pt2fRight(1)) = 1;
% 
% % a2fTmp is now between [0,1]. It will be used to determine the heap map.
% % Where 0 means anything left to m_pt2fLeft and 1 means anything right to
% % m_pt2fRight
% iNumColorQuant = 64;
% a2fJetValues = autumn(iNumColorQuant);
% a2iJetIndices = round( (1-a2fTmp) * (iNumColorQuant-1)) + 1;
% 
% 
% a3fHeat = zeros([size(a2fTmp),3]);
% a3fHeat(:,:,1) = reshape(a2fJetValues(a2iJetIndices,1),size(a2fTmp));
% a3fHeat(:,:,2) = reshape(a2fJetValues(a2iJetIndices,2),size(a2fTmp));
% a3fHeat(:,:,3) = reshape(a2fJetValues(a2iJetIndices,3),size(a2fTmp));
% 
% a2fAlpha = (1-a2fTmp) * fHeight + g_strctModule.m_strctOverlay.m_pt2fRight(2);
% return;


function fnInvalidate(bForceInvalidate)
global g_strctModule
% persistent strctPrevCrossSectionXY strctPrevCrossSectionYZ strctPrevCrossSectionXZ
% persistent a2fPrevCrossSectionXY a2fPrevCrossSectionYZ a2fPrevCrossSectionXZ
% persistent apt3fPrevPlanePointsXZ apt3fPrevPlanePointsYZ apt3fPrevPlanePointsXY
% persistent a2fPrevCrossSectionXY_Func a2fPrevCrossSectionYZ_Func a2fPrevCrossSectionXZ_Func
if ~exist('bForceInvalidate','var')
    bForceInvalidate = false;
end;
if isempty(g_strctModule.m_strctStationaryVol) || isempty(g_strctModule.m_strctMovableVol)
    return;
end;
if g_strctModule.m_bFirstInvalidate
  fnFirstInvalidate();
end;

% First thing first, resample cross sections and redraw on screen


if g_strctModule.m_bDrawMovInStat
    a2fXYZ_To_CRS_Stat = inv(g_strctModule.m_strctStationaryVol.m_a2fM); % * inv(g_strctModule.m_strctStationaryVol.m_a2fReg); this will always be eye(4)
    % This is somewhat redundant since this will be drawn later...
    a2fXYZ_To_CRS_Mov = inv(g_strctModule.m_strctMovableVol.m_a2fM) * inv(fnGetCurrentReg());
    for k=1:3
        [a2fStatCrossSection] = fnResampleCrossSection(g_strctModule.m_strctStationaryVol.m_a3fVol, a2fXYZ_To_CRS_Stat, g_strctModule.m_astrctStatCrossSection(k));
        a2fCrossSectionStatTrans = fnContrastTransform(a2fStatCrossSection, g_strctModule.m_strctStationaryVol.m_strctContrastTransform);
        set(g_strctModule.m_strctPanel.m_astrctCrossSection(3+k).m_hImage,'cdata',fnRep3(a2fCrossSectionStatTrans));
        
        [a2fMovCrossSection] = fnResampleCrossSection(g_strctModule.m_strctStationaryVol.m_a3fVol, a2fXYZ_To_CRS_Stat, g_strctModule.m_astrctMovCrossSection(k));
        a2fCrossSectionMovTrans = fnContrastTransform(a2fMovCrossSection, g_strctModule.m_strctStationaryVol.m_strctContrastTransform);
        set(g_strctModule.m_strctPanel.m_astrctCrossSection(k).m_hImage,'cdata',fnRep3(a2fCrossSectionMovTrans));
    end    
else
    % Normal way of drawing things...
    a2fXYZ_To_CRS_Stat = inv(g_strctModule.m_strctStationaryVol.m_a2fM); % * inv(g_strctModule.m_strctStationaryVol.m_a2fReg); this will always be eye(4)
    % This is som       ewhat redundant since this will be drawn later...
    a2fXYZ_To_CRS_Mov = inv(g_strctModule.m_strctMovableVol.m_a2fM) * inv(fnGetCurrentReg());
    for k=1:3
        [a2fStatCrossSection] = fnResampleCrossSection(g_strctModule.m_strctStationaryVol.m_a3fVol, a2fXYZ_To_CRS_Stat, g_strctModule.m_astrctStatCrossSection(k));
        a2fCrossSectionStatTrans = fnContrastTransform(a2fStatCrossSection, g_strctModule.m_strctStationaryVol.m_strctContrastTransform);
        set(g_strctModule.m_strctPanel.m_astrctCrossSection(3+k).m_hImage,'cdata',fnRep3(a2fCrossSectionStatTrans));
        
        [a2fMovCrossSection] = fnResampleCrossSection(g_strctModule.m_strctMovableVol.m_a3fVol, a2fXYZ_To_CRS_Mov, g_strctModule.m_astrctMovCrossSection(k));
        a2fCrossSectionMovTrans = fnContrastTransform(a2fMovCrossSection, g_strctModule.m_strctMovableVol.m_strctContrastTransform);
        set(g_strctModule.m_strctPanel.m_astrctCrossSection(k).m_hImage,'cdata',fnRep3(a2fCrossSectionMovTrans));
    end
end

if g_strctModule.m_strctGUIOptions.m_bShow2DPlanes
    a4fStatLinesPix = fnComputeCrossSectionIntersections(g_strctModule.m_astrctStatCrossSection);
    a4fMovLinesPix = fnComputeCrossSectionIntersections(g_strctModule.m_astrctMovCrossSection);
    % Update cross hair lines
     for k=1:3
        set(g_strctModule.m_strctPanel.m_a2hStatCrossHairLines(k,1),'xdata',...
            [a4fStatLinesPix(1,1,1,k),a4fStatLinesPix(2,1,1,k)],'ydata',[a4fStatLinesPix(1,2,1,k),a4fStatLinesPix(2,2,1,k)]);
        
        set(g_strctModule.m_strctPanel.m_a2hStatCrossHairLines(k,2),'xdata',...
            [a4fStatLinesPix(1,1,2,k),a4fStatLinesPix(2,1,2,k)],'ydata',[a4fStatLinesPix(1,2,2,k),a4fStatLinesPix(2,2,2,k)]);
        
        set(g_strctModule.m_strctPanel.m_a2hMovCrossHairLines(k,1),'xdata',...
            [a4fMovLinesPix(1,1,1,k),a4fMovLinesPix(2,1,1,k)],'ydata',[a4fMovLinesPix(1,2,1,k),a4fMovLinesPix(2,2,1,k)]);
        
        set(g_strctModule.m_strctPanel.m_a2hMovCrossHairLines(k,2),'xdata',...
            [a4fMovLinesPix(1,1,2,k),a4fMovLinesPix(2,1,2,k)],'ydata',[a4fMovLinesPix(1,2,2,k),a4fMovLinesPix(2,2,2,k)]);
        
    end
%       
end;
return

function Y=fnDup3(X)
Y=reshape([X,X,X], [size(X),3]);
%Y(:,:,1) = X;
%Y(:,:,2) = X;
%Y(:,:,3) = X;
return;

function a2fTranI = fnContrastTransform(a2fI, strctTransform)
if strcmp(strctTransform.m_strType,'Linear');
    a = 1 / (2*strctTransform.m_fWidth);
    b = -a * (strctTransform.m_fCenter -strctTransform.m_fWidth);
    a2fTranI= a*a2fI + b;
    a2fTranI(a2fI <= (strctTransform.m_fCenter-strctTransform.m_fWidth)) = 0;
    a2fTranI(a2fI >=(strctTransform.m_fCenter+strctTransform.m_fWidth)) = 1;
    a2fTranI(a2fTranI < 0) = 0;
    a2fTranI(a2fTranI > 1) = 1;
end;
return;

function pt2iIntersectPix = fnIntersect2D(pt2fP1_1, pt2fP1_2, pt2fP2_1, pt2fP2_2)
% Use Homogeneous coordinate
afLineA = [pt2fP1_1; pt2fP1_2]\[-1;-1];
afLineB = [pt2fP2_1; pt2fP2_2]\[-1;-1];

afHomo = cross([afLineA',1],[afLineB',1]);
pt2iIntersectPix = [afHomo(1)/afHomo(3),afHomo(2)/afHomo(3)];
return;

function pt3fPointMM = fnCrossSection_2D_To_3D(strctCrossSection, pt2iPointPix)
pt2fPointMM = (2*((pt2iPointPix-1) ./ [(strctCrossSection.m_iResWidth-1), (strctCrossSection.m_iResHeight-1)]) - 1) .*  [...
    strctCrossSection.m_fHalfWidthMM, strctCrossSection.m_fHalfHeightMM];
pt3fPosMMOnPlane = [pt2fPointMM(1:2),0,1]';
Tmp = strctCrossSection.m_a2fM*pt3fPosMMOnPlane;
pt3fPointMM = Tmp(1:3);
return;

% 
% function fnRotateMovableAux(hAxes, afDelta)
% global g_strctModule
% switch hAxes
%     case g_strctModule.m_strctPanel.m_strctXY.m_hAxes
% 
%         [pt2fXY_YZ_1, pt2fXY_YZ_2] = fnCrossSectionIntersection(...
%             g_strctModule.m_strctCrossSectionXY, g_strctModule.m_strctCrossSectionYZ,...
%             g_strctModule.m_strctStationaryVol.m_afRangeMM);
% 
%         [pt2fXY_XZ_1, pt2fXY_XZ_2] = fnCrossSectionIntersection(...
%             g_strctModule.m_strctCrossSectionXY, g_strctModule.m_strctCrossSectionXZ,...
%         g_strctModule.m_strctStationaryVol.m_afRangeMM);
% 
%         pt2iIntersectPix = fnIntersect2D(pt2fXY_YZ_1, pt2fXY_YZ_2, pt2fXY_XZ_1, pt2fXY_XZ_2);
%         pt3fPointMM = fnCrossSection_2D_To_3D(g_strctModule.m_strctCrossSectionXY,pt2iIntersectPix);
%         
%         a2fTrans= ...
%              fnRotateInPlaneCrossSectionAux(pt3fPointMM, g_strctModule.m_strctCrossSectionXY.m_a2fM,afDelta(1)/100*pi);
%          
%         g_strctModule.m_strctMovableVol.m_a2fReg = g_strctModule.m_strctMovableVol.m_a2fReg * a2fTrans;
%         
%     case g_strctModule.m_strctPanel.m_strctXZ.m_hAxes
%                 
%  [pt2fXZ_YZ_1, pt2fXZ_YZ_2] = fnCrossSectionIntersection(...
%     g_strctModule.m_strctCrossSectionXZ, g_strctModule.m_strctCrossSectionYZ,...
%     g_strctModule.m_strctStationaryVol.m_afRangeMM);
% 
% [ pt2fXZ_XY_1, pt2fXZ_XY_2] = fnCrossSectionIntersection(...
%     g_strctModule.m_strctCrossSectionXZ, g_strctModule.m_strctCrossSectionXY,...
%     g_strctModule.m_strctStationaryVol.m_afRangeMM);
% 
%     pt2iIntersectPix = fnIntersect2D(pt2fXZ_YZ_1, pt2fXZ_YZ_2, pt2fXZ_XY_1, pt2fXZ_XY_2);
%         pt3fPointMM = fnCrossSection_2D_To_3D(g_strctModule.m_strctCrossSectionXZ,pt2iIntersectPix);
%        
%         a2fTrans= ...
%              fnRotateInPlaneCrossSectionAux(pt3fPointMM, g_strctModule.m_strctCrossSectionXZ.m_a2fM,afDelta(1)/100*pi);
%          
%         g_strctModule.m_strctMovableVol.m_a2fReg = g_strctModule.m_strctMovableVol.m_a2fReg * a2fTrans;
%    
%        case g_strctModule.m_strctPanel.m_strctYZ.m_hAxes
%            
%         
%  [ pt2fYZ_XY_1, pt2fYZ_XY_2] = fnCrossSectionIntersection(...
%     g_strctModule.m_strctCrossSectionYZ, g_strctModule.m_strctCrossSectionXY,...
%     g_strctModule.m_strctStationaryVol.m_afRangeMM);
% [ pt2fYZ_XZ_1, pt2fYZ_XZ_2] = fnCrossSectionIntersection(...
%     g_strctModule.m_strctCrossSectionYZ, g_strctModule.m_strctCrossSectionXZ,...
%     g_strctModule.m_strctStationaryVol.m_afRangeMM);
%        
%          pt2iIntersectPix = fnIntersect2D(pt2fYZ_XY_1, pt2fYZ_XY_2, pt2fYZ_XZ_1, pt2fYZ_XZ_2);
%         pt3fPointMM = fnCrossSection_2D_To_3D(g_strctModule.m_strctCrossSectionXZ,pt2iIntersectPix);
%         
%         a2fTrans= ...
%              fnRotateInPlaneCrossSectionAux(pt3fPointMM, g_strctModule.m_strctCrossSectionYZ.m_a2fM,-afDelta(1)/100*pi);
%          
%         g_strctModule.m_strctMovableVol.m_a2fReg = g_strctModule.m_strctMovableVol.m_a2fReg * a2fTrans;
%         
% 
% end;
% 
% fnInvalidate();
% 
% 
% return;

% 
% 
% function a2fTransformation = fnRotateInPlaneCrossSectionAux(pt3fPointMM, a2fM, fRotAngleRad)
% 
% afRotateDir =a2fM(1:3,3);
% 
% a2fNegTrans = [1 0 0 -pt3fPointMM(1);
%     0 1 0 -pt3fPointMM(2);
%     0 0 1 -pt3fPointMM(3);
%     0 0 0  1];
% 
% a2fPosTrans = [1 0 0 pt3fPointMM(1);
%     0 1 0 pt3fPointMM(2);
%     0 0 1 pt3fPointMM(3);
%     0 0 0  1];
% 
% R = fnRotateVectorAboutAxis(afRotateDir, fRotAngleRad);
% a2fRot = zeros(4,4);
% a2fRot(1:3,1:3) = R;
% a2fRot(4,4) = 1;
% a2fTransformation = a2fPosTrans*a2fRot*a2fNegTrans;
% 
% return;
