function bSuccessful = fnLoadSessionAux(strFullFileName)
global g_strctModule
strctSavedSession= load(strFullFileName);
bSuccessful = true;

if ~isfield(strctSavedSession,'g_strctModule')
    bSuccessful = false;
    return;
end
    
if ~isempty(g_strctModule.m_acAnatVol) && g_strctModule.m_iCurrAnatVol > 0 && ~isempty(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers) && ...
    isfield(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber),'m_ah3DSurfaces')

    if isfield(g_strctModule.m_strctPanel.m_strctXY,'m_ahChamber')
        delete(g_strctModule.m_strctPanel.m_strctXY.m_ahChamber);
    end
    if isfield(g_strctModule.m_strctPanel.m_strctYZ,'m_ahChamber')
        delete(g_strctModule.m_strctPanel.m_strctYZ.m_ahChamber);
    end
    if isfield(g_strctModule.m_strctPanel.m_strctXZ,'m_ahChamber')
        delete(g_strctModule.m_strctPanel.m_strctXZ.m_ahChamber);
    end

    ahHandles = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber).m_ah3DSurfaces;
    delete(ahHandles(ishandle(ahHandles)));
end
  
% Bring things up to date with old versions...
    for iAnatVolIter=1:length(strctSavedSession.g_strctModule.m_acAnatVol)
        if ~isfield(strctSavedSession.g_strctModule.m_acAnatVol{iAnatVolIter},'m_acFreeSurferSurfaces')
            strctSavedSession.g_strctModule.m_acAnatVol{iAnatVolIter}.m_acFreeSurferSurfaces = [];
        end
        if ~isfield(strctSavedSession.g_strctModule.m_acAnatVol{iAnatVolIter},'m_astrctROIs')
            strctSavedSession.g_strctModule.m_acAnatVol{iAnatVolIter}.m_astrctROIs =[];
        end
    end
%%

if ~isempty(strctSavedSession.g_strctModule.m_acAnatVol) && ~isempty(strctSavedSession.g_strctModule.m_acAnatVol{1}.m_astrctChambers) && ...
    isfield(strctSavedSession.g_strctModule.m_acAnatVol{1}.m_astrctChambers(1),'m_a2fM')
    % This is a really old saved session. Import it 
    
    for iAnatVolIter=1:length(strctSavedSession.g_strctModule.m_acAnatVol)
        
        strFileName = strctSavedSession.g_strctModule.m_acAnatVol{iAnatVolIter}.m_strFileName;
        
        if ~exist(strFileName,'file')
            fprintf('You will need to provide the original volume to do this import step!\n');
            fprintf('The original file was at %s, but it is no longer there!\n',strFileName);
            
            [strFile,strPath]=uigetfile(strFileName);
            strFileName = fullfile(strPath,strFile);
        end
        
        g_strctModule.m_acAnatVol{iAnatVolIter} = fnQuickAddVolume(strFileName);
        g_strctModule.m_acAnatVol{iAnatVolIter}.m_a2fM = strctSavedSession.g_strctModule.m_acAnatVol{iAnatVolIter}.m_a2fM;
        g_strctModule.m_acAnatVol{iAnatVolIter}.m_a2fReg = strctSavedSession.g_strctModule.m_acAnatVol{iAnatVolIter}.m_a2fReg;
