
function fnSetCurrAnatVol()
global g_strctModule
if isfield(g_strctModule.m_strctPanel,'m_hMainVolSurface') && ~isempty(g_strctModule.m_strctPanel.m_hMainVolSurface) && ishandle(g_strctModule.m_strctPanel.m_hMainVolSurface)
    delete(g_strctModule.m_strctPanel.m_hMainVolSurface);
    g_strctModule.m_strctPanel.m_hMainVolSurface = [];
end;
if isfield(g_strctModule.m_strctPanel,'m_hBloodSurface')  && ~isempty(g_strctModule.m_strctPanel.m_hBloodSurface) && ishandle(g_strctModule.m_strctPanel.m_hBloodSurface)
    delete(g_strctModule.m_strctPanel.m_hBloodSurface);
    g_strctModule.m_strctPanel.m_hBloodSurface = [];
end;

%fnDeleteChamberContours(); 
fnDeleteMarkerContours();
fnDeleteTargetContours();
fnDeleteFreesurferSurface();
iNewVolSelected = get(g_strctModule.m_strctPanel.m_hAnatList,'value');

if isempty(g_strctModule.m_acAnatVol)
    return
end

bSetDefaultView =  norm(g_strctModule.m_acAnatVol{iNewVolSelected}.m_strctCrossSectionHoriz.m_a2fM(:) - ...
    g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_strctCrossSectionHoriz.m_a2fM(:)) > 1e-10;
    
g_strctModule.m_iCurrAnatVol = iNewVolSelected;
if isfield(g_strctModule.m_acAnatVol{iNewVolSelected},'m_iLastSelectedChamber') && g_strctModule.m_acAnatVol{iNewVolSelected}.m_iLastSelectedChamber > 0
    g_strctModule.m_iCurrChamber = g_strctModule.m_acAnatVol{iNewVolSelected}.m_iLastSelectedChamber;
else
    g_strctModule.m_iCurrChamber = 0;
end
fnUpdateChamberList();
fnSelectChamberAux(g_strctModule.m_iCurrChamber);
    
fnUpdateSurfacePatch();

fnUpdateTargetList();

fnUpdateGridList();
try
fnUpdateGridAxes();
catch %#ok
end
fnUpdateMarkerList();
if (bSetDefaultView)
    fnSetDefaultCrossSections();
end
fnInvalidateSurfaceList();
fnInvalidateImageSeriesList();


 if isfield(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol},'m_acFreeSurferSurfaces')
     iNumSurfaces = length(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_acFreeSurferSurfaces);
     for k=1:iNumSurfaces
        if (g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_acFreeSurferSurfaces{k}.m_bVisible3D)
            fnGenerateFreesurferSurfaceAux(k);
        end
     end
 end
  

fnInvalidate(true);
return;