function  fnDeleteFreesurferContours()
global g_strctModule

if isfield(g_strctModule,'m_ahFreeSurferHandles')
    delete(g_strctModule.m_ahFreeSurferHandles(ishandle(g_strctModule.m_ahFreeSurferHandles)));
    g_strctModule.m_ahFreeSurferHandles = [];
end;
return;