

function fnMoveMarkerAux(strctMouseOp, afDelta)
global g_strctModule
if isempty(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers )
    return;
end;

strctCrossSection=fnAxesHandleToStrctCrossSection(strctMouseOp.m_hAxes);
if isempty(strctCrossSection)
    return;
end;

iCurrMarker = get(g_strctModule.m_strctPanel.m_hMarkersList,'value');
g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers(iCurrMarker).m_strctCrossSectionXY = ...
    g_strctModule.m_strctCrossSectionXY;

g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers(iCurrMarker).m_strctCrossSectionYZ = ...
    g_strctModule.m_strctCrossSectionYZ;

g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers(iCurrMarker).m_strctCrossSectionXZ = ...
    g_strctModule.m_strctCrossSectionXZ;


fScale = 2*fnGetAxesScaleFactor(strctMouseOp.m_hAxes);

afDirX = strctCrossSection.m_a2fM(1:3,1);
afDirY = strctCrossSection.m_a2fM(1:3,2);

a2fCRS_To_XYZ = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fReg*g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fM; 

pt3fPosMM = a2fCRS_To_XYZ*[g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers(iCurrMarker).m_pt3fPosition_vox(:);1];

pt3fNewPosMM = pt3fPosMM(1:3) + (1/fScale)*afDelta(1) * afDirX + (1/fScale)*afDelta(2) * afDirY;
pt3fNewPosVox = inv(a2fCRS_To_XYZ) * [pt3fNewPosMM(:);1]; %#ok
g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers(iCurrMarker).m_pt3fPosition_vox = pt3fNewPosVox(1:3);

fnInvalidate();

return;
