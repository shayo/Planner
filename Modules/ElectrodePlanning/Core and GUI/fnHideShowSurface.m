function fnHideShowSurface()      
global g_strctModule
g_strctModule.m_strctGUIOptions.m_bShowSurface = ~g_strctModule.m_strctGUIOptions.m_bShowSurface;
if isfield(g_strctModule.m_strctPanel,'m_hMainVolSurface') && ~isempty(g_strctModule.m_strctPanel.m_hMainVolSurface) && ishandle(g_strctModule.m_strctPanel.m_hMainVolSurface)
    if g_strctModule.m_strctGUIOptions.m_bShowSurface
        set(g_strctModule.m_strctPanel.m_hMainVolSurface,'visible','on');
    else
        set(g_strctModule.m_strctPanel.m_hMainVolSurface,'visible','off');
    end
end

return;