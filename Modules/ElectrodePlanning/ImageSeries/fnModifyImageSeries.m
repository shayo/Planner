function fnModifyImageSeries()
global g_strctModule

if isempty(g_strctModule.m_acAnatVol) || ~isfield(g_strctModule,'m_astrctImageSeries')
    return;
end;

iCurrentImageSeries = get(g_strctModule.m_strctPanel.m_hImageSeriesList,'value');
if isempty(g_strctModule.m_astrctImageSeries)
    return;
end
strctImageSeries = ImageSeriesInfoGUI(g_strctModule.m_astrctImageSeries(iCurrentImageSeries));

if ~isempty(strctImageSeries)
    g_strctModule.m_astrctImageSeries(iCurrentImageSeries) = strctImageSeries;
end

return;
