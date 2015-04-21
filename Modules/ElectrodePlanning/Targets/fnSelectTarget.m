
function fnSelectTarget()
global g_strctModule
iSelectedTarget = get(g_strctModule.m_strctPanel.m_hTargetList,'value');
if length(iSelectedTarget) > 1 || isempty(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctTargets)
    return;
end;
if ~isempty(iSelectedTarget) && iSelectedTarget > 0 && isfield(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol},'m_astrctTargets')

    a2fCRS_To_XYZ = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fReg*g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fM; 
    
    g_strctModule.m_strctCrossSectionXY = ...
        g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctTargets(iSelectedTarget).m_strctCrossSectionXY;

    g_strctModule.m_strctCrossSectionYZ = ...
        g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctTargets(iSelectedTarget).m_strctCrossSectionYZ;

    g_strctModule.m_strctCrossSectionXZ = ...
        g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctTargets(iSelectedTarget).m_strctCrossSectionXZ;
    
    
    
    pt3fPos = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctTargets(iSelectedTarget).m_pt3fPositionVoxel;
    pt3fPosMM = a2fCRS_To_XYZ*[pt3fPos;1];
    g_strctModule.m_strctCrossSectionXY.m_a2fM(1:3,4) = pt3fPosMM(1:3);
    g_strctModule.m_strctCrossSectionYZ.m_a2fM(1:3,4) = pt3fPosMM(1:3);
    g_strctModule.m_strctCrossSectionXZ.m_a2fM(1:3,4) = pt3fPosMM(1:3);
    fnUpdateTargetContours();
    fnInvalidate();
end;

return;

    
