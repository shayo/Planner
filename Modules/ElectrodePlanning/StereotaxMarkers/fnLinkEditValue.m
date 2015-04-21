

function fnLinkEditValue(iLinkIndex)
global g_strctModule
fNewValue = str2num(get(g_strctModule.m_strctPanel.m_ahLinkEdit(iLinkIndex),'string')); %#ok

if isempty(fNewValue) || ~isreal(fNewValue)
    % recover old value...
    set(g_strctModule.m_strctPanel.m_ahLinkEdit(iLinkIndex),'string',sprintf('%.2f',g_strctModule.m_strctVirtualArm.m_astrctJointsDescription(iLinkIndex).m_fValue));
    return;
end

fNewValue = min(max(fNewValue,g_strctModule.m_strctVirtualArm.m_astrctJointsDescription(iLinkIndex).m_fMin),g_strctModule.m_strctVirtualArm.m_astrctJointsDescription(iLinkIndex).m_fMax);
g_strctModule.m_strctVirtualArm.m_astrctJointsDescription(iLinkIndex).m_fValue = fNewValue;
if ~isempty(g_strctModule.m_strctVirtualArm.m_astrctJointsDescription(iLinkIndex).m_afDiscreteValues)
    
else
    % Simple case.
    set(g_strctModule.m_strctPanel.m_ahLinkSlider(iLinkIndex),'value',fNewValue);
end

delete(g_strctModule.m_ahRobotHandles);


afConf = fnRobotGetConfFromRobotStruct(g_strctModule.m_strctVirtualArm);

g_strctModule.m_ahRobotHandles = fnRobotDraw(g_strctModule.m_strctVirtualArm,afConf,...
    g_strctModule.m_strctPanel.m_strctStereoTactic.m_hAxes,1);

%T = fnRobotForward(g_strctModule.m_strctVirtualArm,afConf);
%set(g_strctModule.m_strctPanel.m_hStatusLine,'string',sprintf('%.2f %.2f %.2f',T(1,4),T(2,4),T(3,4)));


fnUpdateChamberContour();
return;



    