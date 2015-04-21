function  fnAddGrid(iModel,iSubModel)
global g_strctModule

if isempty(g_strctModule.m_iCurrAnatVol) || isempty(g_strctModule.m_acAnatVol) || isempty(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers)
    return;
end;

fnAddGridFromStruct(g_strctModule.m_astrctGrids(iModel),iSubModel);
fnUpdateChamberMIP();
fnInvalidate(1);

return;