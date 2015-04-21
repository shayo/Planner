function fnScaleAtlas(hAxes, afDelta)
global g_strctModule
if isempty(hAxes)
    return;
end;
fScale1 = 1+ 1/150* fnGetAxesScaleFactor(g_strctModule.m_strctLastMouseDown.m_hAxes) * afDelta(1);
fScale2 =1+1/150* fnGetAxesScaleFactor(g_strctModule.m_strctLastMouseDown.m_hAxes) * afDelta(2);

switch hAxes %#ok
    case g_strctModule.m_strctPanel.m_strctXY.m_hAxes
          a2fScaleMatrix = [fScale1 0 0 0;
                          0       1 0 0;
                          0         0      fScale2 0;
                          0         0       0 1];
                          
      
                          
        g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fAtlasReg = a2fScaleMatrix * g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fAtlasReg;
        
    case g_strctModule.m_strctPanel.m_strctYZ.m_hAxes
       
        a2fScaleMatrix = [1 0 0 0;
                          0       fScale1 0 0;
                          0         0      fScale2 0;
                          0         0       0 1];
                          
        g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fAtlasReg = a2fScaleMatrix * g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fAtlasReg;
        
    case g_strctModule.m_strctPanel.m_strctXZ.m_hAxes    
         a2fScaleMatrix = [fScale1 0 0 0;
                          0       fScale2 0 0;
                          0         0      1 0;
                          0         0       0 1];
    
        g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fAtlasReg = a2fScaleMatrix * g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fAtlasReg;
  end
fnInvalidate();

return;