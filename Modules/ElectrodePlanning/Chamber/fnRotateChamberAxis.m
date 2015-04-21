function fnRotateChamberAxis(hAxes,afDelta)
global g_strctModule
if isempty(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers) || g_strctModule.m_iCurrChamber == 0 || isempty(hAxes)
    return;
end;
fScale = fnGetAxesScaleFactor(g_strctModule.m_strctLastMouseDown.m_hAxes); %#ok
a2fCRS_To_XYZ = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fReg*g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fM; 
a2fM = a2fCRS_To_XYZ*g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber).m_a2fM_vox;
[fMax,iDummy] = max(abs(afDelta)); %#ok


a2fT = eye(4);
a2fT(1:3,4) = -a2fM(1:3,4);



a2fR = fnRotateVectorAboutAxis(a2fM(1:3,3),afDelta(iDummy)/300*pi);
a2fRot = zeros(4,4);
a2fRot(1:3,1:3) = a2fR;
a2fRot(4,4) = 1;

a2fM = inv(a2fT) * a2fRot * a2fT * a2fM; %#ok

g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber).m_a2fM_vox = inv(a2fCRS_To_XYZ) * a2fM;%#ok
fnUpdateChamberMIP();
fnInvalidate();

return;