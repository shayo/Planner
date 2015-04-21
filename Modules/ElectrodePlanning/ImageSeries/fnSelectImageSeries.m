function fnSelectImageSeries()
global g_strctModule
if isempty(g_strctModule.m_acAnatVol) || ~isfield(g_strctModule,'m_astrctImageSeries')
    return;
end;

iActiveSeries = get(g_strctModule.m_strctPanel.m_hImageSeriesList,'value');
if iActiveSeries == 0 || length(g_strctModule.m_astrctImageSeries) < iActiveSeries
    return;
end
fnInvalidateImagesInSeriesList();
 %Find the closest image
iNumImagesInSeries=length(g_strctModule.m_astrctImageSeries(iActiveSeries).m_acImages);
afDist=zeros(1,iNumImagesInSeries);
for k=1:iNumImagesInSeries
    pt3fTmp = g_strctModule.m_astrctImageSeries(iActiveSeries).m_a2fImagePlaneTo3D(1:3,4) + ...
    g_strctModule.m_astrctImageSeries(iActiveSeries).m_a2fImagePlaneTo3D(1:3,3)*g_strctModule.m_astrctImageSeries(iActiveSeries).m_acImages{k}.m_fZOffsetMM;
    afDist(k)=norm(pt3fTmp-g_strctModule.m_strctCrossSectionXZ.m_a2fM(1:3,4));
end
[fDummy,iIndex]=min(afDist);

if strcmpi(g_strctModule.m_astrctImageSeries(iActiveSeries).m_strOrientation,'coronal')
    g_strctModule.m_strctCrossSectionXZ.m_a2fM = g_strctModule.m_astrctImageSeries(iActiveSeries).m_a2fImagePlaneTo3D;
    if ~isempty(g_strctModule.m_astrctImageSeries(iActiveSeries).m_acImages)
    g_strctModule.m_strctCrossSectionXZ.m_a2fM(1:3,4) = g_strctModule.m_strctCrossSectionXZ.m_a2fM(1:3,4) + g_strctModule.m_strctCrossSectionXZ.m_a2fM(1:3,3) * ...
        g_strctModule.m_astrctImageSeries(iActiveSeries).m_acImages{iIndex}.m_fZOffsetMM;
    end
elseif strcmpi(g_strctModule.m_astrctImageSeries(iActiveSeries).m_strOrientation,'horizontal')
    g_strctModule.m_strctCrossSectionXY.m_a2fM = g_strctModule.m_astrctImageSeries(iActiveSeries).m_a2fImagePlaneTo3D;    
else 
    g_strctModule.m_strctCrossSectionYZ.m_a2fM = g_strctModule.m_astrctImageSeries(iActiveSeries).m_a2fImagePlaneTo3D;    
end

g_strctModule.m_strctGUIOptions.m_bImageSeries = true;
fnInvalidate();
drawnow
return;