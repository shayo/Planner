
function fnInvalidateOverlayAxes()
global g_strctModule
set(g_strctModule.m_strctPanel.m_strctOverlayAxes.hLine2,'xdata',...
    [g_strctModule.m_strctOverlay.m_pt2fLeft(1) g_strctModule.m_strctOverlay.m_pt2fRight(1)],...
    'Ydata',[g_strctModule.m_strctOverlay.m_pt2fLeft(2) g_strctModule.m_strctOverlay.m_pt2fRight(2)]);

set(g_strctModule.m_strctPanel.m_strctOverlayAxes.hLeftPoint,'xdata',...
 g_strctModule.m_strctOverlay.m_pt2fLeft(1),'ydata',g_strctModule.m_strctOverlay.m_pt2fLeft(2));
 
set(g_strctModule.m_strctPanel.m_strctOverlayAxes.hRightPoint,'xdata',...
 g_strctModule.m_strctOverlay.m_pt2fRight(1),'ydata',g_strctModule.m_strctOverlay.m_pt2fRight(2));


if ~isfield(g_strctModule.m_strctOverlay,'m_pt2fRightPos')
    g_strctModule.m_strctOverlay.m_pt2fRightPos = [8, 1];
    g_strctModule.m_strctOverlay.m_pt2fLeftPos = [4, 0];
    g_strctModule.m_strctOverlay.m_afPvalueRange = [-30 30];
end

set(g_strctModule.m_strctPanel.m_strctOverlayAxes.hLeftPointPos,'xdata',...
 g_strctModule.m_strctOverlay.m_pt2fLeftPos(1),'ydata',g_strctModule.m_strctOverlay.m_pt2fLeftPos(2));
 
set(g_strctModule.m_strctPanel.m_strctOverlayAxes.hRightPointPos,'xdata',...
 g_strctModule.m_strctOverlay.m_pt2fRightPos(1),'ydata',g_strctModule.m_strctOverlay.m_pt2fRightPos(2));

set(g_strctModule.m_strctPanel.m_strctOverlayAxes.hLine4,'xdata',...
    [g_strctModule.m_strctOverlay.m_pt2fLeftPos(1) g_strctModule.m_strctOverlay.m_pt2fRightPos(1)],...
    'Ydata',[g_strctModule.m_strctOverlay.m_pt2fLeftPos(2) g_strctModule.m_strctOverlay.m_pt2fRightPos(2)]);


set(g_strctModule.m_strctPanel.m_strctOverlayAxes.m_hAxes,'xlim',g_strctModule.m_strctOverlay.m_afPvalueRange,'ylim',[-0.2 1.2]);
return;

