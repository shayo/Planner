
function fnRenameAnat()
global g_strctModule

if g_strctModule.m_iCurrAnatVol == 0
    return;
end;

answer=inputdlg({'New Anatomical Volume Name:'},'Change Volume Name',1,{g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_strName});
if isempty(answer)
    return;
end;
g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_strName = answer{1};
fnUpdateAnatomicalsList();
return;


