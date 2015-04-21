function ahHandles = fnDrawMesh(astrctMesh)
global g_strctModule

ahHandles =[];
ahAxes = [g_strctModule.m_strctPanel.m_strctXY.m_hAxes,...
    g_strctModule.m_strctPanel.m_strctXZ.m_hAxes,...
    g_strctModule.m_strctPanel.m_strctYZ.m_hAxes];

astrctCrossSection = [g_strctModule.m_strctCrossSectionXY,...
    g_strctModule.m_strctCrossSectionXZ,...
    g_strctModule.m_strctCrossSectionYZ];
for iAxesIter=1:3
    for iMeshIter=1:length(astrctMesh)
        strctMesh = astrctMesh(iMeshIter);
%        if sum(strctMesh.m_ahDoNotDrawAxes == ahAxes(iAxesIter)) == 0
            a2fLinesPix = fnMeshCrossSectionIntersection(strctMesh, astrctCrossSection(iAxesIter));
            if ~isempty(a2fLinesPix)
                ahHandles(end+1) = fnPlotLinesAsSinglePatch(ahAxes(iAxesIter), a2fLinesPix, strctMesh.m_afColor(:)'); %#ok
            end;
%        end;
    end;
end
return;