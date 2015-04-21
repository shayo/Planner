
    function fnRegenerateBloodSurface()
 global g_strctModule
   
strctSurfaceLargeMesh = isosurface(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a3bBloodVolume,0.5);%a3iX,a3iY, a3iZ,a3bVolSub, 0.5);
g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_strctBloodSurface= reducepatch(strctSurfaceLargeMesh, g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_strctFrangiParam.NumberOfFaces);
 fnGenerateBloodVesselSurfacePatch();
    return