function fnUpdateSurfacePatch()
global g_strctModule
if ~isfield(g_strctModule.m_strctPanel,'m_hMainVolSurface') || ...
    (isfield(g_strctModule.m_strctPanel,'m_hMainVolSurface') && isempty(g_strctModule.m_strctPanel.m_hMainVolSurface) && ...
    isfield(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol},'m_strctIsoSurfParam') && ...
   g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_strctIsoSurfParam.m_bDisplay)
    fnGenerateSurfacePatch();
end

if ~isfield(g_strctModule.m_strctPanel,'m_hBloodSurface') || ...
    (isfield(g_strctModule.m_strctPanel,'m_hBloodSurface') && isempty(g_strctModule.m_strctPanel.m_hBloodSurface) && ...
    isfield(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol},'m_strctFrangiParam') && ...
    g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_strctFrangiParam.m_bDisplay)
    fnGenerateBloodVesselSurfacePatch();
end

if isfield(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol},'m_strctIsoSurfParam') && ...
    g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_strctIsoSurfParam.m_bDisplay

    strctIsoCRS = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_strctSurface;
    if ~isempty(strctIsoCRS)
        iNumVertices = size(strctIsoCRS.vertices,1);
        if iNumVertices > 0
            
            VerticesXYZ = inv(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_strctCrossSectionHoriz.m_a2fM)*g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fReg*g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fM*[strctIsoCRS.vertices,ones(iNumVertices,1)]';
            set(g_strctModule.m_strctPanel.m_hMainVolSurface,'vertices',VerticesXYZ(1:3,:)','faces',g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_strctSurface.faces  );
        end
        
    end
end

if  isfield(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol},'m_strctFrangiParam') && isfield( g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_strctFrangiParam,'m_bDisplay') && ...
    g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_strctFrangiParam.m_bDisplay

    strctIsoCRS = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_strctBloodSurface;
    if ~isempty(strctIsoCRS)
        iNumVertices = size(strctIsoCRS.vertices,1);
        if iNumVertices > 0
            VerticesXYZ = inv(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_strctCrossSectionHoriz.m_a2fM)*g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fReg*g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fM*[strctIsoCRS.vertices,ones(iNumVertices,1)]';
            set(g_strctModule.m_strctPanel.m_hBloodSurface,'vertices',VerticesXYZ(1:3,:)','faces',g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_strctBloodSurface.faces  );
        end
    end
end
return;




