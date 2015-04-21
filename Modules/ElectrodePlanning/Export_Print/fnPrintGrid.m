
function fnPrintGrid()
global g_strctModule
if g_strctModule.m_iCurrChamber == 0
    return;
end;
hFig = figure; %#ok
clf;
hAxes = gca;

iSelectedGrid = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber).m_iGridSelected;
strctGrid = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber).m_astrctGrids(iSelectedGrid);

fnUpdateGridAxesAux(hAxes, strctGrid);
axis equal
title(sprintf('Grid: %s, (Angle = %.1f, Rotation = %.1f)',strctGrid.m_strGridName, strctGrid.m_fGridPhiDeg, strctGrid.m_fGridThetaDeg))
% savefig('CurrentGrid', hFig, 'pdf')

% , 'jpeg', '-cmyk', '-c0.1', '-r250');
 
return;