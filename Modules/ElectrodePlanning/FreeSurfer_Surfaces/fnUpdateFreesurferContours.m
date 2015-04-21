function  fnUpdateFreesurferContours()
global g_strctModule

if isfield(g_strctModule,'m_ahFreeSurferHandles')
    delete(g_strctModule.m_ahFreeSurferHandles(ishandle(g_strctModule.m_ahFreeSurferHandles)));
end;


ahAxes = [g_strctModule.m_strctPanel.m_strctXY.m_hAxes,...
    g_strctModule.m_strctPanel.m_strctYZ.m_hAxes,...
    g_strctModule.m_strctPanel.m_strctXZ.m_hAxes];
astrctCrossSection = [g_strctModule.m_strctCrossSectionXY,...
    g_strctModule.m_strctCrossSectionYZ,...
    g_strctModule.m_strctCrossSectionXZ];

g_strctModule.m_ahFreeSurferHandles = [];
if ~isempty(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_acFreeSurferSurfaces) 
    iNumSurfaces = length(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_acFreeSurferSurfaces);
    for iSurfaceIter=1:iNumSurfaces
        if g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_acFreeSurferSurfaces{iSurfaceIter}.m_bVisible2D
            
            for iCrossSectionIter=1:3
                a2fLinesPix = fnMeshCrossSectionIntersection(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_acFreeSurferSurfaces{iSurfaceIter}, astrctCrossSection(iCrossSectionIter));
                if ~isempty(a2fLinesPix)
                g_strctModule.m_ahFreeSurferHandles = [g_strctModule.m_ahFreeSurferHandles,fnPlotLinesAsSinglePatch(ahAxes(iCrossSectionIter),...
                    a2fLinesPix, g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_acFreeSurferSurfaces{iSurfaceIter}.m_afColor)]; 
                end
            end
          end
    end
end

return;