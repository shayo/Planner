
function fnRotatePlane(hAxes, fDiff)
global g_strctModule
switch hAxes
    
    case g_strctModule.m_strctPanel.m_strctXY.m_hLineYZ % bottom left, red
        g_strctModule.m_strctCrossSectionYZ = fnRotateCrossSectionAux(...
            g_strctModule.m_strctCrossSectionYZ, g_strctModule.m_strctCrossSectionXZ, -fDiff/100/2*pi);
        
    case g_strctModule.m_strctPanel.m_strctXY.m_hLineXZ % bottom left, green
        
        g_strctModule.m_strctCrossSectionXZ = fnRotateCrossSectionAux(...
            g_strctModule.m_strctCrossSectionXZ, g_strctModule.m_strctCrossSectionYZ, -fDiff/100/2*pi);
        
    case g_strctModule.m_strctPanel.m_strctXZ.m_hLineYZ % top right , red
        g_strctModule.m_strctCrossSectionYZ = fnRotateCrossSectionAux(...
            g_strctModule.m_strctCrossSectionYZ, g_strctModule.m_strctCrossSectionXY, -fDiff/100/2*pi);
        
    case g_strctModule.m_strctPanel.m_strctXZ.m_hLineXY % top right , blue
        
        g_strctModule.m_strctCrossSectionXY = fnRotateCrossSectionAux(...
            g_strctModule.m_strctCrossSectionXY, g_strctModule.m_strctCrossSectionYZ, -fDiff/100/2*pi);
        
    case g_strctModule.m_strctPanel.m_strctYZ.m_hLineXY % % top left, blue
        g_strctModule.m_strctCrossSectionXY = fnRotateCrossSectionAux(...
            g_strctModule.m_strctCrossSectionXY, g_strctModule.m_strctCrossSectionXZ, -fDiff/100/2*pi);
    case g_strctModule.m_strctPanel.m_strctYZ.m_hLineXZ % top left, green
        g_strctModule.m_strctCrossSectionXZ = fnRotateCrossSectionAux(...
            g_strctModule.m_strctCrossSectionXZ, g_strctModule.m_strctCrossSectionXY, -fDiff/100/2*pi);
end;
fnInvalidate();

return;