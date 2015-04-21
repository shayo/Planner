% Test the solid works mex interface
addpath('C:\Users\Shay\SkyDrive\Planner\Code\MEX\Win_x64');
afX = -1:1;
afY = -1:1;
[a2fX,a2fY]=meshgrid(afX,afY);


P = [a2fX(:)';a2fY(:)'];
N = size(P,2);
Tilt = zeros(1,N);
Rot = zeros(1,N);
Rad = ones(1,N) * 0.375;
strTemplate = 'C:\Users\Shay\SkyDrive\Planner\Code\Solidworks\Grid_Template.SLDPRT';
strOutputFile = 'C:\Users\Shay\SkyDrive\Planner\Code\Solidworks\RecordingChamberMod.SLDPRT';
	
iErr = fndllSolidWorksRecordingChamber2012(P, Tilt, Rot, Rad, strTemplate, strOutputFile);
%%
addpath('C:\Users\shayo\SkyDrive\Planner\Code\MEX\Win_x64');
load('C:\Users\shayo\SkyDrive\Planner\Code\SolidWorksDebug.mat');
iErr = fndllSolidWorksRecordingChamber(P, Tilt, Rot, Rad, strTemplate, strOutputFile);
