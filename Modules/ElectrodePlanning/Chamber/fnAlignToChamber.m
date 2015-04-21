

function fnAlignToChamber()
global g_strctModule
if g_strctModule.m_iCurrChamber == 0
    return;
end;
    a2fCRS_To_XYZ = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fReg*g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fM; 
a2fChamberT = a2fCRS_To_XYZ*g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber).m_a2fM_vox;

% Rotate by pi
a2fPiRot = fnRotateVectorAboutFixedAxis(a2fChamberT(1:3,3),pi,a2fChamberT(1:3,4));
g_strctModule.m_strctCrossSectionXY.m_a2fM = a2fPiRot*a2fChamberT;


%g_strctModule.m_strctCrossSectionXY.m_a2fM(1:3,2) = -a2fChamberT(1:3,2);

g_strctModule.m_strctCrossSectionYZ.m_a2fM(1:3,1:3) = a2fChamberT(1:3,[2,3,1]);
g_strctModule.m_strctCrossSectionYZ.m_a2fM(1:3,4) = a2fChamberT(1:3,4);
g_strctModule.m_strctCrossSectionYZ.m_a2fM(1:3,2)=-g_strctModule.m_strctCrossSectionYZ.m_a2fM(1:3,2);

a2fNewRot=eye(4);
a2fNewRot(1:3,1:3) = a2fChamberT(1:3,[1,3,2]);
a2fPiRot2 = fnRotateVectorAboutFixedAxis(a2fNewRot(1:3,3),pi,a2fChamberT(1:3,4));
g_strctModule.m_strctCrossSectionXZ.m_a2fM = a2fPiRot2*a2fNewRot;
g_strctModule.m_strctCrossSectionXZ.m_a2fM(1:3,4) = a2fChamberT(1:3,4);

fnInvalidate(1);
return;
