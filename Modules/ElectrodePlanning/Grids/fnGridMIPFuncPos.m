

function fnGridMIPFuncPos()
global g_strctModule
g_strctModule.m_strctGUIOptions.m_bMIPFuncPos = ~g_strctModule.m_strctGUIOptions.m_bMIPFuncPos;
fnUpdateChamberMIP();
fnUpdateGridAxes();