function fnAddDerivedFreesurferSurface()
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

iSelectedSurface = get(g_strctModule.m_strctPanel.m_hSurfaceList,'value');
if size(strctMesh.m_a2fVertices,2) ~= size(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_acFreeSurferSurfaces{iSelectedSurface}.m_a2fVertices,2) || ...
        size(strctMesh.m_a2iFaces,2) ~= size(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_acFreeSurferSurfaces{iSelectedSurface}.m_a2iFaces,2)
    h=msgbox(sprintf('The number of vertices / faces does not correspond to the parent surface. This was not derived from surface %s\n',...
        g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_acFreeSurferSurfaces{iSelectedSurface}.m_strName));
    waitfor(h);
    return;
end;
iNumDerivedSurfaces = length(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_acFreeSurferSurfaces{iSelectedSurface}.m_acDerivedSurfaces);
g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_acFreeSurferSurfaces{iSelectedSurface}.m_acDerivedSurfaces{iNumDerivedSurfaces+1} = strctMesh;


fnInvalidateSurfaceList();
return;



