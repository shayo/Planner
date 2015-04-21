
function fnHideShowPlanes3D()
global g_strctModule
g_strctModule.m_strctGUIOptions.m_bShow3DPlanes  = ~g_strctModule.m_strctGUIOptions.m_bShow3DPlanes ;
if g_strctModule.m_strctGUIOptions.m_bShow3DPlanes 
    set(g_strctModule.m_strctPanel.m_hPlaneXY,'visible','on');
    set(g_strctModule.m_strctPanel.m_hPlaneXZ,'visible','on');
    set(g_strctModule.m_strctPanel.m_hPlaneYZ,'visible','on');
else
    set(g_strctModule.m_strctPanel.m_hPlaneXY,'visible','off');
    set(g_strctModule.m_strctPanel.m_hPlaneXZ,'visible','off');
    set(g_strctModule.m_strctPanel.m_hPlaneYZ,'visible','off');
end
return;
