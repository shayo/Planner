function fnUpdateMarkerContours()
global g_strctModule
if g_strctModule.m_iCurrAnatVol == 0 || ~isfield(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol},'m_astrctMarkers')
    return;
end;
if isfield(g_strctModule.m_strctPanel,'m_ahMarkers')
    delete(g_strctModule.m_strctPanel.m_ahMarkers);
    g_strctModule.m_strctPanel.m_ahMarkers = [];
end;
iNumMarkers = length(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers);
ahHandles = [];
ahAxes = [g_strctModule.m_strctPanel.m_strctXY.m_hAxes,...
    g_strctModule.m_strctPanel.m_strctYZ.m_hAxes,...
    g_strctModule.m_strctPanel.m_strctXZ.m_hAxes];
astrctCrossSection = [g_strctModule.m_strctCrossSectionXY,...
    g_strctModule.m_strctCrossSectionYZ,...
    g_strctModule.m_strctCrossSectionXZ];

iSelectedMarker = get(g_strctModule.m_strctPanel.m_hMarkersList,'value');

for iMarkerIter=1:iNumMarkers
    strctMarker = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers(iMarkerIter);
    
    astrctMesh = fnBuildMarkerMesh(strctMarker, iMarkerIter==iSelectedMarker);
    
    for iAxesIter=1:3
        for iMeshIter=1:length(astrctMesh)
            a2fLinesPix = fnMeshCrossSectionIntersection(astrctMesh(iMeshIter), astrctCrossSection(iAxesIter) );
            if ~isempty(a2fLinesPix)
                ahHandles(end+1) = fnPlotLinesAsSinglePatch(ahAxes(iAxesIter), a2fLinesPix, astrctMesh(iMeshIter).m_afColor); %#ok
                ahHandles(end+1) = text(mean(a2fLinesPix(:,1))+5,mean(a2fLinesPix(:,2))-5, strctMarker.m_strName,'parent',ahAxes(iAxesIter),'color','r');
            end;
        end;
        
    end;
end;



ahHandlesMarkers = zeros(1,iNumMarkers);
ahHandlesMarkersText = zeros(1,iNumMarkers);
a2fCRS_To_XYZ = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fReg*g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fM; 

for k=1:iNumMarkers
    
    pt3fMarkerPosMM = inv(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_strctCrossSectionHoriz.m_a2fM)* a2fCRS_To_XYZ*[g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers(k).m_pt3fPosition_vox(:);1];
    
    ahHandlesMarkers(k) = plot3(g_strctModule.m_strctPanel.m_strct3D.m_hAxes,...
        pt3fMarkerPosMM(1),...
        pt3fMarkerPosMM(2),...
        pt3fMarkerPosMM(3),'c.','Markersize',21);
    
    ahHandlesMarkersText(k) = text(...
        pt3fMarkerPosMM(1),...
        pt3fMarkerPosMM(2),...
        pt3fMarkerPosMM(3),...
        sprintf('#%d',k),'parent',g_strctModule.m_strctPanel.m_strct3D.m_hAxes,'color','r');
end;


g_strctModule.m_strctPanel.m_ahMarkers = [ahHandles,ahHandlesMarkers,ahHandlesMarkersText];
return;


