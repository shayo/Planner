function fnRotateImageInImageSeries(hAxes, afDelta)
global g_strctModule
if isempty(g_strctModule.m_acAnatVol) || ~isfield(g_strctModule,'m_astrctImageSeries') || isempty(hAxes)
    return;
end;

iActiveSeries = get(g_strctModule.m_strctPanel.m_hImageSeriesList,'value');
if iActiveSeries == 0 || length(g_strctModule.m_astrctImageSeries) < iActiveSeries
    return;
end

% aiSelectedImages = get(g_strctModule.m_strctPanel.m_hImageList,'value');

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

fScale = fnGetAxesScaleFactor(g_strctModule.m_strctLastMouseDown.m_hAxes);
fTheta = afDelta(1)/500*pi;
a2fRot = [cos(fTheta) sin(fTheta)  0;...
    -sin(fTheta) cos(fTheta) 0;...
    0              0         1];

switch hAxes
    case g_strctModule.m_strctPanel.m_strctXY.m_hAxes
        
        if strcmpi(g_strctModule.m_astrctImageSeries(iActiveSeries).m_strOrientation,'horizontal')
            for k=1:length(aiSelectedImages)
                
                a2fRot = [cos(fTheta) sin(fTheta)  0;...
                    -sin(fTheta) cos(fTheta) 0;...
                    0              0         1];
                afHalfSize = size(g_strctModule.m_astrctImageSeries(iActiveSeries).m_acImages{aiSelectedImages(k)}.m_Data);
                afCurrTrans = g_strctModule.m_astrctImageSeries(iActiveSeries).m_acImages{aiSelectedImages(k)}.m_a2fMMtoPix(1:2,3);
                
                a2fT = [1 0 -afCurrTrans(1)-afHalfSize(1);
                    0 1 -afCurrTrans(2)-afHalfSize(2);
                    0 0 1 ];
                
                g_strctModule.m_astrctImageSeries(iActiveSeries).m_acImages{aiSelectedImages(k)}.m_a2fMMtoPix = inv(a2fT) * a2fRot * a2fT *  ...
                    g_strctModule.m_astrctImageSeries(iActiveSeries).m_acImages{aiSelectedImages(k)}.m_a2fMMtoPix;
            end
        end
    case g_strctModule.m_strctPanel.m_strctYZ.m_hAxes
        
        if strcmpi(g_strctModule.m_astrctImageSeries(iActiveSeries).m_strOrientation,'sagittal')
            for k=1:length(aiSelectedImages)
                a2fRot = [cos(fTheta) sin(fTheta)  0;...
                    -sin(fTheta) cos(fTheta) 0;...
                    0              0         1];
                afHalfSize = size(g_strctModule.m_astrctImageSeries(iActiveSeries).m_acImages{aiSelectedImages(k)}.m_Data);
                afCurrTrans = g_strctModule.m_astrctImageSeries(iActiveSeries).m_acImages{aiSelectedImages(k)}.m_a2fMMtoPix(1:2,3);
                
                a2fT = [1 0 -afCurrTrans(1)-afHalfSize(1);
                    0 1 -afCurrTrans(2)-afHalfSize(2);
                    0 0 1 ];
                
                g_strctModule.m_astrctImageSeries(iActiveSeries).m_acImages{aiSelectedImages(k)}.m_a2fMMtoPix = inv(a2fT) * a2fRot * a2fT *  ...
                    g_strctModule.m_astrctImageSeries(iActiveSeries).m_acImages{aiSelectedImages(k)}.m_a2fMMtoPix;
            end
        end
    case g_strctModule.m_strctPanel.m_strctXZ.m_hAxes
        
        
        if strcmpi(g_strctModule.m_astrctImageSeries(iActiveSeries).m_strOrientation,'coronal')
            for k=1:length(aiSelectedImages)
                
                % Project the center point to 2D, and this is going to be our
                % pivot.
                pt2fPivot = g_strctModule.m_astrctImageSeries(iActiveSeries).m_acImages{aiSelectedImages(k)}.m_a2fSubSampling*[g_strctModule.m_astrctImageSeries(iActiveSeries).m_acImages{aiSelectedImages(k)}.m_a2fMMtoPix];
                a2fS = g_strctModule.m_astrctImageSeries(iActiveSeries).m_acImages{aiSelectedImages(k)}.m_a2fSubSampling;
                a2fT = [1 0 -pt2fPivot(1)-size(g_strctModule.m_astrctImageSeries(iActiveSeries).m_acImages{aiSelectedImages(k)}.m_Data,2)/2;
                    0 1 -pt2fPivot(2)-size(g_strctModule.m_astrctImageSeries(iActiveSeries).m_acImages{aiSelectedImages(k)}.m_Data,1)/2;
                    0 0 1 ];
                
                g_strctModule.m_astrctImageSeries(iActiveSeries).m_acImages{aiSelectedImages(k)}.m_a2fMMtoPix = inv(a2fS)*inv(a2fT) * a2fRot * a2fT * a2fS*  ...
                    g_strctModule.m_astrctImageSeries(iActiveSeries).m_acImages{aiSelectedImages(k)}.m_a2fMMtoPix;
            end
        end
end
fnInvalidate();

