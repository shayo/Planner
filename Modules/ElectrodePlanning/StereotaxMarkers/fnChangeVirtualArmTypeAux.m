
function fnChangeVirtualArmTypeAux()
global g_strctModule
iStartY = 590;
[g_strctModule.m_strctPanel.m_ahLinkFixed,g_strctModule.m_strctPanel.m_ahLinkSlider, g_strctModule.m_strctPanel.m_ahLinkEdit, iNextY] = ...
    fnGenerateControllersForVirtualArm(g_strctModule.m_strctPanel,g_strctModule.m_strctVirtualArm.m_astrctJointsDescription, iStartY); %#ok
try
delete(g_strctModule.m_ahRobotHandles);
catch %#ok
end
g_strctModule.m_ahRobotHandles = fnRobotDraw(g_strctModule.m_strctVirtualArm,fnRobotGetConfFromRobotStruct(g_strctModule.m_strctVirtualArm),...
    g_strctModule.m_strctPanel.m_strctStereoTactic.m_hAxes,1);
delete(g_strctModule.m_ahRobotHandles);
g_strctModule.m_ahRobotHandles = fnRobotDraw(g_strctModule.m_strctVirtualArm,fnRobotGetConfFromRobotStruct(g_strctModule.m_strctVirtualArm),...
    g_strctModule.m_strctPanel.m_strctStereoTactic.m_hAxes,1);
return;
