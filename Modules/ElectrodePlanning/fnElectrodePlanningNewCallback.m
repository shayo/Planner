function fnElectrodePlanningNewCallback(strCallback, varargin)
global g_strctWindows g_strctModule %#ok
switch strCallback
    case 'StereotaxHelper'
        fnStereotaxHelper();
    case 'ModifyImageSeries'
        fnModifyImageSeries();
    case 'ToggleLabelsVisibility'
        fnToggleLabelsVisibility();
    case 'ScaleEntireImageSeriesKeepAspect'
        fnChangeMouseMode('ScaleEntireImageSeriesKeepAspect','Scale Series');
    case 'MoveEntireImageSeries'
        fnChangeMouseMode('MoveEntireImageSeries','Move Series');
    case 'RotateEntireImageSeries'
        fnChangeMouseMode('RotateEntireImageSeries','Rotate Series');
    case 'ScaleEntireImageSeries'
        fnChangeMouseMode('ScaleEntireImageSeries','Scale Series');
    case 'MoveImageInImageSeries'
        fnChangeMouseMode('MoveImageInImageSeries','Move Image(s)');
    case 'RotateImageInImageSeries'
        fnChangeMouseMode('RotateImageInImageSeries','Rotate Image(s)');
    case 'ScaleImageInImageSeries'
        fnChangeMouseMode('ScaleImageInImageSeries','Scale Image(s)');
    case 'ScaleImageInImageSeriesKeepAspect'
        fnChangeMouseMode('ScaleImageInImageSeriesKeepAspect','Scale Image(s)');
    case 'SelectImageFromSeries'
        fnSelectImageFromSeries();
    case 'NewImageSeries'
        fnNewImageSeries();
    case 'DeleteImageSeries'
        fnDeleteImageSeries();
    case 'AddImagesToImageSeries'
        fnAddImagesToImageSeries();
    case 'RemoveImagesFromImageSeries'
        fnRemoveImagesFromImageSeries();
    case 'KeyDown'
        fnKeyDown(varargin{1});
    case 'KeyUp'
        fnKeyUp(varargin{1});
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
    case 'InvalidateStereotactic'
        fnInvalidateStereotactic();
    case 'SetSlicesMode'
        fnSetSliceMode();
    case 'SetContrastMode'
        fnSetContrastMode();
    case 'SetZoomMode'
        fnSetZoomMode();
    case 'SetLinkedZoomMode'
        fnSetLinkedZoomMode();
    case 'SetPanMode'
        fnSetPanMode();
    case 'SetRotateMode'
        fnSetRotateMode();
    case 'SetCrosshairMode'
        fnSetCrosshairMode();
    case 'SetDefaultView'
        fnSetDefaultCrossSections();
        fnInvalidate();
    case 'SetAtlasView'
        fnAlignViewWithAtlas( );
        fnInvalidate();
    case 'ExportCoronal'
        fnExportCoronal();
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
    case 'SwitchFunc'
        fnSetCurrFuncVol();
    case 'SetRotate2DMode'
        fnSetRotate2DMode();
    case 'SetRotateChamber3DMode'
        fnSetRotateChamber3DMode();
    case 'SetRotateVolumeMode'
        fnSetRotateVolumeMode();
    case 'SelectChamber'
        fnSelectChamber();
    case 'SelectGrid'
        fnSelectGrid();
    case 'AddGridFromModel'
        fnAddGridFromModel(varargin{1});
    case 'AddGrid'
        iGridModel = varargin{1};
        if nargin > 2
            iGridSubModel = varargin{2};
        else
            iGridSubModel = [];
        end
        fnAddGrid(iGridModel,iGridSubModel);
    case 'AddChamberSinglePoint'
        fnAddChamberNormalToPlane();
    case 'AddChamberTwoPoints'
        fnAddChamberInPlane();
        
    case 'SetChamberTrans'
        fnSetChamberTransMode();
    case 'SetChamberRot'
        fnSetChamberRotMode();
    case 'RotChamberAccurate'
        RotateChamberByFixedAmount();
    case 'ShowHideChamber'
        fnHideShowShowHideChamber();
    case 'PrintSlices'
        fnPrintSlices();
    case 'AddTarget'
        fnAddTarget();
    case 'MoveTarget'
        fnSelectMoveTarget();
    case 'SelectTarget'
        fnSelectTarget();
    case 'TargetRename'
        fnRenameTarget();
    case 'TargetKeepView'
        fnTargetKeepView();
    case 'RotateGrid'
        fnRotateGrid();
    case 'ShowHideTargets'
        fnHideShowTargets();
    case 'TargetFindHole'
        fnTargetFindHole();
    case 'TargetFindHoleWithGridRotation'
        fnTargetFindHoleWithGridRotation();
    case 'TargetFindGridAndHole'
        fnTargetFindGridAndHole();
    case 'SaveSession'
        fnSaveSession();
    case 'LoadSession'
        fnLoadSession();
    case 'RemoveGrid'
        fnRemoveGrid();
    case 'RenameGrid'
        fnRenameGrid();
    case 'RemoveTarget'
        fnRemoveTarget();
    case 'RenameFunc'
        fnRenameFunc();
    case 'RenameAnat'
        fnRenameAnat();
    case 'RemoveAnat'
        fnRemoveAnat();
    case 'RemoveFunc'
        fnRemoveFunc();
    case 'RenameChamber'
        fnRenameChamber();
    case 'RemoveChamber'
        fnRemoveChamber();
    case 'fnApplyAnatTrans'
        fnApplyAnatTrans();
    case 'fnApplyAnatInvTrans'
        fnApplyAnatInvTrans();
    case 'fnApplyFuncTrans'
        fnApplyFuncTrans();
    case 'fnApplyFuncInvTrans'
        fnApplyFuncInvTrans();
    case 'fnAlignToChamber'
        fnAlignToChamber();
    case 'DuplicateGrid'
        fnDuplicateGrid();
    case 'SetFocus'
        fnSetFocus();
    case 'ShowHideBloodVessels'
        fnShowHideBloodVessels();
    case 'RemoveBloodVessel'
        fnRemoveBloodVessel();
    case 'RenameBloodVessel'
        fnRenameBloodVessel();
    case 'SelectBloodVessel'
        fnSelectBloodVessel();
    case 'PrintGrid'
        fnPrintGrid();
    case 'MeasureDist'
        fnMeasureDist();
    case 'AddGridUsingDirection'
        fnAddGridUsingDirection();
    case 'MeasureDistTopGrid'
        fnMeasureDistTopGrid();
    case 'SetDepth'
        fnSetDepth();
    case 'SetNormalMode'
        fnSetNormalMode();
    case 'SetChamberMode'
        SetChamberMode();
    case 'ModuleSwitch'
        fnSetNormalMode();
    case 'SetArmOnMarker'
        fnSetArmOnMarker();
    case 'AddMarker'
        fnAddMarker();
    case 'AddMarkerSmart'
        fnAddMarkerSmart();
    case 'RotateMarker'
        fnRotateMarker();
    case 'MoveMarker'
        fnMoveMarker();
    case 'ShowHideMarkers'
        fnShowHideMarkers();
    case 'RemoveMarker'
        fnRemoveMarker();
    case 'RenameMarker'
        fnRenameMarker();
    case 'SwitchMarker'
        fnSelectMarker();
    case 'SwitchChamber'
        fnSelectNewChamberInPlanningMode();
    case 'AddBloodVesselMode'
        fnAddBloodVesselMode();
    case 'RemoveBloodVesselMode'
        fnRemoveBloodVesselMode();
    case 'ShowHideTimeCourse'
        fnShowHideTimeCourse();
    case 'LongChamber'
        fnLongChamber();
    case 'RendererToggle'
        fnRendererToggle();
    case 'LongGrid'
        fnLongGridMode();
    case 'SetGridTrans'
        fnSetGridTrans();
    case 'Rot3Edit'
        fnSetMarkerRot3();
    case 'IsoSurfaceThresholdMode'
        fnIsoSurfaceThresholdMode();
    case 'SetChamberRotateAxis'
        fnSetChamberRotateAxis();
    case 'RegenerateBloodSurface'
        fnRegenerateBloodSurface();
    case 'ProjectBloodPattern'
        fnProjectBloodPattern();
    case 'SwitchStereoModel'
        fnSwitchStereoModel();
    case 'JointEdit'
        fnJointEdit();
    case 'SwitchJoint'
        fnSwitchJoint();
    case 'SwitchStereoArm'
        fnSwitchStereoArm();
    case 'ExportAnatRegMatrix'
        fnExportAnatRegMatrix();
    case 'AddChamberUsingArm'
        fnAddChamberUsingArm();
    case 'SetChamberTransAxis'
        fnSetChamberTransAxis();
    case 'FlipChamberAxis'
        fnFlipChamberAxis();
    case 'AlignToGridHole'
        fnAlignToGridHole(varargin{1});
    case 'GridMIPFuncNeg'
        fnGridMIPFuncNeg();
    case 'GridMIPFuncPos'
        fnGridMIPFuncPos();
    case 'GridMIPVessels'
        fnGridMIPVessels();
    case 'VirtualArmAddChamber'
        fnVirtualArmAddChamber();
    case 'VirtualArmSave'
        fnVirtualArmSave();
    case 'SetNewVirtualArmType'
        fnChangeVirtualArmType();
    case 'FeaturesRegistration'
        fnFeaturesRegistration();
    case 'EarBarZeroRegistration'
        fnEarBarZeroRegistration();
    case 'SolveRegistration'
        fnSolveRegistration();
    case 'LinkEditValue'
        fnLinkEditValue(varargin{1});
    case 'LinkSliderValue'
        fnLinkSliderValue(varargin{1});
    case 'LinkFixValue'
        fnLinkFixValue(varargin{1});
    case 'SwitchVirtualArm'
        fnSwitchVirtualArm();
    case 'ChangeChamberType'
        fnChangeChamberType(varargin{1})
    case 'ExportFuncRegMatrix'
        fnExportFuncRegMatrix();
        
    case 'ExportFuncVol'
        fnExportFuncVol();
    case 'ExportAnatVol'
        fnExportAnatVol();
    case 'SetNewVirtualChamberType'
        fnSetNewVirtualChamberType();
    case 'SolveWithVirtualArm'
        fnSolveWithVirtualArm();
    case 'HideShowSurface'
        fnHideShowSurface();
    case 'HideShowBloodVessels'
        fnHideShowBloodVessels();
    case 'PrintMarkerTable'
        fnPrintMarkerTable();
    case 'SwithMarker'
        fnSwithMarker();
    case 'CorrectOrientation'
        fnCorrectOrientation();
    case 'AddSurface'
        fnAddSurface();
    case 'AddBloodVessels'
        fnAddBloodVessels();
    case 'fnShowHideChamber'
        fnfnShowHideChamber();
    case 'GridAlwaysVisible'
        fnGridAlwaysVisible();
    case 'UpdateGridModel'
        fnUpdateGridModel(varargin{1});
    case 'SetFullScreen'
        fnSetFullScreen();
    case 'SetAtlasMode'
        fnSetAtlasMode();
    case 'ToggleAtlas'
        fnToggleAtlas();
    case 'MoveAtlasMouse'
        fnMoveAtlasMouse();
    case 'RotateAtlasMouse'
        fnRotateAtlasMouse();
    case 'ScaleAtlasMouse'
        fnScaleAtlasMouse();
    case 'SearchAtlasRegion'
        fnSearchAtlasRegion();
    case 'LocalizeRegion'
        fnLocalizeRegion();
    case 'SetNewDefaultView'
        fnSetNewDefaultView();
    case 'SetNewAtlas'
        fnSetNewAtlas();
    case 'QueryAtlasMode'
        fnQueryAtlasMode();
    case 'MoveLightSource'
        fnMoveLightSource();
    case 'Pan3D'
        fnPan3D();
    case 'AddChamber3D'
        fnAddChamber3D();
    case 'AddChamber3DTowardsTarget'
        fnAddChamber3DTowardsTarget();
    case 'AddRuler'
        fnAddRuler();
    case 'RemoveRuler'
        fnRemoveRuler(varargin{1});
    case 'PrintInfoAnat'
        fnPrintInfoAnat();
    case 'PrintInfoFunc'
        fnPrintInfoFunc();
    case 'AddFreesurferSurface'
        fnAddFreesurferSurface();
    case 'ToggleSurfaceVisibility2D'
        fnToggleFreesurferSurfaceVisibility2D();
    case 'ToggleSurfaceVisibility3D'
        fnToggleFreesurferSurfaceVisibility3D();
    case 'AddDerivedFreesurferSurface'
        fnAddDerivedFreesurferSurface();
    case 'ChangeSurfaceColor'
    case 'RenameSurface'
    case 'DeleteSurface'
        fnRemoveFreesurferSurface();
    case 'SelectSurface'
        fnSelectSurface();
    case 'SetEraseMode'
        b2D = strcmpi(varargin{1},'2D');
        fnSetEraseMode(b2D);
    case 'SetROIAdd'
        b2D = strcmpi(varargin{1},'2D');
        fnSetROIAdd(b2D);
    case 'SetROISubtract'
        b2D = strcmpi(varargin{1},'2D');
        fnSetROISubtract(b2D);
    case 'SelectDerivedSurface'
        dbg = 1;
        
    case 'ROIFromFunctional'
        fnAddNewROIUsingSeedPoint();
    case 'AddNewROI'
        fnAddNewROI();
    case 'RenameROI'
        fnRenameROI();
    case 'ProjectROIonSurface'
    case 'DeleteROI'
        fnDeleteROIs();
    case 'ToggleVisibilityROI'
        fnToggleVisibilityROI();
    case 'ClearROI'
        fnClearROIs();
    case 'ToggleROIsVisibility'
        g_strctModule.m_strctGUIOptions.m_bShowROIs  = ~g_strctModule.m_strctGUIOptions.m_bShowROIs ;
        fnInvalidate(1);
    case 'AddNewROIUsingAtlas'
        fnAddNewROIUsingAtlas();
    case 'SelectImageSeries'
        fnSelectImageSeries();
    case 'ToggleScaleBar'
        fnToggleScaleBar();
    case 'SetScaleBarLocation'
        fnSetScaleBarLocation(varargin{1});
    case 'SetScaleBarLength'
        fnSetScaleBarLength(varargin{1});
    case 'SetFixedZoom'
        fnSetFixedZoom(varargin);
    case 'MoveAnatDown'
        fnMoveAnatInList('Down');
    case 'MoveAnatUp'
        fnMoveAnatInList('Up');
    case 'MoveAnatFirst'
        fnMoveAnatInList('First');
    case 'MoveAnatLast'
        fnMoveAnatInList('Last');
    case 'MoveFuncDown'
        fnMoveFuncInList('Down');        
    case 'MoveFuncUp'
        fnMoveFuncInList('Up');        
    case 'MoveFuncFirst'
        fnMoveFuncInList('First');        
    case 'MoveFuncLast'
        fnMoveFuncInList('Last');        
    case 'ToggleChambeAnglesVisibility'
        fnToggleChambeAnglesVisibility();
        
    otherwise
        dbg = 1; %#ok
