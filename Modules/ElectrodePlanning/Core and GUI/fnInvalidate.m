function fnInvalidate(bForceInvalidate)
%profile on
global g_strctModule
persistent strctPrevCrossSectionXY strctPrevCrossSectionYZ strctPrevCrossSectionXZ
persistent a2fPrevCrossSectionXY a2fPrevCrossSectionYZ a2fPrevCrossSectionXZ
persistent apt3fPrevPlanePointsXZ apt3fPrevPlanePointsYZ apt3fPrevPlanePointsXY %#ok
persistent a2fPrevCrossSectionXY_Func a2fPrevCrossSectionYZ_Func a2fPrevCrossSectionXZ_Func
if ~exist('bForceInvalidate','var')
    bForceInvalidate = false;
end;

if ~g_strctModule.m_bVolumeLoaded
 set(g_strctModule.m_strctPanel.m_hWindowsPanel,'visible','off');    
    return;
end;

if g_strctModule.m_bFirstInvalidate
  fnFirstInvalidate();
end;

a2fXYZ_To_CRS = inv(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fM) * inv(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fReg); %#ok

if ~isempty(g_strctModule.m_acFuncVol) &&  g_strctModule.m_iCurrFuncVol > 0 && g_strctModule.m_strctGUIOptions.m_bShowFunctional
    a2fXYZ_To_CRS_Func = inv(g_strctModule.m_acFuncVol{g_strctModule.m_iCurrFuncVol}.m_a2fM) * inv(g_strctModule.m_acFuncVol{g_strctModule.m_iCurrFuncVol}.m_a2fReg); %#ok
else
    a2fXYZ_To_CRS_Func = [];
end;

if fnSameStruct(strctPrevCrossSectionXY, g_strctModule.m_strctCrossSectionXY) && ~bForceInvalidate
    a2fCrossSectionXY = a2fPrevCrossSectionXY;
    a2fCrossSectionXY_Func = a2fPrevCrossSectionXY_Func;
else
    [a2fCrossSectionXY, apt3fPlanePointsXY] = fnResampleCrossSection(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a3fVol, a2fXYZ_To_CRS, g_strctModule.m_strctCrossSectionXY);
    
    Tmp= inv(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_strctCrossSectionHoriz.m_a2fM)*[apt3fPlanePointsXY;ones(1,size(apt3fPlanePointsXY,2))];
    apt3fPlanePointsXY=Tmp(1:3,:);
    
    a2fPrevCrossSectionXY =a2fCrossSectionXY;
    apt3fPrevPlanePointsXY = apt3fPlanePointsXY;
    strctPrevCrossSectionXY = g_strctModule.m_strctCrossSectionXY;
    
    if g_strctModule.m_strctGUIOptions.m_bShow3DPlanes % Set Crosshairs planes on 3D axes
        set(g_strctModule.m_strctPanel.m_hPlaneXY,'Xdata', reshape(apt3fPlanePointsXY(1,:),2,2),'Ydata',reshape(apt3fPlanePointsXY(2,:),2,2),'ZData',reshape(apt3fPlanePointsXY(3,:),2,2));
    end;
    if  ~isempty(g_strctModule.m_acFuncVol) &&  g_strctModule.m_iCurrFuncVol > 0 && g_strctModule.m_strctGUIOptions.m_bShowFunctional
        [a2fCrossSectionXY_Func] = fnResampleCrossSection(g_strctModule.m_acFuncVol{g_strctModule.m_iCurrFuncVol}.m_a3fVol, a2fXYZ_To_CRS_Func, g_strctModule.m_strctCrossSectionXY);
        a2fPrevCrossSectionXY_Func = a2fCrossSectionXY_Func;
    end;
end


if fnSameStruct(strctPrevCrossSectionYZ, g_strctModule.m_strctCrossSectionYZ) && ~bForceInvalidate
    a2fCrossSectionYZ = a2fPrevCrossSectionYZ;
    a2fCrossSectionYZ_Func = a2fPrevCrossSectionYZ_Func;
