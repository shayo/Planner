
function fnHideShowBloodVessels()
global g_strctModule
g_strctModule.m_strctGUIOptions.m_bShowBloodVessels = ~g_strctModule.m_strctGUIOptions.m_bShowBloodVessels;
if isfield(g_strctModule.m_strctPanel,'m_hBloodSurface') && ~isempty(g_strctModule.m_strctPanel.m_hBloodSurface) && ishandle(g_strctModule.m_strctPanel.m_hBloodSurface)
    if g_strctModule.m_strctGUIOptions.m_bShowBloodVessels
        set(g_strctModule.m_strctPanel.m_hBloodSurface,'visible','on');
    else
        set(g_strctModule.m_strctPanel.m_hBloodSurface,'visible','off');
    end
end
return;
    


