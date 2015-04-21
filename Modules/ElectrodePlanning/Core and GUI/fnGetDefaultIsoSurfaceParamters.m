function strctIsoSurfParam = fnGetDefaultIsoSurfaceParamters(a3fVol)
% We want to bring initial fast marching to be done on a 32x32x32 volume.
iTargetSize = 32;
strctIsoSurfParam.m_iSubSampleX = ceil(size(a3fVol,2)/ iTargetSize);
strctIsoSurfParam.m_iSubSampleY = ceil(size(a3fVol,1)/ iTargetSize);
strctIsoSurfParam.m_iSubSampleZ = ceil(size(a3fVol,3)/ iTargetSize);

strctIsoSurfParam.m_fLeftThreshold = 70;
strctIsoSurfParam.m_fRightThreshold = Inf;
strctIsoSurfParam.m_iLargeCCSize = 2;
strctIsoSurfParam.m_iOpenSize = 0;

return
