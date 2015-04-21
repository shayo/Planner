function [apt3fMarkersStereoTaticCoord, apt3fMarkersMRIMetricCoord]=fnSolveRegistrationAux()
global g_strctModule

iNumMarkers = length(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers);
apt3fMarkersStereoTaticCoord = zeros(3,iNumMarkers);
apt3fMarkersMRIMetricCoord = zeros(3,iNumMarkers);
a2fCRS_To_XYZ = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fReg*g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fM; 
% Refresh models
fnRefreshStereoModels();



% The convension says: [X,Y,Z] = [MidLine, AP, Z]
for k=1:iNumMarkers
    strctMarker = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers(k);
    
    iModelIndex = find(ismember({g_strctModule.m_astrctStereoTaxticModels.m_strName},strctMarker.m_strModelName));
    iNumArmsInModel = length(g_strctModule.m_astrctStereoTaxticModels(iModelIndex).m_astrctArms);
    acArmNames = cell(1,iNumArmsInModel);
    for j=1:iNumArmsInModel
        acArmNames{j} = g_strctModule.m_astrctStereoTaxticModels(iModelIndex).m_astrctArms(j).m_strctRobot.m_strName;
    end
    iArmIndex = find(ismember(acArmNames, strctMarker.m_strArmType));
    
    % Convert the internal stuff to configuration vector
    abRotatory = g_strctModule.m_astrctStereoTaxticModels(iModelIndex).m_astrctArms(iArmIndex).m_strctRobot.m_a2fDH(:,5) == 0;
    afArmConfiguration = cat(1,strctMarker.m_astrctJointDescirptions.m_fValue)';
    afArmConfiguration(abRotatory) = afArmConfiguration(abRotatory) / 180 * pi; % Convert from deg to rad
    % Build the configuration from readout values...
%     afArmConfiguration



    T = fnRobotForward(g_strctModule.m_astrctStereoTaxticModels(iModelIndex).m_astrctArms(iArmIndex).m_strctRobot,afArmConfiguration);

    apt3fMarkersStereoTaticCoord(:,k) = T(1:3,4);
    pt3fMarkerMM = a2fCRS_To_XYZ*[strctMarker.m_pt3fPosition_vox(:);1];
    % BUG ? 15 Sep 2011. 
    % For some weird reason, the Y axis is flipped in MRI coordinates. 
    apt3fMarkersMRIMetricCoord(:,k) = [pt3fMarkerMM(1),-pt3fMarkerMM(2),pt3fMarkerMM(3)];
end     
return;
