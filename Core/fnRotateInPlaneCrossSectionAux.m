function strctCrossSectionNew = fnRotateInPlaneCrossSectionAux(strctCrossSection,fRotAngleRad)

pt3iPointOnLine = strctCrossSection.m_a2fM(1:3,4);
afRotateDir =strctCrossSection.m_a2fM(1:3,3);

a2fNegTrans = [1 0 0 -pt3iPointOnLine(1);
    0 1 0 -pt3iPointOnLine(2);
    0 0 1 -pt3iPointOnLine(3);
    0 0 0  1];

a2fPosTrans = [1 0 0 pt3iPointOnLine(1);
    0 1 0 pt3iPointOnLine(2);
    0 0 1 pt3iPointOnLine(3);
    0 0 0  1];

R = fnRotateVectorAboutAxis(afRotateDir, fRotAngleRad);
a2fRot = zeros(4,4);
a2fRot(1:3,1:3) = R;
a2fRot(4,4) = 1;

strctCrossSectionNew = strctCrossSection;
strctCrossSectionNew.m_a2fM = ...
    a2fPosTrans*a2fRot*a2fNegTrans*strctCrossSection.m_a2fM;

return;

