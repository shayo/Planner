
function fnGridMIPFuncNeg()
global g_strctModule
g_strctModule.m_strctGUIOptions.m_bMIPFuncNeg = ~g_strctModule.m_strctGUIOptions.m_bMIPFuncNeg;
fnUpdateChamberMIP();
fnUpdateGridAxes();