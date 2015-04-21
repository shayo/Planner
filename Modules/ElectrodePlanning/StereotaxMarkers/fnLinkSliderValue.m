function fnLinkSliderValue(iLinkIndex)
global g_strctModule
fNewValue = get(g_strctModule.m_strctPanel.m_ahLinkSlider(iLinkIndex),'value');
if ~isempty(g_strctModule.m_strctVirtualArm.m_astrctJointsDescription(iLinkIndex).m_afDiscreteValues)
    fNewValue = g_strctModule.m_strctVirtualArm.m_astrctJointsDescription(iLinkIndex).m_afDiscreteValues(round(fNewValue));
    g_strctModule.m_strctVirtualArm.m_astrctJointsDescription(iLinkIndex).m_fValue = fNewValue;
else
    g_strctModule.m_strctVirtualArm.m_astrctJointsDescription(iLinkIndex).m_fValue = fNewValue;
end
set(g_strctModule.m_strctPanel.m_ahLinkEdit(iLinkIndex),'String',sprintf('%.2f',fNewValue));
try
    delete(g_strctModule.m_ahRobotHandles);
catch
end
afConf = fnRobotGetConfFromRobotStruct(g_strctModule.m_strctVirtualArm);

g_strctModule.m_ahRobotHandles = fnRobotDraw(g_strctModule.m_strctVirtualArm,afConf,...
    g_strctModule.m_strctPanel.m_strctStereoTactic.m_hAxes,1);

T = fnRobotForward(g_strctModule.m_strctVirtualArm,afConf); %#ok
%set(g_strctModule.m_strctPanel.m_hStatusLine,'string',sprintf('%.2f %.2f %.2f',T(1,4),T(2,4),T(3,4)));

fnUpdateChamberContour();
% % This code sets a chamber in the virtual arm position....
% T = fnRobotForward(g_strctModule.m_strctVirtualArm,fnRobotGetConfFromRobotStruct(g_strctModule.m_strctVirtualArm));
% a2fRegistrationMatrix = fnGetRegistrationMatrixForChamberPlanning();
% a2fManipulatorMM = inv(a2fRegistrationMatrix)*T;
% a2fManipulatorMM(1:3,1:3)=a2fManipulatorMM(1:3,1:3)/10;
% a2fManipulatorMM(1:3,3)=-a2fManipulatorMM(1:3,3);
% a2fXYZ_To_CRS = inv(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fM) * inv(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fReg); 
% a2fManipualtor_Vox = a2fXYZ_To_CRS*a2fManipulatorMM;
% g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber).m_a2fM_vox = a2fManipualtor_Vox; 
% fnInvalidate();

return;

