function fnSetScaleBarLocation(strLocation)
global g_strctModule
g_strctModule.m_strctGUIOptions.m_strLocation = strLocation;
fnInvalidate(1);
