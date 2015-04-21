function fnToggleVisibilityROI()
global g_strctModule
if isempty(g_strctModule.m_iCurrAnatVol)
    return;
end;
iSelectedROI = get(g_strctModule.m_strctPanel.m_hROIList,'value');
for k=1:length(iSelectedROI)
    g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctROIs(iSelectedROI(k)).m_bVisible= ~g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctROIs(iSelectedROI(k)).m_bVisible;
end;
fnInvalidate(1);
return;




