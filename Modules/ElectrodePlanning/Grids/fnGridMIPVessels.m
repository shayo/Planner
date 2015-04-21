

function fnGridMIPVessels()
global g_strctModule
g_strctModule.m_strctGUIOptions.m_bMIPBlood = ~g_strctModule.m_strctGUIOptions.m_bMIPBlood;
fnUpdateChamberMIP();
fnUpdateGridAxes();        
