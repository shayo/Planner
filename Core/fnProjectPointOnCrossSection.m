function [pt3fNearestPointOnPlane, pt2fImageMM,Dist] = fnProjectPointOnCrossSection(strctCrossSection, pt3fPoint)
if ~isstruct(strctCrossSection)
    strctCrossSection.m_a2fM = strctCrossSection;
end
d = -strctCrossSection.m_a2fM(1:3,3)' * strctCrossSection.m_a2fM(1:3,4);
v = strctCrossSection.m_a2fM(1:3,3);
Dist = strctCrossSection.m_a2fM(1:3,3)' * pt3fPoint(1:3) + d;

pt3fNearestPointOnPlane = pt3fPoint(1:3) -Dist*v;
pt2fImageMM = inv(strctCrossSection.m_a2fM) * [pt3fNearestPointOnPlane;1];
pt2fImageMM = pt2fImageMM(1:2);
% Make sure it is on the plane (strctCrossSection.m_a2fM(1:3,3)' * pt3fNearestPointOnPlane+d)


