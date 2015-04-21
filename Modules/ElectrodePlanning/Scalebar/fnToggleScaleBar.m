function fnToggleScaleBar()
global g_strctModule
if ~isfield(g_strctModule.m_strctGUIOptions,'m_bScaleBar')
    g_strctModule.m_strctGUIOptions.m_bScaleBar = false; 
end

g_strctModule.m_strctGUIOptions.m_bScaleBar = ~g_strctModule.m_strctGUIOptions.m_bScaleBar; 
if g_strctModule.m_strctGUIOptions.m_bScaleBar 
    if ~isempty(g_strctModule.m_strctPanel.m_strctXZ.m_hScaleBar)
        set(g_strctModule.m_strctPanel.m_strctXZ.m_hScaleBar,'visible','on');
    end
    if ~isempty(g_strctModule.m_strctPanel.m_strctXY.m_hScaleBar)
        set(g_strctModule.m_strctPanel.m_strctXY.m_hScaleBar,'visible','on');
    end
    if ~isempty(g_strctModule.m_strctPanel.m_strctYZ.m_hScaleBar)
        set(g_strctModule.m_strctPanel.m_strctYZ.m_hScaleBar,'visible','on');
    end
else
    if ~isempty(g_strctModule.m_strctPanel.m_strctXZ.m_hScaleBar)
        set(g_strctModule.m_strctPanel.m_strctXZ.m_hScaleBar,'visible','off');
    end
    if ~isempty(g_strctModule.m_strctPanel.m_strctXY.m_hScaleBar)
        set(g_strctModule.m_strctPanel.m_strctXY.m_hScaleBar,'visible','off');
    end
    if ~isempty(g_strctModule.m_strctPanel.m_strctYZ.m_hScaleBar)
        set(g_strctModule.m_strctPanel.m_strctYZ.m_hScaleBar,'visible','off');
    end
end

fnDrawScaleBar();