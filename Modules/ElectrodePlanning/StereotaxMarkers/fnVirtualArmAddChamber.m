function fnVirtualArmAddChamber()
global g_strctModule
% This code sets a chamber in the virtual arm position....
T = fnRobotForward(g_strctModule.m_strctVirtualArm,fnRobotGetConfFromRobotStruct(g_strctModule.m_strctVirtualArm));
% T(1:3,4)=T(1:3,4)*10;
a2fRegistrationMatrix = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fRegToStereoTactic;
a2fManipulatorMM = inv(a2fRegistrationMatrix)*T;
a2fManipulatorMM(1:3,1:3)=1/10*a2fManipulatorMM(1:3,1:3);
a2fManipulatorMM(1:3,3)=-a2fManipulatorMM(1:3,3);
fnAddChamberAuxWithType(a2fManipulatorMM, g_strctModule.m_strctVirtualChamber);

return;

