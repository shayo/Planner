function fnMoveChamberAxis(hAxes,afDelta)
global g_strctModule
if isempty(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers) || g_strctModule.m_iCurrChamber == 0 || isempty(hAxes)
    return;
end;
fScale = fnGetAxesScaleFactor(g_strctModule.m_strctLastMouseDown.m_hAxes);
a2fCRS_To_XYZ = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fReg*g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fM; 
a2fM = a2fCRS_To_XYZ*g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber).m_a2fM_vox;
[fMax,iDummy] = max(abs(afDelta)); %#ok
a2fM(1:3,4) = a2fM(1:3,4) + (1/fScale)* -afDelta(iDummy) * a2fM(1:3,3);
g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber).m_a2fM_vox = inv(a2fCRS_To_XYZ) * a2fM;%#ok
fnInvalidate();


return;