

function fnRotateGrid()
global g_strctModule
if ~isfield(g_strctModule.m_strctPanel.m_strctGrid,'m_hCurrGridHole') || isempty(g_strctModule.m_acAnatVol)
    return;
end;
iSelectedGrid = get(g_strctModule.m_strctPanel.m_hGridList,'value');
if isempty(iSelectedGrid)
    return;
end;
fRotationAngle = round(get(g_strctModule.m_strctPanel.m_strctGrid.m_hScroll,'value'));
g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber).m_astrctGrids(iSelectedGrid).m_fGridThetaDeg = fRotationAngle;

fnUpdateGridAxes();
fnUpdateChamberMIP();
fnInvalidate();

return;