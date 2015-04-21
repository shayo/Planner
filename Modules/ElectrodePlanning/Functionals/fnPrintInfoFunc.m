
function fnPrintInfoFunc()
global g_strctModule
if ~isempty(g_strctModule.m_acFuncVol) && g_strctModule.m_iCurrFuncVol >0
    h=msgbox(g_strctModule.m_acFuncVol{g_strctModule.m_iCurrFuncVol}.m_strFileName);
    waitfor(h);
end