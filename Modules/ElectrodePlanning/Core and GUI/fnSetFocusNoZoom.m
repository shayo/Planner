
function fnSetFocusNoZoom(strctMouseOp)
global g_strctModule
hAxes  = strctMouseOp.m_hAxes;
if isempty(hAxes)
    return;
end;

switch hAxes 
    case g_strctModule.m_strctPanel.m_strctXY.m_hAxes
        % Transform the clicked point to 3D coordinates
        pt2fPosMM = fnCrossSection_Image_To_MM(g_strctModule.m_strctCrossSectionXY, strctMouseOp.m_pt2fPos);
        pt3fPosMMOnPlane = [pt2fPosMM,0,1]';
        pt3fPosInVol = g_strctModule.m_strctCrossSectionXY.m_a2fM*pt3fPosMMOnPlane;
 g_strctModule.m_strctCrossSectionYZ.m_a2fM(1:3,4) = pt3fPosInVol(1:3);
 g_strctModule.m_strctCrossSectionXZ.m_a2fM(1:3,4) = pt3fPosInVol(1:3);
   
    case g_strctModule.m_strctPanel.m_strctYZ.m_hAxes
        pt2fPosMM = fnCrossSection_Image_To_MM(g_strctModule.m_strctCrossSectionYZ, strctMouseOp.m_pt2fPos);
        pt3fPosMMOnPlane = [pt2fPosMM,0,1]';
        pt3fPosInVol = g_strctModule.m_strctCrossSectionYZ.m_a2fM*pt3fPosMMOnPlane;
        
 g_strctModule.m_strctCrossSectionXY.m_a2fM(1:3,4) = pt3fPosInVol(1:3);
 g_strctModule.m_strctCrossSectionXZ.m_a2fM(1:3,4) = pt3fPosInVol(1:3);
        
    case g_strctModule.m_strctPanel.m_strctXZ.m_hAxes        
         pt2fPosMM = fnCrossSection_Image_To_MM(g_strctModule.m_strctCrossSectionXZ, strctMouseOp.m_pt2fPos);
        pt3fPosMMOnPlane = [pt2fPosMM,0,1]';
        pt3fPosInVol = g_strctModule.m_strctCrossSectionXZ.m_a2fM*pt3fPosMMOnPlane;
 g_strctModule.m_strctCrossSectionXY.m_a2fM(1:3,4) = pt3fPosInVol(1:3);
  g_strctModule.m_strctCrossSectionYZ.m_a2fM(1:3,4) = pt3fPosInVol(1:3);

end;

fnInvalidate(1);
return;
