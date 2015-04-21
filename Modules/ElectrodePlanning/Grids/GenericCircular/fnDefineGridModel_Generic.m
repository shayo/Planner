function strctGridParam = fnDefineGridModel_Generic()
% Generate a standard grid model (circular).

% Define the default 0 deg grid that has 7 holes along the major axis

strctGridParam.m_fMinimumDistanceBetweenHolesMM = 1;
strctGridParam.m_fGridHoleDiameterMM = 0.75;
strctGridParam.m_fGridInnerDiameterMM = 16.6;
strctGridParam.m_fGridHeightMM = 10;
strctGridParam.m_fGridHeightAboveMM = 9;
afCenter = -7:7;
[a2fXc, a2fYc] = meshgrid(afCenter, afCenter);
a2bFeasibleTop =  sqrt(a2fXc.^2 + a2fYc.^2) + strctGridParam.m_fGridHoleDiameterMM/2 < strctGridParam.m_fGridInnerDiameterMM/2;
iNumHoles = sum(a2bFeasibleTop(:));

strctGridParam.m_a2fGroupColor = [0;1;0];
strctGridParam.m_acGroupNames = {'All'};
strctGridParam.m_aiGroupAssignment = ones(1,iNumHoles);  % one is the default group!
strctGridParam.m_afGridHoleXpos_mm = a2fXc(a2bFeasibleTop)';
strctGridParam.m_afGridHoleYpos_mm =  a2fYc(a2bFeasibleTop)';
strctGridParam.m_afGridHoleRotationDeg = zeros(1,iNumHoles);
strctGridParam.m_afGridHoleTiltDeg = zeros(1,iNumHoles);

% Members that must be present in a grid model
strctGridParam.m_strGridType = 'Generic Circular';
strctGridParam.m_abSelectedHoles = [];

return;

