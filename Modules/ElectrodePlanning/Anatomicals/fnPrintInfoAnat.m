
function fnPrintInfoAnat()
global g_strctModule
if ~isempty(g_strctModule.m_acAnatVol) && g_strctModule.m_iCurrAnatVol >0
    h=msgbox(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_strFileName);
    waitfor(h);
end