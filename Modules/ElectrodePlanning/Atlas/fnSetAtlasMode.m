function fnSetAtlasMode()
global g_strctModule
g_strctModule.m_bInAtlasMode = true;
set(g_strctModule.m_strctPanel.m_ahRightPanels(3),'visible','on');
set(g_strctModule.m_strctPanel.m_ahRightPanels(1:2),'visible','off');
return;

