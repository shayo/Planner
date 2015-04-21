function fnSwithMarker()
global g_strctModule
if ~isfield(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol},'m_astrctMarkers')
    errordlg('Please add markers first!');
    return;
end;

aiCurrMarkers = get(g_strctModule.m_strctPanel.m_hMarkersList,'value');
if ~isfield(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers(1),'m_bEnabled')
    for k=1:length(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers)
        g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers(k).m_bEnabled = true;
    end
end

for k=1:length(aiCurrMarkers)
    g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers(aiCurrMarkers(k)).m_bEnabled = ~g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers(aiCurrMarkers(k)).m_bEnabled;
end

fnUpdateMarkerList();
fnInvalidate(true);
return;        
