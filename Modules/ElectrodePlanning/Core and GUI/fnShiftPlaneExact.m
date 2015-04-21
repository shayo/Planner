
function  fnShiftPlaneExact(strctLastMouseDown, strctMouseOp)
global g_strctModule
% Transform MouseOp into a 3D Point.
pt3fPosIn3DSpace=fnGet3DCoord(strctMouseOp);

switch strctLastMouseDown.m_hAxesSelected
    case g_strctModule.m_strctPanel.m_strctXY.m_hAxes 
        fDist = fnPointPlaneDist(g_strctModule.m_strctCrossSectionXY, pt3fPosIn3DSpace) ;
        
        afCurrPos = g_strctModule.m_strctCrossSectionXY.m_a2fM(1:3,4);
        afDirection = g_strctModule.m_strctCrossSectionXY.m_a2fM(:,3);
        afNewPos = afCurrPos + afDirection(1:3) * fDist;
        g_strctModule.m_strctCrossSectionXY.m_a2fM(1:3,4) = afNewPos;
        fnInvalidate();
    case g_strctModule.m_strctPanel.m_strctYZ.m_hAxes
         fDist = fnPointPlaneDist(g_strctModule.m_strctCrossSectionYZ, pt3fPosIn3DSpace) ;
         
        afCurrPos = g_strctModule.m_strctCrossSectionYZ.m_a2fM(1:3,4);
        afDirection = g_strctModule.m_strctCrossSectionYZ.m_a2fM(:,3);
        afNewPos = afCurrPos + afDirection(1:3) * fDist;
        g_strctModule.m_strctCrossSectionYZ.m_a2fM(1:3,4) = afNewPos;
        fnInvalidate();
    case g_strctModule.m_strctPanel.m_strctXZ.m_hAxes 
        fDist = fnPointPlaneDist(g_strctModule.m_strctCrossSectionXZ, pt3fPosIn3DSpace) ;
        
        afCurrPos = g_strctModule.m_strctCrossSectionXZ.m_a2fM(1:3,4);
        afDirection = g_strctModule.m_strctCrossSectionXZ.m_a2fM(:,3);
        afNewPos = afCurrPos + afDirection(1:3) * fDist;
        g_strctModule.m_strctCrossSectionXZ.m_a2fM(1:3,4) = afNewPos;
        fnInvalidate();
end;

return;
