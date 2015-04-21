
function fnChangeVirtualArmType()
global g_strctModule
% First, delete current controllers.
try
    delete([g_strctModule.m_strctPanel.m_ahLinkEdit,g_strctModule.m_strctPanel.m_ahLinkFixed,g_strctModule.m_strctPanel.m_ahLinkSlider]);
catch %#ok
end
iNewManipulatorIndex = get(g_strctModule.m_strctPanel.m_hVirtualArmType,'value');
iNewModelIndex = g_strctModule.m_strctPanel.m_aiModelIndex(iNewManipulatorIndex);
iNewArmIndex = g_strctModule.m_strctPanel.m_aiArmIndex(iNewManipulatorIndex);

% Reload from disk the model....
if ~iscell(g_strctModule.m_strctConfig.m_acStereoModels.m_strctModel{iNewModelIndex}.m_strctArm)
    g_strctModule.m_strctVirtualArm = feval(g_strctModule.m_strctConfig.m_acStereoModels.m_strctModel{iNewModelIndex}.m_strctArm.m_strModelFunction);
else
    g_strctModule.m_strctVirtualArm = feval(g_strctModule.m_strctConfig.m_acStereoModels.m_strctModel{iNewModelIndex}.m_strctArm{iNewArmIndex}.m_strModelFunction);
end
fnChangeVirtualArmTypeAux();%iNewModelIndex,iNewArmIndex,g_strctModule.m_strctVirtualArm);
fnInvalidate(1);
return;
