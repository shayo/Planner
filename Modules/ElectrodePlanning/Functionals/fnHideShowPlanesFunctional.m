

function fnHideShowPlanesFunctional()
global g_strctModule
g_strctModule.m_strctGUIOptions.m_bShowFunctional = ~g_strctModule.m_strctGUIOptions.m_bShowFunctional;
fnInvalidate(true);
return;