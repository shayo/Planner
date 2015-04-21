function  fnDeleteFreesurferSurface()
global g_strctModule

if isfield(g_strctModule,'m_ahFreeSurfer3DHandles')
    g_strctModule.m_ahFreeSurfer3DHandles=g_strctModule.m_ahFreeSurfer3DHandles(g_strctModule.m_ahFreeSurfer3DHandles>0);
    delete(g_strctModule.m_ahFreeSurfer3DHandles(ishandle(g_strctModule.m_ahFreeSurfer3DHandles)));
    g_strctModule.m_ahFreeSurfer3DHandles = [];
end;
return;