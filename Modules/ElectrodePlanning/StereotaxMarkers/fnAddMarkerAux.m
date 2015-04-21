function fnAddMarkerAux(strctMouseOp)
global g_strctModule

a2fXYZ_To_CRS = inv(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fM) * inv(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fReg);  %#ok
strctCrossSection=fnAxesHandleToStrctCrossSection(strctMouseOp.m_hAxes);
if isempty(strctCrossSection)
    return;
end;

pt2fPosMM = fnCrossSection_Image_To_MM(strctCrossSection, strctMouseOp.m_pt2fPos);
pt3fPosMMOnPlane = [pt2fPosMM,0,1]';
pt3fPosInVol = strctCrossSection.m_a2fM*pt3fPosMMOnPlane;
pt3fPosInStereoSpace=fnGetCoordInStereotacticSpace(pt3fPosInVol(1:3));
pt3fPosVoxel = a2fXYZ_To_CRS * pt3fPosInVol;

fnAddMarkerAux2(pt3fPosVoxel(1:3),pt3fPosInStereoSpace,pt3fPosInVol);

set(g_strctModule.m_strctPanel.m_hMarkersList,'value', ...
    length( g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers));
fnUpdateMarkerList();
fnInvalidate(true);
return;
