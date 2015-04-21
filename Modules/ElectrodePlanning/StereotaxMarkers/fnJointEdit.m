
function fnJointEdit()

global g_strctModule
iSelectedMarker = get(g_strctModule.m_strctPanel.m_hMarkersList,'value');
if length(iSelectedMarker) > 1 || g_strctModule.m_iCurrAnatVol == 0
    return;
end;
if ~isempty(iSelectedMarker) && iSelectedMarker > 0 && isfield(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol},'m_astrctMarkers')
    if ~isempty(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers)
        g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers(iSelectedMarker).m_astrctJointDescirptions(g_strctModule.m_iJointSelected).m_fValue = ...
            str2double(get(g_strctModule.m_strctPanel.m_hJointEdit,'string'));
        fnSelectMarker();
    end
end