
function fnShowHideBloodVessels()
global g_strctModule

g_strctModule.m_strctGUIOptions.m_bShowBloodVessels = ~g_strctModule.m_strctGUIOptions.m_bShowBloodVessels;
fnInvalidate();

return;

