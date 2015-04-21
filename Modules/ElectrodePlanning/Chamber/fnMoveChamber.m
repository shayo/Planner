function fnMoveChamber(hAxes, afDelta)
global g_strctModule
if isempty(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers) || g_strctModule.m_iCurrChamber == 0 || isempty(hAxes)
    return;
end;
fScale = fnGetAxesScaleFactor(g_strctModule.m_strctLastMouseDown.m_hAxes);
a2fCRS_To_XYZ = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fReg*g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fM; 

switch hAxes
    case g_strctModule.m_strctPanel.m_strctXY.m_hAxes
        
        afDirX = g_strctModule.m_strctCrossSectionXY.m_a2fM(1:3,1);
        afDirY = g_strctModule.m_strctCrossSectionXY.m_a2fM(1:3,2);
         a2fM = a2fCRS_To_XYZ*g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber).m_a2fM_vox;
        a2fM(1:3,4) = a2fM(1:3,4) +  (1/fScale)*afDelta(1) * afDirX +(1/fScale)* afDelta(2) * afDirY;
        g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber).m_a2fM_vox = inv(a2fCRS_To_XYZ) * a2fM; %#ok
       
        
    case g_strctModule.m_strctPanel.m_strctYZ.m_hAxes
       
        afDirX = g_strctModule.m_strctCrossSectionYZ.m_a2fM(1:3,1);
        afDirY = g_strctModule.m_strctCrossSectionYZ.m_a2fM(1:3,2);
        a2fM = a2fCRS_To_XYZ*g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber).m_a2fM_vox;
        a2fM(1:3,4) = a2fM(1:3,4) +  (1/fScale)*afDelta(1) * afDirX +(1/fScale)* afDelta(2) * afDirY;
        g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber).m_a2fM_vox = inv(a2fCRS_To_XYZ) * a2fM;%#ok
            
    case g_strctModule.m_strctPanel.m_strctXZ.m_hAxes    
        afDirX = g_strctModule.m_strctCrossSectionXZ.m_a2fM(1:3,1);
        afDirY = g_strctModule.m_strctCrossSectionXZ.m_a2fM(1:3,2);
        a2fM = a2fCRS_To_XYZ*g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber).m_a2fM_vox;
        a2fM(1:3,4) = a2fM(1:3,4) +  (1/fScale)*afDelta(1) * afDirX +(1/fScale)* afDelta(2) * afDirY;
        g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber).m_a2fM_vox = inv(a2fCRS_To_XYZ) * a2fM; %#ok
       
end
fnUpdateChamberMIP();
fnInvalidate();

return;