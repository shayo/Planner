 
function fDist = fnPointPlaneDist(strctCrossSection, pt3fPoint) 
fD = -strctCrossSection.m_a2fM(1:3,3)' * strctCrossSection.m_a2fM(1:3,4);
fDist = strctCrossSection.m_a2fM(1:3,3)' * pt3fPoint(1:3) +fD;
return
