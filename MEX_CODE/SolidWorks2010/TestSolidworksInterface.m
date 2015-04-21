% Test the solid works mex interface
addpath('Y:\MEX\Win_x64');
afX = -2:2;
afY = -2:2;
[a2fX,a2fY]=meshgrid(afX,afY);


P = [a2fX(:)';a2fY(:)'];
N = size(P,2);
Tilt = zeros(1,N);
Rot = zeros(1,N);
Rad = ones(1,N) * 0.375;
strTemplate = 'Y:\Solidworks\RecordingChamber_Template.SLDPRT';
strOutputFile = 'Y:\Solidworks\RecordingChamberMod.SLDPRT';
	
iErr = fndllSolidWorksRecordingChamber(P, Tilt, Rot, Rad, strTemplate, strOutputFile);

addpath('C:\Users\shayo\SkyDrive\Planner\Code\MEX\Win_x64');
load('C:\Users\shayo\SkyDrive\Planner\Code\SolidWorksDebug.mat');
iErr = fndllSolidWorksRecordingChamber(P, Tilt, Rot, Rad, strTemplate, strOutputFile);
