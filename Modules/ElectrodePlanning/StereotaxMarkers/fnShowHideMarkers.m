
function fnShowHideMarkers()
global g_strctModule

g_strctModule.m_strctGUIOptions.m_bShowMarkers = ~g_strctModule.m_strctGUIOptions.m_bShowMarkers;
fnInvalidate();

return;

