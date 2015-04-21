mex eig3volume.c
mex imgaussian.c

M=mriread('D:\Data\Doris\Planner\Houdini\100622Houdini.mgz');
% Frangi Filter the stent volume
GrayScaleValue = 600;
options.BlackWhite=false;
options.FrangiScaleRatio = 2;
options.FrangiScaleRange=[0.7 0.7];
options.FrangiC = GrayScaleValue/4;
options.FrangiAlpha = 1;
Vfiltered=1e4*FrangiFilter3D(M.vol,options); % Single scale Frangi Filter

iCCSize = 100;
fVesselnessThreshold = 10;
a3bBinary = Vfiltered>fVesselnessThreshold;
L=bwlabeln(a3bBinary);
aiHist=histc(L(:),0:max(L(:)));
aiLargeCCs=  find(aiHist(2:end)>iCCSize);
T=fndllSelectLabels(uint16(L),uint16(aiLargeCCs))>0;
strctSurface=isosurface(T,0.5);
figure;
hMainVolSurface = patch(strctSurface);
set(hMainVolSurface,'FaceColor','r','EdgeColor','none','facealpha',0.6);
camlight('left')
lighting('gouraud');
