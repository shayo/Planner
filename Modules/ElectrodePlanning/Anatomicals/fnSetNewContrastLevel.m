function fnSetNewContrastLevel(afDelta)
global g_strctModule

strctLinearHistogramStretch = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_strctContrastTransform;

fMaxWidth = strctLinearHistogramStretch.m_fMax/2;%max(1,2*strctLinearHistogramStretch.m_fWidth);
strctLinearHistogramStretch.m_fWidth = min(fMaxWidth,max(0,...
    strctLinearHistogramStretch.m_fWidth + afDelta(2)*fMaxWidth/400));
strctLinearHistogramStretch.m_fCenter = min(strctLinearHistogramStretch.m_fMax,...
    max(strctLinearHistogramStretch.m_fMin,...
    strctLinearHistogramStretch.m_fCenter + afDelta(1)*fMaxWidth/400));


g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_strctContrastTransform = strctLinearHistogramStretch;
fnInvalidate(false);
return;