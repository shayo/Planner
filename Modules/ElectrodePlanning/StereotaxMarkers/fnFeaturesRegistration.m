function fnFeaturesRegistration()
global g_strctModule
set(g_strctModule.m_strctPanel.m_hRegisterFeatures,'value',1);
set(g_strctModule.m_strctPanel.m_hRegisterEB0,'value',0);
bSolved = fnSolveRegistration();
if (bSolved)
    fnInvalidateStereotactic();
end
