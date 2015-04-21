function fnDeleteMarkerContours()
global g_strctModule
if isfield(g_strctModule.m_strctPanel,'m_ahMarkers')
    delete(g_strctModule.m_strctPanel.m_ahMarkers);
end;
g_strctModule.m_strctPanel.m_ahMarkers = [];

return;