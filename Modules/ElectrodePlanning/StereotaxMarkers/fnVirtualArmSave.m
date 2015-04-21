
function fnVirtualArmSave()
global g_strctModule
   
iNumSavedArms = length(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_acSavedVirtualArms);
g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_acSavedVirtualArms{iNumSavedArms+1} = g_strctModule.m_strctVirtualArm;

fnInvalidateVirtualArmList();
return;

