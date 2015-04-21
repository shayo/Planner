function fnRotateEntireImageSeries(hAxes, afDelta)
global g_strctModule
%return;
if isempty(g_strctModule.m_acAnatVol) || ~isfield(g_strctModule,'m_astrctImageSeries')
    return;
end;

iActiveSeries = get(g_strctModule.m_strctPanel.m_hImageSeriesList,'value');
if iActiveSeries == 0 || length(g_strctModule.m_astrctImageSeries) < iActiveSeries
    return;
end

strctCrossSection=fnAxesHandleToStrctCrossSection(hAxes);
 
if ~isempty(strctCrossSection)
        pt3fCurrPos = g_strctModule.m_astrctImageSeries(iActiveSeries).m_a2fImagePlaneTo3D(1:3,4);
        a2fT = [1 0 0 -pt3fCurrPos(1); 
                0 1 0 -pt3fCurrPos(2);
                0 0 1 -pt3fCurrPos(3);
                0 0 0 1];
        a2fR = fnRotateVectorAboutAxis(strctCrossSection.m_a2fM(1:3,3),afDelta(1)/500*pi);
        a2fRot = zeros(4,4);
        a2fRot(1:3,1:3) = a2fR;
        a2fRot(4,4) = 1;
        g_strctModule.m_astrctImageSeries(iActiveSeries).m_a2fImagePlaneTo3D = ...
        inv(a2fT) * a2fRot * a2fT * g_strctModule.m_astrctImageSeries(iActiveSeries).m_a2fImagePlaneTo3D;
end
% Now,  if the cross-section that is being used to rotate the images is not
% the same one as the image series (i.e., rotate in sagittal view when
% image series is coronal), update the coronal cross section view plane
% This will keep the image series in view.

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
    g_strctModule.m_strctCrossSectionXZ.m_a2fM(1:3,4) = g_strctModule.m_strctCrossSectionXZ.m_a2fM(1:3,4) + g_strctModule.m_strctCrossSectionXZ.m_a2fM(1:3,3) * ...
        g_strctModule.m_astrctImageSeries(iActiveSeries).m_acImages{iIndex}.m_fZOffsetMM;
elseif strcmpi(g_strctModule.m_astrctImageSeries(iActiveSeries).m_strOrientation,'horizontal')
    g_strctModule.m_strctCrossSectionXY.m_a2fM = g_strctModule.m_astrctImageSeries(iActiveSeries).m_a2fImagePlaneTo3D;    
else 
    g_strctModule.m_strctCrossSectionYZ.m_a2fM = g_strctModule.m_astrctImageSeries(iActiveSeries).m_a2fImagePlaneTo3D;    
end

%    g_strctModule.m_strctGUIOptions.m_bImageSeries = false;
%     fnInvalidate();
%     drawnow
%     g_strctModule.m_strctGUIOptions.m_bImageSeries = true;
%     fnInvalidate();
%     drawnow
fnInvalidate();
return;