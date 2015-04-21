

function fnHideShowTargets()
global g_strctModule
g_strctModule.m_strctGUIOptions.m_bShowTargets = ~g_strctModule.m_strctGUIOptions.m_bShowTargets;
fnInvalidate();
return;