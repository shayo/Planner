function [pt3fPosIn3DSpace, pt3fPosInStereoSpace, pt3fVoxelCoordinate, strctCrossSection,pt3fPosInAtlasSpace]=fnGet3DCoord(strctMouseOp)
global g_strctModule
if isempty(strctMouseOp.m_hAxes )
    pt3fPosIn3DSpace = [NaN,NaN,NaN]';
    pt3fPosInStereoSpace = [NaN,NaN,NaN];
    pt3fVoxelCoordinate = [NaN,NaN,NaN];
     strctCrossSection = [];
     pt3fPosInAtlasSpace =  [NaN,NaN,NaN];
    return;
end;
switch strctMouseOp.m_hAxes 
    case g_strctModule.m_strctPanel.m_strctXY.m_hAxes
        % Transform the clicked point to 3D coordinates
        strctCrossSection = g_strctModule.m_strctCrossSectionXY;
        pt2fPosMM = fnCrossSection_Image_To_MM(g_strctModule.m_strctCrossSectionXY, strctMouseOp.m_pt2fPos);
        pt3fPosMMOnPlane = [pt2fPosMM,0,1]';
        pt3fPosIn3DSpace = g_strctModule.m_strctCrossSectionXY.m_a2fM*pt3fPosMMOnPlane;
        pt3fPosInStereoSpace=fnGetCoordInStereotacticSpace(pt3fPosIn3DSpace);
        pt3fPosInAtlasSpace = fnGetCoordInAtlasSpace(pt3fPosIn3DSpace);
        a2fXYZ_To_CRS = inv(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fM) * inv(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fReg);  %#ok
        pt3fVoxelCoordinate = a2fXYZ_To_CRS*pt3fPosIn3DSpace;
        pt3fVoxelCoordinate = pt3fVoxelCoordinate(1:3);
    case g_strctModule.m_strctPanel.m_strctYZ.m_hAxes
        strctCrossSection = g_strctModule.m_strctCrossSectionYZ;
        pt2fPosMM = fnCrossSection_Image_To_MM(g_strctModule.m_strctCrossSectionYZ, strctMouseOp.m_pt2fPos);
        pt3fPosMMOnPlane = [pt2fPosMM,0,1]';
        pt3fPosIn3DSpace = g_strctModule.m_strctCrossSectionYZ.m_a2fM*pt3fPosMMOnPlane;
        pt3fPosInStereoSpace=fnGetCoordInStereotacticSpace(pt3fPosIn3DSpace);
        pt3fPosInAtlasSpace = fnGetCoordInAtlasSpace(pt3fPosIn3DSpace);
        a2fXYZ_To_CRS = inv(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fM) * inv(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fReg);  %#ok
        pt3fVoxelCoordinate = a2fXYZ_To_CRS*pt3fPosIn3DSpace;
        pt3fVoxelCoordinate = pt3fVoxelCoordinate(1:3);
        
    case g_strctModule.m_strctPanel.m_strctXZ.m_hAxes        
        strctCrossSection = g_strctModule.m_strctCrossSectionXZ;
        pt2fPosMM = fnCrossSection_Image_To_MM(g_strctModule.m_strctCrossSectionXZ, strctMouseOp.m_pt2fPos);
        pt3fPosMMOnPlane = [pt2fPosMM,0,1]';
        pt3fPosIn3DSpace = g_strctModule.m_strctCrossSectionXZ.m_a2fM*pt3fPosMMOnPlane;
        pt3fPosInStereoSpace=fnGetCoordInStereotacticSpace(pt3fPosIn3DSpace);
        pt3fPosInAtlasSpace = fnGetCoordInAtlasSpace(pt3fPosIn3DSpace);
        a2fXYZ_To_CRS = inv(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fM) * inv(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fReg);  %#ok
        pt3fVoxelCoordinate = a2fXYZ_To_CRS*pt3fPosIn3DSpace;
        pt3fVoxelCoordinate = pt3fVoxelCoordinate(1:3);
           
    otherwise
    pt3fPosIn3DSpace = [NaN,NaN,NaN];
    pt3fPosInStereoSpace = [NaN,NaN,NaN];
    pt3fVoxelCoordinate = [NaN,NaN,NaN];
     strctCrossSection = [];
     pt3fPosInAtlasSpace =  [NaN,NaN,NaN];
end;

return;