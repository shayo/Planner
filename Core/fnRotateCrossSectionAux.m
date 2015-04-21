function strctCrossSectionNew = fnRotateCrossSectionAux(strctCrossSection1, strctCrossSection2,fRotAngleRad)

[pt3iPointOnLine, afRotateDir] = fnPlanePlaneIntersection(strctCrossSection1,...
    strctCrossSection2);

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

strctCrossSectionNew = strctCrossSection1;
strctCrossSectionNew.m_a2fM = ...
    a2fPosTrans*a2fRot*a2fNegTrans*strctCrossSection1.m_a2fM;

return;

