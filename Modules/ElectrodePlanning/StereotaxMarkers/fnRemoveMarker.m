function fnRemoveMarker()
global g_strctModule
if g_strctModule.m_iCurrAnatVol == 0 || isempty(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers) 
    return;
end;
aiCurrMarkers = get(g_strctModule.m_strctPanel.m_hMarkersList,'value');
g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers(aiCurrMarkers) = [];
iNumRemainingMarkers = length(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers);
set(g_strctModule.m_strctPanel.m_hMarkersList,'value',iNumRemainingMarkers);
fnUpdateMarkerList();
fnInvalidate(true);

return;
