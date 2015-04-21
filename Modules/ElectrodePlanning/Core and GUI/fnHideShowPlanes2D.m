
function fnHideShowPlanes2D()
global g_strctModule
g_strctModule.m_strctGUIOptions.m_bShow2DPlanes = ~g_strctModule.m_strctGUIOptions.m_bShow2DPlanes;

if g_strctModule.m_strctGUIOptions.m_bShow2DPlanes
    set(g_strctModule.m_strctPanel.m_strctXY.m_hLineYZ,'visible','on');
    set(g_strctModule.m_strctPanel.m_strctXY.m_hLineXZ,'visible','on');
    set(g_strctModule.m_strctPanel.m_strctXZ.m_hLineYZ,'visible','on');
    set(g_strctModule.m_strctPanel.m_strctXZ.m_hLineXY,'visible','on');
    set(g_strctModule.m_strctPanel.m_strctYZ.m_hLineXY,'visible','on');
    set(g_strctModule.m_strctPanel.m_strctYZ.m_hLineXZ,'visible','on');
else
    set(g_strctModule.m_strctPanel.m_strctXY.m_hLineYZ,'visible','off');
    set(g_strctModule.m_strctPanel.m_strctXY.m_hLineXZ,'visible','off');
    set(g_strctModule.m_strctPanel.m_strctXZ.m_hLineYZ,'visible','off');
    set(g_strctModule.m_strctPanel.m_strctXZ.m_hLineXY,'visible','off');
    set(g_strctModule.m_strctPanel.m_strctYZ.m_hLineXY,'visible','off');
    set(g_strctModule.m_strctPanel.m_strctYZ.m_hLineXZ,'visible','off');
end;

fnInvalidate();
return;