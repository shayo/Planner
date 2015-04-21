
function fnSetAllWindowsMode(strMode)
global g_strctModule            
set(g_strctModule.m_strctPanel.m_strctXY.m_hPanel,'visible',strMode);
set(g_strctModule.m_strctPanel.m_strctYZ.m_hPanel,'visible',strMode);
set(g_strctModule.m_strctPanel.m_strctXZ.m_hPanel,'visible',strMode);
set(g_strctModule.m_strctPanel.m_strct3D.m_hPanel,'visible',strMode);
return;
