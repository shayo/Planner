
function fnSwitchStereoArm()
global g_strctModule
g_strctModule.m_iStereoArmSelected = get(g_strctModule.m_strctPanel.m_hStereoArmsList,'value');

iSelectedMarker = get(g_strctModule.m_strctPanel.m_hMarkersList,'value');
if length(iSelectedMarker) > 1 || g_strctModule.m_iCurrAnatVol == 0
    return;
end;
if ~isempty(iSelectedMarker) && iSelectedMarker > 0 && isfield(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol},'m_astrctMarkers')
    if ~isempty(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers)
        g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers(iSelectedMarker).m_strArmType = ...
            g_strctModule.m_astrctStereoTaxticModels(g_strctModule.m_iStereoModelSelected).m_astrctArms(g_strctModule.m_iStereoArmSelected).m_strctRobot.m_strName;
        
        g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers(iSelectedMarker).m_astrctJointDescirptions = ...
            g_strctModule.m_astrctStereoTaxticModels(g_strctModule.m_iStereoModelSelected).m_astrctArms(g_strctModule.m_iStereoArmSelected).m_strctRobot.m_astrctJointsDescription;
        fnSelectMarker();
    end
end


return;

