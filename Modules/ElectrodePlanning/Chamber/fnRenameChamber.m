
function fnRenameChamber()
global g_strctModule
if g_strctModule.m_iCurrChamber==0
    return;
end

answer=inputdlg({'New Chamber Name:'},'Change Volume Name',1,...
    {g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber).m_strName});

if isempty(answer)
    return;
end;
g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber).m_strName = answer{1};
fnUpdateChamberList();
return;