end

return;

function fnToggleChambeAnglesVisibility()
global g_strctModule
g_strctModule.m_strctGUIOptions.m_bChamberAngles = ~g_strctModule.m_strctGUIOptions.m_bChamberAngles;
if (g_strctModule.m_strctGUIOptions.m_bChamberAngles)
    set(g_strctModule.m_strctPanel.m_strctYZ.m_ahTextHandles(12),'Visible','on')
else
    set(g_strctModule.m_strctPanel.m_strctYZ.m_ahTextHandles(12),'Visible','off')
end
fnInvalidate(true);
return

function fnKeyUp(strctKey)
global g_strctModule
if isfield(strctKey,'Key') && strcmpi(strctKey.Key,'shift')
    g_strctModule.m_bShiftPressed = false;
end
return;


function fnKeyDown(strctKey)
global g_strctModule
if isfield(strctKey,'Key') && strcmpi(strctKey.Key,'escape')
    fnChangeMouseMode('Scroll');
end
if isfield(strctKey,'Key') && strcmpi(strctKey.Key,'shift')
    g_strctModule.m_bShiftPressed = true;
end
if isfield(strctKey,'Key') && strcmpi(strctKey.Key,'space')
    g_strctModule.m_strctGUIOptions.m_bImageSeries = ~g_strctModule.m_strctGUIOptions.m_bImageSeries;
    fnInvalidate();
