
function fnUpdateOverlayTransform()
global g_strctModule
Tmp = get(g_strctModule.m_strctPanel.m_strctOverlayAxes.m_hAxes,'CurrentPoint');

afRange = axis(g_strctModule.m_strctPanel.m_strctOverlayAxes.m_hAxes);
pt2fCurrPoint = Tmp([2,3]);
pt2fCurrPoint(1) = min(afRange(2), max(afRange(1), pt2fCurrPoint(1)));
pt2fCurrPoint(2) = min(1, max(0, pt2fCurrPoint(2)));

if ~isempty(g_strctModule.m_strctLastMouseDown) && ~isempty(g_strctModule.m_strctLastMouseDown.m_hObjectSelected)
    switch g_strctModule.m_strctLastMouseDown.m_hObjectSelected
        case g_strctModule.m_strctPanel.m_strctOverlayAxes.hLeftPoint
            pt2fCurrPoint(1) = min(pt2fCurrPoint(1), g_strctModule.m_strctOverlay.m_pt2fRight(1));
            g_strctModule.m_strctOverlay.m_pt2fLeft = pt2fCurrPoint;
            fnInvalidateOverlayAxes();
            fnInvalidate();
        case g_strctModule.m_strctPanel.m_strctOverlayAxes.hRightPoint
            pt2fCurrPoint(1) = max(pt2fCurrPoint(1), g_strctModule.m_strctOverlay.m_pt2fLeft(1));
            g_strctModule.m_strctOverlay.m_pt2fRight = pt2fCurrPoint;
            fnInvalidateOverlayAxes();
            fnInvalidate();
        case g_strctModule.m_strctPanel.m_strctOverlayAxes.hLeftPointPos
            pt2fCurrPoint(1) = min(pt2fCurrPoint(1), g_strctModule.m_strctOverlay.m_pt2fRightPos(1));
            g_strctModule.m_strctOverlay.m_pt2fLeftPos = pt2fCurrPoint;
            fnInvalidateOverlayAxes();
            fnInvalidate();
        case g_strctModule.m_strctPanel.m_strctOverlayAxes.hRightPointPos
            pt2fCurrPoint(1) = max(pt2fCurrPoint(1), g_strctModule.m_strctOverlay.m_pt2fLeftPos(1));
            g_strctModule.m_strctOverlay.m_pt2fRightPos = pt2fCurrPoint;
            fnInvalidateOverlayAxes();
            fnInvalidate();
         
    end;
end;

return;
