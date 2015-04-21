
function fnCopyTarget(a,b,iAnatVolTo) %#ok
global g_strctModule
aiCurrTarget = get(g_strctModule.m_strctPanel.m_hTargetList,'value');
astrctTarget = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctTargets(aiCurrTarget);
for k=1:length(aiCurrTarget)
    
    
    a2fCRS_To_XYZ = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fReg*g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fM;
    a2fM = a2fCRS_To_XYZ*[astrctTarget(k).m_pt3fPositionVoxel;1];
    a2fCRS_To_XYZ_To = g_strctModule.m_acAnatVol{iAnatVolTo}.m_a2fReg*g_strctModule.m_acAnatVol{iAnatVolTo}.m_a2fM;
    Tmp = inv(a2fCRS_To_XYZ_To) * a2fM; %#ok
    astrctTarget(k).m_pt3fPositionVoxel = Tmp(1:3);
    if ~isfield(g_strctModule.m_acAnatVol{iAnatVolTo},'m_astrctTargets') || isempty(g_strctModule.m_acAnatVol{iAnatVolTo}.m_astrctTargets)
        g_strctModule.m_acAnatVol{iAnatVolTo}.m_astrctTargets = astrctTarget(1);
    else
        g_strctModule.m_acAnatVol{iAnatVolTo}.m_astrctTargets(end+1) = astrctTarget(k);
    end;
end;
fnUpdateTargetList();
return;

