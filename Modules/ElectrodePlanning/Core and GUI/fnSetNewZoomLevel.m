function fnSetNewZoomLevel(hAxes, afDelta)
global g_strctModule
fDiff = afDelta(2)/2;
if ~isempty(hAxes)
    switch hAxes
        
        case g_strctModule.m_strctPanel.m_strctXY.m_hAxes
            g_strctModule.m_strctCrossSectionXY.m_fHalfWidthMM = max(1,g_strctModule.m_strctCrossSectionXY.m_fHalfWidthMM + fDiff);
            g_strctModule.m_strctCrossSectionXY.m_fHalfHeightMM = max(1,g_strctModule.m_strctCrossSectionXY.m_fHalfHeightMM + fDiff);
        case g_strctModule.m_strctPanel.m_strctYZ.m_hAxes
            g_strctModule.m_strctCrossSectionYZ.m_fHalfWidthMM = max(1,g_strctModule.m_strctCrossSectionYZ.m_fHalfWidthMM + fDiff);
            g_strctModule.m_strctCrossSectionYZ.m_fHalfHeightMM = max(1,g_strctModule.m_strctCrossSectionYZ.m_fHalfHeightMM + fDiff);
        case g_strctModule.m_strctPanel.m_strctXZ.m_hAxes
            g_strctModule.m_strctCrossSectionXZ.m_fHalfWidthMM = max(1,g_strctModule.m_strctCrossSectionXZ.m_fHalfWidthMM + fDiff);
            g_strctModule.m_strctCrossSectionXZ.m_fHalfHeightMM = max(1,g_strctModule.m_strctCrossSectionXZ.m_fHalfHeightMM + fDiff);
    end;
end;

fnInvalidate();
return;

