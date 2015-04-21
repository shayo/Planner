
function fnRemoveTarget()
global g_strctModule
if g_strctModule.m_iCurrAnatVol == 0 || isempty(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctTargets) 
    return;
end;
strAnswer = questdlg({'Are you sure you want to remove target(s)?'},'Warning','Yes','No','No');
if strcmpi(strAnswer,'yes')
    aiCurrTargets = get(g_strctModule.m_strctPanel.m_hTargetList,'value');
    g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctTargets(aiCurrTargets) = [];
    iNumRemainingTargets = length(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctTargets);
    set(g_strctModule.m_strctPanel.m_hTargetList,'value',iNumRemainingTargets);
    fnUpdateTargetList();
    fnInvalidate(true);
 end;

return;
