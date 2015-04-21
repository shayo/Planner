function fnRemoveGrid()
global g_strctModule
if g_strctModule.m_iCurrAnatVol == 0 || g_strctModule.m_iCurrChamber == 0 || ...
        isempty(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber).m_astrctGrids) 
    return;
end;

iSelectedGrid = get(g_strctModule.m_strctPanel.m_hGridList,'value');

g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber).m_astrctGrids(iSelectedGrid) = [];
iNumRemainingGrids = length(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber).m_astrctGrids);
g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber).m_iGridSelected = iNumRemainingGrids;
set(g_strctModule.m_strctPanel.m_hGridList,'value',max(1,iNumRemainingGrids));

%g_strctModule.m_iCurrGrid = iNumRemainingGrids;
fnUpdateGridList();
fnUpdateGridAxes();
fnInvalidate(1);
return;