end
if isfield(strctKey,'Key') && strcmpi(strctKey.Key,'period')
    iActiveSeries = get(g_strctModule.m_strctPanel.m_hImageSeriesList,'value');
    g_strctModule.m_astrctImageSeries(iActiveSeries).m_fOpacity = min(1,g_strctModule.m_astrctImageSeries(iActiveSeries).m_fOpacity + 0.1);
    fnInvalidate();
end
if isfield(strctKey,'Key') && strcmpi(strctKey.Key,'comma')
    iActiveSeries = get(g_strctModule.m_strctPanel.m_hImageSeriesList,'value');
    g_strctModule.m_astrctImageSeries(iActiveSeries).m_fOpacity = max(0,g_strctModule.m_astrctImageSeries(iActiveSeries).m_fOpacity - 0.1);
    fnInvalidate();
end

return;


function fnHandleMouseMoveWhileDown(strctPrevMouseOp, strctMouseOp)

global g_strctModule g_strctWindows
afDelta= strctMouseOp.m_pt2fPos - strctPrevMouseOp.m_pt2fPos;
afDiff = g_strctModule.m_strctLastMouseDown.m_pt2fPos - strctMouseOp.m_pt2fPos;

if ~isempty(g_strctModule.m_strctLastMouseDown.m_hAxes) && (strcmp(g_strctModule.m_strMouseMode,'AddBloodVessel')  || strcmp(g_strctModule.m_strMouseMode,'RemoveBloodVessel') )&& ...
        ((g_strctModule.m_strctLastMouseDown.m_hAxes == g_strctModule.m_strctPanel.m_strctXY.m_hAxes) || ...
        (g_strctModule.m_strctLastMouseDown.m_hAxes == g_strctModule.m_strctPanel.m_strctYZ.m_hAxes) || ...
        (g_strctModule.m_strctLastMouseDown.m_hAxes == g_strctModule.m_strctPanel.m_strctXZ.m_hAxes) )
    
    [pt3fPosIn3DSpace,pt3fPosInStereoSpace, pt3fVoxelCoordinate, strctCrossSection,pt3fPosInAtlasSpace]=fnGet3DCoord(strctMouseOp); %#ok
    if strcmp(g_strctModule.m_strMouseMode,'AddBloodVessel')
        iCubeRad = 0;
        aiYRange = min(size( g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a3bBloodVolume,1),      max(1,round(pt3fVoxelCoordinate(2))-iCubeRad:round(pt3fVoxelCoordinate(2))+iCubeRad));
        aiXRange = min(size( g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a3bBloodVolume,2),max(1,round(pt3fVoxelCoordinate(1))-iCubeRad:round(pt3fVoxelCoordinate(1))+iCubeRad));
        aiZRange = min(size( g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a3bBloodVolume,3),max(1,round(pt3fVoxelCoordinate(3))-iCubeRad:round(pt3fVoxelCoordinate(3))+iCubeRad));
        
        g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a3bBloodVolume(aiYRange,aiXRange,aiZRange) = 1;
    else
        iCubeRad = 1;
        aiYRange = min(size( g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a3bBloodVolume,1),      max(1,round(pt3fVoxelCoordinate(2))-iCubeRad:round(pt3fVoxelCoordinate(2))+iCubeRad));
        aiXRange = min(size( g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a3bBloodVolume,2),max(1,round(pt3fVoxelCoordinate(1))-iCubeRad:round(pt3fVoxelCoordinate(1))+iCubeRad));
        aiZRange = min(size( g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a3bBloodVolume,3),max(1,round(pt3fVoxelCoordinate(3))-iCubeRad:round(pt3fVoxelCoordinate(3))+iCubeRad));
        g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a3bBloodVolume(aiYRange,aiXRange,aiZRange) = 0;
    end
    % HERE !
    fnInvalidate(1);
    %strctSurfaceLargeMesh = isosurface(a3bVolume,0.5);%a3iX,a3iY, a3iZ,a3bVolSub, 0.5);
    %strctSurface = reducepatch(strctSurfaceLargeMesh, strctVol.m_strctFrangiParam.NumberOfFaces);
    
    return;
end

if ~isempty(g_strctModule.m_strctLastMouseDown.m_hAxes) && strcmp(g_strctModule.m_strMouseMode,'MeasureDist') && ...
        ((g_strctModule.m_strctLastMouseDown.m_hAxes == g_strctModule.m_strctPanel.m_strctXY.m_hAxes) || ...
        (g_strctModule.m_strctLastMouseDown.m_hAxes == g_strctModule.m_strctPanel.m_strctYZ.m_hAxes) || ...
        (g_strctModule.m_strctLastMouseDown.m_hAxes == g_strctModule.m_strctPanel.m_strctXZ.m_hAxes) )
    
    if ~isempty(g_strctModule.m_strctPanel.m_hMeasureLine)
        set(g_strctModule.m_strctPanel.m_hMeasureLine,'xdata',...
            [g_strctModule.m_strctLastMouseDown.m_pt2fPos(1),strctMouseOp.m_pt2fPos(1)],...
            'ydata',[g_strctModule.m_strctLastMouseDown.m_pt2fPos(2),strctMouseOp.m_pt2fPos(2)]);
        
        if strcmpi(g_strctModule.m_strDistMode,'PointToPoint');
            
            switch  g_strctModule.m_strctLastMouseDown.m_hAxes
                case g_strctModule.m_strctPanel.m_strctXY.m_hAxes
                    strctCrossSection = g_strctModule.m_strctCrossSectionXY;
                case g_strctModule.m_strctPanel.m_strctYZ.m_hAxes
                    strctCrossSection = g_strctModule.m_strctCrossSectionYZ;
                case g_strctModule.m_strctPanel.m_strctXZ.m_hAxes
                    strctCrossSection = g_strctModule.m_strctCrossSectionXZ;
            end;
            fDistXMM = afDiff(1) / strctCrossSection.m_iResWidth * (2*strctCrossSection.m_fHalfWidthMM);
            fDistYMM = afDiff(2) / strctCrossSection.m_iResHeight * (2*strctCrossSection.m_fHalfHeightMM);
            
            
            fAngleRad = -atan2(fDistYMM,fDistXMM)-pi/2;
            fDiffMM = sqrt(fDistXMM^2+fDistYMM^2);
            set(g_strctModule.m_strctPanel.m_hMeasureText,'string',sprintf('%.3f mm, %.2f Deg',fDiffMM,fAngleRad/pi*180),'FontSize',11,'FontWeight','bold');
        elseif strcmpi(g_strctModule.m_strDistMode,'PointToGridTop');
            
            if ~isempty(g_strctModule.m_acAnatVol) && g_strctModule.m_iCurrAnatVol > 0 && ~isempty(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers) && ...
                    g_strctModule.m_iCurrChamber > 0 && g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber).m_iGridSelected > 0
                strctChamber = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber);
                iSelectedGrid=g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber).m_iGridSelected;
                
                
                strctGrid = strctChamber.m_astrctGrids(iSelectedGrid);
                a2fCRS_To_XYZ = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fReg*g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fM;
                a2fM = a2fCRS_To_XYZ*strctChamber.m_a2fM_vox;
                a2fGridOffsetTransform = eye(4);
                a2fGridOffsetTransform(3,4) = -strctGrid.m_fChamberDepthOffset;
                a2fM_WithMeshOffset =a2fM*a2fGridOffsetTransform;
                pt3fPosIn3DSpace=fnGet3DCoord(strctMouseOp);
                
                [fMinDist, afMinDistToTarget, iBestHole, fDistanceFromHoleMM]=fnGridErrorFunction(...
                    g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber).m_astrctGrids(iSelectedGrid).m_strctModel,...
                    pt3fPosIn3DSpace, a2fM_WithMeshOffset); %#ok
                set(g_strctModule.m_strctPanel.m_hMeasureText,'string',sprintf('%.3f mm from grid top',fDistanceFromHoleMM),'FontSize',11,'FontWeight','bold');
            end
        end
    else
        g_strctModule.m_strctPanel.m_hMeasureLine = plot(g_strctModule.m_strctLastMouseDown.m_hAxes,...
            [g_strctModule.m_strctLastMouseDown.m_pt2fPos(1),strctMouseOp.m_pt2fPos(1)],...
            [g_strctModule.m_strctLastMouseDown.m_pt2fPos(2),strctMouseOp.m_pt2fPos(2)],'g','LineWidth',1);
        
        g_strctModule.m_strctPanel.m_hMeasureText = text(g_strctModule.m_strctLastMouseDown.m_pt2fPos(1),...
            g_strctModule.m_strctLastMouseDown.m_pt2fPos(2)-5,...
            '0 mm','color','g','parent',g_strctModule.m_strctLastMouseDown.m_hAxes,'FontName',g_strctWindows.m_strDefaultFontName);
        
    end;
    
    
    return;