%         g_strctModule.m_acAnatVol{iAnatVolIter}.m_a2fEB0 = [1 0 0 0; 0 -1 0 0; 0 0 1 0; 0 0 0 1];
%         g_strctModule.m_acAnatVol{iAnatVolIter}.m_strctCrossSectionCoronal.m_a2fM = [1 0 0 0; 0 0 -1 0; 0 -1 0 0; 0 0 0 1];
%         g_strctModule.m_acAnatVol{iAnatVolIter}.m_strctCrossSectionSaggital.m_a2fM = [0 0 1 0; 1 0 0 0; 0 -1 0 0; 0 0 0 1];
%         g_strctModule.m_acAnatVol{iAnatVolIter}.m_strctCrossSectionSaggital.m_bZFlip = true;
%         g_strctModule.m_acAnatVol{iAnatVolIter}.m_strctCrossSectionSaggital.m_a2fM = [1 0 0 0 ; 0 -1 0 0; 0 0 1 0; 0 0 0 1];
%         g_strctModule.m_acAnatVol{iAnatVolIter}.m_strctCrossSectionSaggital.m_bZFlip = true;
%         
       
        a2fCRS_To_XYZ = g_strctModule.m_acAnatVol{iAnatVolIter}.m_a2fReg*g_strctModule.m_acAnatVol{iAnatVolIter}.m_a2fM; 
        
        % Add chambers
        for iChamberIter=1:length(strctSavedSession.g_strctModule.m_acAnatVol{iAnatVolIter}.m_astrctChambers)
            g_strctModule.m_acAnatVol{iAnatVolIter}.m_astrctChambers(iChamberIter).m_a2fM_vox = ...
                inv(a2fCRS_To_XYZ)*strctSavedSession.g_strctModule.m_acAnatVol{iAnatVolIter}.m_astrctChambers(iChamberIter).m_a2fM; %#ok
            g_strctModule.m_acAnatVol{iAnatVolIter}.m_astrctChambers(iChamberIter).m_astrctGrids = [];
            g_strctModule.m_acAnatVol{iAnatVolIter}.m_astrctChambers(iChamberIter).m_strctModel = g_strctModule.m_astrctChamberModels(1);
             g_strctModule.m_acAnatVol{iAnatVolIter}.m_astrctChambers(iChamberIter).m_strName = strctSavedSession.g_strctModule.m_acAnatVol{iAnatVolIter}.m_astrctChambers(iChamberIter).m_strName;
             g_strctModule.m_acAnatVol{iAnatVolIter}.m_astrctChambers(iChamberIter).m_ah3DSurfaces = [];
             g_strctModule.m_acAnatVol{iAnatVolIter}.m_astrctChambers(iChamberIter).m_bVisible = true;
             g_strctModule.m_acAnatVol{iAnatVolIter}.m_astrctChambers(iChamberIter).m_iGridSelected = 0;
        end
        % Add markers
        if isfield(strctSavedSession.g_strctModule.m_acAnatVol{iAnatVolIter},'m_astrctMarkers')
            
            iNumMarkers = length(strctSavedSession.g_strctModule.m_acAnatVol{iAnatVolIter}.m_astrctMarkers);
        else
             iNumMarkers =0;
        end
        for iMarkerIter=1:iNumMarkers
                        
            clear strctMarker
            Tmp = inv(a2fCRS_To_XYZ)*[strctSavedSession.g_strctModule.m_acAnatVol{iAnatVolIter}.m_astrctMarkers(iMarkerIter).m_pt3fPositionMM;1]; %#ok
            strctMarker.m_pt3fPosition_vox = Tmp(1:3);
            strctMarker.m_strName = strctSavedSession.g_strctModule.m_acAnatVol{iAnatVolIter}.m_astrctMarkers(iMarkerIter).m_strName;
            
            strctMarker.m_strctCrossSectionXY =  g_strctModule.m_acAnatVol{iAnatVolIter}.m_strctCrossSectionHoriz;
            strctMarker.m_strctCrossSectionYZ = g_strctModule.m_acAnatVol{iAnatVolIter}.m_strctCrossSectionSaggital;
            strctMarker.m_strctCrossSectionXZ = g_strctModule.m_acAnatVol{iAnatVolIter}.m_strctCrossSectionCoronal;
            strctMarker.m_strctCrossSectionXY.m_a2fM(1:3,4) = strctMarker.m_pt3fPosition_vox(1:3);
            strctMarker.m_strctCrossSectionYZ.m_a2fM(1:3,4) = strctMarker.m_pt3fPosition_vox(1:3);
            strctMarker.m_strctCrossSectionXZ.m_a2fM(1:3,4) = strctMarker.m_pt3fPosition_vox(1:3);
            
            
            
            
            if isfield(strctSavedSession.g_strctModule.m_acAnatVol{iAnatVolIter}.m_astrctMarkers(iMarkerIter),'m_bLeftArm')
                iModel = 1; % Assume Kopf 1430
                strctMarker.m_strModelName =  g_strctModule.m_astrctStereoTaxticModels(iModel).m_strName;
                
                if  strctSavedSession.g_strctModule.m_acAnatVol{iAnatVolIter}.m_astrctMarkers(iMarkerIter).m_bLeftArm
                    iArm=1;
                else
                    iArm=2;
                end
                fApValue = strctSavedSession.g_strctModule.m_acAnatVol{iAnatVolIter}.m_astrctMarkers(iMarkerIter).m_fAP_Value;
                fDvValue = strctSavedSession.g_strctModule.m_acAnatVol{iAnatVolIter}.m_astrctMarkers(iMarkerIter).m_fZ_Value;
                
                fMlValue = strctSavedSession.g_strctModule.m_acAnatVol{iAnatVolIter}.m_astrctMarkers(iMarkerIter).m_fMidline_Value;
            else
                
                iModel = 2;
                iArm =1 ;
                strctMarker.m_strModelName =  g_strctModule.m_astrctStereoTaxticModels(iModel).m_strName;
                fApValue = strctSavedSession.g_strctModule.m_acAnatVol{iAnatVolIter}.m_astrctMarkers(iMarkerIter).m_astrctJointDescirptions(1).m_fValue;
                fDvValue = strctSavedSession.g_strctModule.m_acAnatVol{iAnatVolIter}.m_astrctMarkers(iMarkerIter).m_astrctJointDescirptions(5).m_fValue;
                fMlValue = strctSavedSession.g_strctModule.m_acAnatVol{iAnatVolIter}.m_astrctMarkers(iMarkerIter).m_astrctJointDescirptions(6).m_fValue;
            end
            
            strctMarker.m_astrctJointDescirptions = ...
                g_strctModule.m_astrctStereoTaxticModels(iModel).m_astrctArms(iArm).m_strctRobot.m_astrctJointsDescription;
            strctMarker.m_strArmType = g_strctModule.m_astrctStereoTaxticModels(iModel).m_astrctArms(iArm).m_strctRobot.m_strName;                

            % Copy the parameters...
            strctMarker.m_astrctJointDescirptions(1).m_fValue = fApValue;
            strctMarker.m_astrctJointDescirptions(2).m_fValue = 0;
            strctMarker.m_astrctJointDescirptions(3).m_fValue = 0;
            strctMarker.m_astrctJointDescirptions(4).m_fValue = 0;
            strctMarker.m_astrctJointDescirptions(5).m_fValue = fDvValue;
            strctMarker.m_astrctJointDescirptions(6).m_fValue = fMlValue;
            strctMarker.m_astrctJointDescirptions(7).m_fValue = 0;
            strctMarker.m_astrctJointDescirptions(8).m_fValue = 0;
            g_strctModule.m_acAnatVol{iAnatVolIter}.m_astrctMarkers(iMarkerIter) = strctMarker;
         %   end
        end

        
        
    end
    
    g_strctModule.m_acFuncVol = strctSavedSession.g_strctModule.m_acFuncVol;
    g_strctModule.m_bVolumeLoaded = strctSavedSession.g_strctModule.m_bVolumeLoaded;
    g_strctModule.m_iCurrAnatVol = strctSavedSession.g_strctModule.m_iCurrAnatVol;
    g_strctModule.m_iCurrFuncVol = strctSavedSession.g_strctModule.m_iCurrFuncVol;
    g_strctModule.m_iCurrChamber = strctSavedSession.g_strctModule.m_iCurrChamber;
    g_strctModule.m_bFuncVolLoaded = strctSavedSession.g_strctModule.m_bFuncVolLoaded;

