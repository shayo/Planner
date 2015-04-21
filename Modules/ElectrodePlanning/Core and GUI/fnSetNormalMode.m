function fnSetNormalMode()
global g_strctModule 
g_strctModule.m_bInChamberMode = false;
for k=1:length(g_strctModule.m_strctPanel.m_ahRightPanels)
    if k~=1
        set(g_strctModule.m_strctPanel.m_ahRightPanels(k),'visible','off');
    else
        set(g_strctModule.m_strctPanel.m_ahRightPanels(k),'visible','on');
    end
end
set(g_strctModule.m_strctPanel.m_strctStereoTactic.m_hPanel,'visible','off');
delete(get(g_strctModule.m_strctPanel.m_strctStereoTactic.m_hAxes,'children'));
set(g_strctModule.m_strctPanel.m_strctStereoTactic.m_hAxes,'visible','off');
set(g_strctModule.m_strctPanel.m_strct3D.m_hPanel,'visible','on');
set(g_strctModule.m_strctPanel.m_strct3D.m_hAxes,'visible','on');
axis(g_strctModule.m_strctPanel.m_strct3D.m_hAxes,'xy');
g_strctModule.m_bInChamberMode = false;
g_strctModule.m_bInAtlasMode = false;


try
    set(g_strctModule.m_strctPanel.m_hMainVolSurface,'visible','on');
catch %#ok
end

fnInvalidate(1);

return;