else
    [a2fCrossSectionYZ, apt3fPlanePointsYZ] = fnResampleCrossSection(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a3fVol, a2fXYZ_To_CRS, g_strctModule.m_strctCrossSectionYZ);
    
    Tmp= inv(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_strctCrossSectionHoriz.m_a2fM)*[apt3fPlanePointsYZ;ones(1,size(apt3fPlanePointsYZ,2))];
    apt3fPlanePointsYZ=Tmp(1:3,:);
    
    a2fPrevCrossSectionYZ =a2fCrossSectionYZ;
    apt3fPrevPlanePointsYZ = apt3fPlanePointsYZ;
    strctPrevCrossSectionYZ = g_strctModule.m_strctCrossSectionYZ;
    
    if g_strctModule.m_strctGUIOptions.m_bShow3DPlanes % Set Crosshairs planes on 3D axes
        set(g_strctModule.m_strctPanel.m_hPlaneYZ,'Xdata', reshape(apt3fPlanePointsYZ(1,:),2,2),'Ydata',reshape(apt3fPlanePointsYZ(2,:),2,2),'ZData',reshape(apt3fPlanePointsYZ(3,:),2,2));
    end;
    if ~isempty(g_strctModule.m_acFuncVol) &&  g_strctModule.m_iCurrFuncVol > 0 && g_strctModule.m_strctGUIOptions.m_bShowFunctional
        [a2fCrossSectionYZ_Func] = fnResampleCrossSection(g_strctModule.m_acFuncVol{g_strctModule.m_iCurrFuncVol}.m_a3fVol, a2fXYZ_To_CRS_Func, g_strctModule.m_strctCrossSectionYZ);
        a2fPrevCrossSectionYZ_Func = a2fCrossSectionYZ_Func;
    end;
end

if fnSameStruct(strctPrevCrossSectionXZ, g_strctModule.m_strctCrossSectionXZ) && ~bForceInvalidate
    a2fCrossSectionXZ = a2fPrevCrossSectionXZ;
    a2fCrossSectionXZ_Func = a2fPrevCrossSectionXZ_Func;
else
    [a2fCrossSectionXZ, apt3fPlanePointsXZ] = fnResampleCrossSection(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a3fVol, a2fXYZ_To_CRS, g_strctModule.m_strctCrossSectionXZ);
    
    Tmp= inv(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_strctCrossSectionHoriz.m_a2fM)*[apt3fPlanePointsXZ;ones(1,size(apt3fPlanePointsXZ,2))];
    apt3fPlanePointsXZ=Tmp(1:3,:);
    
    a2fPrevCrossSectionXZ =a2fCrossSectionXZ;
    apt3fPrevPlanePointsXZ = apt3fPlanePointsXZ;
    strctPrevCrossSectionXZ = g_strctModule.m_strctCrossSectionXZ;
    
     if g_strctModule.m_strctGUIOptions.m_bShow3DPlanes % Set Crosshairs planes on 3D axes
        set(g_strctModule.m_strctPanel.m_hPlaneXZ,'Xdata', reshape(apt3fPlanePointsXZ(1,:),2,2),'Ydata',reshape(apt3fPlanePointsXZ(2,:),2,2),'ZData',reshape(apt3fPlanePointsXZ(3,:),2,2));
    end;
    if ~isempty(g_strctModule.m_acFuncVol) &&  g_strctModule.m_iCurrFuncVol > 0 && g_strctModule.m_strctGUIOptions.m_bShowFunctional
        [a2fCrossSectionXZ_Func] = fnResampleCrossSection(g_strctModule.m_acFuncVol{g_strctModule.m_iCurrFuncVol}.m_a3fVol, a2fXYZ_To_CRS_Func, g_strctModule.m_strctCrossSectionXZ);
        a2fPrevCrossSectionXZ_Func = a2fCrossSectionXZ_Func;
    end;
end

%if g_strctModule.m_strctCrossSectionXY
% Use cache for fast drawing when there is no need to resample

