function fnVolumeViewerCallback(strCallback, varargin)
global g_strctWindows g_strctModule
switch strCallback
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
    case 'SetSlicesMode'
        fnSetSliceMode();
    case 'SetContrastMode'
        fnSetContrastMode();
    case 'SetZoomMode'
        fnSetZoomMode();
    case 'SetPanMode'
        fnSetPanMode();
    case 'SetCrosshairMode'
        fnSetCrosshairMode();
    case 'SetDefaultView'
        fnSetDefaultCrossSections();%g_strctModule.m_strctPanel.m_aiImageRes(2),g_strctModule.m_strctPanel.m_aiImageRes(1));
        fnInvalidate();
    case 'HideShowPlanes'
        fnHideShowPlanes3D();
    case 'LoadAnatVol'
        fnLoadAnatVol();
   case 'LoadFuncVol'
        fnLoadFuncVol();
   case 'ShowHideCrosshairs'
        fnHideShowPlanes2D();
   case 'ShowFunctional'
        fnHideShowPlanesFunctional();   
    case 'SwitchAnat'
        fnSetCurrAnatVol();
end

return;


function fnHideShowPlanes2D()
global g_strctModule
g_strctModule.m_bShow2DPlanes = ~g_strctModule.m_bShow2DPlanes;

if g_strctModule.m_bShow2DPlanes
    set(g_strctModule.m_strctPanel.m_strctXY.m_hLineYZ,'visible','on');
    set(g_strctModule.m_strctPanel.m_strctXY.m_hLineXZ,'visible','on');
    set(g_strctModule.m_strctPanel.m_strctXZ.m_hLineYZ,'visible','on');
    set(g_strctModule.m_strctPanel.m_strctXZ.m_hLineXY,'visible','on');
    set(g_strctModule.m_strctPanel.m_strctYZ.m_hLineXY,'visible','on');
    set(g_strctModule.m_strctPanel.m_strctYZ.m_hLineXZ,'visible','on');
else
    set(g_strctModule.m_strctPanel.m_strctXY.m_hLineYZ,'visible','off');
    set(g_strctModule.m_strctPanel.m_strctXY.m_hLineXZ,'visible','off');
    set(g_strctModule.m_strctPanel.m_strctXZ.m_hLineYZ,'visible','off');
    set(g_strctModule.m_strctPanel.m_strctXZ.m_hLineXY,'visible','off');
    set(g_strctModule.m_strctPanel.m_strctYZ.m_hLineXY,'visible','off');
    set(g_strctModule.m_strctPanel.m_strctYZ.m_hLineXZ,'visible','off');
end;

fnInvalidate();
return;


function fnHideShowPlanesFunctional()
global g_strctModule
g_strctModule.m_bShowFunctional = ~g_strctModule.m_bShowFunctional;
fnInvalidate();
return;



function strctAnatVol = fnCreateInitialCrossSections(strctParams)
strctAnatVol.m_afVoxelSpacing = strctParams.AnatVol.volres;
strctAnatVol.m_aiVolSize = [256 256 256]; %row, col, slice
strctAnatVol.m_a3fVol = strctParams.AnatVol.vol;

a2fM = fnFreesurferToPlanner(strctParams.AnatVol);

strctAnatVol.m_a2fM = a2fM;%strctParams.AnatVol.tkrvox2ras;


strctAnatVol.m_strctSurface.m_fThreshold = 70;
strctAnatVol.m_strctSurface.m_iSubSample = 4;

% Conv with smoothing kernel
afKernelX = ones(1,strctAnatVol.m_strctSurface.m_iSubSample) / strctAnatVol.m_strctSurface.m_iSubSample;
afKernelY = ones(strctAnatVol.m_strctSurface.m_iSubSample,1) / strctAnatVol.m_strctSurface.m_iSubSample;
afKernelZ = ones(1,1,strctAnatVol.m_strctSurface.m_iSubSample) / strctAnatVol.m_strctSurface.m_iSubSample;
a3fConvVol = convn(convn(convn(strctAnatVol.m_a3fVol,afKernelX,'same'),afKernelY,'same'),afKernelZ,'same');
strctAnatVol.m_strctSurface.m_a3bVol = a3fConvVol(1:strctAnatVol.m_strctSurface.m_iSubSample:end,1:strctAnatVol.m_strctSurface.m_iSubSample:end,1:strctAnatVol.m_strctSurface.m_iSubSample:end) > ...
    strctAnatVol.m_strctSurface.m_fThreshold;

aiCroppedSize = size(strctAnatVol.m_strctSurface.m_a3bVol);
afX = [0:strctAnatVol.m_strctSurface.m_iSubSample:strctAnatVol.m_aiVolSize(2)-1];
afY = [0:strctAnatVol.m_strctSurface.m_iSubSample:strctAnatVol.m_aiVolSize(1)-1];
afZ = [0:strctAnatVol.m_strctSurface.m_iSubSample:strctAnatVol.m_aiVolSize(3)-1];
afX=afX(1:aiCroppedSize(2));
afY=afY(1:aiCroppedSize(1));
afZ=afZ(1:aiCroppedSize(3));

[a3iX, a3iY, a3iZ] = meshgrid(afX,afY,afZ);
a3iOnes = ones(size(a3iX));
Tmp = strctAnatVol.m_a2fM * [a3iX(:),a3iY(:),a3iZ(:), a3iOnes(:)]';
strctAnatVol.m_strctSurface.m_a3fX = reshape(Tmp(1,:),size(a3iX));         
strctAnatVol.m_strctSurface.m_a3fY = reshape(Tmp(2,:),size(a3iY));
strctAnatVol.m_strctSurface.m_a3fZ = reshape(Tmp(3,:),size(a3iZ));

strctAnatVol.m_strctSurface.m_strctIso = isosurface(strctAnatVol.m_strctSurface.m_a3fX,...
    strctAnatVol.m_strctSurface.m_a3fY,...
    strctAnatVol.m_strctSurface.m_a3fZ,...
    strctAnatVol.m_strctSurface.m_a3bVol, 0.5);

fMin = min(strctAnatVol.m_a3fVol(:));
fMax = max(strctAnatVol.m_a3fVol(:));

strctLinearHistogramStretch.m_strType = 'Linear';
strctLinearHistogramStretch.m_fMin = double(fMin);
strctLinearHistogramStretch.m_fMax = double(fMax);
strctLinearHistogramStretch.m_fRange = double(fMax-fMin);
strctLinearHistogramStretch.m_fCenter = double(fMin + (fMax-fMin)/2);
strctLinearHistogramStretch.m_fWidth  = double(fMax-fMin);
strctAnatVol.m_strctContrastTransform = strctLinearHistogramStretch;


