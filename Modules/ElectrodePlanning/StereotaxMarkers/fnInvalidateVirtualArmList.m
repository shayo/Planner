
function fnInvalidateVirtualArmList()
global g_strctModule
if ~isfield(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol},'m_acSavedVirtualArms')
    g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_acSavedVirtualArms = {};
end
 
iNumSavedArms = length(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_acSavedVirtualArms);
if iNumSavedArms == 0
    set(g_strctModule.m_strctPanel.m_hVirtualArmList,'string','','value',1);
    return;
end;
acSavedNames = cell(1,iNumSavedArms);
for iArmIter=1:iNumSavedArms
    acSavedNames{iArmIter}=g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_acSavedVirtualArms{iArmIter}.m_strName;
end
set(g_strctModule.m_strctPanel.m_hVirtualArmList,'string',acSavedNames,'value',iNumSavedArms);
return;

