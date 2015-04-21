

function fnTargetFindHole()
global g_strctModule
if isempty(g_strctModule.m_acAnatVol) || g_strctModule.m_iCurrChamber == 0
    return;
end;
iNumGrids = length(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber).m_astrctGrids);
if iNumGrids == 0
    return;
end;
aiCurrTarget = get(g_strctModule.m_strctPanel.m_hTargetList,'value');
if length(aiCurrTarget) > 1
    msgbox('This option is available only for one target');
    return;
end;
iCurrTarget = aiCurrTarget(1);
iSelectedGrid = get(g_strctModule.m_strctPanel.m_hGridList,'value');

a2fCRS_To_XYZ = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fReg*g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fM; 
pt3fTargetPosMM = a2fCRS_To_XYZ*[g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctTargets(iCurrTarget).m_pt3fPositionVoxel;1];



strctChamber = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber);
strctGrid = strctChamber.m_astrctGrids(iSelectedGrid);
a2fCRS_To_XYZ = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fReg*g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fM; 
a2fM = a2fCRS_To_XYZ*strctChamber.m_a2fM_vox;

a2fGridOffsetTransform = eye(4);
a2fGridOffsetTransform(3,4) = -strctGrid.m_fChamberDepthOffset;
a2fM_WithMeshOffset =a2fM*a2fGridOffsetTransform;

[fMinDist, iBestHole,fDepthMM,afDistToTargetMM] = fnFindNearestHoleToTarget(a2fM_WithMeshOffset,strctGrid,pt3fTargetPosMM);

if length(strctGrid.m_strctModel.m_afGridHolesX) > 1
    
[a2fX,a2fY ]= meshgrid(-7:7,-7:7);
a2fZ=griddata(strctGrid.m_strctModel.m_afGridHolesX,strctGrid.m_strctModel.m_afGridHolesY,afDistToTargetMM,a2fX,a2fY);
figure(2);
clf;
imagesc(-7:7,-7:-7,a2fZ);
colormap jet
colorbar 
hold on;
axis xy
plot(strctGrid.m_strctModel.m_afGridHolesX,strctGrid.m_strctModel.m_afGridHolesY,'wo');
plot(strctGrid.m_strctModel.m_afGridHolesX(iBestHole),strctGrid.m_strctModel.m_afGridHolesY(iBestHole),'w.','MarkerSize',16);

%title('Distance to Target. No Grid Rotation');
title( sprintf('Minimum distance to target is %.2f mm, at depth %.2f mm ',fMinDist,fDepthMM));
axis equal

g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber).m_astrctGrids(iSelectedGrid).m_strctModel.m_strctGridParams.m_abSelectedHoles(iBestHole) = 1;
fnUpdateGridAxes();
fnInvalidate(1);
%fnChangePlanarIntersectionToElectrodeTract(strctGrid, iBestHole);
end
return;
