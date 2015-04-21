
function fnUpdateTargetList()
global g_strctModule
if ~isfield(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol},'m_astrctTargets')
    set(g_strctModule.m_strctPanel.m_hTargetList,'String','');
else
    strName = '';
    iNumTargets = length(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctTargets);

    for k=1:iNumTargets
        strName = [strName,'|',g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctTargets(k).m_strName]; %#ok
    end;
    iValue = min(iNumTargets,get(g_strctModule.m_strctPanel.m_hTargetList,'value'));
    if isempty(iValue)
        iValue = iNumTargets;
    end;
    if iNumTargets == 0
        iValue = 1;
    end;    
    set(g_strctModule.m_strctPanel.m_hTargetList,'String',strName(2:end),'value',iValue,'min',1,'max',max(1,iNumTargets));
end;

return;