else

g_strctModule.m_acAnatVol = strctSavedSession.g_strctModule.m_acAnatVol;
g_strctModule.m_acFuncVol = strctSavedSession.g_strctModule.m_acFuncVol;
g_strctModule.m_bVolumeLoaded = strctSavedSession.g_strctModule.m_bVolumeLoaded;
g_strctModule.m_iCurrAnatVol = strctSavedSession.g_strctModule.m_iCurrAnatVol;
g_strctModule.m_iCurrFuncVol = strctSavedSession.g_strctModule.m_iCurrFuncVol;
g_strctModule.m_iCurrChamber = strctSavedSession.g_strctModule.m_iCurrChamber;
g_strctModule.m_bFuncVolLoaded = strctSavedSession.g_strctModule.m_bFuncVolLoaded;
end



acFieldNames = fieldnames(g_strctModule.m_strctGUIOptions);
for k=1:length(acFieldNames)
    if isfield(strctSavedSession.g_strctModule.m_strctGUIOptions,acFieldNames{k})
        setfield(g_strctModule.m_strctGUIOptions,acFieldNames{k},...
            getfield(g_strctModule.m_strctGUIOptions,acFieldNames{k})); %#ok
    end
end

g_strctModule.m_strctOverlay = strctSavedSession.g_strctModule.m_strctOverlay;
g_strctModule.m_strctCrossSectionXY = strctSavedSession.g_strctModule.m_strctCrossSectionXY;
g_strctModule.m_strctCrossSectionYZ = strctSavedSession.g_strctModule.m_strctCrossSectionYZ;
g_strctModule.m_strctCrossSectionXZ = strctSavedSession.g_strctModule.m_strctCrossSectionXZ;

if isfield(strctSavedSession.g_strctModule,'m_astrctImageSeries')
    g_strctModule.m_astrctImageSeries = strctSavedSession.g_strctModule.m_astrctImageSeries;
end

% Delete existing surfaces
fnDeleteFreesurferSurface()
fnGenerateFreesurferSurface();
% Delete existing chamber conoutrs

fnUpdateAnatomicalsList();
fnUpdateFunctionalsList();
fnUpdateChamberList();
fnUpdateGridList();
fnUpdateTargetList();
%fnUpdateBloodVesselList();
fnUpdateROIList();
fnUpdateMarkerList();
fnUpdateGridAxes();
fnUpdateChamberMIP();
fnUpdateOverlayTransform();
fnInvalidateOverlayAxes();
fnUpdateSurfacePatch();
 fnInvalidateSurfaceList();
 if (g_strctModule.m_bInChamberMode)
     fnInvalidateStereotactic();
 end
fnInvalidateImageSeriesList();

fnInvalidate(true);

if ~g_strctModule.m_strctGUIOptions.m_bShow3DPlanes 
    set(g_strctModule.m_strctPanel.m_hPlaneXY,'visible','off');
    set(g_strctModule.m_strctPanel.m_hPlaneYZ,'visible','off');
    set(g_strctModule.m_strctPanel.m_hPlaneXZ,'visible','off');
end;

return;