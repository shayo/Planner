
function fnSetNewDefaultView()
global g_strctModule    
g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_strctCrossSectionHoriz = g_strctModule.m_strctCrossSectionXY;
g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_strctCrossSectionCoronal = g_strctModule.m_strctCrossSectionXZ;
g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_strctCrossSectionSaggital = g_strctModule.m_strctCrossSectionYZ;
return;
    