end;

if strcmp(g_strctModule.m_strMouseMode,'WaitForTwoClickEndPoint') && ...
        ((g_strctModule.m_strctLastMouseDown.m_hAxes == strctMouseOp.m_hAxes))
    if isfield(g_strctModule.m_strctPanel,'m_hTwoClickObjectTempLine')  && ~isempty(g_strctModule.m_strctPanel.m_hTwoClickObjectTempLine)
        set(g_strctModule.m_strctPanel.m_hTwoClickObjectTempLine,'xdata',...
            [g_strctModule.m_strctLastMouseDown.m_pt2fPos(1),strctMouseOp.m_pt2fPos(1)],...
            'ydata',[g_strctModule.m_strctLastMouseDown.m_pt2fPos(2),strctMouseOp.m_pt2fPos(2)]);
    else
        g_strctModule.m_strctPanel.m_hTwoClickObjectTempLine = plot(g_strctModule.m_strctLastMouseDown.m_hAxes,...
            [g_strctModule.m_strctLastMouseDown.m_pt2fPos(1),strctMouseOp.m_pt2fPos(1)],...
            [g_strctModule.m_strctLastMouseDown.m_pt2fPos(2),strctMouseOp.m_pt2fPos(2)],'r','LineWidth',2);
    end;
end

if strcmp(g_strctModule.m_strMouseMode,'ModifyController')
    % Modify controller....
    fnModifyController(g_strctModule.m_strctActiveController.m_iIndex,strctMouseOp,g_strctModule.m_strctActiveController.m_strWhat);
    fnInvalidate(1);
    return;
end

% If user press cross section lines:
if ~isempty(g_strctModule.m_strctLastMouseDown.m_hAxesSelected)
    bPan = strcmp(g_strctModule.m_strctLastMouseDown.m_strAxisOp,'Pan');
    if bPan
        fnShiftPlaneExact(g_strctModule.m_strctLastMouseDown, strctMouseOp)
    else
        fnRotatePlane(g_strctModule.m_strctLastMouseDown.m_hAxesLineSelected, sum(-afDelta .* g_strctModule.m_strctLastMouseDown.m_afAxesPen));
        %fnRotatePlaneExact(g_strctModule.m_strctLastMouseDown, strctMouseOp);
    end;
    fnInvalidate();
    return;
end;

if g_strctModule.m_strctLastMouseDown.m_hAxes == g_strctModule.m_strctPanel.m_strctOverlayAxes.m_hAxes
    fnUpdateOverlayTransform();
    fnUpdateChamberMIP();
    return;
end;

% 3D Operation

if ~isempty(g_strctModule.m_strctLastMouseDown.m_hAxes) && (g_strctModule.m_strctLastMouseDown.m_hAxes == g_strctModule.m_strctPanel.m_strct3D.m_hAxes ||g_strctModule.m_strctLastMouseDown.m_hAxes ==  g_strctModule.m_strctPanel.m_strctStereoTactic.m_hAxes)
    afDiffScr = strctMouseOp.m_pt2fPosScr - strctPrevMouseOp.m_pt2fPosScr;
    
    switch g_strctModule.m_strMouse3DMode
        case 'Rotate'
            if strcmp(get(g_strctModule.m_strctPanel.m_strct3D.m_hAxes,'visible'),'off')
                camorbit(g_strctModule.m_strctPanel.m_strctStereoTactic.m_hAxes, -afDiffScr(1)/5,-afDiffScr(2)/5, 'none');
            else
                camorbit(g_strctModule.m_strctPanel.m_strct3D.m_hAxes, -afDiffScr(1)/5,-afDiffScr(2)/5, 'none');
            end
        case 'MoveLights'
            if strcmp(get(g_strctModule.m_strctPanel.m_strct3D.m_hAxes,'visible'),'off')
                L= fnGetLightSources(g_strctModule.m_strctPanel.m_strctStereoTactic.m_hAxes);
            else
                L= fnGetLightSources(g_strctModule.m_strctPanel.m_strct3D.m_hAxes);
            end
            for k=1:length(L)
                [AZ,EL] = lightangle(L(k));
                lightangle(L(k), AZ-afDiffScr(1)/5,EL-afDiffScr(2)/5);
            end
            
        case 'Pan3D'
            if strcmp(get(g_strctModule.m_strctPanel.m_strct3D.m_hAxes,'visible'),'off')
                camdolly(g_strctModule.m_strctPanel.m_strctStereoTactic.m_hAxes, -afDiffScr(1)/5,-afDiffScr(2)/5, 0, 'movetarget', 'pixels');
            else
                camdolly(g_strctModule.m_strctPanel.m_strct3D.m_hAxes, -afDiffScr(1)/5,-afDiffScr(2)/5, 0, 'movetarget', 'pixels');
            end
            
            
        case 'RotateChamber3D'
            if ~isempty(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers)
                rotHV = fnGetRotationMatrixFromAxes(g_strctModule.m_strctPanel.m_strct3D.m_hAxes, -afDiffScr(1)/5,-afDiffScr(2)/5);
                a2fCRS_To_XYZ = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fReg*g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fM;
                a2fM = a2fCRS_To_XYZ*g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber).m_a2fM_vox;
                pt3fCurrPos = a2fM(1:3,4);
                a2fT = [1 0 0 -pt3fCurrPos(1);
                    0 1 0 -pt3fCurrPos(2);
                    0 0 1 -pt3fCurrPos(3);
                    0 0 0 1];
                
                a2fRot = zeros(4,4);
                a2fRot(1:3,1:3) = rotHV;
                a2fRot(4,4) = 1;
                a2fM = inv(a2fT) * a2fRot * a2fT * a2fM; %#ok
                g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber).m_a2fM_vox = inv(a2fCRS_To_XYZ) * a2fM; %#ok
                fnUpdateChamberMIP();
                fnInvalidate();
            end
            %        fnSetNewZoomLevel(handles, afDelta);
        case 'Pan'
            %        fnSetNewPanLevel(handles, afDiff);
    end;
    
