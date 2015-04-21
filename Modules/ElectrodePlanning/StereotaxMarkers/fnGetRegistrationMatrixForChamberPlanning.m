function a2fRegistrationMatrix = fnGetRegistrationMatrixForChamberPlanning()
global g_strctModule
assert(false);
bUseRegistrationFromFeatures = get(g_strctModule.m_strctPanel.m_hRegisterFeatures,'value');

fAPBarsDistance = 17.8;
fEarBarOffsetCM = -2.34- sqrt(2) * 0.61 /2;

if bUseRegistrationFromFeatures
    a2fRegistrationMatrix = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fRegToStereoTactic;
else
    a2fRescaleToCm = eye(4);
    a2fRescaleToCm(1,1) = 1/10;
    a2fRescaleToCm(2,2) = 1/10;
    a2fRescaleToCm(3,3) = 1/10;
    
     AP = [0 0 1];
     ML = [0 1 0];
     DV = [1 0 0]; %#ok
     
     a2fRotAP = eye(4);
     a2fRotAP(1:3,1:3) = fnRotateVectorAboutAxis(AP,-pi/2);
%     
     a2fRotML = eye(4);
     a2fRotML(1:3,1:3) = fnRotateVectorAboutAxis(ML,pi/2);
     a2fTransML0 = eye(4);
     a2fTransML0(2,4) = fAPBarsDistance/2;
%     
     a2fTransDV0 = eye(4);
     a2fTransDV0(1,4) = fEarBarOffsetCM;

    % User stereotactic plane to align the monkey in the stereotactic frame
    %a2fRegistrationMatrix=a2fTransDV0*a2fTransML0*a2fRotML*a2fRotAP*a2fRescaleToCm*inv(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fReg*g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fM);    %#ok
    a2fRegistrationMatrix=a2fTransDV0*a2fTransML0*a2fRotML*a2fRotAP*a2fRescaleToCm;
end
return;

