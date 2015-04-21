
function fnTargetKeepView()
global g_strctModule
if isempty(g_strctModule.m_acAnatVol) || isempty(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctTargets )
    return;
end;

aiCurrTarget = get(g_strctModule.m_strctPanel.m_hTargetList,'value');
if length(aiCurrTarget) > 1
    msgbox('This option is available only for one target');
    return;
end;
iCurrTarget = aiCurrTarget(1);

g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctTargets(iCurrTarget).m_strctCrossSectionXY = ...
    g_strctModule.m_strctCrossSectionXY;

g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctTargets(iCurrTarget).m_strctCrossSectionXZ = ...
    g_strctModule.m_strctCrossSectionXZ;

g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctTargets(iCurrTarget).m_strctCrossSectionYZ = ...
    g_strctModule.m_strctCrossSectionYZ;

return;