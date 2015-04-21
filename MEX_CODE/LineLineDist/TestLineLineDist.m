addpath('Y:\MEX');
addpath(genpath('Y:\'))
strctGridParam = fnDefineGridModel_Generic();

strctGridParam.m_afGridHoleTiltDeg(:) = 10;
strctGridParam.m_afGridHoleRotationDeg(1:20) = 20;
strctGridParam.m_aiGroupAssignment(1:20) = 2;
strctGridParam.m_a2fGroupColor(:,2) = [0;1;1];
strctGridModel = fnBuildGridModel_Generic(strctGridParam)

figure(11);
clf;
ahHolesHandles = fnDraw2DGridModel_Generic(strctGridModel, gca, []);
axis equal