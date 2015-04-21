
function fnRenameTarget()
global g_strctModule
if isempty(g_strctModule.m_iCurrAnatVol)
    return;
end;
iSelectedTarget = get(g_strctModule.m_strctPanel.m_hTargetList,'value');
if length(iSelectedTarget) > 1
    msgbox('This option is available for only one target');
    return;
end;

if iSelectedTarget > 0
    
    answer=inputdlg({'New Target Name'},'Change Target Name',1,{g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctTargets(iSelectedTarget).m_strName});
    
    if isempty(answer)
        return;
    end;
    g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctTargets(iSelectedTarget).m_strName = answer{1};
    fnUpdateTargetList()
end;

return;