afCoord0 = strctAnatVol.m_a2fM * [0,0,0,1]';
afCoordMax = strctAnatVol.m_a2fM * [strctAnatVol.m_aiVolSize([2,1,3]),1]';
strctAnatVol.m_afRangeMM = [min(afCoord0(1:3),afCoordMax(1:3)), max(afCoord0(1:3),afCoordMax(1:3))];

return;


function fnLoadFuncVol()
global g_strctModule
    
[strFuncFile, strPath] = uigetfile([g_strctModule.m_strDefaultFilesFolder,'*.bhdr'],'Select Functional Volume');
if strFuncFile(1) == 0
    return;
end;
strInputVolfile = [strPath,strFuncFile];

[strFile, strPath] = uigetfile([g_strctModule.m_strDefaultFilesFolder,'*.reg;*.dat'],'Select registeration');
if strFile(1) == 0
    % no registeration available?
    strInputRegfile = 'Missing';
    a2fRegisteration = [1 0 0 0;
                        0 1 0 0;
                        0 0 1 0;
                        0 0 0 1];
    afVoxelSpacing = [1 1 1]; % unknown...
else
    strInputRegfile = [strPath,strFile];
    [a2fRegisteration, strSubjectName, strVolType,afVoxelSpacing] = fnReadRegisteration(strInputRegfile);    
end;

strctVol = MRIread(strInputVolfile);
assert(size(strctVol.vol,4) == 1)

strctFuncVol.m_afVoxelSpacing = strctVol.volres;
strctFuncVol.m_aiVolSize = size(strctVol.vol);
strctFuncVol.m_a3fVol = strctVol.vol;


a2fM = fnFreesurferToPlanner(strctVol);


strctFuncVol.m_a2fM = a2fM;
strctFuncVol.m_a2fReg = a2fRegisteration;
strctFuncVol.m_a2fRegVoxelSpacing = afVoxelSpacing;

g_strctModule.m_iCurrFuncVol = g_strctModule.m_iCurrFuncVol + 1;

g_strctModule.m_acFuncVol{g_strctModule.m_iCurrFuncVol} = strctFuncVol;
g_strctModule.m_strctFuncVol = strctFuncVol;

strList = get(g_strctModule.m_strctPanel.m_hFuncList,'String');
if isempty(strList)
    set(g_strctModule.m_strctPanel.m_hFuncList,'String',strFuncFile);
else
    if size(strList,2) < length(strFuncFile)
        strListTmp = zeros(size(strList,1),length(strFuncFile));
        strListTmp(:, 1:size(strList,2)) = strList;
        strList= char(strListTmp);
    end
    strList(end+1,1:length(strFuncFile)) = strFuncFile;
    set(g_strctModule.m_strctPanel.m_hFuncList,'String',strList,'value',g_strctModule.m_iCurrFuncVol);
end;

if ~g_strctModule.m_bFuncVolLoaded 
    g_strctModule.m_bFuncVolLoaded  = true;
end;
fnInvalidate();
return;




function fnLoadAnatVol()
global g_strctModule
    
[strFile, strPath] = uigetfile([g_strctModule.m_strDefaultFilesFolder,'*.mgz'],'MultiSelect','on');

if ~iscell(strFile)
    strFile = {strFile};
end;
if strFile{1}(1) == 0
    return;
end;
hWaitbar = waitbar(0,'Loading volume(s)...');
for iFileIter=1:length(strFile)
    strInputfile = [strPath,strFile{iFileIter}];
    
    g_strctModule.m_iCurrAnatVol = g_strctModule.m_iCurrAnatVol + 1;
    strctParams.AnatVol = MRIread(strInputfile);
    waitbar(iFileIter/length(strFile), hWaitbar);
    strctAnatVol = fnCreateInitialCrossSections(strctParams);
    
    g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol} = strctAnatVol;
    g_strctModule.m_strctMainVol = strctAnatVol;
    
        
    strList = get(g_strctModule.m_strctPanel.m_hAnatList,'String');
    if isempty(strList)
        set(g_strctModule.m_strctPanel.m_hAnatList,'String',strFile{iFileIter});
    else
        if size(strList,2) < length(strFile{iFileIter})
            strListTmp = zeros(size(strList,1),length(strFile{iFileIter}));
            strListTmp(:, 1:size(strList,2)) = strList;
            strList= char(strListTmp);
        end
        
        strList(end+1,1:length(strFile{iFileIter})) = strFile{iFileIter};
        set(g_strctModule.m_strctPanel.m_hAnatList,'String',strList,'value',g_strctModule.m_iCurrAnatVol);
    end;
end;

if ~g_strctModule.m_bVolumeLoaded 
    g_strctModule.m_bVolumeLoaded = true;
    g_strctModule.m_strctPanel.m_hMainVolSurface = patch(g_strctModule.m_strctMainVol.m_strctSurface.m_strctIso, ...
        'parent',g_strctModule.m_strctPanel.m_strct3D.m_hAxes,'visible','on');
    set(g_strctModule.m_strctPanel.m_hMainVolSurface,'FaceColor','c','EdgeColor','none');
    set(g_strctModule.m_strctPanel.m_hMainVolSurface, 'UIContextMenu', g_strctModule.m_strctPanel.m_hMenu3D);
    
    


    fnSetDefaultCrossSections(g_strctModule.m_strctPanel.m_aiImageRes(2),g_strctModule.m_strctPanel.m_aiImageRes(1));
end;
close(hWaitbar);
fnInvalidate();
return;


function fnSetCurrAnatVol()
global g_strctModule
delete(g_strctModule.m_strctPanel.m_hMainVolSurface);

  
iNewVolSelected = get(g_strctModule.m_strctPanel.m_hAnatList,'value');
g_strctModule.m_strctMainVol = g_strctModule.m_acAnatVol{iNewVolSelected};

g_strctModule.m_strctPanel.m_hMainVolSurface = patch(g_strctModule.m_strctMainVol.m_strctSurface.m_strctIso, ...
    'parent',g_strctModule.m_strctPanel.m_strct3D.m_hAxes,'visible','on');
set(g_strctModule.m_strctPanel.m_hMainVolSurface,'FaceColor','c','EdgeColor','none');
set(g_strctModule.m_strctPanel.m_hMainVolSurface, 'UIContextMenu', g_strctModule.m_strctPanel.m_hMenu3D);

fnInvalidate();

return;

function fnHideShowPlanes3D()
global g_strctModule
g_strctModule.m_bShow3DPlanes  = ~g_strctModule.m_bShow3DPlanes ;
if g_strctModule.m_bShow3DPlanes 
    set(g_strctModule.m_strctPanel.m_hPlaneXY,'visible','on');
    set(g_strctModule.m_strctPanel.m_hPlaneXZ,'visible','on');
    set(g_strctModule.m_strctPanel.m_hPlaneYZ,'visible','on');
