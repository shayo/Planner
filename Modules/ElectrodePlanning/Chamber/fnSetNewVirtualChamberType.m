function fnSetNewVirtualChamberType()
global g_strctModule
iNewType = get(g_strctModule.m_strctPanel.m_hVirtualArmToolType,'value');
g_strctModule.m_strctVirtualChamber = g_strctModule.m_astrctChamberModels(iNewType);
fnUpdateChamberContour();

fnInvalidate();

return;    


