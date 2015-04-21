
function fnRotatePlaneExact(strctMouseDown, strctMouseOp) %#ok
global g_strctModule
pt3fPosIn3DSpace=fnGet3DCoord(strctMouseOp);


switch strctMouseDown.m_hAxesLineSelected
    
    case g_strctModule.m_strctPanel.m_strctXY.m_hLineYZ % bottom left, red
        fRotationAngle=fnRotatePlaneExactAuxComputeRotationAngle(pt3fPosIn3DSpace,g_strctModule.m_strctCrossSectionXY,g_strctModule.m_strctCrossSectionYZ,g_strctModule.m_strctCrossSectionXZ, g_strctModule.m_strctPanel.m_strctXY.m_hAxes);
        g_strctModule.m_strctCrossSectionYZ = fnRotateCrossSectionAux(...
            g_strctModule.m_strctCrossSectionYZ, g_strctModule.m_strctCrossSectionXZ, fRotationAngle);
        
    case g_strctModule.m_strctPanel.m_strctXY.m_hLineXZ % bottom left, green
        fRotationAngle=fnRotatePlaneExactAuxComputeRotationAngle(pt3fPosIn3DSpace,g_strctModule.m_strctCrossSectionXY,g_strctModule.m_strctCrossSectionXZ,g_strctModule.m_strctCrossSectionYZ, g_strctModule.m_strctPanel.m_strctXY.m_hAxes);
        g_strctModule.m_strctCrossSectionXZ = fnRotateCrossSectionAux(...
            g_strctModule.m_strctCrossSectionXZ, g_strctModule.m_strctCrossSectionYZ, fRotationAngle);
        
    case g_strctModule.m_strctPanel.m_strctXZ.m_hLineYZ % top right , red
        fRotationAngle=fnRotatePlaneExactAuxComputeRotationAngle(pt3fPosIn3DSpace,g_strctModule.m_strctCrossSectionXZ,g_strctModule.m_strctCrossSectionYZ,g_strctModule.m_strctCrossSectionXY, g_strctModule.m_strctPanel.m_strctXZ.m_hAxes);
        
        g_strctModule.m_strctCrossSectionYZ = fnRotateCrossSectionAux(...
            g_strctModule.m_strctCrossSectionYZ, g_strctModule.m_strctCrossSectionXY, fRotationAngle);
        
    case g_strctModule.m_strctPanel.m_strctXZ.m_hLineXY % top right , blue
        fRotationAngle=fnRotatePlaneExactAuxComputeRotationAngle(pt3fPosIn3DSpace,g_strctModule.m_strctCrossSectionXZ,g_strctModule.m_strctCrossSectionXY,g_strctModule.m_strctCrossSectionYZ, g_strctModule.m_strctPanel.m_strctXZ.m_hAxes);
        g_strctModule.m_strctCrossSectionXY = fnRotateCrossSectionAux(...
            g_strctModule.m_strctCrossSectionXY, g_strctModule.m_strctCrossSectionYZ, fRotationAngle);
        
    case g_strctModule.m_strctPanel.m_strctYZ.m_hLineXY % % top left, blue
        fRotationAngle=fnRotatePlaneExactAuxComputeRotationAngle(pt3fPosIn3DSpace,g_strctModule.m_strctCrossSectionYZ,g_strctModule.m_strctCrossSectionXY,g_strctModule.m_strctCrossSectionXZ, g_strctModule.m_strctPanel.m_strctYZ.m_hAxes);
        g_strctModule.m_strctCrossSectionXY = fnRotateCrossSectionAux(...
            g_strctModule.m_strctCrossSectionXY, g_strctModule.m_strctCrossSectionXZ, fRotationAngle);
    case g_strctModule.m_strctPanel.m_strctYZ.m_hLineXZ % top left, green
        fRotationAngle=fnRotatePlaneExactAuxComputeRotationAngle(pt3fPosIn3DSpace,g_strctModule.m_strctCrossSectionYZ,g_strctModule.m_strctCrossSectionXZ,g_strctModule.m_strctCrossSectionXY, g_strctModule.m_strctPanel.m_strctYZ.m_hAxes);
        g_strctModule.m_strctCrossSectionXZ = fnRotateCrossSectionAux(...
            g_strctModule.m_strctCrossSectionXZ, g_strctModule.m_strctCrossSectionXY, fRotationAngle);
end;
fnInvalidate();

return;

    
    