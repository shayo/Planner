function fnChangeChamberType(iNewType)
global g_strctModule
iSelectedChamber = get(g_strctModule.m_strctPanel.m_hChamberList,'value');
if isempty(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers)
    return;
end;


iNumChamberModels = length(g_strctModule.m_strctParams.m_strctConfig.m_acChamberModels.m_strctModel);
for iModelIter=1:iNumChamberModels
    strctChamber.m_strType = g_strctModule.m_strctParams.m_strctConfig.m_acChamberModels.m_strctModel{iModelIter}.m_strModelName;
    strctChamber.m_strFuncName = g_strctModule.m_strctParams.m_strctConfig.m_acChamberModels.m_strctModel{iModelIter}.m_strModelFunc;
    strctChamber.m_strctModel = eval(strctChamber.m_strFuncName);
    g_strctModule.m_astrctChamberModels(iModelIter) = strctChamber;
end

g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(iSelectedChamber).m_strctModel = g_strctModule.m_astrctChamberModels(iNewType);

a2fCRS_To_XYZ = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fReg*g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fM; 
a2fM = a2fCRS_To_XYZ*g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(iSelectedChamber).m_a2fM_vox;
pt3fPosInStereoSpace=fnGetCoordInStereotacticSpace(a2fM(1:3,4));
g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(iSelectedChamber).m_strName = sprintf('%s @ AP %.2f ML %.2f DV %.2f',...
    g_strctModule.m_astrctChamberModels(iNewType).m_strType,...
    pt3fPosInStereoSpace(1),pt3fPosInStereoSpace(2),pt3fPosInStereoSpace(3));
fnInvalidate();
return;