else
    switch g_strctModule.m_strMouseMode
        case 'VoxelEraseMode2D'
            fnEraseVoxels(strctMouseOp,true);
        case 'VoxelEraseMode3D'
            fnEraseVoxels(strctMouseOp,false);
        case 'ROI_Add_2D'
            fnROIChange(strctMouseOp,1,true);
        case 'ROI_Sub_2D'
            fnROIChange(strctMouseOp,0,true);
            
        case 'ROI_Add_3D'
            fnROIChange(strctMouseOp,1,false);
        case 'ROI_Sub_3D'
            fnROIChange(strctMouseOp,0,false);
        case 'Scroll'
            
            %if strcmp(strctMouseOp.m_strButton,'Left')
            fnSetFocusNoZoom(strctMouseOp);
            %end
        case 'Rotate2D'
            fnRotateAxesInPlane(g_strctModule.m_strctLastMouseDown.m_hAxes,afDelta);
        case 'Contrast'
            fnSetNewContrastLevel(afDelta);
        case 'Zoom'
            fnSetNewZoomLevel(g_strctModule.m_strctLastMouseDown.m_hAxes,afDelta);
        case 'ZoomLinked'
            fnSetNewZoomLevel(g_strctModule.m_strctPanel.m_strctXZ.m_hAxes,afDelta);
            fnSetNewZoomLevel(g_strctModule.m_strctPanel.m_strctYZ.m_hAxes,afDelta);
            fnSetNewZoomLevel(g_strctModule.m_strctPanel.m_strctXY.m_hAxes,afDelta);
        case 'Pan'
            fnSetNewPanLevel(g_strctModule.m_strctLastMouseDown.m_hAxes,afDelta/4);
        case 'ChamberTrans'
            fnMoveChamber(g_strctModule.m_strctLastMouseDown.m_hAxes,afDelta);
        case 'ChamberTransAxis'
            fnMoveChamberAxis(g_strctModule.m_strctLastMouseDown.m_hAxes,afDelta);
        case 'ChamberRotateAxis'
            fnRotateChamberAxis(g_strctModule.m_strctLastMouseDown.m_hAxes,-afDelta);
        case 'MoveGrid'
            fnMoveGrid(afDelta);
        case 'ChamberRot'
            fnRotateChamber(g_strctModule.m_strctLastMouseDown.m_hAxes,afDelta);
        case 'RotateMarker'
            fnRotateMarkerAux(g_strctModule.m_strctLastMouseDown.m_hAxes,afDelta);
        case 'MoveTarget'
            fnMoveTarget(g_strctModule.m_strctLastMouseDown.m_hAxes,afDelta);
        case 'MoveAtlas'
            fnMoveAtlas(g_strctModule.m_strctLastMouseDown.m_hAxes,afDelta);
        case 'RotateAtlas'
            fnRotateAtlas(g_strctModule.m_strctLastMouseDown.m_hAxes,afDelta);
        case 'ScaleAtlas'
            fnScaleAtlas(g_strctModule.m_strctLastMouseDown.m_hAxes,afDelta);
        case 'MoveBloodVessel'
            fnMoveBloodVesselAux(g_strctModule.m_strctLastMouseDown.m_hAxes,afDelta);
        case 'MoveMarker'
            fnMoveMarkerAux(strctMouseOp,afDelta);
        case 'AddAvgTimeCourse'
            fnAddAvgTimeCourse();
        case 'MoveEntireImageSeries'
            fnMoveEntireImageSeries(g_strctModule.m_strctLastMouseDown.m_hAxes,afDelta);
        case 'RotateEntireImageSeries'
            fnRotateEntireImageSeries(g_strctModule.m_strctLastMouseDown.m_hAxes,afDelta);
        case 'ScaleEntireImageSeries'
            fnScaleEntireImageSeries(g_strctModule.m_strctLastMouseDown.m_hAxes,afDelta,false);
        case 'ScaleEntireImageSeriesKeepAspect'
            fnScaleEntireImageSeries(g_strctModule.m_strctLastMouseDown.m_hAxes,afDelta,true);
        case 'MoveImageInImageSeries'
            fnMoveImageInImageSeries(g_strctModule.m_strctLastMouseDown.m_hAxes,afDelta);
        case 'RotateImageInImageSeries'
            fnRotateImageInImageSeries(g_strctModule.m_strctLastMouseDown.m_hAxes,afDelta);
        case 'ScaleImageInImageSeries'
            fnScaleImageInImageSeries(g_strctModule.m_strctLastMouseDown.m_hAxes,afDelta,false);
        case 'ScaleImageInImageSeriesKeepAspect'
            fnScaleImageInImageSeries(g_strctModule.m_strctLastMouseDown.m_hAxes,afDelta,true);
            
    end;
end;
return;



function fnMouseMove(strctMouseOp)
global g_strctModule g_strctWindows
if ~g_strctModule.m_bVolumeLoaded
    return;
end;

if isempty(g_strctModule.m_strctPrevMouseOp)
    g_strctModule.m_strctPrevMouseOp = strctMouseOp;
end;
if ~g_strctModule.m_bFirstInvalidate && g_strctModule.m_strctGUIOptions.m_bShow2DPlanes
    fnIntersectAxis(strctMouseOp);  % Change mouse cursor
    
end;
if  ~g_strctModule.m_bFirstInvalidate &&  ~isempty(strctMouseOp.m_hAxes)
    [bIntersects, strctObject, strWhat] = fnIntersectsControllableObject(strctMouseOp); %#ok
    if bIntersects
        set(g_strctWindows.m_hFigure,'Pointer','fleur');
    end
end


if  ~isempty(strctMouseOp.m_hAxes)
    if g_strctModule.m_bMouseDown
        fnHandleMouseMoveWhileDown(g_strctModule.m_strctPrevMouseOp, strctMouseOp);
    end;
end;

if strcmpi(g_strctModule.m_strMouseMode,'AddTwoClickObject')
    set(g_strctWindows.m_hFigure,'Pointer','fleur');
end;

g_strctModule.m_strctPrevMouseOp = strctMouseOp;


if strcmpi(g_strctModule.m_strMouseIcon,'Radius2D') ||  strcmpi(g_strctModule.m_strMouseIcon,'Radius3D')
    fnUpdateSelectRadiusPos();
end

fnUpdatePos();
return;

function fnUpdateSelectRadiusPos()
global g_strctModule
strctMouseOp = g_strctModule.m_strctPrevMouseOp;


if strcmpi(g_strctModule.m_strMouseIcon,'Radius2D')
    [strName,strctCrossSection] = fnAxesToName(strctMouseOp.m_hAxes);
    bYZ = strcmp(strName,'YZ');
    bXZ = strcmp(strName,'XZ');
    bXY = strcmp(strName,'XY');
else
    bYZ = true;
    bXY = true;
    bXZ = true;
end


afAngles = linspace(0,2*pi,30);
%fPIX_To_MM = g_strctModule.m_strctCrossSectionXY.m_iResWidth / (2*g_strctModule.m_strctCrossSectionXY.m_fHalfWidthMM);
fMM_To_Pix_XY = (2*g_strctModule.m_strctCrossSectionXY.m_fHalfWidthMM) / g_strctModule.m_strctCrossSectionXY.m_iResWidth;
fMM_To_Pix_YZ = (2*g_strctModule.m_strctCrossSectionYZ.m_fHalfWidthMM) / g_strctModule.m_strctCrossSectionYZ.m_iResWidth;
fMM_To_Pix_XZ = (2*g_strctModule.m_strctCrossSectionXZ.m_fHalfWidthMM) / g_strctModule.m_strctCrossSectionXZ.m_iResWidth;
afX_MM = cos(afAngles) * g_strctModule.m_strctGUIOptions.m_fSelectRadiusMM;
afY_MM = sin(afAngles) * g_strctModule.m_strctGUIOptions.m_fSelectRadiusMM;

% Update the erase kernel position
if bXY && isempty(g_strctModule.m_strctPanel.m_strctXY.m_ahMouseRadiusSelect)
    g_strctModule.m_strctPanel.m_strctXY.m_ahMouseRadiusSelect=...
        plot(g_strctModule.m_strctPanel.m_strctXY.m_hAxes,strctMouseOp.m_pt2fPos(1) + afX_MM * fMM_To_Pix_XY,strctMouseOp.m_pt2fPos(2) + afY_MM * fMM_To_Pix_XY,'r','uicontextmenu',g_strctModule.m_strctPanel.m_hMenu);
end
if bYZ && isempty(g_strctModule.m_strctPanel.m_strctYZ.m_ahMouseRadiusSelect)
    g_strctModule.m_strctPanel.m_strctYZ.m_ahMouseRadiusSelect=...
        plot(g_strctModule.m_strctPanel.m_strctYZ.m_hAxes,strctMouseOp.m_pt2fPos(1) + afX_MM * fMM_To_Pix_YZ,strctMouseOp.m_pt2fPos(2) + afY_MM * fMM_To_Pix_YZ,'r','uicontextmenu',g_strctModule.m_strctPanel.m_hMenu);
end
if bXZ && isempty(g_strctModule.m_strctPanel.m_strctXZ.m_ahMouseRadiusSelect)
    g_strctModule.m_strctPanel.m_strctXZ.m_ahMouseRadiusSelect=...
        plot(g_strctModule.m_strctPanel.m_strctXZ.m_hAxes,strctMouseOp.m_pt2fPos(1) + afX_MM * fMM_To_Pix_XZ,strctMouseOp.m_pt2fPos(2) + afY_MM * fMM_To_Pix_XZ,'r','uicontextmenu',g_strctModule.m_strctPanel.m_hMenu);
end

