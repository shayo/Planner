
function fnTargetFindGridAndHole()
global g_strctModule


aiCurrTarget = get(g_strctModule.m_strctPanel.m_hTargetList,'value');
iNumTargets=length(aiCurrTarget);
iSelectedGrid = get(g_strctModule.m_strctPanel.m_hGridList,'value');
if iNumTargets == 0 || iSelectedGrid == 0
    return;
end;

a2fCRS_To_XYZ = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fReg*g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fM; 
apt2fTargetsVoxels = cat(2,g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctTargets(aiCurrTarget).m_pt3fPositionVoxel);
apt3fTargetsPosMM = a2fCRS_To_XYZ*[apt2fTargetsVoxels;ones(1,iNumTargets)];
if isempty(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber).m_astrctGrids)
    h=msgbox('Please add a grid first');
    waitfor(h);
    return;
end;
strctGrid = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber).m_astrctGrids(iSelectedGrid);
if strcmp(strctGrid.m_strType,'Standard Circular')
    strctChamber = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber);
    TargetHelper(apt3fTargetsPosMM,strctChamber,strctGrid,a2fCRS_To_XYZ);
else
    h=msgbox('This option is only available for standard circular grids','Warning');
    waitfor(h);
end
% 
% 
% iNumGrids = length(g_strctModule.m_astrctGrids(iSelectedGridType).m_astrctModels);
% afMinDist = zeros(1,iNumGrids);
% afDepthMM = zeros(1,iNumGrids);
% aiBestHole= zeros(1,iNumGrids);
% afBestTheta= zeros(1,iNumGrids);
% 
% for iModelIter=1:iNumGrids
%     strctGrid = g_strctModule.m_astrctGrids(iSelectedGridType).m_astrctModels(iModelIter);
%     [afMinDist(iModelIter),afDepthMM(iModelIter),aiBestHole(iModelIter),afBestTheta(iModelIter)] = fnSearchAllOrientations(strctGrid, a2fChamberM,pt3fTargetPosMM);
% end;
% [fMinDist, iBestModel] = min(afMinDist);
% fDepthMM = afDepthMM(iBestModel);
% iBestHole = aiBestHole(iBestModel);
% fBestTheta = afBestTheta(iBestModel);
% 
% strctGrid = g_strctModule.m_astrctGrids(iSelectedGridType).m_astrctModels(iBestModel);

%fnAddNewGridWithResults(strctGrid, fBestTheta, iBestHole,fDepthMM);
% str1 = sprintf('Minimum distance from electrode tip to target: %.2f mm',fMinDist);
% str2 = sprintf('Grid Model : %s',strctGrid.m_strGridType);
% str3 = sprintf('Grid Orientation: %.2f deg',fBestTheta);
% str4 = sprintf('Depth: %.2f mm',fDepthMM);
% msgbox( {str1,str2,str3,str4},'Result');


return;