function fnGenerateFreesurferSurface()
global g_strctModule

iNumSurfaces = length(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_acFreeSurferSurfaces);
for iSurfaceIter=1:iNumSurfaces
  fnGenerateFreesurferSurfaceAux(iSurfaceIter);
end


return;