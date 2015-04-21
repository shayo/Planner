

function fnHideShowShowHideChamber()
global g_strctModule
g_strctModule.m_strctGUIOptions.m_bShowChamber = ~g_strctModule.m_strctGUIOptions.m_bShowChamber;
fnInvalidate();
return;