function fScale = fnGetAxesScaleFactor(hAxes)
global g_strctModule
if isempty(hAxes)
    fScale = 0;
    return;
end;
switch hAxes
    case g_strctModule.m_strctPanel.m_strctXY.m_hAxes
        fScale = g_strctModule.m_strctCrossSectionXY.m_iResHeight /  (2*g_strctModule.m_strctCrossSectionXY.m_fHalfHeightMM);
    case g_strctModule.m_strctPanel.m_strctYZ.m_hAxes
        fScale = g_strctModule.m_strctCrossSectionYZ.m_iResHeight /  (2*g_strctModule.m_strctCrossSectionYZ.m_fHalfHeightMM);
    case g_strctModule.m_strctPanel.m_strctXZ.m_hAxes
        fScale = g_strctModule.m_strctCrossSectionXZ.m_iResHeight /  (2*g_strctModule.m_strctCrossSectionXZ.m_fHalfHeightMM);
    otherwise 
        fScale = 1;
end
return