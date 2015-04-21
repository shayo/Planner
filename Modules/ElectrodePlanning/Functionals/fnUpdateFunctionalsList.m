
function fnUpdateFunctionalsList()
global g_strctModule
strList = '';
for iFuncIter=1:length(g_strctModule.m_acFuncVol)
    strList = [strList,'|',g_strctModule.m_acFuncVol{iFuncIter}.m_strName]; %#ok
end;
set(g_strctModule.m_strctPanel.m_hFuncList,'String',strList(2:end),'value',g_strctModule.m_iCurrFuncVol);
return;
