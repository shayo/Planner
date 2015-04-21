function fnInvalidateImagesInSeriesList()
global g_strctModule

if isempty(g_strctModule.m_acAnatVol) || ~isfield(g_strctModule,'m_astrctImageSeries')
    return;
end;

iActiveSeries = get(g_strctModule.m_strctPanel.m_hImageSeriesList,'value');
if iActiveSeries == 0 || length(g_strctModule.m_astrctImageSeries) < iActiveSeries
    set(g_strctModule.m_strctPanel.m_hImageList,'String','','value',1);
    return;
end

iNumImages = length(g_strctModule.m_astrctImageSeries(iActiveSeries).m_acImages);
if iNumImages == 0
        set(g_strctModule.m_strctPanel.m_hImageList,'String','','value',1);
        return;
end

acImageNames = cell(1,iNumImages);
for k=1:iNumImages
    acImageNames{k} = g_strctModule.m_astrctImageSeries(iActiveSeries).m_acImages{k}.m_strName;
end

set(g_strctModule.m_strctPanel.m_hImageList,'String',acImageNames,'value',1,'min',1,'max',iNumImages);

return
