
function fnRenameFunc()
global g_strctModule

if g_strctModule.m_iCurrFuncVol == 0
    return;
end;

answer=inputdlg({'New Functional Volume Name:'},'Change Volume Name',1,{g_strctModule.m_acFuncVol{g_strctModule.m_iCurrFuncVol}.m_strName});
if isempty(answer)
    return;
end;
g_strctModule.m_acFuncVol{g_strctModule.m_iCurrFuncVol}.m_strName = answer{1};
fnUpdateFunctionalsList();    
return;

