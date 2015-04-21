function fnClearROIs()
global g_strctModule
if isempty(g_strctModule.m_iCurrAnatVol)
    return;
end;
aiSelectedROI = get(g_strctModule.m_strctPanel.m_hROIList,'value');
for k=1:length(aiSelectedROI)
    g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctROIs(aiSelectedROI(k)).m_aiVolumeIndices = [];
end
fnInvalidate(1);
return;
