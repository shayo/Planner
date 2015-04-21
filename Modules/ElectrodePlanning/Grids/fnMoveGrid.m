
function fnMoveGrid(afDelta)
global g_strctModule
if isempty(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers) || g_strctModule.m_iCurrChamber == 0 
    return;
end;
iSelectedGrid = get(g_strctModule.m_strctPanel.m_hGridList,'value');
if isempty(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber).m_astrctGrids)
    return;
end;
if isempty(g_strctModule.m_strctLastMouseDown.m_hAxes)
    return;
end;
fScale = fnGetAxesScaleFactor(g_strctModule.m_strctLastMouseDown.m_hAxes);
g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber).m_astrctGrids(iSelectedGrid).m_fChamberDepthOffset = ...
g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber).m_astrctGrids(iSelectedGrid).m_fChamberDepthOffset + afDelta(2)/fScale; 

% set(g_strctModule.m_strctPanel.m_hStatusLine,'string',sprintf('Grid offset : %.2f mm',...
%     g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber).m_astrctGrids(iSelectedGrid).m_fChamberDepthOffset));

fnInvalidate();

return;