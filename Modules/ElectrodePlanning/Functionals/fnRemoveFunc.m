
function fnRemoveFunc()
global g_strctModule

if length(g_strctModule.m_acFuncVol) <= 1
    msgbox('You cannot remove this volume');
    return;
end;

strAnswer = questdlg('Are you sure you want to remove this volume?','Warning','Yes','No','No');
if strcmpi(strAnswer,'yes')
    g_strctModule.m_acFuncVol(g_strctModule.m_iCurrFuncVol) = [];
    g_strctModule.m_iCurrFuncVol = length(g_strctModule.m_acFuncVol);    
    fnUpdateFunctionalsList();
    fnInvalidate(true);
end;
return;


