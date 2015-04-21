function fnScaleImageInImageSeries(hAxes, afDelta,bKeepAspect)
global g_strctModule
if isempty(g_strctModule.m_acAnatVol) || ~isfield(g_strctModule,'m_astrctImageSeries')
    return;
end;

iActiveSeries = get(g_strctModule.m_strctPanel.m_hImageSeriesList,'value');
if iActiveSeries == 0 || length(g_strctModule.m_astrctImageSeries) < iActiveSeries
    return;
end
if isempty(hAxes)
    return;
end;



 %Find the closest image
iNumImagesInSeries=length(g_strctModule.m_astrctImageSeries(iActiveSeries).m_acImages);
afDist=zeros(1,iNumImagesInSeries);
for k=1:iNumImagesInSeries
    pt3fTmp = g_strctModule.m_astrctImageSeries(iActiveSeries).m_a2fImagePlaneTo3D(1:3,4) + ...
    g_strctModule.m_astrctImageSeries(iActiveSeries).m_a2fImagePlaneTo3D(1:3,3)*g_strctModule.m_astrctImageSeries(iActiveSeries).m_acImages{k}.m_fZOffsetMM;
    afDist(k)=norm(pt3fTmp-g_strctModule.m_strctCrossSectionXZ.m_a2fM(1:3,4));
end
[fDummy,iIndex]=min(afDist);
aiSelectedImages= iIndex;

%aiSelectedImages = get(g_strctModule.m_strctPanel.m_hImageList,'value');

if (bKeepAspect)
    afDelta = ones(1,2) * norm(afDelta) * sign(afDelta(1));
end
fScale1 = 1+ 1/850* fnGetAxesScaleFactor(g_strctModule.m_strctLastMouseDown.m_hAxes) * -afDelta(1);
fScale2 =1-1/850* fnGetAxesScaleFactor(g_strctModule.m_strctLastMouseDown.m_hAxes) * -afDelta(2);
a2fScale = [fScale1, 0, 0;
        0, fScale2, 0;
        0,0,1];
switch hAxes
    case g_strctModule.m_strctPanel.m_strctXY.m_hAxes
        if strcmpi(g_strctModule.m_astrctImageSeries(iActiveSeries).m_strOrientation,'horizontal')
            for k=1:length(aiSelectedImages)
                pt2fPivot = g_strctModule.m_astrctImageSeries(iActiveSeries).m_acImages{aiSelectedImages(k)}.m_a2fSubSampling*[g_strctModule.m_astrctImageSeries(iActiveSeries).m_acImages{aiSelectedImages(k)}.m_a2fMMtoPix];
                a2fS = g_strctModule.m_astrctImageSeries(iActiveSeries).m_acImages{aiSelectedImages(k)}.m_a2fSubSampling;
                a2fT = [1 0 -pt2fPivot(1)-size(g_strctModule.m_astrctImageSeries(iActiveSeries).m_acImages{aiSelectedImages(k)}.m_Data,2)/2;
                    0 1 -pt2fPivot(2)-size(g_strctModule.m_astrctImageSeries(iActiveSeries).m_acImages{aiSelectedImages(k)}.m_Data,1)/2;
                    0 0 1 ];
                
                g_strctModule.m_astrctImageSeries(iActiveSeries).m_acImages{aiSelectedImages(k)}.m_a2fMMtoPix = inv(a2fS)*inv(a2fT) * a2fScale * a2fT * a2fS*  ...
                    g_strctModule.m_astrctImageSeries(iActiveSeries).m_acImages{aiSelectedImages(k)}.m_a2fMMtoPix;
            end
        end
    case g_strctModule.m_strctPanel.m_strctYZ.m_hAxes
        if strcmpi(g_strctModule.m_astrctImageSeries(iActiveSeries).m_strOrientation,'sagittal')
            for k=1:length(aiSelectedImages)
                pt2fPivot = g_strctModule.m_astrctImageSeries(iActiveSeries).m_acImages{aiSelectedImages(k)}.m_a2fSubSampling*[g_strctModule.m_astrctImageSeries(iActiveSeries).m_acImages{aiSelectedImages(k)}.m_a2fMMtoPix];
                a2fS = g_strctModule.m_astrctImageSeries(iActiveSeries).m_acImages{aiSelectedImages(k)}.m_a2fSubSampling;
                a2fT = [1 0 -pt2fPivot(1)-size(g_strctModule.m_astrctImageSeries(iActiveSeries).m_acImages{aiSelectedImages(k)}.m_Data,2)/2;
                    0 1 -pt2fPivot(2)-size(g_strctModule.m_astrctImageSeries(iActiveSeries).m_acImages{aiSelectedImages(k)}.m_Data,1)/2;
                    0 0 1 ];
                
                g_strctModule.m_astrctImageSeries(iActiveSeries).m_acImages{aiSelectedImages(k)}.m_a2fMMtoPix = inv(a2fS)*inv(a2fT) * a2fScale * a2fT * a2fS*  ...
                    g_strctModule.m_astrctImageSeries(iActiveSeries).m_acImages{aiSelectedImages(k)}.m_a2fMMtoPix;
            end
        end
    case g_strctModule.m_strctPanel.m_strctXZ.m_hAxes
        if strcmpi(g_strctModule.m_astrctImageSeries(iActiveSeries).m_strOrientation,'coronal')
            for k=1:length(aiSelectedImages)
                pt2fPivot = g_strctModule.m_astrctImageSeries(iActiveSeries).m_acImages{aiSelectedImages(k)}.m_a2fSubSampling*[g_strctModule.m_astrctImageSeries(iActiveSeries).m_acImages{aiSelectedImages(k)}.m_a2fMMtoPix];
                a2fS = g_strctModule.m_astrctImageSeries(iActiveSeries).m_acImages{aiSelectedImages(k)}.m_a2fSubSampling;
                a2fT = [1 0 -pt2fPivot(1)-size(g_strctModule.m_astrctImageSeries(iActiveSeries).m_acImages{aiSelectedImages(k)}.m_Data,2)/2;
                    0 1 -pt2fPivot(2)-size(g_strctModule.m_astrctImageSeries(iActiveSeries).m_acImages{aiSelectedImages(k)}.m_Data,1)/2;
                    0 0 1 ];
                
                g_strctModule.m_astrctImageSeries(iActiveSeries).m_acImages{aiSelectedImages(k)}.m_a2fMMtoPix = inv(a2fS)*inv(a2fT) * a2fScale * a2fT * a2fS*  ...
                    g_strctModule.m_astrctImageSeries(iActiveSeries).m_acImages{aiSelectedImages(k)}.m_a2fMMtoPix;

            end
        end
end
fnInvalidate();

return;