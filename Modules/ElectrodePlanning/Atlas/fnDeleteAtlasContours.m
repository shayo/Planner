function fnDeleteAtlasContours()
global g_strctModule
if isfield(g_strctModule.m_strctPanel,'m_ahAtlas')
    delete(g_strctModule.m_strctPanel.m_ahAtlas);
end;
g_strctModule.m_strctPanel.m_ahAtlas = [];

return;