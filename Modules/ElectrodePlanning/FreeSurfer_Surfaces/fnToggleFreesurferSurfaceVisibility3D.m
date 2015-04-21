function fnToggleFreesurferSurfaceVisibility3D()
 global g_strctModule
if g_strctModule.m_iCurrAnatVol == 0
    return;
end;

% 
% 
aiSelectedSurfaces = get(g_strctModule.m_strctPanel.m_hSurfaceList,'value');
for k=1:length(aiSelectedSurfaces)
     if g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_acFreeSurferSurfaces{aiSelectedSurfaces(k)}.m_bVisible3D
         g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_acFreeSurferSurfaces{aiSelectedSurfaces(k)}.m_bVisible3D = false;
         set(g_strctModule.m_ahFreeSurfer3DHandles(aiSelectedSurfaces(k)),'visible','off');
     else
         g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_acFreeSurferSurfaces{aiSelectedSurfaces(k)}.m_bVisible3D = true;
         set(g_strctModule.m_ahFreeSurfer3DHandles(aiSelectedSurfaces(k)),'visible','on');
     end
 end

return;