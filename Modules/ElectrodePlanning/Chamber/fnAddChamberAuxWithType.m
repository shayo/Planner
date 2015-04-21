function fnAddChamberAuxWithType(a2fM_mm, strctChamberModel)
global g_strctModule

a2fXYZ_To_CRS = inv(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fM) * inv(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fReg); %#ok

pt3fPosMM = a2fM_mm(1:3,3);
pt3fPosInStereoSpace=fnGetCoordInStereotacticSpace(pt3fPosMM);

strctChamber.m_a2fM_vox = a2fXYZ_To_CRS*a2fM_mm; % Chamber is represented in volume coordinates (!)
strctChamber.m_astrctGrids = [];
strctChamber.m_strctModel = strctChamberModel; % Default chamber....
strctChamber.m_strName = sprintf('%s @ AP %.2f ML %.2f DV %.2f',strctChamber.m_strctModel.m_strType,...
    pt3fPosInStereoSpace(1),pt3fPosInStereoSpace(2),pt3fPosInStereoSpace(3));

strctChamber.m_ah3DSurfaces = [];
strctChamber.m_bVisible = true;
strctChamber.m_iGridSelected = [];

if isempty(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers)
    g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers = strctChamber;
    g_strctModule.m_iCurrChamber = 1;
else
    g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(end+1) = strctChamber;
end;

fnUpdateChamberList();
fnUpdateGridList();
fnSelectChamberAux(length(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers));
fnInvalidate();
return;