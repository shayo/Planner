function fnGenerateSurfacePatch()
global g_strctModule

strctIsoCRS = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_strctSurface;
if isfield(g_strctModule.m_strctPanel,'m_hMainVolSurface') && ~isempty(g_strctModule.m_strctPanel.m_hMainVolSurface) &&  ishandle(g_strctModule.m_strctPanel.m_hMainVolSurface)
    delete(g_strctModule.m_strctPanel.m_hMainVolSurface);
end;

if ~isempty(strctIsoCRS)
    iNumVertices = size(strctIsoCRS.vertices,1);
    if iNumVertices > 0
        VerticesXYZ =inv(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_strctCrossSectionHoriz.m_a2fM) * g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fReg*g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fM*[strctIsoCRS.vertices,ones(iNumVertices,1)]';
        strctIsoXYZ.vertices = VerticesXYZ(1:3,:)';
        strctIsoXYZ.faces = strctIsoCRS.faces;
        g_strctModule.m_strctPanel.m_hMainVolSurface = patch(strctIsoXYZ, ...
            'parent',g_strctModule.m_strctPanel.m_strct3D.m_hAxes,'visible','on');
          set(g_strctModule.m_strctPanel.m_hMainVolSurface,'FaceColor',...
            g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_strctIsoSurfParam.m_afSurfaceColor,...
            'EdgeColor','none','facealpha',g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_strctIsoSurfParam.m_fSurfaceOpacity);
        set(g_strctModule.m_strctPanel.m_hMainVolSurface, 'UIContextMenu', g_strctModule.m_strctPanel.m_hMenu3D);
       axis(g_strctModule.m_strctPanel.m_strct3D.m_hAxes,'xy');
    end
end
return;
