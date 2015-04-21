function fnAddTargetAux2(pt3fPosInVol,pt3fPosInStereoSpace)
global g_strctModule

strctTarget.m_pt3fPositionVoxel = pt3fPosInVol;
strctTarget.m_strName = sprintf('Unknown (AP %.2f ML %.2f DV %.2f)', pt3fPosInStereoSpace(1),pt3fPosInStereoSpace(2),pt3fPosInStereoSpace(3));
strctTarget.m_strctCrossSectionXY = g_strctModule.m_strctCrossSectionXY;
strctTarget.m_strctCrossSectionYZ = g_strctModule.m_strctCrossSectionYZ;
strctTarget.m_strctCrossSectionXZ = g_strctModule.m_strctCrossSectionXZ;

if ~isfield(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol},'m_astrctTargets') || ...
        isempty(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctTargets)
     g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctTargets = strctTarget;
else
    iNumTargets = length(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctTargets);    
    g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctTargets(iNumTargets+1) = strctTarget;
end;
fnUpdateTargetList();
return;


