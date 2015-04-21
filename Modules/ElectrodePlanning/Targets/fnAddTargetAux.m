function fnAddTargetAux(strctMouseOp)
global g_strctModule
a2fXYZ_To_CRS = inv(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fM) * inv(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fReg);  %#ok

strctCrossSection=fnAxesHandleToStrctCrossSection(strctMouseOp.m_hAxes);
if isempty(strctCrossSection)
    return;
end;

% Transform the clicked point to 3D coordinates
pt2fPosMM = fnCrossSection_Image_To_MM(strctCrossSection, strctMouseOp.m_pt2fPos);
pt3fPosMMOnPlane = [pt2fPosMM,0,1]';
pt3fPosInVol = strctCrossSection.m_a2fM*pt3fPosMMOnPlane;


pt3fPosInStereoSpace=fnGetCoordInStereotacticSpace(pt3fPosInVol(1:3));
pt3fPosVoxel = a2fXYZ_To_CRS * pt3fPosInVol;
% Convert to coordinates voxel
% this way, if the volume moves, or something, it will still be in
% alignment!
fnAddTargetAux2(pt3fPosVoxel(1:3),pt3fPosInStereoSpace);
set(g_strctModule.m_strctPanel.m_hTargetList,'value', length( g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctTargets ));
fnUpdateTargetList();
fnInvalidate(true);
return;


