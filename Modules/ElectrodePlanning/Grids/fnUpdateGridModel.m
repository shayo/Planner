
function fnUpdateGridModel(strctGridModel)
global g_strctModule
if isempty(g_strctModule) || isempty(g_strctModule.m_acAnatVol)
    return;
end;
iSelectedGrid = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber).m_iGridSelected;
g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber).m_astrctGrids(iSelectedGrid).m_strctModel = strctGridModel;
fnInvalidate();

return;