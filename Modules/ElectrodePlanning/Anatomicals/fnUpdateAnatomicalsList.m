function fnUpdateAnatomicalsList()
global g_strctModule
strList = '';
ahChildren = get(g_strctModule.m_strctPanel.m_AnatCopySubMenu,'children');
delete(ahChildren);
ahChildren = get(g_strctModule.m_strctPanel.m_TargetCopySubMenu,'children');
delete(ahChildren);

ahChildren = get(g_strctModule.m_strctPanel.m_hAnatOriCopySubMenu,'children');
delete(ahChildren);

 
for iAnatIter=1:length(g_strctModule.m_acAnatVol)
    strList = [strList,'|',g_strctModule.m_acAnatVol{iAnatIter}.m_strName]; %#ok
    uimenu(g_strctModule.m_strctPanel.m_AnatCopySubMenu,'Label',g_strctModule.m_acAnatVol{iAnatIter}.m_strName,'callback',{@fnCopyChamber,iAnatIter});
    uimenu(g_strctModule.m_strctPanel.m_TargetCopySubMenu,'Label',g_strctModule.m_acAnatVol{iAnatIter}.m_strName,'callback',{@fnCopyTarget,iAnatIter});
    uimenu(g_strctModule.m_strctPanel.m_hAnatOriCopySubMenu,'Label',g_strctModule.m_acAnatVol{iAnatIter}.m_strName,'callback',{@fnCopyOrientation,iAnatIter});
end; 

set(g_strctModule.m_strctPanel.m_hAnatList,'String',strList(2:end),'value',g_strctModule.m_iCurrAnatVol);
return;