if bXY
    set(g_strctModule.m_strctPanel.m_strctXY.m_ahMouseRadiusSelect,'xdata',strctMouseOp.m_pt2fPos(1) + afX_MM / fMM_To_Pix_XY,'ydata',strctMouseOp.m_pt2fPos(2) + afY_MM / fMM_To_Pix_XY);
else
    if ~isempty(g_strctModule.m_strctPanel.m_strctXY.m_ahMouseRadiusSelect)
        delete(g_strctModule.m_strctPanel.m_strctXY.m_ahMouseRadiusSelect)
        g_strctModule.m_strctPanel.m_strctXY.m_ahMouseRadiusSelect = [];
    end
end

if bYZ
    set(g_strctModule.m_strctPanel.m_strctYZ.m_ahMouseRadiusSelect,'xdata',strctMouseOp.m_pt2fPos(1) + afX_MM / fMM_To_Pix_YZ,'ydata',strctMouseOp.m_pt2fPos(2) + afY_MM / fMM_To_Pix_YZ);
else
    if ~isempty(g_strctModule.m_strctPanel.m_strctYZ.m_ahMouseRadiusSelect)
        delete(g_strctModule.m_strctPanel.m_strctYZ.m_ahMouseRadiusSelect)
        g_strctModule.m_strctPanel.m_strctYZ.m_ahMouseRadiusSelect = [];
    end
    
end
if bXZ
    set(g_strctModule.m_strctPanel.m_strctXZ.m_ahMouseRadiusSelect,'xdata',strctMouseOp.m_pt2fPos(1) + afX_MM / fMM_To_Pix_XZ,'ydata',strctMouseOp.m_pt2fPos(2) + afY_MM / fMM_To_Pix_XZ);
else
    if ~isempty(g_strctModule.m_strctPanel.m_strctXZ.m_ahMouseRadiusSelect)
        delete(g_strctModule.m_strctPanel.m_strctXZ.m_ahMouseRadiusSelect)
        g_strctModule.m_strctPanel.m_strctXZ.m_ahMouseRadiusSelect = [];
    end
    
end

return;


function fnMouseDown(strctMouseOp)
%profile on
global g_strctModule g_strctWindows
if ~g_strctModule.m_bVolumeLoaded
    return;
end;



if g_strctModule.m_strctGUIOptions.m_bShow2DPlanes
    [strctMouseOp.m_hAxesSelected,bCloseToCenter,afPenDir,strctMouseOp.m_hAxesLineSelected] = fnIntersectAxis(strctMouseOp);
    if isempty(strctMouseOp.m_hAxesSelected)
        strctMouseOp.m_strAxisOp = 'Pan';
    else
        if bCloseToCenter
            strctMouseOp.m_strAxisOp = 'Pan';
        else
            strctMouseOp.m_strAxisOp = 'Rotate';
        end;
    end
    strctMouseOp.m_afAxesPen = afPenDir; % Penpendicular direction to selected axes
else
    strctMouseOp.m_hAxesSelected = [];
    strctMouseOp.m_hAxesLineSelected = [];
    strctMouseOp.m_afAxesPen = [];
    strctMouseOp.m_strAxisOp = '';
end;

if strctMouseOp.m_hAxes == g_strctModule.m_strctPanel.m_strctOverlayAxes.m_hAxes
    Tmp = get(g_strctModule.m_strctPanel.m_strctOverlayAxes.m_hAxes,'CurrentPoint');
    pt2fMousePoint = Tmp([1,3]);
    afDist = [norm(pt2fMousePoint-g_strctModule.m_strctOverlay.m_pt2fLeft);
        norm(pt2fMousePoint-g_strctModule.m_strctOverlay.m_pt2fRight);
        norm(pt2fMousePoint-g_strctModule.m_strctOverlay.m_pt2fLeftPos);
        norm(pt2fMousePoint-g_strctModule.m_strctOverlay.m_pt2fRightPos)];
    [fMinDist, iIndex] = min(afDist);
    fThreshold = 2;
    
    if fMinDist > fThreshold
        strctMouseOp.m_hObjectSelected = [];
    else
        switch iIndex
            case 1
                strctMouseOp.m_hObjectSelected = g_strctModule.m_strctPanel.m_strctOverlayAxes.hLeftPoint;
            case 2
                strctMouseOp.m_hObjectSelected = g_strctModule.m_strctPanel.m_strctOverlayAxes.hRightPoint;
            case 3
                strctMouseOp.m_hObjectSelected = g_strctModule.m_strctPanel.m_strctOverlayAxes.hLeftPointPos;
            case 4
                strctMouseOp.m_hObjectSelected = g_strctModule.m_strctPanel.m_strctOverlayAxes.hRightPointPos;
        end
    end
    
end;
%
% if strctMouseOp.m_hAxes == g_strctModule.m_strctPanel.m_strctGrid.m_hAxes
%
%     fnSelectGridHole(strctMouseOp);
%     fnHandleMouseMoveOnGridAxes(strctMouseOp);
% end;



if strcmpi(strctMouseOp.m_strButton,'left')
    if strcmp(g_strctModule.m_strMouseMode,'AddBloodVessel') && isfield(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol},'m_a3bBloodVolume')
        [pt3fPosIn3DSpace,pt3fPosInStereoSpace, pt3fVoxelCoordinate, strctCrossSection,pt3fPosInAtlasSpace]=fnGet3DCoord(strctMouseOp); %#ok
        iCubeRad = 0;
        aiYRange = min(size( g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a3bBloodVolume,1),      max(1,round(pt3fVoxelCoordinate(2))-iCubeRad:round(pt3fVoxelCoordinate(2))+iCubeRad));
        aiXRange = min(size( g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a3bBloodVolume,2),max(1,round(pt3fVoxelCoordinate(1))-iCubeRad:round(pt3fVoxelCoordinate(1))+iCubeRad));
        aiZRange = min(size( g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a3bBloodVolume,3),max(1,round(pt3fVoxelCoordinate(3))-iCubeRad:round(pt3fVoxelCoordinate(3))+iCubeRad));
        
        g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a3bBloodVolume(aiYRange,aiXRange,aiZRange) = 1;
        fnInvalidate(1);
        
    elseif strcmp(g_strctModule.m_strMouseMode,'RemoveBloodVessel') && isfield(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol},'m_a3bBloodVolume')
        [pt3fPosIn3DSpace,pt3fPosInStereoSpace, pt3fVoxelCoordinate, strctCrossSection,pt3fPosInAtlasSpace]=fnGet3DCoord(strctMouseOp);  %#ok
        iCubeRad = 1;
        aiYRange = min(size( g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a3bBloodVolume,1),      max(1,round(pt3fVoxelCoordinate(2))-iCubeRad:round(pt3fVoxelCoordinate(2))+iCubeRad));
        aiXRange = min(size( g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a3bBloodVolume,2),max(1,round(pt3fVoxelCoordinate(1))-iCubeRad:round(pt3fVoxelCoordinate(1))+iCubeRad));
        aiZRange = min(size( g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a3bBloodVolume,3),max(1,round(pt3fVoxelCoordinate(3))-iCubeRad:round(pt3fVoxelCoordinate(3))+iCubeRad));
        g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a3bBloodVolume(aiYRange,aiXRange,aiZRange) = 0;
        fnInvalidate(1);
        
    end
end

if strcmp(g_strctModule.m_strMouseMode,'Scroll') && strcmp(strctMouseOp.m_strButton,'DoubleClick') && ...
        strcmp(strctMouseOp.m_strAxisOp,'Pan') && ~isempty(strctMouseOp.m_hAxes ) && strctMouseOp.m_hAxes ~= g_strctModule.m_strctPanel.m_strct3D.m_hAxes
    
    hAxes = fnIntersectAxis(strctMouseOp);
    if isempty(hAxes)
        fnSetFocusNoZoom(strctMouseOp);
    end
end


