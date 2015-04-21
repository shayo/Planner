function fnAddFreesurferSurface()
 global g_strctModule
if g_strctModule.m_iCurrAnatVol == 0
    return;
end;
    [strFile,strPath]=uigetfile('*.*');
    if strFile(1) ==0
        return;
    end;
strSurfaceFileConformed = fullfile(strPath,strFile);    
strctMesh = fnReadSurfWrapper(strSurfaceFileConformed, true);
if ~isfield(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol},'m_acFreeSurferSurfaces')
   g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_acFreeSurferSurfaces{1} =  strctMesh;
   iNewSurfaceIndex = 1;
else
    a2fColors = colorcube(50);
    iNumSurfaces = length(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_acFreeSurferSurfaces);
    iNewSurfaceIndex = iNumSurfaces+1;
    strctMesh.m_afColor = a2fColors(2+iNewSurfaceIndex,:);
    g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_acFreeSurferSurfaces{iNewSurfaceIndex} =  strctMesh;
end

  fnGenerateFreesurferSurfaceAux(iNewSurfaceIndex);
  
 
  
fnInvalidateSurfaceList();
fnInvalidate();
return;