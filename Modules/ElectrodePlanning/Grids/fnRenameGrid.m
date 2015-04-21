
function fnRenameGrid()
global g_strctModule
if g_strctModule.m_iCurrAnatVol == 0 || g_strctModule.m_iCurrChamber == 0 || ...
        isempty(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber).m_astrctGrids) 
    return;
end;

iSelectedGrid = get(g_strctModule.m_strctPanel.m_hGridList,'value');
strOldName = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber).m_astrctGrids(iSelectedGrid).m_strName;
answer=inputdlg({'New Chamber Name:'},'Change Volume Name',1,{strOldName});
if isempty(answer)
    return;
end;
g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber).m_astrctGrids(iSelectedGrid).m_strName = answer{1};
fnUpdateGridList();
return;

