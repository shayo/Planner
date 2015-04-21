function strctSurface = fnComputeIsoSurfaceSub(a3fConvSub, strctIsoSurfParam,aiVolSize)

a3bVol= a3fConvSub > strctIsoSurfParam.m_fLeftThreshold & a3fConvSub <= strctIsoSurfParam.m_fRightThreshold;
if strctIsoSurfParam.m_iOpenSize > 0
    a3bEroded = bwdist(~a3bVol) > strctIsoSurfParam.m_iOpenSize;
    a3bOpened= bwdist(a3bEroded) < strctIsoSurfParam.m_iOpenSize+0.001;
else
    a3bOpened = a3bVol;
end
if strctIsoSurfParam.m_iLargeCCSize > 0
    a3iLabeled = fndllBWLabelnUint16(a3bOpened);
    aiHist = histc(a3iLabeled(:), 0:max(a3iLabeled(:)));
%     aiHist = fndllLabelsHist(a3iLabeled);
    a3bVol = fndllSelectLabels(a3iLabeled, uint16(find(aiHist(2:end) > strctIsoSurfParam.m_iLargeCCSize))) > 0;
else
    a3bVol = a3bOpened;
end

[a3iX,a3iY, a3iZ] = ...
    meshgrid([0:strctIsoSurfParam.m_iSubSampleX:aiVolSize(2)-1],...
    [0:strctIsoSurfParam.m_iSubSampleY:aiVolSize(1)-1],...
    [0:strctIsoSurfParam.m_iSubSampleZ:aiVolSize(3)-1]);

strctSurface = isosurface(a3iX,a3iY,a3iZ, a3bVol, 0.5);
