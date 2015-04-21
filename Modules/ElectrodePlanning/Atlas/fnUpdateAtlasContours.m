function fnUpdateAtlasContours()
global g_strctModule
if g_strctModule.m_iCurrAnatVol == 0 || isempty(g_strctModule.m_acAnatVol)
    return;
end;
if isfield(g_strctModule.m_strctPanel,'m_ahAtlas')
    delete(g_strctModule.m_strctPanel.m_ahAtlas);
    g_strctModule.m_strctPanel.m_ahAtlas = [];
end;

%iActiveAtlas = get(
if ~isfield(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol},'m_a2fAtlasReg')
    g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fAtlasReg  = [...
        -1 0 0 0;
        0 -1 0 0;
        0 0 1 0;
        0 0 0 1];
end


ahAxes = [g_strctModule.m_strctPanel.m_strctXY.m_hAxes,...
    g_strctModule.m_strctPanel.m_strctYZ.m_hAxes,...
    g_strctModule.m_strctPanel.m_strctXZ.m_hAxes];
astrctCrossSection = [g_strctModule.m_strctCrossSectionXY,...
    g_strctModule.m_strctCrossSectionYZ,...
    g_strctModule.m_strctCrossSectionXZ];


aiVisibleRegions = find(cat(1,g_strctModule.m_strctAtlas.m_astrctMesh.visible));
ahHandles = [];

for iRegionIter=1:length(aiVisibleRegions)
    
    iRegion = aiVisibleRegions(iRegionIter);
    
    if ~isempty(g_strctModule.m_strctAtlas.m_astrctMesh(iRegion).vertices)
        % Apply the transformation
        P = [g_strctModule.m_strctAtlas.m_astrctMesh(iRegion).vertices'; ...
            ones(1,size(g_strctModule.m_strctAtlas.m_astrctMesh(iRegion).vertices,1))];
        Pt = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fAtlasReg * P;
        
        strctMeshRegion.m_a2fVertices = Pt(1:3,:);
        strctMeshRegion.m_a2iFaces = g_strctModule.m_strctAtlas.m_astrctMesh(iRegion).faces';
        strctMeshRegion.m_afColor = g_strctModule.m_strctAtlas.m_astrctMesh(iRegion).color;
        strctMeshRegion.m_fOpacity = 0.6;
        for iAxesIter=1:3
            a2fLinesPix = fnMeshCrossSectionIntersection(strctMeshRegion, astrctCrossSection(iAxesIter) );
            if ~isempty(a2fLinesPix)
                ahHandles(end+1) = fnPlotLinesAsSinglePatch(ahAxes(iAxesIter), a2fLinesPix, ...
                    g_strctModule.m_strctAtlas.m_astrctMesh(iRegion).color); %#ok
            end;
        end;
    end
  %    ahHandles = [ahHandles,fnDrawMeshIn3D( strctMeshRegion ,g_strctModule.m_strctPanel.m_strct3D.m_hAxes)];

end


g_strctModule.m_strctPanel.m_ahAtlas = ahHandles;
return;