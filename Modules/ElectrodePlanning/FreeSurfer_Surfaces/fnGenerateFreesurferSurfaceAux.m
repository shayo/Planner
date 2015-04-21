function fnGenerateFreesurferSurfaceAux(iSurfaceIndex)
global g_strctModule
iNumVertices = size(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_acFreeSurferSurfaces{iSurfaceIndex}.m_a2fVertices,2);

VerticesXYZ =inv(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_strctCrossSectionHoriz.m_a2fM) * g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fReg*[g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_acFreeSurferSurfaces{iSurfaceIndex}.m_a2fVertices;ones(1,iNumVertices)];

strctIsoXYZ.vertices =VerticesXYZ(1:3,:)';
strctIsoXYZ.faces = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_acFreeSurferSurfaces{iSurfaceIndex}.m_a2iFaces';

strctIsoXYZ_small = reducepatch(strctIsoXYZ,0.2) ;

g_strctModule.m_ahFreeSurfer3DHandles(iSurfaceIndex) = patch(strctIsoXYZ_small, ...
    'parent',g_strctModule.m_strctPanel.m_strct3D.m_hAxes,'visible','on');
set(g_strctModule.m_ahFreeSurfer3DHandles(iSurfaceIndex),'EdgeColor','none', 'facecolor',g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_acFreeSurferSurfaces{iSurfaceIndex}.m_afColor,...
    'facealpha',0.9);
%'FaceVertexCData',a2fColors,'FaceColor','interp','facealpha',0.9);

return;
