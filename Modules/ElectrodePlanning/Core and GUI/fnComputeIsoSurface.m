function strctSurface = fnComputeIsoSurface(a3fVol, strctIsoSurfParam)
% a2fT maps voxel to mm  and should be equal to  strctAnatVol.m_a2fReg *strctAnatVol.m_a2fM 

fprintf('Smoothing volume, this can take some time...');
a3fConvSub = fnSubSample(a3fVol,strctIsoSurfParam);
fprintf('Done!\n');
strctSurface = fnComputeIsoSurfaceSub(a3fConvSub, strctIsoSurfParam, size(a3fVol));
return;