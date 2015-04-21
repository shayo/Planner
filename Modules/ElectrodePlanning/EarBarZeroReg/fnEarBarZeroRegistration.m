function fnEarBarZeroRegistration()
global g_strctModule
set(g_strctModule.m_strctPanel.m_hRegisterFeatures,'value',0);
set(g_strctModule.m_strctPanel.m_hRegisterEB0,'value',1);

g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fRegToStereoTactic = 1/10*fnRotateVectorAboutAxis4D([1 0 0],pi)* inv(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_strctCrossSectionHoriz.m_a2fM);

fnInvalidateStereotactic();
return;