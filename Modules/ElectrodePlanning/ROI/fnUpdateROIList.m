function fnUpdateROIList()
global g_strctModule
if isempty(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctROIs)
    set(g_strctModule.m_strctPanel.m_hROIList,'String','','value',1);
else
    strName = '';
    iNumROIs = length(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctROIs);

    for k=1:iNumROIs
        strName = [strName,'|',g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctROIs(k).m_strName]; %#ok
    end;
    iValue = min(iNumROIs,get(g_strctModule.m_strctPanel.m_hROIList,'value'));
    if isempty(iValue)
        iValue = iNumROIs;
    end;
    if iNumROIs == 0
        iValue = 1;
    end;    
    set(g_strctModule.m_strctPanel.m_hROIList,'String',strName(2:end),'value',iValue,'min',1,'max',max(1,iNumROIs));
end;

return;
