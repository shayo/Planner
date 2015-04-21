function fnToggleFreesurferSurfaceVisibility2D()
 global g_strctModule
if g_strctModule.m_iCurrAnatVol == 0
    return;
end;

aiSelectedSurfaces = get(g_strctModule.m_strctPanel.m_hSurfaceList,'value');
for k=1:length(aiSelectedSurfaces)
g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_acFreeSurferSurfaces{aiSelectedSurfaces(k)}.m_bVisible2D = ~g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_acFreeSurferSurfaces{aiSelectedSurfaces(k)}.m_bVisible2D;
end

fnInvalidateSurfaceList();
fnInvalidate();
return;