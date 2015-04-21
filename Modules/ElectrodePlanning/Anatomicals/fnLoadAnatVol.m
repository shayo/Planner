
function fnLoadAnatVol()
global g_strctModule
    
[strFile, strPath] = uigetfile([g_strctModule.m_strDefaultFilesFolder,'*.mgz;*.img;*.nii'],'MultiSelect','off');
if strFile(1) == 0
    return;
end;
% Start the import process
strFilename = fullfile(strPath,strFile);
strctVol=fnQuickAddVolume(strFilename);

% Add the new volume to planner
iNumVolumes = length(g_strctModule.m_acAnatVol);
g_strctModule.m_acAnatVol{iNumVolumes+1} = strctVol;
g_strctModule.m_iCurrAnatVol = length(g_strctModule.m_acAnatVol);
g_strctModule.m_bVolumeLoaded = true;
 fnDeleteFreesurferSurface();
fnSetDefaultCrossSections();
fnUpdateAnatomicalsList();    
fnUpdateSurfacePatch();

fnUpdateChamberList();
fnUpdateGridList();
set(g_strctModule.m_strctPanel.m_hAnatList,'value',iNumVolumes+1);
fnSetCurrAnatVol();
fnInvalidate();
return;
