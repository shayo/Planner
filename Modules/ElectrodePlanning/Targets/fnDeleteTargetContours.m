function fnDeleteTargetContours()
global g_strctModule
if isfield(g_strctModule.m_strctPanel,'m_ahTargets')
    delete(g_strctModule.m_strctPanel.m_ahTargets);
end;
g_strctModule.m_strctPanel.m_ahTargets = [];

return;