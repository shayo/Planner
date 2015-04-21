function fnScaleEntireImageSeries(hAxes, afDelta,bKeepAspect)
global g_strctModule
return;
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
if (bKeepAspect)
    afDelta = ones(1,2) * norm(afDelta) * sign(afDelta(1));
end
fScale1 = 1+ 1/150* fnGetAxesScaleFactor(g_strctModule.m_strctLastMouseDown.m_hAxes) * afDelta(1);
fScale2 =1+1/150* fnGetAxesScaleFactor(g_strctModule.m_strctLastMouseDown.m_hAxes) * afDelta(2);
    
switch hAxes %#ok
    case g_strctModule.m_strctPanel.m_strctXY.m_hAxes
          a2fScaleMatrix = [fScale1 0 0 0;
                          0       1 0 0;
                          0         0      fScale2 0;
                          0         0       0 1];
                          
      
                          
        g_strctModule.m_astrctImageSeries(iActiveSeries).m_a2fImagePlaneTo3D = a2fScaleMatrix * g_strctModule.m_astrctImageSeries(iActiveSeries).m_a2fImagePlaneTo3D;
        
    case g_strctModule.m_strctPanel.m_strctYZ.m_hAxes
       
        a2fScaleMatrix = [1 0 0 0;
                          0       fScale1 0 0;
                          0         0      fScale2 0;
                          0         0       0 1];
                          
        g_strctModule.m_astrctImageSeries(iActiveSeries).m_a2fImagePlaneTo3D = a2fScaleMatrix * g_strctModule.m_astrctImageSeries(iActiveSeries).m_a2fImagePlaneTo3D;
        
    case g_strctModule.m_strctPanel.m_strctXZ.m_hAxes    
         a2fScaleMatrix = [fScale1 0 0 0;
                          0       fScale2 0 0;
                          0         0      1 0;
                          0         0       0 1];
    
        g_strctModule.m_astrctImageSeries(iActiveSeries).m_a2fImagePlaneTo3D = a2fScaleMatrix * g_strctModule.m_astrctImageSeries(iActiveSeries).m_a2fImagePlaneTo3D;
end
  
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

   g_strctModule.m_strctGUIOptions.m_bImageSeries = false;
    fnInvalidate();
    drawnow
    g_strctModule.m_strctGUIOptions.m_bImageSeries = true;
    fnInvalidate();
    drawnow


return;