a2fCrossSectionXY_Trans = fnContrastTransform(a2fCrossSectionXY, g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_strctContrastTransform);
a2fCrossSectionYZ_Trans = fnContrastTransform(a2fCrossSectionYZ, g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_strctContrastTransform);
a2fCrossSectionXZ_Trans = fnContrastTransform(a2fCrossSectionXZ, g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_strctContrastTransform);

a2fROIXY = zeros(size(a2fCrossSectionXY_Trans));
a2fROIYZ = zeros(size(a2fCrossSectionYZ_Trans));
a2fROIXZ = zeros(size(a2fCrossSectionXZ_Trans));

bOverlayBlood = g_strctModule.m_strctGUIOptions.m_bShowBloodVessels && ...
    ~isempty(g_strctModule.m_acAnatVol) && ...
    isfield(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol},'m_a3bBloodVolume') && ...
    ~isempty(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a3bBloodVolume);
if bOverlayBlood
            [a2fBloodXY] = fnResampleCrossSection(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a3bBloodVolume, a2fXYZ_To_CRS, g_strctModule.m_strctCrossSectionXY);
            [a2fBloodYZ] = fnResampleCrossSection(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a3bBloodVolume, a2fXYZ_To_CRS, g_strctModule.m_strctCrossSectionYZ);
            [a2fBloodXZ] = fnResampleCrossSection(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a3bBloodVolume, a2fXYZ_To_CRS, g_strctModule.m_strctCrossSectionXZ);
end




if ~isempty(g_strctModule.m_acFuncVol) && g_strctModule.m_iCurrFuncVol > 0 && g_strctModule.m_strctGUIOptions.m_bShowFunctional
    
    [a3fXY_Func, a2fXY_Alpha] = fnOverlayContrastTransform(a2fCrossSectionXY_Func);
    [a3fXZ_Func, a2fXZ_Alpha] = fnOverlayContrastTransform(a2fCrossSectionXZ_Func);
    [a3fYZ_Func, a2fYZ_Alpha] = fnOverlayContrastTransform(a2fCrossSectionYZ_Func);
    

    if bOverlayBlood
        a3fCrossSectionXY = ((1-fnDup3(a2fXY_Alpha)) .* fnDup3(a2fCrossSectionXY_Trans)) + fnDup3(a2fXY_Alpha) .* a3fXY_Func;
        a3fCrossSectionYZ = ((1-fnDup3(a2fYZ_Alpha)) .* fnDup3(a2fCrossSectionYZ_Trans)) + fnDup3(a2fYZ_Alpha) .* a3fYZ_Func;
        a3fCrossSectionXZ = ((1-fnDup3(a2fXZ_Alpha)) .* fnDup3(a2fCrossSectionXZ_Trans)) + fnDup3(a2fXZ_Alpha) .* a3fXZ_Func;
        
        a3fCrossSectionXY = fnOverlayBlood(a3fCrossSectionXY,a2fBloodXY>0);
        a3fCrossSectionYZ = fnOverlayBlood(a3fCrossSectionYZ,a2fBloodYZ>0);
        a3fCrossSectionXZ = fnOverlayBlood(a3fCrossSectionXZ,a2fBloodXZ>0);
        
        
    else
        a3fCrossSectionXY = ((1-fnDup3(a2fXY_Alpha)) .* fnDup3(a2fCrossSectionXY_Trans)) + fnDup3(a2fXY_Alpha) .* a3fXY_Func;
        a3fCrossSectionYZ = ((1-fnDup3(a2fYZ_Alpha)) .* fnDup3(a2fCrossSectionYZ_Trans)) + fnDup3(a2fYZ_Alpha) .* a3fYZ_Func;
        a3fCrossSectionXZ = ((1-fnDup3(a2fXZ_Alpha)) .* fnDup3(a2fCrossSectionXZ_Trans)) + fnDup3(a2fXZ_Alpha) .* a3fXZ_Func;
    end
    
