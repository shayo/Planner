function fnInvalidateImageSeriesList()
global g_strctModule

if isempty(g_strctModule.m_acAnatVol)
    return;
end;

if ~isfield(g_strctModule,'m_astrctImageSeries')
    set(g_strctModule.m_strctPanel.m_hImageSeriesList,'String','');
    return;
end

iNumSeries = length(g_strctModule.m_astrctImageSeries);
if iNumSeries == 0
    set(g_strctModule.m_strctPanel.m_hImageSeriesList,'String','','value',1);
    fnInvalidateImagesInSeriesList();
    return;
end

acSeriesNames = cell(1,iNumSeries);
for k=1:iNumSeries
    acSeriesNames{k} = g_strctModule.m_astrctImageSeries(k).m_strName;
end

set(g_strctModule.m_strctPanel.m_hImageSeriesList,'String',acSeriesNames,'value',iNumSeries);
fnInvalidateImagesInSeriesList();
return;

