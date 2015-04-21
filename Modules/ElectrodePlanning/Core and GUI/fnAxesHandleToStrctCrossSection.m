function strctCrossSection=fnAxesHandleToStrctCrossSection(hAxes)
global g_strctModule
switch hAxes
    case g_strctModule.m_strctPanel.m_strctXY.m_hAxes
        strctCrossSection = g_strctModule.m_strctCrossSectionXY;
    case g_strctModule.m_strctPanel.m_strctYZ.m_hAxes
        strctCrossSection = g_strctModule.m_strctCrossSectionYZ;
    case g_strctModule.m_strctPanel.m_strctXZ.m_hAxes
        strctCrossSection = g_strctModule.m_strctCrossSectionXZ;
    otherwise
        strctCrossSection = [];
end
return;