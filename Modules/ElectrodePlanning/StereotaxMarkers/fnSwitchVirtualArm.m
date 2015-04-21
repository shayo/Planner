
function fnSwitchVirtualArm()
global g_strctModule
iSelectedArm = get(g_strctModule.m_strctPanel.m_hVirtualArmList,'value');
iNumSavedArms = length(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_acSavedVirtualArms);
if iSelectedArm > iNumSavedArms 
    return;
end;
g_strctModule.m_strctVirtualArm = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_acSavedVirtualArms{iSelectedArm};
fnChangeVirtualArmTypeAux();
fnInvalidate(1);
return;


