
function  fnSelectGrid()
global g_strctModule
iSelectedGrid = get(g_strctModule.m_strctPanel.m_hGridList,'value');
if isempty(iSelectedGrid) || g_strctModule.m_iCurrChamber == 0
    return;
end;
g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber).m_iGridSelected = iSelectedGrid;
fnUpdateGridAxes(false);
fnUpdateChamberMIP();

fnInvalidate();
return;
