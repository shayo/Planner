function fnDeleteROIs()
global g_strctModule
if isempty(g_strctModule.m_iCurrAnatVol)
    return;
end;
iSelectedROI = get(g_strctModule.m_strctPanel.m_hROIList,'value');
g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctROIs(iSelectedROI) = [];
fnUpdateROIList();
fnInvalidate(1);
return;
