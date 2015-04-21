
function fnInvalidateDerivedSurfaceList()
global g_strctModule
iSelectedParentSurface = get(g_strctModule.m_strctPanel.m_hSurfaceList,'value');
if isempty(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_acFreeSurferSurfaces)
    set(g_strctModule.m_strctPanel.m_hDerivedSurfaceList,'string',[]);
    return;
end;

iNumDerived = length(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_acFreeSurferSurfaces{iSelectedParentSurface}.m_acDerivedSurfaces);
acDerivedNames = cell(1,iNumDerived);
for k=1:iNumDerived
    acDerivedNames{k}=g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_acFreeSurferSurfaces{iSelectedParentSurface}.m_acDerivedSurfaces{k}.m_strName;
end
set(g_strctModule.m_strctPanel.m_hDerivedSurfaceList,'string',acDerivedNames);
return;