else
    set(g_strctModule.m_strctPanel.m_hPlaneXY,'visible','off');
    set(g_strctModule.m_strctPanel.m_hPlaneXZ,'visible','off');
    set(g_strctModule.m_strctPanel.m_hPlaneYZ,'visible','off');
end
return;

function fnUpdateOverlayTransform()
global g_strctModule
Tmp = get(g_strctModule.m_strctPanel.m_strctOverlayAxes.m_hAxes,'CurrentPoint');

afRange = axis(g_strctModule.m_strctPanel.m_strctOverlayAxes.m_hAxes);
pt2fCurrPoint = Tmp([2,3]);
pt2fCurrPoint(1) = min(afRange(2), max(afRange(1), pt2fCurrPoint(1)));
pt2fCurrPoint(2) = min(afRange(4), max(afRange(3), pt2fCurrPoint(2)));

if ~isempty(g_strctModule.m_strctLastMouseDown.m_hObjectSelected)
    switch g_strctModule.m_strctLastMouseDown.m_hObjectSelected
        case g_strctModule.m_strctPanel.m_strctOverlayAxes.hLeftPoint
            pt2fCurrPoint(1) = min(pt2fCurrPoint(1), g_strctModule.m_strctOverlay.m_pt2fRight(1));
            g_strctModule.m_strctOverlay.m_pt2fLeft = pt2fCurrPoint;
            fnInvalidateOverlayAxes();
            fnInvalidate();
        case g_strctModule.m_strctPanel.m_strctOverlayAxes.hRightPoint
            pt2fCurrPoint(1) = max(pt2fCurrPoint(1), g_strctModule.m_strctOverlay.m_pt2fLeft(1));
            g_strctModule.m_strctOverlay.m_pt2fRight = pt2fCurrPoint;
            fnInvalidateOverlayAxes();
            fnInvalidate();
    end;
end;

return;

function fnHandleMouseMoveWhileDown(strctPrevMouseOp, strctMouseOp)

global g_strctModule
afDelta= strctMouseOp.m_pt2fPos - strctPrevMouseOp.m_pt2fPos;
afDiff = g_strctModule.m_strctLastMouseDown.m_pt2fPos - strctMouseOp.m_pt2fPos;

% If user press cross section lines:
if ~isempty(g_strctModule.m_strctLastMouseDown.m_hAxesSelected)
    bPan = strcmp(g_strctModule.m_strctLastMouseDown.m_strAxisOp,'Pan');
    if bPan
        fnShiftPlane(g_strctModule.m_strctLastMouseDown.m_hAxesSelected, sum(afDelta .* g_strctModule.m_strctLastMouseDown.m_afAxesPen));
    else
        fnRotatePlane(g_strctModule.m_strctLastMouseDown.m_hAxesLineSelected, sum(-afDelta .* g_strctModule.m_strctLastMouseDown.m_afAxesPen));
    end;   
    fnInvalidate();
    return;
end;

if g_strctModule.m_strctLastMouseDown.m_hAxes == g_strctModule.m_strctPanel.m_strctOverlayAxes.m_hAxes
    fnUpdateOverlayTransform();
    return;
end;

% 3D Operation

if g_strctModule.m_strctLastMouseDown.m_hAxes == g_strctModule.m_strctPanel.m_strct3D.m_hAxes
    switch g_strctModule.m_strMouse3DMode
        case 'Rotate'
            afDiffScr = strctMouseOp.m_pt2fPosScr - strctPrevMouseOp.m_pt2fPosScr;
            camorbit(g_strctModule.m_strctPanel.m_strct3D.m_hAxes, -afDiffScr(1)/5,-afDiffScr(2)/5, 'none');
        case 'Zoom'
            %        fnSetNewZoomLevel(handles, afDelta);
        case 'Pan'
            %        fnSetNewPanLevel(handles, afDiff);
    end;

