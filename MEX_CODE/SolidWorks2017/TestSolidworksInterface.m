% Test the solid works mex interface
addpath('C:\Users\Shay\SkyDrive\Planner\Code\MEX\Win_x64');
afX = -5:5;
afY = -5:5;
[a2fX,a2fY]=meshgrid(afX,afY);


P = [a2fX(:)';a2fY(:)'];
N = size(P,2);
Tilt = zeros(1,N);
Rot = zeros(1,N);
Rad = ones(1,N) * 0.375;
strTemplate = 'C:\Users\shayo\Dropbox (MIT)\Code\Github\Planner\Solidworks\Grid_Template.SLDPRT';
strOutputFile = 'C:\Users\shayo\Dropbox (MIT)\Code\Github\Planner\Solidworks\RecordingChamberMod.SLDPRT';
	
iErr = fndllSolidWorksRecordingChamber2016(P, Tilt, Rot, Rad, strTemplate, strOutputFile,false);
%%
addpath('C:\Users\shayo\SkyDrive\Planner\Code\MEX\Win_x64');
load('C:\Users\shayo\SkyDrive\Planner\Code\SolidWorksDebug.mat');
iErr = fndllSolidWorksRecordingChamber(P, Tilt, Rot, Rad, strTemplate, strOutputFile);
