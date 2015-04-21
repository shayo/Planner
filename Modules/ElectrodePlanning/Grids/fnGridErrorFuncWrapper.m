function fMinDist=fnGridErrorFuncWrapper(X, aiOptimize, strctGrid,apt3fTargetsPosMM, a2fM_WithMeshOffset)
strctGridParam = strctGrid.m_strctModel.m_strctGridParams;
% Apply the parameters...
iNumParamToOpt=length(aiOptimize);
for iParamIter=1:iNumParamToOpt
    strctGridParam.m_acParam{  aiOptimize(iParamIter)}.m_Value = X(iParamIter);
end;
strctModel = feval(strctGrid.m_strctGeneral.m_strBuildModel, strctGridParam);

[fMinDist, afMinDistToTarget, iBestHole]=fnGridErrorFunction(strctModel,apt3fTargetsPosMM, a2fM_WithMeshOffset);
