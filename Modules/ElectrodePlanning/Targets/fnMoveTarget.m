function fnMoveTarget(hAxes, afDelta)
global g_strctModule
if isempty(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctTargets ) || isempty(hAxes)
    return;
end;
iCurrTarget = get(g_strctModule.m_strctPanel.m_hTargetList,'value');
g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctTargets(iCurrTarget).m_strctCrossSectionXY = ...
    g_strctModule.m_strctCrossSectionXY;

g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctTargets(iCurrTarget).m_strctCrossSectionYZ = ...
    g_strctModule.m_strctCrossSectionYZ;

g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctTargets(iCurrTarget).m_strctCrossSectionXZ = ...
    g_strctModule.m_strctCrossSectionXZ;


fScale = 2*fnGetAxesScaleFactor(g_strctModule.m_strctLastMouseDown.m_hAxes);
a2fCRS_To_XYZ = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fReg*g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fM;

switch hAxes
    case g_strctModule.m_strctPanel.m_strctXY.m_hAxes
        
        afDirX = g_strctModule.m_strctCrossSectionXY.m_a2fM(1:3,1);
        afDirY = g_strctModule.m_strctCrossSectionXY.m_a2fM(1:3,2);

        pt3fOldPositionMM = a2fCRS_To_XYZ*[g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctTargets(iCurrTarget).m_pt3fPositionVoxel;1];
        pt3fNewPositionMM = pt3fOldPositionMM(1:3) +(1/fScale)*afDelta(1) * afDirX + (1/fScale)*afDelta(2) * afDirY;
        pt3fNewPositionVox = inv(a2fCRS_To_XYZ) * [pt3fNewPositionMM;1]; %#ok
        g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctTargets(iCurrTarget).m_pt3fPositionVoxel = pt3fNewPositionVox(1:3);
        
    case g_strctModule.m_strctPanel.m_strctYZ.m_hAxes
       
        afDirX = g_strctModule.m_strctCrossSectionYZ.m_a2fM(1:3,1);
        afDirY = g_strctModule.m_strctCrossSectionYZ.m_a2fM(1:3,2);
        
        pt3fOldPositionMM = a2fCRS_To_XYZ*[g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctTargets(iCurrTarget).m_pt3fPositionVoxel;1];
        pt3fNewPositionMM = pt3fOldPositionMM(1:3) +(1/fScale)*afDelta(1) * afDirX + (1/fScale)*afDelta(2) * afDirY;
        pt3fNewPositionVox = inv(a2fCRS_To_XYZ) * [pt3fNewPositionMM;1]; %#ok
        g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctTargets(iCurrTarget).m_pt3fPositionVoxel = pt3fNewPositionVox(1:3);
        
    case g_strctModule.m_strctPanel.m_strctXZ.m_hAxes    
        afDirX = g_strctModule.m_strctCrossSectionXZ.m_a2fM(1:3,1);
        afDirY = g_strctModule.m_strctCrossSectionXZ.m_a2fM(1:3,2);
        
        pt3fOldPositionMM = a2fCRS_To_XYZ*[g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctTargets(iCurrTarget).m_pt3fPositionVoxel;1];
        pt3fNewPositionMM = pt3fOldPositionMM(1:3) +(1/fScale)*afDelta(1) * afDirX + (1/fScale)*afDelta(2) * afDirY;
        pt3fNewPositionVox = inv(a2fCRS_To_XYZ) * [pt3fNewPositionMM;1];%#ok
        g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctTargets(iCurrTarget).m_pt3fPositionVoxel = pt3fNewPositionVox(1:3);
       
end
fnInvalidate();

return;