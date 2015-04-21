
function fnSetFocus()
global g_strctModule
hAxes  = g_strctModule.m_strctMouseOpMenu.m_hAxes;
if isempty(hAxes)
    return;
end;

switch hAxes 
    case g_strctModule.m_strctPanel.m_strctXY.m_hAxes
        % Transform the clicked point to 3D coordinates
        pt2fPosMM = fnCrossSection_Image_To_MM(g_strctModule.m_strctCrossSectionXY, g_strctModule.m_strctMouseOpMenu.m_pt2fPos);
        pt3fPosMMOnPlane = [pt2fPosMM,0,1]';
        pt3fPosInVol = g_strctModule.m_strctCrossSectionXY.m_a2fM*pt3fPosMMOnPlane;
   
    case g_strctModule.m_strctPanel.m_strctYZ.m_hAxes
        pt2fPosMM = fnCrossSection_Image_To_MM(g_strctModule.m_strctCrossSectionYZ, g_strctModule.m_strctMouseOpMenu.m_pt2fPos);
        pt3fPosMMOnPlane = [pt2fPosMM,0,1]';
        pt3fPosInVol = g_strctModule.m_strctCrossSectionYZ.m_a2fM*pt3fPosMMOnPlane;
    case g_strctModule.m_strctPanel.m_strctXZ.m_hAxes        
         pt2fPosMM = fnCrossSection_Image_To_MM(g_strctModule.m_strctCrossSectionXZ, g_strctModule.m_strctMouseOpMenu.m_pt2fPos);
        pt3fPosMMOnPlane = [pt2fPosMM,0,1]';
        pt3fPosInVol = g_strctModule.m_strctCrossSectionXZ.m_a2fM*pt3fPosMMOnPlane;
 end;
 g_strctModule.m_strctCrossSectionXY.m_fHalfWidthMM = 15;
 g_strctModule.m_strctCrossSectionXY.m_fHalfHeightMM = 15;
 g_strctModule.m_strctCrossSectionXZ.m_fHalfWidthMM = 15;
 g_strctModule.m_strctCrossSectionXZ.m_fHalfHeightMM = 15;
 g_strctModule.m_strctCrossSectionYZ.m_fHalfWidthMM = 15;
 g_strctModule.m_strctCrossSectionYZ.m_fHalfHeightMM = 15;
 g_strctModule.m_strctCrossSectionXY.m_a2fM(1:3,4) = pt3fPosInVol(1:3);
 g_strctModule.m_strctCrossSectionYZ.m_a2fM(1:3,4) = pt3fPosInVol(1:3);
 g_strctModule.m_strctCrossSectionXZ.m_a2fM(1:3,4) = pt3fPosInVol(1:3);
fnInvalidate(1);
return;

    