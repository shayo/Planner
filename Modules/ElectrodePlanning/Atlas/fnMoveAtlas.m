function fnMoveAtlas(hAxes, afDelta)
global g_strctModule
if isempty(hAxes)
    return;
end;
fScale = 2*fnGetAxesScaleFactor(g_strctModule.m_strctLastMouseDown.m_hAxes);

switch hAxes
    case g_strctModule.m_strctPanel.m_strctXY.m_hAxes
        
        afDirX = g_strctModule.m_strctCrossSectionXY.m_a2fM(1:3,1);
        afDirY = g_strctModule.m_strctCrossSectionXY.m_a2fM(1:3,2);

        pt3fOldPositionMM = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fAtlasReg(:,4);
        pt3fNewPositionMM = pt3fOldPositionMM(1:3) +(1/fScale)*afDelta(1) * afDirX + (1/fScale)*afDelta(2) * afDirY;
        g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fAtlasReg(1:3,4) = pt3fNewPositionMM;
        
    case g_strctModule.m_strctPanel.m_strctYZ.m_hAxes
       
        afDirX = g_strctModule.m_strctCrossSectionYZ.m_a2fM(1:3,1);
        afDirY = g_strctModule.m_strctCrossSectionYZ.m_a2fM(1:3,2);
        
        pt3fOldPositionMM = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fAtlasReg(:,4);
        pt3fNewPositionMM = pt3fOldPositionMM(1:3) +(1/fScale)*afDelta(1) * afDirX + (1/fScale)*afDelta(2) * afDirY;
        g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fAtlasReg(1:3,4) = pt3fNewPositionMM;
        
    case g_strctModule.m_strctPanel.m_strctXZ.m_hAxes    
        afDirX = g_strctModule.m_strctCrossSectionXZ.m_a2fM(1:3,1);
        afDirY = g_strctModule.m_strctCrossSectionXZ.m_a2fM(1:3,2);
        
        pt3fOldPositionMM = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fAtlasReg(:,4);
        pt3fNewPositionMM = pt3fOldPositionMM(1:3) +(1/fScale)*afDelta(1) * afDirX + (1/fScale)*afDelta(2) * afDirY;
        g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fAtlasReg(1:3,4) = pt3fNewPositionMM;
end
fnInvalidate();

return;