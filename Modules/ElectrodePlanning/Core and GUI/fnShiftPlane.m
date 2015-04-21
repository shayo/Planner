
 function fnShiftPlane(hAxes, fDiff)
global g_strctModule
switch hAxes
    case g_strctModule.m_strctPanel.m_strctXY.m_hAxes 
        afCurrPos = g_strctModule.m_strctCrossSectionXY.m_a2fM(1:3,4);
        afDirection = g_strctModule.m_strctCrossSectionXY.m_a2fM(:,3);
        afNewPos = afCurrPos - afDirection(1:3) * fDiff;
        g_strctModule.m_strctCrossSectionXY.m_a2fM(1:3,4) = afNewPos;
        fnInvalidate();
    case g_strctModule.m_strctPanel.m_strctYZ.m_hAxes
        afCurrPos = g_strctModule.m_strctCrossSectionYZ.m_a2fM(1:3,4);
        afDirection = g_strctModule.m_strctCrossSectionYZ.m_a2fM(:,3);
        afNewPos = afCurrPos + afDirection(1:3) * fDiff;
        g_strctModule.m_strctCrossSectionYZ.m_a2fM(1:3,4) = afNewPos;
        fnInvalidate();
    case g_strctModule.m_strctPanel.m_strctXZ.m_hAxes 
        afCurrPos = g_strctModule.m_strctCrossSectionXZ.m_a2fM(1:3,4);
        afDirection = g_strctModule.m_strctCrossSectionXZ.m_a2fM(:,3);
        afNewPos = afCurrPos + afDirection(1:3) * fDiff;
        g_strctModule.m_strctCrossSectionXZ.m_a2fM(1:3,4) = afNewPos;
        fnInvalidate();
end;

return;


