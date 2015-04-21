function fnRemoveFreesurferSurface()
 global g_strctModule
if g_strctModule.m_iCurrAnatVol == 0
    return;
end;

aiSelectedSurfaces = get(g_strctModule.m_strctPanel.m_hSurfaceList,'value');
g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_acFreeSurferSurfaces(aiSelectedSurfaces) = [];
delete(g_strctModule.m_ahFreeSurfer3DHandles(aiSelectedSurfaces));
g_strctModule.m_ahFreeSurfer3DHandles(aiSelectedSurfaces) = [];

fnInvalidateSurfaceList();
fnInvalidate();
return;