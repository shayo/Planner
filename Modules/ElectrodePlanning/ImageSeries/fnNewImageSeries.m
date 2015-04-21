function fnNewImageSeries()
global g_strctModule

if isempty(g_strctModule.m_acAnatVol)
    return;
end;


strctImageSeries = ImageSeriesInfoGUI();
if isempty(strctImageSeries)
    return;
end;

if strcmpi(strctImageSeries.m_strOrientation,'coronal')
    strctImageSeries.m_a2fImagePlaneTo3D = g_strctModule.m_strctCrossSectionXZ.m_a2fM;
elseif strcmpi(strctImageSeries.m_strOrientation,'horizontal')
    strctImageSeries.m_a2fImagePlaneTo3D = g_strctModule.m_strctCrossSectionXY.m_a2fM;    
else 
    strctImageSeries.m_a2fImagePlaneTo3D = g_strctModule.m_strctCrossSectionYZ.m_a2fM;
end

if isfield(g_strctModule,'m_astrctImageSeries')
    g_strctModule.m_astrctImageSeries(end+1) = strctImageSeries;
else
    g_strctModule.m_astrctImageSeries = strctImageSeries;
end

fnInvalidateImageSeriesList();
return
