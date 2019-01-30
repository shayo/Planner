% Test the solid works mex interface

afX = -1:1;
afY = -1:1;
[a2fX,a2fY]=meshgrid(afX,afY);


P = [a2fX(:)';a2fY(:)'];
N = size(P,2);
Tilt = zeros(1,N);
Rot = zeros(1,N);
Rad = ones(1,N) * 0.375;
strTemplate = 'C:\Users\Liang\Desktop\Project1 scene graph\MRI_analysis\PlannerPB\Code\Solidworks\Grid_Template.SLDPRT';
strOutputFile = 'D:\RecordingChamber_test.SLDPRT';
bCloseSolidworksAfter = false;

iErr = fndllSolidWorksRecordingChamber2015(P, Tilt, Rot, Rad, strTemplate, strOutputFile, bCloseSolidworksAfter);

%%
% addpath('C:\Users\shayo\SkyDrive\Planner\Code\MEX\Win_x64');
% load('C:\Users\shayo\SkyDrive\Planner\Code\SolidWorksDebug.mat');
% iErr = fndllSolidWorksRecordingChamber(P, Tilt, Rot, Rad, strTemplate, strOutputFile);