else
    
    switch g_strctModule.m_strMouseMode
        case 'Scroll'
            
            %       fnSetNewCrosssection(
        case 'Contrast'
            fnSetNewContrastLevel(afDelta);
        case 'Zoom'
           fnSetNewZoomLevel(g_strctModule.m_strctLastMouseDown.m_hAxes,afDelta);
        case 'Pan'
            fnSetNewPanLevel(g_strctModule.m_strctLastMouseDown.m_hAxes,afDelta);
    end;
end;
return;

function fnSetNewZoomLevel(hAxes, afDelta)
global g_strctModule
fDiff = afDelta(2)/2;
if ~isempty(hAxes)
    switch hAxes
        
        case g_strctModule.m_strctPanel.m_strctXY.m_hAxes
            g_strctModule.m_strctCrossSectionXY.m_fHalfWidthMM = g_strctModule.m_strctCrossSectionXY.m_fHalfWidthMM + fDiff;
            g_strctModule.m_strctCrossSectionXY.m_fHalfHeightMM = g_strctModule.m_strctCrossSectionXY.m_fHalfHeightMM + fDiff;
        case g_strctModule.m_strctPanel.m_strctYZ.m_hAxes
            g_strctModule.m_strctCrossSectionYZ.m_fHalfWidthMM = g_strctModule.m_strctCrossSectionYZ.m_fHalfWidthMM + fDiff;
            g_strctModule.m_strctCrossSectionYZ.m_fHalfHeightMM = g_strctModule.m_strctCrossSectionYZ.m_fHalfHeightMM + fDiff;
        case g_strctModule.m_strctPanel.m_strctXZ.m_hAxes
            g_strctModule.m_strctCrossSectionXZ.m_fHalfWidthMM = g_strctModule.m_strctCrossSectionXZ.m_fHalfWidthMM + fDiff;
            g_strctModule.m_strctCrossSectionXZ.m_fHalfHeightMM = g_strctModule.m_strctCrossSectionXZ.m_fHalfHeightMM + fDiff;
    end;
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

function fnSetNewContrastLevel(afDelta)
global g_strctModule

strctLinearHistogramStretch = g_strctModule.m_strctMainVol.m_strctContrastTransform;

fMaxWidth = 2*strctLinearHistogramStretch.m_fWidth;
strctLinearHistogramStretch.m_fWidth = min(fMaxWidth,max(0,...
    strctLinearHistogramStretch.m_fWidth + afDelta(2)*fMaxWidth/400));
strctLinearHistogramStretch.m_fCenter = min(strctLinearHistogramStretch.m_fMax,...
    max(strctLinearHistogramStretch.m_fMin,...
    strctLinearHistogramStretch.m_fCenter + afDelta(1)*fMaxWidth/400));

g_strctModule.m_strctMainVol.m_strctContrastTransform = strctLinearHistogramStretch;
fnInvalidate();
return;

function fnUpdateStatusLine(strctMouseOp)
global g_strctWindows

if ~isempty(strctMouseOp.m_pt2fPos)
    %set(g_strctWindows.m_hStatusLine,'string',sprintf('Mouse Down at [%.0f %.0f]',strctMouseOp.m_pt2fPos(1),strctMouseOp.m_pt2fPos(2)));
end;

return;

function [fDist, fDistFromCenter,afPenDir] = fnGetDistanceToLine(pt2fPos, hAxes)
afX = get(hAxes,'xdata');
afY = get(hAxes,'ydata');
fDist = abs(((afX(2)-afX(1)) * (afY(1)-pt2fPos(2)) - (afX(1)-pt2fPos(1))*(afY(2)-afY(1))) / sqrt( (afX(2)-afX(1))^2 + (afY(2)-afY(1))^2));
fDistFromCenter = sqrt( (mean(afX) - pt2fPos(1))^2 + (mean(afY) - pt2fPos(2))^2);
afPenDir = [afY(1)-afY(2), afX(2)-afX(1)] ./ sqrt((afX(2)-afX(1)).^2+ (afY(2)-afY(1)).^2);
return;

function [hAxes,bCloseToCenter, afPenDir,hAxesLine] = fnIntersectAxis(strctMouseOp)
global g_strctModule g_strctWindows
hAxes = [];
hAxesLine = [];
fThreshold = 10;
iWindowSize = g_strctModule.m_strctPanel.m_strctXY.m_aiPos(end);
fCenterDist = 0.6*(iWindowSize/2);
bCloseToCenter = false;
afPenDir = [];
if ~isempty(strctMouseOp.m_hAxes)
    switch strctMouseOp.m_hAxes
        case g_strctModule.m_strctPanel.m_strctXY.m_hAxes
            [fDistXZ, fDistFromCenterXZ,afPenDirXZ] =fnGetDistanceToLine(strctMouseOp.m_pt2fPos,  g_strctModule.m_strctPanel.m_strctXY.m_hLineXZ);
            [fDistYZ, fDistFromCenterYZ,afPenDirYZ] =fnGetDistanceToLine(strctMouseOp.m_pt2fPos,  g_strctModule.m_strctPanel.m_strctXY.m_hLineYZ);
            %[fDistXZ, fDistFromCenterXZ;fDistYZ, fDistFromCenterYZ]
            if fDistXZ < fDistYZ
                if fDistXZ < fThreshold
                    hAxes = g_strctModule.m_strctPanel.m_strctXZ.m_hAxes;
                    bCloseToCenter = fDistFromCenterXZ < fCenterDist;
                    afPenDir = afPenDirXZ;
                    hAxesLine = g_strctModule.m_strctPanel.m_strctXY.m_hLineXZ;
                end;
            else
                if fDistYZ < fThreshold
                    hAxes = g_strctModule.m_strctPanel.m_strctYZ.m_hAxes;
                    bCloseToCenter = fDistFromCenterYZ < fCenterDist;
                    afPenDir = -afPenDirYZ;
                    hAxesLine = g_strctModule.m_strctPanel.m_strctXY.m_hLineYZ;
                end;
            end;
         case g_strctModule.m_strctPanel.m_strctYZ.m_hAxes
            [fDistXZ, fDistFromCenterXZ,afPenDirXZ] =fnGetDistanceToLine(strctMouseOp.m_pt2fPos,  g_strctModule.m_strctPanel.m_strctYZ.m_hLineXZ);
            [fDistXY, fDistFromCenterXY,afPenDirXY] =fnGetDistanceToLine(strctMouseOp.m_pt2fPos,  g_strctModule.m_strctPanel.m_strctYZ.m_hLineXY);
            if fDistXZ < fDistXY
                if fDistXZ < fThreshold
                    hAxes = g_strctModule.m_strctPanel.m_strctXZ.m_hAxes;
                    bCloseToCenter = fDistFromCenterXZ < fCenterDist;
                    afPenDir = -afPenDirXZ;
                    hAxesLine = g_strctModule.m_strctPanel.m_strctYZ.m_hLineXZ;
                end;
            else
                if fDistXY < fThreshold
                    hAxes = g_strctModule.m_strctPanel.m_strctXY.m_hAxes;
                    bCloseToCenter = fDistFromCenterXY < fCenterDist;
                    afPenDir = afPenDirXY;
                    hAxesLine = g_strctModule.m_strctPanel.m_strctYZ.m_hLineXY;
                end;
            end;
        case g_strctModule.m_strctPanel.m_strctXZ.m_hAxes
            [fDistYZ, fDistFromCenterYZ,afPenDirYZ] =fnGetDistanceToLine(strctMouseOp.m_pt2fPos,  g_strctModule.m_strctPanel.m_strctXZ.m_hLineYZ);
            [fDistXY, fDistFromCenterXY,afPenDirXY] =fnGetDistanceToLine(strctMouseOp.m_pt2fPos,  g_strctModule.m_strctPanel.m_strctXZ.m_hLineXY);
            if fDistYZ < fDistXY
                if fDistYZ < fThreshold
                    hAxes = g_strctModule.m_strctPanel.m_strctYZ.m_hAxes;
                    bCloseToCenter = fDistFromCenterYZ < fCenterDist;
                    afPenDir = -afPenDirYZ;
                    hAxesLine = g_strctModule.m_strctPanel.m_strctXZ.m_hLineYZ;
                end;
            else
                if fDistXY < fThreshold
                    hAxes = g_strctModule.m_strctPanel.m_strctXY.m_hAxes;
                    bCloseToCenter = fDistFromCenterXY < fCenterDist;
                    afPenDir = afPenDirXY;
                    hAxesLine = g_strctModule.m_strctPanel.m_strctXZ.m_hLineXY;
                end;
            end;            
    end;
end;

if ~isempty(hAxes)
    if bCloseToCenter
       set(g_strctWindows.m_hFigure,'Pointer','fleur');
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
        
function fnMouseMove(strctMouseOp)
global g_strctModule
if ~g_strctModule.m_bVolumeLoaded
    return;
end;

if isempty(g_strctModule.m_strctPrevMouseOp)
    g_strctModule.m_strctPrevMouseOp = strctMouseOp;
end;
if ~g_strctModule.m_bFirstInvalidate && g_strctModule.m_bShow2DPlanes
    fnIntersectAxis(strctMouseOp);  % Change mouse cursor
end;

if  ~isempty(strctMouseOp.m_hAxes) 
    if g_strctModule.m_bMouseDown
        fnHandleMouseMoveWhileDown(g_strctModule.m_strctPrevMouseOp, strctMouseOp);
    else
        fnUpdateStatusLine(strctMouseOp);
    end;
end;
g_strctModule.m_strctPrevMouseOp = strctMouseOp;
return;
        
function fnMouseDown(strctMouseOp)
global g_strctModule
if ~g_strctModule.m_bVolumeLoaded
    return;
end;

if g_strctModule.m_bShow2DPlanes
    
    [strctMouseOp.m_hAxesSelected,bCloseToCenter,afPenDir,strctMouseOp.m_hAxesLineSelected] = fnIntersectAxis(strctMouseOp);
    if bCloseToCenter
        strctMouseOp.m_strAxisOp = 'Pan';
    else
        strctMouseOp.m_strAxisOp = 'Rotate';
    end;
    strctMouseOp.m_afAxesPen = afPenDir; % Penpendicular direction to selected axes
else
    strctMouseOp.m_hAxesSelected = [];
    strctMouseOp.m_hAxesLineSelected = [];
    strctMouseOp.m_afAxesPen = [];
end;

if strctMouseOp.m_hAxes == g_strctModule.m_strctPanel.m_strctOverlayAxes.m_hAxes
    Tmp = get(g_strctModule.m_strctPanel.m_strctOverlayAxes.m_hAxes,'CurrentPoint');
    pt2fMousePoint = Tmp([1,3]);
    fDistToLeft = norm(pt2fMousePoint-g_strctModule.m_strctOverlay.m_pt2fLeft);
    fDistToRight = norm(pt2fMousePoint-g_strctModule.m_strctOverlay.m_pt2fRight);
    fThreshold = 1;
    
    if fDistToLeft < fThreshold
        strctMouseOp.m_hObjectSelected = g_strctModule.m_strctPanel.m_strctOverlayAxes.hLeftPoint;
    elseif fDistToRight < fThreshold
        strctMouseOp.m_hObjectSelected = g_strctModule.m_strctPanel.m_strctOverlayAxes.hRightPoint;    
    else
        strctMouseOp.m_hObjectSelected = [];
    end
    %strctMouseOp.m_hObjectSelected = 
end;



g_strctModule.m_strctLastMouseDown = strctMouseOp;
g_strctModule.m_bMouseDown = true;


return;
       

function fnMouseUp(strctMouseOp)
global g_strctModule
g_strctModule.m_strctLastMouseUp = strctMouseOp;
g_strctModule.m_bMouseDown = false;
return;

function fnZoom3DAxes(iDirection)
global g_strctModule
q = max(-.9, min(.9, iDirection/70));

%posOld = get(g_strctModule.m_strctPanel.m_strct3D.m_hAxes,'CameraPosition');
camdolly(g_strctModule.m_strctPanel.m_strct3D.m_hAxes,0,0,q, 'f');

%     %If the dolly puts us too close to the target, undo the move:
%     dist = norm(get(haxes,'CameraPosition')-get(haxes,'CameraTarget'));
%     if dist > 3.3316e+003 || dist < 0.4
%         set(haxes,'CameraPosition',posOld);
%     end
   return;
 
function fnMouseWheel(strctMouseOp)
global g_strctModule
if isempty(strctMouseOp.m_hAxes) || ~g_strctModule.m_bVolumeLoaded
    return;
end;

if (strctMouseOp.m_hAxes == g_strctModule.m_strctPanel.m_strct3D.m_hAxes)
    fnZoom3DAxes(strctMouseOp.m_iScroll);
else
    fnShiftPlane(strctMouseOp.m_hAxes , strctMouseOp.m_iScroll)
end;

return;

function fnInvalidateOverlayAxes()
global g_strctModule
set(g_strctModule.m_strctPanel.m_strctOverlayAxes.hLine1,'xdata',[g_strctModule.m_afPvalueRange(1) g_strctModule.m_strctOverlay.m_pt2fLeft(1)],...
    'ydata',[g_strctModule.m_strctOverlay.m_pt2fLeft(2) g_strctModule.m_strctOverlay.m_pt2fLeft(2)]);

set(g_strctModule.m_strctPanel.m_strctOverlayAxes.hLine2,'xdata',...
    [g_strctModule.m_strctOverlay.m_pt2fLeft(1) g_strctModule.m_strctOverlay.m_pt2fRight(1)],...
    'Ydata',[g_strctModule.m_strctOverlay.m_pt2fLeft(2) g_strctModule.m_strctOverlay.m_pt2fRight(2)]);

set(g_strctModule.m_strctPanel.m_strctOverlayAxes.hLine3,'xdata',...
    [g_strctModule.m_strctOverlay.m_pt2fRight(1) g_strctModule.m_afPvalueRange(2) ],'ydata',...
    [g_strctModule.m_strctOverlay.m_pt2fRight(2) g_strctModule.m_strctOverlay.m_pt2fRight(2)]);

set(g_strctModule.m_strctPanel.m_strctOverlayAxes.hLeftPoint,'xdata',...
 g_strctModule.m_strctOverlay.m_pt2fLeft(1),'ydata',g_strctModule.m_strctOverlay.m_pt2fLeft(2));
 
set(g_strctModule.m_strctPanel.m_strctOverlayAxes.hRightPoint,'xdata',...
 g_strctModule.m_strctOverlay.m_pt2fRight(1),'ydata',g_strctModule.m_strctOverlay.m_pt2fRight(2));
return;

function fnRotatePlane(hAxes, fDiff)
global g_strctModule
switch hAxes
    
    case g_strctModule.m_strctPanel.m_strctXY.m_hLineYZ % bottom left, red
        g_strctModule.m_strctCrossSectionYZ = fnRotateCrossSectionAux(...
            g_strctModule.m_strctCrossSectionYZ, g_strctModule.m_strctCrossSectionXZ, -fDiff/100/2*pi);
        
    case g_strctModule.m_strctPanel.m_strctXY.m_hLineXZ % bottom left, green
        
        g_strctModule.m_strctCrossSectionXZ = fnRotateCrossSectionAux(...
            g_strctModule.m_strctCrossSectionXZ, g_strctModule.m_strctCrossSectionYZ, -fDiff/100/2*pi);
        
    case g_strctModule.m_strctPanel.m_strctXZ.m_hLineYZ % top right , red
        g_strctModule.m_strctCrossSectionYZ = fnRotateCrossSectionAux(...
            g_strctModule.m_strctCrossSectionYZ, g_strctModule.m_strctCrossSectionXY, -fDiff/100/2*pi);
        
    case g_strctModule.m_strctPanel.m_strctXZ.m_hLineXY % top right , blue
        
        g_strctModule.m_strctCrossSectionXY = fnRotateCrossSectionAux(...
            g_strctModule.m_strctCrossSectionXY, g_strctModule.m_strctCrossSectionYZ, -fDiff/100/2*pi);
        
    case g_strctModule.m_strctPanel.m_strctYZ.m_hLineXY % % top left, blue
        g_strctModule.m_strctCrossSectionXY = fnRotateCrossSectionAux(...
            g_strctModule.m_strctCrossSectionXY, g_strctModule.m_strctCrossSectionXZ, -fDiff/100/2*pi);
    case g_strctModule.m_strctPanel.m_strctYZ.m_hLineXZ % top left, green
        g_strctModule.m_strctCrossSectionXZ = fnRotateCrossSectionAux(...
            g_strctModule.m_strctCrossSectionXZ, g_strctModule.m_strctCrossSectionXY, -fDiff/100/2*pi);
end;
fnInvalidate();

return;

function fnShiftPlane(hAxes, fDiff)
global g_strctModule
switch hAxes
    case g_strctModule.m_strctPanel.m_strctXY.m_hAxes 
        afCurrPos = g_strctModule.m_strctCrossSectionXY.m_a2fM(1:3,4);
        afDirection = g_strctModule.m_strctCrossSectionXY.m_a2fM(:,3);
        afNewPos = afCurrPos + afDirection(1:3) * fDiff;
        afNewPosCropped = min( max(afNewPos, g_strctModule.m_strctMainVol.m_afRangeMM(:,1)), g_strctModule.m_strctMainVol.m_afRangeMM(:,2));
        g_strctModule.m_strctCrossSectionXY.m_a2fM(1:3,4) = afNewPosCropped;
        fnInvalidate();
    case g_strctModule.m_strctPanel.m_strctYZ.m_hAxes
        afCurrPos = g_strctModule.m_strctCrossSectionYZ.m_a2fM(1:3,4);
        afDirection = g_strctModule.m_strctCrossSectionYZ.m_a2fM(:,3);
        afNewPos = afCurrPos + afDirection(1:3) * fDiff;
        afNewPosCropped = min( max(afNewPos, g_strctModule.m_strctMainVol.m_afRangeMM(:,1)), g_strctModule.m_strctMainVol.m_afRangeMM(:,2));
        g_strctModule.m_strctCrossSectionYZ.m_a2fM(1:3,4) = afNewPosCropped;
        fnInvalidate();
    case g_strctModule.m_strctPanel.m_strctXZ.m_hAxes 
        afCurrPos = g_strctModule.m_strctCrossSectionXZ.m_a2fM(1:3,4);
        afDirection = g_strctModule.m_strctCrossSectionXZ.m_a2fM(:,3);
        afNewPos = afCurrPos + afDirection(1:3) * fDiff;
        afNewPosCropped = min( max(afNewPos, g_strctModule.m_strctMainVol.m_afRangeMM(:,1)), g_strctModule.m_strctMainVol.m_afRangeMM(:,2));
        g_strctModule.m_strctCrossSectionXZ.m_a2fM(1:3,4) = afNewPosCropped;
        fnInvalidate();
end;

return;

function fnSetSliceMode()
global g_strctModule
g_strctModule.m_strMouseMode = 'Scroll';
return;

function fnSetContrastMode()
global g_strctModule
g_strctModule.m_strMouseMode = 'Contrast';
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

function fnFirstInvalidate()
global g_strctModule
g_strctModule.m_bFirstInvalidate = false;
a2fXYZ_To_CRS = inv(g_strctModule.m_strctMainVol.m_a2fM);
[a2fCrossSectionXY, apt3fPlanePointsXY] = fnResampleCrossSection(g_strctModule.m_strctMainVol.m_a3fVol, a2fXYZ_To_CRS, g_strctModule.m_strctCrossSectionXY);
[a2fCrossSectionYZ, apt3fPlanePointsYZ] = fnResampleCrossSection(g_strctModule.m_strctMainVol.m_a3fVol, a2fXYZ_To_CRS, g_strctModule.m_strctCrossSectionYZ);
[a2fCrossSectionXZ, apt3fPlanePointsXZ] = fnResampleCrossSection(g_strctModule.m_strctMainVol.m_a3fVol, a2fXYZ_To_CRS, g_strctModule.m_strctCrossSectionXZ);


[pt2fXY_YZ_1, pt2fXY_YZ_2,...
          pt2fXY_XZ_1, pt2fXY_XZ_2, ...
          pt2fXZ_YZ_1, pt2fXZ_YZ_2,...
          pt2fXZ_XY_1, pt2fXZ_XY_2,...
          pt2fYZ_XY_1, pt2fYZ_XY_2,...
          pt2fYZ_XZ_1, pt2fYZ_XZ_2]= fnComputeCrossSectionIntersections();


g_strctModule.m_strctPanel.m_hPlaneXY = surface(reshape(apt3fPlanePointsXY(1,:),2,2),...
    reshape(apt3fPlanePointsXY(2,:),2,2),...
    reshape(apt3fPlanePointsXY(3,:),2,2), ...
    'parent',g_strctModule.m_strctPanel.m_strct3D.m_hAxes,'FaceAlpha',0.7,'FaceColor',[0 0 1 ],...
    'UIContextMenu', g_strctModule.m_strctPanel.m_hMenu3D);

g_strctModule.m_strctPanel.m_hPlaneYZ = surface(reshape(apt3fPlanePointsYZ(1,:),2,2),...
    reshape(apt3fPlanePointsYZ(2,:),2,2),...
    reshape(apt3fPlanePointsYZ(3,:),2,2), ...
    'parent',g_strctModule.m_strctPanel.m_strct3D.m_hAxes,'FaceAlpha',0.7,'FaceColor',[1 0 0],...
    'UIContextMenu', g_strctModule.m_strctPanel.m_hMenu3D);

g_strctModule.m_strctPanel.m_hPlaneXZ = surface(reshape(apt3fPlanePointsXZ(1,:),2,2),...
    reshape(apt3fPlanePointsXZ(2,:),2,2),...
    reshape(apt3fPlanePointsXZ(3,:),2,2), 'parent',...
    g_strctModule.m_strctPanel.m_strct3D.m_hAxes,'FaceAlpha',0.7,'FaceColor',[0 1 0],...
    'UIContextMenu', g_strctModule.m_strctPanel.m_hMenu3D);

g_strctModule.m_strctPanel.m_strctXY.m_hLineYZ = plot(g_strctModule.m_strctPanel.m_strctXY.m_hAxes, ...
    [pt2fXY_YZ_1(1),pt2fXY_YZ_2(1)],[pt2fXY_YZ_1(2),pt2fXY_YZ_2(2)],'r');

g_strctModule.m_strctPanel.m_strctXY.m_hLineXZ = plot(g_strctModule.m_strctPanel.m_strctXY.m_hAxes, ...
    [pt2fXY_XZ_1(1),pt2fXY_XZ_2(1)],[pt2fXY_XZ_1(2),pt2fXY_XZ_2(2)],'g');

g_strctModule.m_strctPanel.m_strctXZ.m_hLineYZ = plot(g_strctModule.m_strctPanel.m_strctXZ.m_hAxes, ...
    [pt2fXZ_YZ_1(1),pt2fXZ_YZ_2(1)],[pt2fXZ_YZ_1(2),pt2fXZ_YZ_2(2)],'r');
g_strctModule.m_strctPanel.m_strctXZ.m_hLineXY = plot(g_strctModule.m_strctPanel.m_strctXZ.m_hAxes, ...
    [pt2fXZ_XY_1(1),pt2fXZ_XY_2(1)],[pt2fXZ_XY_1(2),pt2fXZ_XY_2(2)],'b');


g_strctModule.m_strctPanel.m_strctYZ.m_hLineXY = plot(g_strctModule.m_strctPanel.m_strctYZ.m_hAxes, ...
    [pt2fYZ_XY_1(1),pt2fYZ_XY_2(1)],[pt2fYZ_XY_1(2),pt2fYZ_XY_2(2)],'b');
g_strctModule.m_strctPanel.m_strctYZ.m_hLineXZ = plot(g_strctModule.m_strctPanel.m_strctYZ.m_hAxes, ...
    [pt2fYZ_XZ_1(1),pt2fYZ_XZ_2(1)],[pt2fYZ_XZ_1(2),pt2fYZ_XZ_2(2)],'g');
set(g_strctModule.m_strctPanel.m_hWindowsPanel,'visible','on');
axes(g_strctModule.m_strctPanel.m_strct3D.m_hAxes);
camlight('right')
lighting('gouraud');
 return;
 
function [pt2fXY_YZ_1, pt2fXY_YZ_2,...
          pt2fXY_XZ_1, pt2fXY_XZ_2, ...
          pt2fXZ_YZ_1, pt2fXZ_YZ_2,...
          pt2fXZ_XY_1, pt2fXZ_XY_2,...
          pt2fYZ_XY_1, pt2fYZ_XY_2,...
          pt2fYZ_XZ_1, pt2fYZ_XZ_2]= fnComputeCrossSectionIntersections()
global  g_strctModule       

% XY crosshairs:
[pt2fXY_YZ_1, pt2fXY_YZ_2] = fnCrossSectionIntersection(...
    g_strctModule.m_strctCrossSectionXY, g_strctModule.m_strctCrossSectionYZ,...
    g_strctModule.m_strctMainVol.m_afRangeMM);

[pt2fXY_XZ_1, pt2fXY_XZ_2] = fnCrossSectionIntersection(...
    g_strctModule.m_strctCrossSectionXY, g_strctModule.m_strctCrossSectionXZ,...
    g_strctModule.m_strctMainVol.m_afRangeMM);

% XZ crosshairs:
[pt2fXZ_YZ_1, pt2fXZ_YZ_2] = fnCrossSectionIntersection(...
    g_strctModule.m_strctCrossSectionXZ, g_strctModule.m_strctCrossSectionYZ,...
    g_strctModule.m_strctMainVol.m_afRangeMM);

[ pt2fXZ_XY_1, pt2fXZ_XY_2] = fnCrossSectionIntersection(...
    g_strctModule.m_strctCrossSectionXZ, g_strctModule.m_strctCrossSectionXY,...
    g_strctModule.m_strctMainVol.m_afRangeMM);


% YZ crosshairs:
[ pt2fYZ_XY_1, pt2fYZ_XY_2] = fnCrossSectionIntersection(...
    g_strctModule.m_strctCrossSectionYZ, g_strctModule.m_strctCrossSectionXY,...
    g_strctModule.m_strctMainVol.m_afRangeMM);
[ pt2fYZ_XZ_1, pt2fYZ_XZ_2] = fnCrossSectionIntersection(...
    g_strctModule.m_strctCrossSectionYZ, g_strctModule.m_strctCrossSectionXZ,...
    g_strctModule.m_strctMainVol.m_afRangeMM);
return;        

function [a3fHeat, a2fAlpha] = fnOverlayContrastTransform(a2fI)
global g_strctModule

fWidth = g_strctModule.m_strctOverlay.m_pt2fRight(1)-g_strctModule.m_strctOverlay.m_pt2fLeft(1);
fHeight = abs(g_strctModule.m_strctOverlay.m_pt2fRight(2)-g_strctModule.m_strctOverlay.m_pt2fLeft(2));

a2fTmp = (a2fI - g_strctModule.m_strctOverlay.m_pt2fLeft(1)) / fWidth;
a2fTmp(a2fI < g_strctModule.m_strctOverlay.m_pt2fLeft(1)) = 0;
a2fTmp(a2fI > g_strctModule.m_strctOverlay.m_pt2fRight(1)) = 1;

% a2fTmp is now between [0,1]. It will be used to determine the heap map.
% Where 0 means anything left to m_pt2fLeft and 1 means anything right to
% m_pt2fRight
iNumColorQuant = 64;
a2fJetValues = autumn(iNumColorQuant);
a2iJetIndices = round( (1-a2fTmp) * (iNumColorQuant-1)) + 1;


a3fHeat = zeros([size(a2fTmp),3]);
a3fHeat(:,:,1) = reshape(a2fJetValues(a2iJetIndices,1),size(a2fTmp));
a3fHeat(:,:,2) = reshape(a2fJetValues(a2iJetIndices,2),size(a2fTmp));
a3fHeat(:,:,3) = reshape(a2fJetValues(a2iJetIndices,3),size(a2fTmp));

a2fAlpha = (1-a2fTmp) * fHeight + g_strctModule.m_strctOverlay.m_pt2fRight(2);
return;


function fnInvalidate()
global g_strctModule
if ~g_strctModule.m_bVolumeLoaded
 set(g_strctModule.m_strctPanel.m_hWindowsPanel,'visible','off');    
    return;
end;
a2fXYZ_To_CRS = inv(g_strctModule.m_strctMainVol.m_a2fM);
[a2fCrossSectionXY, apt3fPlanePointsXY] = fnResampleCrossSection(g_strctModule.m_strctMainVol.m_a3fVol, a2fXYZ_To_CRS, g_strctModule.m_strctCrossSectionXY);
[a2fCrossSectionYZ, apt3fPlanePointsYZ] = fnResampleCrossSection(g_strctModule.m_strctMainVol.m_a3fVol, a2fXYZ_To_CRS, g_strctModule.m_strctCrossSectionYZ);
[a2fCrossSectionXZ, apt3fPlanePointsXZ] = fnResampleCrossSection(g_strctModule.m_strctMainVol.m_a3fVol, a2fXYZ_To_CRS, g_strctModule.m_strctCrossSectionXZ);
a2fCrossSectionXY_Trans = fnContrastTransform(a2fCrossSectionXY, g_strctModule.m_strctMainVol.m_strctContrastTransform);
a2fCrossSectionYZ_Trans = fnContrastTransform(a2fCrossSectionYZ, g_strctModule.m_strctMainVol.m_strctContrastTransform);
a2fCrossSectionXZ_Trans = fnContrastTransform(a2fCrossSectionXZ, g_strctModule.m_strctMainVol.m_strctContrastTransform);

if g_strctModule.m_bFirstInvalidate
  fnFirstInvalidate();
end;


if isfield(g_strctModule,'m_strctFuncVol') && ~isempty(g_strctModule.m_strctFuncVol) && g_strctModule.m_bShowFunctional
    a2fXYZ_To_CRS_Func = inv(g_strctModule.m_strctFuncVol.m_a2fM) * (g_strctModule.m_strctFuncVol.m_a2fReg) ;
    [a2fCrossSectionXY_Func] = fnResampleCrossSection(g_strctModule.m_strctFuncVol.m_a3fVol, a2fXYZ_To_CRS_Func, g_strctModule.m_strctCrossSectionXY);
    [a2fCrossSectionYZ_Func] = fnResampleCrossSection(g_strctModule.m_strctFuncVol.m_a3fVol, a2fXYZ_To_CRS_Func, g_strctModule.m_strctCrossSectionYZ);
    [a2fCrossSectionXZ_Func] = fnResampleCrossSection(g_strctModule.m_strctFuncVol.m_a3fVol, a2fXYZ_To_CRS_Func, g_strctModule.m_strctCrossSectionXZ);
    
    [a3fXY_Func, a2fXY_Alpha] = fnOverlayContrastTransform(a2fCrossSectionXY_Func);
    [a3fXZ_Func, a2fXZ_Alpha] = fnOverlayContrastTransform(a2fCrossSectionXZ_Func);
    [a3fYZ_Func, a2fYZ_Alpha] = fnOverlayContrastTransform(a2fCrossSectionYZ_Func);
    
    
    a3fCrossSectionXY = ((1-fnDup3(a2fXY_Alpha)) .* fnDup3(a2fCrossSectionXY_Trans)) + fnDup3(a2fXY_Alpha) .* a3fXY_Func;
    a3fCrossSectionYZ = ((1-fnDup3(a2fYZ_Alpha)) .* fnDup3(a2fCrossSectionYZ_Trans)) + fnDup3(a2fYZ_Alpha) .* a3fYZ_Func;
    a3fCrossSectionXZ = ((1-fnDup3(a2fXZ_Alpha)) .* fnDup3(a2fCrossSectionXZ_Trans)) + fnDup3(a2fXZ_Alpha) .* a3fXZ_Func;
else
    % Set Overlays
    a3fCrossSectionXY = fnDup3(a2fCrossSectionXY_Trans);
    a3fCrossSectionYZ = fnDup3(a2fCrossSectionYZ_Trans);
    a3fCrossSectionXZ = fnDup3(a2fCrossSectionXZ_Trans);
    
end;

% Set Images
set(g_strctModule.m_strctPanel.m_strctXY.m_hImage,'cdata',a3fCrossSectionXY);
set(g_strctModule.m_strctPanel.m_strctYZ.m_hImage,'cdata',a3fCrossSectionYZ);
set(g_strctModule.m_strctPanel.m_strctXZ.m_hImage,'cdata',a3fCrossSectionXZ);

if g_strctModule.m_bShow3DPlanes
    % Set Crosshairs planes on 3D axes
    set(g_strctModule.m_strctPanel.m_hPlaneXY,'Xdata', reshape(apt3fPlanePointsXY(1,:),2,2),'Ydata',reshape(apt3fPlanePointsXY(2,:),2,2),'ZData',reshape(apt3fPlanePointsXY(3,:),2,2));
    set(g_strctModule.m_strctPanel.m_hPlaneYZ,'Xdata', reshape(apt3fPlanePointsYZ(1,:),2,2),'Ydata',reshape(apt3fPlanePointsYZ(2,:),2,2),'ZData',reshape(apt3fPlanePointsYZ(3,:),2,2));
    set(g_strctModule.m_strctPanel.m_hPlaneXZ,'Xdata', reshape(apt3fPlanePointsXZ(1,:),2,2),'Ydata',reshape(apt3fPlanePointsXZ(2,:),2,2),'ZData',reshape(apt3fPlanePointsXZ(3,:),2,2));
end;

if g_strctModule.m_bShow2DPlanes
    
    [pt2fXY_YZ_1, pt2fXY_YZ_2,...
        pt2fXY_XZ_1, pt2fXY_XZ_2, ...
        pt2fXZ_YZ_1, pt2fXZ_YZ_2,...
        pt2fXZ_XY_1, pt2fXZ_XY_2,...
        pt2fYZ_XY_1, pt2fYZ_XY_2,...
        pt2fYZ_XZ_1, pt2fYZ_XZ_2]= fnComputeCrossSectionIntersections();
    
    
    % Set crosshairs planes on 2D axes
    
    set(g_strctModule.m_strctPanel.m_strctXY.m_hLineYZ,'Xdata',[pt2fXY_YZ_1(1),pt2fXY_YZ_2(1)],'YData',[pt2fXY_YZ_1(2),pt2fXY_YZ_2(2)]);
    set(g_strctModule.m_strctPanel.m_strctXY.m_hLineXZ,'Xdata',[pt2fXY_XZ_1(1),pt2fXY_XZ_2(1)],'YData',[pt2fXY_XZ_1(2),pt2fXY_XZ_2(2)]);
    set(g_strctModule.m_strctPanel.m_strctXZ.m_hLineYZ,'Xdata',[pt2fXZ_YZ_1(1),pt2fXZ_YZ_2(1)],'YData',[pt2fXZ_YZ_1(2),pt2fXZ_YZ_2(2)]);
    set(g_strctModule.m_strctPanel.m_strctXZ.m_hLineXY,'Xdata',[pt2fXZ_XY_1(1),pt2fXZ_XY_2(1)],'YData',[pt2fXZ_XY_1(2),pt2fXZ_XY_2(2)]);
    set(g_strctModule.m_strctPanel.m_strctYZ.m_hLineXY,'Xdata',[pt2fYZ_XY_1(1),pt2fYZ_XY_2(1)],'YData',[pt2fYZ_XY_1(2),pt2fYZ_XY_2(2)]);
    set(g_strctModule.m_strctPanel.m_strctYZ.m_hLineXZ,'Xdata',[pt2fYZ_XZ_1(1),pt2fYZ_XZ_2(1)],'YData',[pt2fYZ_XZ_1(2),pt2fYZ_XZ_2(2)]);
end;

return

function Y=fnDup3(X)
Y=zeros([size(X),3]);
Y(:,:,1) = X;
Y(:,:,2) = X;
Y(:,:,3) = X;
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

