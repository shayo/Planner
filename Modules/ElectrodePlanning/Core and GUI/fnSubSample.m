function a3fConvSub = fnSubSample(a3fVol,strctIsoSurfParam)
% Wrong for non-isotropic volumes, but who cares...
afKernelX = ones(1,strctIsoSurfParam.m_iSubSampleX) / strctIsoSurfParam.m_iSubSampleX;
afKernelY = ones(strctIsoSurfParam.m_iSubSampleY,1) / strctIsoSurfParam.m_iSubSampleY;
afKernelZ = ones(1,1,strctIsoSurfParam.m_iSubSampleZ) / strctIsoSurfParam.m_iSubSampleZ;
% Smoothing always helps
a3fConvVol = convn(convn(convn(a3fVol,afKernelX,'same'),afKernelY,'same'),afKernelZ,'same');
% Subsample
a3fConvSub = a3fConvVol(1:strctIsoSurfParam.m_iSubSampleY:end,1:strctIsoSurfParam.m_iSubSampleX:end,1:strctIsoSurfParam.m_iSubSampleZ:end);
return;
