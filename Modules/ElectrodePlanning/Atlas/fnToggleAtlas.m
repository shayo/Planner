
function fnToggleAtlas()
global g_strctModule
g_strctModule.m_strctGUIOptions.m_bShowAtlas = ~g_strctModule.m_strctGUIOptions.m_bShowAtlas;
fnInvalidate();
return;
    