function fnMoveImageInImageSeries(hAxes, afDelta)
global g_strctModule
if isempty(g_strctModule.m_acAnatVol) || ~isfield(g_strctModule,'m_astrctImageSeries')
    return;
end;

iActiveSeries = get(g_strctModule.m_strctPanel.m_hImageSeriesList,'value');
if iActiveSeries == 0 || length(g_strctModule.m_astrctImageSeries) < iActiveSeries
    return;
end
afDelta=afDelta*0.5;
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

% We need to project the directions of the cross section view onto the 
% plane of the image.....


fScale = fnGetAxesScaleFactor(g_strctModule.m_strctLastMouseDown.m_hAxes)*0.2;

switch hAxes
    case g_strctModule.m_strctPanel.m_strctXY.m_hAxes
        afDirX = g_strctModule.m_strctCrossSectionXY.m_a2fM(1:3,1);
        afDirY = g_strctModule.m_strctCrossSectionXY.m_a2fM(1:3,2);
        afMoveVector3D = (fScale)*afDelta(1) * afDirX +(fScale)* afDelta(2) * afDirY;
        
        fX = -sum(g_strctModule.m_astrctImageSeries(iActiveSeries).m_a2fImagePlaneTo3D(1:3,1).*afMoveVector3D);
        fY = -sum(g_strctModule.m_astrctImageSeries(iActiveSeries).m_a2fImagePlaneTo3D(1:3,2).*afMoveVector3D);
        
        if strcmpi(g_strctModule.m_astrctImageSeries(iActiveSeries).m_strOrientation,'horizontal')
            for k=1:length(aiSelectedImages)
                g_strctModule.m_astrctImageSeries(iActiveSeries).m_acImages{aiSelectedImages(k)}.m_a2fMMtoPix(1,3) = ...
                    g_strctModule.m_astrctImageSeries(iActiveSeries).m_acImages{aiSelectedImages(k)}.m_a2fMMtoPix(1,3) +  fX;
                g_strctModule.m_astrctImageSeries(iActiveSeries).m_acImages{aiSelectedImages(k)}.m_a2fMMtoPix(2,3) = ...
                    g_strctModule.m_astrctImageSeries(iActiveSeries).m_acImages{aiSelectedImages(k)}.m_a2fMMtoPix(2,3) +  fY;
            end
        end
    case g_strctModule.m_strctPanel.m_strctYZ.m_hAxes
        afDirX = g_strctModule.m_strctCrossSectionYZ.m_a2fM(1:3,1);
        afDirY = g_strctModule.m_strctCrossSectionYZ.m_a2fM(1:3,2);
        afMoveVector3D = (fScale)*afDelta(1) * afDirX +(fScale)* afDelta(2) * afDirY;
        
        fX = -sum(g_strctModule.m_astrctImageSeries(iActiveSeries).m_a2fImagePlaneTo3D(1:3,1).*afMoveVector3D);
        fY = -sum(g_strctModule.m_astrctImageSeries(iActiveSeries).m_a2fImagePlaneTo3D(1:3,2).*afMoveVector3D);
        
        if strcmpi(g_strctModule.m_astrctImageSeries(iActiveSeries).m_strOrientation,'sagittal')
            for k=1:length(aiSelectedImages)
                g_strctModule.m_astrctImageSeries(iActiveSeries).m_acImages{aiSelectedImages(k)}.m_a2fMMtoPix(1,3) = ...
                    g_strctModule.m_astrctImageSeries(iActiveSeries).m_acImages{aiSelectedImages(k)}.m_a2fMMtoPix(1,3)  +fX;
                g_strctModule.m_astrctImageSeries(iActiveSeries).m_acImages{aiSelectedImages(k)}.m_a2fMMtoPix(2,3) = ...
                    g_strctModule.m_astrctImageSeries(iActiveSeries).m_acImages{aiSelectedImages(k)}.m_a2fMMtoPix(2,3)  + fY;
            end
        end            
    case g_strctModule.m_strctPanel.m_strctXZ.m_hAxes    
        
        afDirX = g_strctModule.m_strctCrossSectionXZ.m_a2fM(1:3,1);
        afDirY = g_strctModule.m_strctCrossSectionXZ.m_a2fM(1:3,2);
        afMoveVector3D = (fScale)*afDelta(1) * afDirX +(fScale)* afDelta(2) * afDirY;
        
        fX = -sum(g_strctModule.m_astrctImageSeries(iActiveSeries).m_a2fImagePlaneTo3D(1:3,1).*afMoveVector3D);
        fY = -sum(g_strctModule.m_astrctImageSeries(iActiveSeries).m_a2fImagePlaneTo3D(1:3,2).*afMoveVector3D);
        
        if strcmpi(g_strctModule.m_astrctImageSeries(iActiveSeries).m_strOrientation,'coronal')
            for k=1:length(aiSelectedImages)
                g_strctModule.m_astrctImageSeries(iActiveSeries).m_acImages{aiSelectedImages(k)}.m_a2fMMtoPix(1,3) = ...
                    g_strctModule.m_astrctImageSeries(iActiveSeries).m_acImages{aiSelectedImages(k)}.m_a2fMMtoPix(1,3) +fX;
                g_strctModule.m_astrctImageSeries(iActiveSeries).m_acImages{aiSelectedImages(k)}.m_a2fMMtoPix(2,3) = ...
                    g_strctModule.m_astrctImageSeries(iActiveSeries).m_acImages{aiSelectedImages(k)}.m_a2fMMtoPix(2,3) +fY;
            end
        end
end
fnInvalidate();

