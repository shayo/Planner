function fnModifyLinkValueEditSlider(iLinkIndex, fNewValue)
global g_strctModule
% 
g_strctModule.m_strctVirtualArm.m_astrctJointsDescription(iLinkIndex).m_fValue = fNewValue;
set(g_strctModule.m_strctPanel.m_ahLinkEdit(iLinkIndex),'String',sprintf('%.2f',fNewValue));
if ~isempty(g_strctModule.m_strctVirtualArm.m_astrctJointsDescription(iLinkIndex).m_afDiscreteValues)
    [fDummy,iIndex] = min(abs(g_strctModule.m_strctVirtualArm.m_astrctJointsDescription(iLinkIndex).m_afDiscreteValues - fNewValue)); %#ok
     set(g_strctModule.m_strctPanel.m_ahLinkSlider(iLinkIndex),'value',iIndex);
else
    fNewMin = min(g_strctModule.m_strctVirtualArm.m_astrctJointsDescription(iLinkIndex).m_fMin,fNewValue);
    fNewMax = min(g_strctModule.m_strctVirtualArm.m_astrctJointsDescription(iLinkIndex).m_fMax,fNewValue);
    set(g_strctModule.m_strctPanel.m_ahLinkSlider(iLinkIndex),'min',fNewMin,'max',fNewMax,'value',fNewValue);
end
return;

