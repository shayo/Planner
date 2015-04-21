
function fnSwitchJoint()
global g_strctModule
iSelectedMarker = get(g_strctModule.m_strctPanel.m_hMarkersList,'value');
if length(iSelectedMarker) > 1 || g_strctModule.m_iCurrAnatVol == 0 || ~isfield(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol},'m_astrctMarkers')
    return;
end;
g_strctModule.m_iJointSelected  = get(g_strctModule.m_strctPanel.m_hStereoJointsList,'value');
set(g_strctModule.m_strctPanel.m_hJointEdit,'string',...
    sprintf('%.3f',g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers(iSelectedMarker).m_astrctJointDescirptions(g_strctModule.m_iJointSelected).m_fValue));
return;