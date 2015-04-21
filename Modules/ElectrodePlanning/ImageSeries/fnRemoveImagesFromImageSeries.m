function RemoveImagesFromImageSeries
global g_strctModule

if isempty(g_strctModule.m_acAnatVol) || ~isfield(g_strctModule,'m_astrctImageSeries')
    return;
end;

iActiveSeries = get(g_strctModule.m_strctPanel.m_hImageSeriesList,'value');
if iActiveSeries == 0 || length(g_strctModule.m_astrctImageSeries) < iActiveSeries
    set(g_strctModule.m_strctPanel.m_hImageList,'String','','value',1);
    return;
end

aiSelected = get(g_strctModule.m_strctPanel.m_hImageList,'value');
if isempty(g_strctModule.m_astrctImageSeries(iActiveSeries).m_acImages)
    return;
end
g_strctModule.m_astrctImageSeries(iActiveSeries).m_acImages(aiSelected) = [];


set(g_strctModule.m_strctPanel.m_hImageList,'value',1);

fnInvalidateImageSeriesList();
fnInvalidate();
return