if (strcmpi(g_strctModule.m_strMouse3DMode,'AddChamberTowardsTarget') || strcmpi(g_strctModule.m_strMouse3DMode,'AddChamber') )&& ~isempty(strctMouseOp.m_hAxes ) && strctMouseOp.m_hAxes ==  g_strctModule.m_strctPanel.m_strct3D.m_hAxes
    a2fLineIn3D = get(g_strctModule.m_strctPanel.m_strct3D.m_hAxes,'currentPoint');
    
    
    % The two points define a line in 3D. We need to find the intersection
    % with the actual surface....
    
    % Code to add a chamber passing between two targets.
    a2fCRS_To_XYZ = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fReg * g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fM;
    afPt1 = a2fLineIn3D(1,:);
    afPt2 = a2fLineIn3D(2,:);
    afDirection = afPt1(1:3)-afPt2(1:3);
    fDistance = norm(afDirection);
    afDirection = afDirection/fDistance;
    afRange = -fDistance:0.5:fDistance;
    apt2fPointsMM=[afPt1(1) + afRange*afDirection(1);afPt1(2) + afRange*afDirection(2);afPt1(3) + afRange*afDirection(3); ones(1, length(afRange))];
    apt2fPoints = inv(a2fCRS_To_XYZ)*apt2fPointsMM; %#ok
    afValues= fndllFastInterp3(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a3bSurfaceVolume, 1+apt2fPoints(1,:),1+apt2fPoints(2,:),1+apt2fPoints(3,:));
    iIndex = find(afValues>0,1,'last');
    % Normal to surface ?
    % Find closest vertex?
    pt3fPointOnSurface = apt2fPoints(1:3,iIndex);
    pt3fPointOnSurfaceMM = apt2fPointsMM(1:3,iIndex);
    
    iNumSurfaceVertices = size(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_strctSurface.vertices ,1);
    [fDummy, iClosestVertexOnSurface]=min(sum(abs(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_strctSurface.vertices - repmat(pt3fPointOnSurface(1:3)', iNumSurfaceVertices,1)),2)); %#ok
    
    if  strcmpi(g_strctModule.m_strMouse3DMode,'AddChamberTowardsTarget')
        aiCurrTarget = get(g_strctModule.m_strctPanel.m_hTargetList,'value');
        a2fCRS_To_XYZ = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fReg * g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fM;
        
        pt3fTarget_mm= a2fCRS_To_XYZ*[g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctTargets(aiCurrTarget(1)).m_pt3fPositionVoxel;1];
        afDirection = pt3fPointOnSurfaceMM-pt3fTarget_mm(1:3);
        afDirection = [afDirection / norm(afDirection)]'; %#ok
        
    else
        
        % Compute vertex normal
        % Find all neighboring faces
        [aiTriangleIndex, aiDummy]=find(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_strctSurface.faces == iClosestVertexOnSurface); %#ok
        % Triangles normal?
        iNumTriangles = length(aiTriangleIndex);
        afAvgNormal = zeros(1,3);
        for iTriangleIter=1:iNumTriangles
            aiVertices = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_strctSurface.faces(aiTriangleIndex(iTriangleIter),:);
            Amm = a2fCRS_To_XYZ*[g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_strctSurface.vertices(aiVertices(1),:)';1];
            Bmm = a2fCRS_To_XYZ*[g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_strctSurface.vertices(aiVertices(2),:)';1];
            Cmm = a2fCRS_To_XYZ*[g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_strctSurface.vertices(aiVertices(3),:)';1];
            ABmm = Bmm-Amm;
            ACmm = Cmm-Amm;
            afTmp = cross(ABmm(1:3),ACmm(1:3));
            afTmp = afTmp/norm(afTmp);
            afAvgNormal=afAvgNormal+afTmp';
        end
        afAvgNormal=afAvgNormal/iNumTriangles;
        afDirection = afAvgNormal/norm(afAvgNormal);
    end
    [afDirection1,afDirection2] = fnGramSchmidt(afDirection);
    a2fM = eye(4);
    a2fM(1:3,3) = afDirection;
    a2fM(1:3,1) = afDirection1;
    a2fM(1:3,2) = afDirection2;
    a2fM(1:3,4) = pt3fPointOnSurfaceMM'+afDirection*10;
    fnAddChamberAux(a2fM);
    g_strctModule.m_strMouse3DMode = 'Rotate';
    
end

if strcmpi(g_strctModule.m_strMouseMode,'VoxelEraseMode2D') && strcmpi(strctMouseOp.m_strButton,'Left')
    fnEraseVoxels(strctMouseOp, true)
end;
if strcmpi(g_strctModule.m_strMouseMode,'VoxelEraseMode3D') && strcmpi(strctMouseOp.m_strButton,'Left')
    fnEraseVoxels(strctMouseOp, false)
end;


if strcmpi(g_strctModule.m_strMouseMode,'ROI_Add_3D') && strcmpi(strctMouseOp.m_strButton,'Left')
    fnROIChange(strctMouseOp,true,false);
end
if strcmpi(g_strctModule.m_strMouseMode,'ROI_Add_2D') && strcmpi(strctMouseOp.m_strButton,'Left')
    fnROIChange(strctMouseOp,true,true);
end
if strcmpi(g_strctModule.m_strMouseMode,'ROI_Sub_3D') && strcmpi(strctMouseOp.m_strButton,'Left')
    fnROIChange(strctMouseOp,false,false);
end
if strcmpi(g_strctModule.m_strMouseMode,'ROI_Sub_2D') && strcmpi(strctMouseOp.m_strButton,'Left')
    fnROIChange(strctMouseOp,false,true);
end

if strcmpi(g_strctModule.m_strMouseMode,'AddTwoClickObject')
    % User selected to add a chamber. We wait for first click, and now it
    % happened. Verify that the selected axis is the same. Otherwise, abort.
    
    % Great. Save this position and change state machine.
    g_strctModule.m_strctSavedClickedPoint1 = strctMouseOp;
    g_strctModule.m_strMouseMode = 'WaitForTwoClickEndPoint';
    
end

if strcmp(g_strctModule.m_strMouseMode,'AddSingleClickObject') && strcmpi(strctMouseOp.m_strButton,'left')
    if ~isempty(strctMouseOp.m_hAxes)
        if ( strctMouseOp.m_hAxes == g_strctModule.m_strctPanel.m_strctXY.m_hAxes || ...
                strctMouseOp.m_hAxes == g_strctModule.m_strctPanel.m_strctXZ.m_hAxes ||  ...
                strctMouseOp.m_hAxes == g_strctModule.m_strctPanel.m_strctYZ.m_hAxes )
            
            feval(g_strctModule.m_hClickCallback,strctMouseOp);
            set(g_strctWindows.m_hFigure,'Pointer','arrow');
            
            g_strctModule.m_strMouseMode = 'Scroll';
            return;
        elseif strctMouseOp.m_hAxes == g_strctModule.m_strctPanel.m_strct3D.m_hAxes
            
            
        end
    end
end

if ~isempty(strctMouseOp.m_hAxes)
    [bIntersects, strctObject, strWhat,iObjectIndex] = fnIntersectsControllableObject(strctMouseOp);
    if bIntersects
        g_strctModule.m_strctActiveController.m_strSavedMouseMode = g_strctModule.m_strMouseMode;
        g_strctModule.m_strMouseMode = 'ModifyController';
        g_strctModule.m_strctActiveController.m_strWhat = strWhat;
        g_strctModule.m_strctActiveController.m_strctObject = strctObject;
        g_strctModule.m_strctActiveController.m_iIndex = iObjectIndex;
    end
end


g_strctModule.m_strctPrevMouseOp = strctMouseOp;
g_strctModule.m_strctLastMouseDown = strctMouseOp;
g_strctModule.m_bMouseDown = true;
% fnSetRes(64);

return;



function fnMouseUp(strctMouseOp)
global g_strctModule
g_strctModule.m_strctLastMouseUp = strctMouseOp;
g_strctModule.m_bMouseDown = false;

if ishandle(g_strctModule.m_strctPanel.m_hMeasureLine)
    delete(g_strctModule.m_strctPanel.m_hMeasureLine)
    g_strctModule.m_strctPanel.m_hMeasureLine = [];
end;

if ishandle(g_strctModule.m_strctPanel.m_hMeasureText)
    delete(g_strctModule.m_strctPanel.m_hMeasureText);
    g_strctModule.m_strctPanel.m_hMeasureText = [];
end;

if  strcmp(g_strctModule.m_strMouseMode, 'ModifyController');
    % restore mouse op
    g_strctModule.m_strMouseMode = g_strctModule.m_strctActiveController.m_strSavedMouseMode;
end

if strcmpi(g_strctModule.m_strMouseMode,'WaitForTwoClickEndPoint')
    % Add chamber
    if isfield(g_strctModule.m_strctPanel,'m_hTwoClickObjectTempLine') && ~isempty(g_strctModule.m_strctPanel.m_hTwoClickObjectTempLine) && ishandle(g_strctModule.m_strctPanel.m_hTwoClickObjectTempLine)
        delete(g_strctModule.m_strctPanel.m_hTwoClickObjectTempLine)
        g_strctModule.m_strctPanel.m_hTwoClickObjectTempLine = [];
    end
    g_strctModule.m_strMouseMode = 'Scroll';
    
    strctStartPoint = g_strctModule.m_strctLastMouseDown;
    strctEndPoint = strctMouseOp;
    
    if strctEndPoint.m_hAxes == strctStartPoint.m_hAxes % Otherwise, it does not make sense!
        feval(g_strctModule.m_hClickCallback,strctStartPoint,strctEndPoint);
    end
end
%profile off
%profile viewer
return;





function fnMouseWheel(strctMouseOp)
global g_strctModule
if isempty(strctMouseOp.m_hAxes) || ~g_strctModule.m_bVolumeLoaded
    return;
end;
if (strctMouseOp.m_hAxes == g_strctModule.m_strctPanel.m_strctOverlayAxes.m_hAxes)
    
    g_strctModule.m_strctOverlay.m_afPvalueRange = g_strctModule.m_strctOverlay.m_afPvalueRange + ...
        [-strctMouseOp.m_iScroll,strctMouseOp.m_iScroll];
    fnInvalidateOverlayAxes();
    return;
end

if (strcmpi(g_strctModule.m_strMouseIcon,'Radius2D') || strcmpi(g_strctModule.m_strMouseIcon,'Radius3D')) && g_strctModule.m_bShiftPressed
    g_strctModule.m_strctGUIOptions.m_fSelectRadiusMM  = max(0.5, g_strctModule.m_strctGUIOptions.m_fSelectRadiusMM +strctMouseOp.m_iScroll * 0.5);
    fnUpdateSelectRadiusPos();
else
    
    if (strctMouseOp.m_hAxes == g_strctModule.m_strctPanel.m_strct3D.m_hAxes)
        fnZoom3DAxes(strctMouseOp.m_iScroll);
    else
        if strctMouseOp.m_hAxes  == g_strctModule.m_strctPanel.m_strctXY.m_hAxes
            strctMouseOp.m_iScroll = -strctMouseOp.m_iScroll;
        end;
        
        fnShiftPlane(strctMouseOp.m_hAxes , min(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_afVoxelSpacing)*strctMouseOp.m_iScroll)
    end;
end
fnUpdatePos();

return;


function fnSetSliceMode()
fnChangeMouseMode('Scroll');
return;

function fnSetContrastMode()
fnChangeMouseMode('Contrast');
return;

function fnSetRotate2DMode()
fnChangeMouseMode('Rotate2D');
return;



function fnSetLinkedZoomMode()
fnChangeMouseMode('ZoomLinked');
return;

function fnSetZoomMode()
fnChangeMouseMode('Zoom');
return;

function fnSetPanMode()
fnChangeMouseMode('Pan');
return;

function fnSetCrosshairMode()
fnChangeMouseMode('Crosshair');
return;






function fnSetRotateVolumeMode()
global g_strctModule
g_strctModule.m_strMouse3DMode = 'RotateVolume3D';
return;

function fnSetRotateChamber3DMode()
global g_strctModule
fnChangeMouseMode('RotateChamber3D', 'Rotate Chamber in 3D');
g_strctModule.m_strMouse3DMode = 'RotateChamber3D';

return;

function fnSetRotateMode()
global g_strctModule
g_strctModule.m_strMouse3DMode = 'Rotate';
return;

function fnIsoSurfaceThresholdMode()
global g_strctModule
g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol} = SurfaceHelper(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol});


fnUpdateSurfacePatch();
return;


function fnSetGridTrans()
fnChangeMouseMode('MoveGrid');
return;




function fnLongGridMode()
global g_strctModule
g_strctModule.m_strctGUIOptions.m_bLongGrid = ~g_strctModule.m_strctGUIOptions.m_bLongGrid;
fnInvalidate(1);
return;


function fnRendererToggle()
global g_strctModule g_strctWindows
if ~isfield(g_strctModule.m_strctGUIOptions,'m_bOpenGL')
    g_strctModule.m_strctGUIOptions.m_bOpenGL = true;
end
g_strctModule.m_strctGUIOptions.m_bOpenGL = ~g_strctModule.m_strctGUIOptions.m_bOpenGL;
if g_strctModule.m_strctGUIOptions.m_bOpenGL
    set(g_strctWindows.m_hFigure,'Renderer','opengl');
else
    set(g_strctWindows.m_hFigure,'Renderer','zbuffer');
end


function fnSetChamberTransMode()
fnChangeMouseMode('ChamberTrans');
return;

function fnSetChamberRotMode()
fnChangeMouseMode('ChamberRot');
return;



function fnAddChamber3DTowardsTarget()
global g_strctModule
g_strctModule.m_strMouse3DMode = 'AddChamberTowardsTarget';
return;

function fnAddChamber3D()
global g_strctModule
g_strctModule.m_strMouse3DMode = 'AddChamber';

return;

function fnPan3D()
global g_strctModule
g_strctModule.m_strMouse3DMode = 'Pan3D';
return;

function fnRemoveBloodVesselMode()
fnChangeMouseMode('RemoveBloodVessel');
return
function fnQueryAtlasMode()
fnChangeMouseMode('QueryAtlas');
return

function fnSetROIAdd(b2D)
global g_strctModule
if isempty(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctROIs)
    h=msgbox('Please add an ROI first');
    waitfor(h);
    return;
end;


if b2D
    fnChangeMouseMode('ROI_Add_2D','Add Voxels To ROI 2D','Radius2D');
else
    fnChangeMouseMode('ROI_Add_3D','Add Voxels To ROI 3D','Radius3D');
end
fnUpdateSelectRadiusPos;
return

function fnSetROISubtract(b2D)
global g_strctModule
if isempty(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctROIs)
    h=msgbox('Please add an ROI first');
    waitfor(h);
    return;
end;

if b2D
    fnChangeMouseMode('ROI_Sub_2D','Subtract Voxels From ROI 2D','Radius2D');
else
    fnChangeMouseMode('ROI_Sub_3D','Subtract Voxels From ROI 3D','Radius3D');
end
fnUpdateSelectRadiusPos;
return


function fnSetEraseMode(b2D)
if b2D
    fnChangeMouseMode('VoxelEraseMode2D','Erase Voxels 2D','Radius2D');
else
    fnChangeMouseMode('VoxelEraseMode3D','Erase Voxels 3D','Radius3D');
end

fnUpdateSelectRadiusPos();
return


function fnAddTargetAux()
return

function fnToggleLabelsVisibility()
global g_strctModule
if ~isfield(g_strctModule.m_strctGUIOptions,'m_bShowLabels')
    g_strctModule.m_strctGUIOptions.m_bShowLabels  = true;
end
g_strctModule.m_strctGUIOptions.m_bShowLabels = ~g_strctModule.m_strctGUIOptions.m_bShowLabels;
if g_strctModule.m_strctGUIOptions.m_bShowLabels
    set(g_strctModule.m_strctPanel.m_strctYZ.m_ahTextHandles,'visible','on');
    set(g_strctModule.m_strctPanel.m_strctXZ.m_ahTextHandles,'visible','on');
    set(g_strctModule.m_strctPanel.m_strctXY.m_ahTextHandles,'visible','on');
    set(g_strctModule.m_strctPanel.hMouseModeText,'visible','on');
    
else
    set(g_strctModule.m_strctPanel.m_strctYZ.m_ahTextHandles,'visible','off');
    set(g_strctModule.m_strctPanel.m_strctXZ.m_ahTextHandles,'visible','off');
    set(g_strctModule.m_strctPanel.m_strctXY.m_ahTextHandles,'visible','off');
    set(g_strctModule.m_strctPanel.hMouseModeText,'visible','off');
end