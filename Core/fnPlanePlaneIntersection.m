function [pt3iPointOnLine, afLineDir] = fnPlanePlaneIntersection(strctPlaneA, strctPlaneB)
% First step, find the plane-plane intersection (i.e., a line)
afLineDir = cross(strctPlaneA.m_a2fM(1:3,3),strctPlaneB.m_a2fM(1:3,3));
fPlaneAcoeff = strctPlaneA.m_a2fM(1:3,3)' * strctPlaneA.m_a2fM(1:3,4);
fPlaneBcoeff = strctPlaneB.m_a2fM(1:3,3)' * strctPlaneB.m_a2fM(1:3,4);

[fDummy,iIndex]=max(abs(afLineDir));
switch iIndex
    case 1 % X component of afLineDir is non zero
        % find particular solution with X = 0
        P = [strctPlaneA.m_a2fM([2,3],3)';
             strctPlaneB.m_a2fM([2,3],3)'] \ [fPlaneAcoeff;fPlaneBcoeff];
        pt3iPointOnLine = [0,P(1), P(2)];
        
    case 2 % Y component of afLineDir is non zero
        % find particular solution with Y = 0
        P = [strctPlaneA.m_a2fM([1,3],3)';
             strctPlaneB.m_a2fM([1,3],3)'] \ [fPlaneAcoeff;fPlaneBcoeff];
        pt3iPointOnLine = [P(1), 0, P(2)];
    case 3 % Z component of afLineDir is non zero
        % find particular solution with Z = 0
        P = [strctPlaneA.m_a2fM(1:2,3)';
             strctPlaneB.m_a2fM(1:2,3)'] \ [fPlaneAcoeff;fPlaneBcoeff];
        pt3iPointOnLine = [P(1), P(2),0];
end;
afLineDir = afLineDir' ./ norm(afLineDir);
return;
