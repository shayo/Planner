
function fnRefreshStereoModels()
global g_strctModule

%%
% Initialize stereotaxtic models
iNumModels = length(g_strctModule.m_strctConfig.m_acStereoModels.m_strctModel);
for iModelIter=1:iNumModels
    astrctStereoTaxticModels(iModelIter).m_strName = g_strctModule.m_strctConfig.m_acStereoModels.m_strctModel{iModelIter}.m_strctGeneral.m_strModelName; %#ok
    iNumArms = length(g_strctModule.m_strctConfig.m_acStereoModels.m_strctModel{iModelIter}.m_strctArm);
    for iArmIter=1:iNumArms
        if isstruct(g_strctModule.m_strctConfig.m_acStereoModels.m_strctModel{iModelIter}.m_strctArm)
            strctRobot = feval(g_strctModule.m_strctConfig.m_acStereoModels.m_strctModel{iModelIter}.m_strctArm.m_strModelFunction);
        else
            strctRobot = feval(g_strctModule.m_strctConfig.m_acStereoModels.m_strctModel{iModelIter}.m_strctArm{iArmIter}.m_strModelFunction);
        end
        astrctStereoTaxticModels(iModelIter).m_astrctArms(iArmIter).m_strctRobot = strctRobot; %#ok
    end
end
g_strctModule.m_astrctStereoTaxticModels = astrctStereoTaxticModels;
return;