else
    % No Overlays
        a3fCrossSectionXY = fnDup3(a2fCrossSectionXY_Trans);
        a3fCrossSectionYZ = fnDup3(a2fCrossSectionYZ_Trans);
        a3fCrossSectionXZ = fnDup3(a2fCrossSectionXZ_Trans);
    if bOverlayBlood
        a3fCrossSectionXY = fnOverlayBlood(a3fCrossSectionXY,a2fBloodXY>0);
        a3fCrossSectionYZ = fnOverlayBlood(a3fCrossSectionYZ,a2fBloodYZ>0);
        a3fCrossSectionXZ = fnOverlayBlood(a3fCrossSectionXZ,a2fBloodXZ>0);
    end
    
end;



if g_strctModule.m_strctGUIOptions.m_bShowTimeCourse
    fnShowTimeCourse();
end


if g_strctModule.m_strctGUIOptions.m_bShowROIs
    a3bTemp = zeros(size(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a3fVol),'uint8')>0;
    for k=1:length(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctROIs)
        if g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctROIs(k).m_bVisible
            a3bTemp(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctROIs(k).m_aiVolumeIndices) = true;
        end
    end
    [a2fROIXY] = fnResampleCrossSection(a3bTemp, a2fXYZ_To_CRS, g_strctModule.m_strctCrossSectionXY);
    [a2fROIYZ] = fnResampleCrossSection(a3bTemp, a2fXYZ_To_CRS, g_strctModule.m_strctCrossSectionYZ);
    [a2fROIXZ] = fnResampleCrossSection(a3bTemp, a2fXYZ_To_CRS, g_strctModule.m_strctCrossSectionXZ);
    a3fCrossSectionXY = fnOverlayROI(a3fCrossSectionXY,a2fROIXY>0);
    a3fCrossSectionYZ = fnOverlayROI(a3fCrossSectionYZ,a2fROIYZ>0);
    a3fCrossSectionXZ = fnOverlayROI(a3fCrossSectionXZ,a2fROIXZ>0);
end
% Image series overlay....
[a3fCrossSectionXY,a3fCrossSectionYZ,a3fCrossSectionXZ]=fnInvalidateImageSeries(a3fCrossSectionXY,a3fCrossSectionYZ,a3fCrossSectionXZ);

%%




% Set Images
set(g_strctModule.m_strctPanel.m_strctXY.m_hImage,'cdata',a3fCrossSectionXY);
set(g_strctModule.m_strctPanel.m_strctYZ.m_hImage,'cdata',a3fCrossSectionYZ);
set(g_strctModule.m_strctPanel.m_strctXZ.m_hImage,'cdata',a3fCrossSectionXZ);


if g_strctModule.m_strctGUIOptions.m_bShow2DPlanes
    
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

if g_strctModule.m_strctGUIOptions.m_bShowChamber
    fnUpdateChamberContour();
end;

if g_strctModule.m_strctGUIOptions.m_bShowTargets
    fnUpdateTargetContours();
else
    fnDeleteTargetContours();
end;



if g_strctModule.m_strctGUIOptions.m_bShowFreesurferSurfaces
    fnUpdateFreesurferContours();
else
    fnDeleteFreesurferContours();
end;



if ~isfield(g_strctModule.m_strctGUIOptions,'m_bShowAtlas')
    g_strctModule.m_strctGUIOptions.m_bShowAtlas = false;
end;

if g_strctModule.m_strctGUIOptions.m_bShowAtlas
    fnUpdateAtlasContours();
else
    fnDeleteAtlasContours();
end;


 fnDrawControlableObject();


if isfield(g_strctModule.m_strctGUIOptions,'m_bShowMarkers') && g_strctModule.m_strctGUIOptions.m_bShowMarkers
    fnUpdateMarkerContours();
else
    fnDeleteMarkerContours();
    g_strctModule.m_strctGUIOptions.m_bShowMarkers = false;
end;

set(g_strctModule.m_strctPanel.m_strctYZ.m_ahTextHandles(9),'string', sprintf('C %d',round(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_strctContrastTransform.m_fCenter)));
set(g_strctModule.m_strctPanel.m_strctYZ.m_ahTextHandles(10),'string',sprintf('W %d',round(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_strctContrastTransform.m_fWidth)));

fnDrawScaleBar();

%profile off
%profile viewer
return
