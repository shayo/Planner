
function fnShowHideTimeCourse()
global g_strctModule

if g_strctModule.m_strctGUIOptions.m_bShowTimeCourse
    g_strctModule.m_strctGUIOptions.m_bShowTimeCourse = false;
    set(g_strctModule.m_strctPanel.m_strct3D.m_hPanel,'visible','on')
    set(g_strctModule.m_strctPanel.m_strctTimeCourse.m_hPanel,'visible','off')
    set(g_strctModule.m_strctPanel.m_strctTimeCourse.m_hAxes,'Visible','off');
    
else
    g_strctModule.m_strctGUIOptions.m_bShowTimeCourse = true;
    set(g_strctModule.m_strctPanel.m_strct3D.m_hPanel,'visible','off')
    set(g_strctModule.m_strctPanel.m_strctTimeCourse.m_hPanel,'visible','on')
    set(g_strctModule.m_strctPanel.m_strctTimeCourse.m_hAxes,'Visible','on');
    
end

return;