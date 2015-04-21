function strctLinearHistogramStretch=fnBuildDefaultContrastTransform(a3fVol)
fMin = min(a3fVol(:));
fMax = max(a3fVol(:));

strctLinearHistogramStretch.m_strType = 'Linear';
strctLinearHistogramStretch.m_fMin = double(fMin);
strctLinearHistogramStretch.m_fMax = double(fMax);
strctLinearHistogramStretch.m_fRange = double(fMax-fMin);
strctLinearHistogramStretch.m_fCenter = double(fMin + (fMax-fMin)/2);
strctLinearHistogramStretch.m_fWidth  = double(fMax-fMin)/2;
return;