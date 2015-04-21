
function fnGenerateBloodVesselSurfacePatch()
global g_strctModule
strctIsoCRS = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_strctBloodSurface;
if isfield(g_strctModule.m_strctPanel,'m_hBloodSurface') && ~isempty(g_strctModule.m_strctPanel.m_hBloodSurface) && ishandle(g_strctModule.m_strctPanel.m_hBloodSurface)
    delete(g_strctModule.m_strctPanel.m_hBloodSurface);
end;

if ~isempty(strctIsoCRS)
    iNumVertices = size(strctIsoCRS.vertices,1);
    if iNumVertices > 0
        VerticesXYZ = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fReg*g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fM*[strctIsoCRS.vertices,ones(iNumVertices,1)]';
        strctIsoXYZ.vertices = VerticesXYZ(1:3,:)';
        strctIsoXYZ.faces = strctIsoCRS.faces;
        g_strctModule.m_strctPanel.m_hBloodSurface = patch(strctIsoXYZ, ...
            'parent',g_strctModule.m_strctPanel.m_strct3D.m_hAxes,'visible','on');
        set(g_strctModule.m_strctPanel.m_hBloodSurface,'FaceColor',...
            g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_strctFrangiParam.m_afSurfaceColor,...
            'EdgeColor','none','facealpha',g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_strctFrangiParam.m_fSurfaceOpacity);
        set(g_strctModule.m_strctPanel.m_hBloodSurface, 'UIContextMenu', g_strctModule.m_strctPanel.m_hMenu3D);
    end
end

return;



