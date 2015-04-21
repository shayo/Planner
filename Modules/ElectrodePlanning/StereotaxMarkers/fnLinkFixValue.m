
function fnLinkFixValue(iLinkIndex)
global g_strctModule
bFixed = get(g_strctModule.m_strctPanel.m_ahLinkFixed(iLinkIndex),'value');
if ~bFixed
    set(g_strctModule.m_strctPanel.m_ahLinkEdit(iLinkIndex),'enable','on');
    set(g_strctModule.m_strctPanel.m_ahLinkSlider(iLinkIndex),'enable','on');
    g_strctModule.m_strctVirtualArm.m_astrctJointsDescription(iLinkIndex).m_bFixed = false;
else
    set(g_strctModule.m_strctPanel.m_ahLinkEdit(iLinkIndex),'enable','off');
    set(g_strctModule.m_strctPanel.m_ahLinkSlider(iLinkIndex),'enable','off');
    g_strctModule.m_strctVirtualArm.m_astrctJointsDescription(iLinkIndex).m_bFixed = true;
end
return; 

