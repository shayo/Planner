
function fnRotateAxesInPlane(hAxes,afDelta)
global g_strctModule
if isempty(hAxes)
    return;
end;
switch hAxes
    case g_strctModule.m_strctPanel.m_strctXY.m_hAxes
        g_strctModule.m_strctCrossSectionXY = ...
            fnRotateInPlaneCrossSectionAux(g_strctModule.m_strctCrossSectionXY, afDelta(1)/100*pi);
    case g_strctModule.m_strctPanel.m_strctYZ.m_hAxes
        g_strctModule.m_strctCrossSectionYZ = ...
            fnRotateInPlaneCrossSectionAux(g_strctModule.m_strctCrossSectionYZ, afDelta(1)/100*pi);
    case g_strctModule.m_strctPanel.m_strctXZ.m_hAxes
        g_strctModule.m_strctCrossSectionXZ = ...
            fnRotateInPlaneCrossSectionAux(g_strctModule.m_strctCrossSectionXZ, -afDelta(1)/100*pi);
end;

fnInvalidate();


return;