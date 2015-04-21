function fnSetScaleBarLength(fLength)
global g_strctModule
g_strctModule.m_strctGUIOptions.m_fScaleBarLengthMM = fLength;
fnInvalidate(1);