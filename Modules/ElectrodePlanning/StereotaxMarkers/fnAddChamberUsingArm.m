function fnAddChamberUsingArm()
global g_strctModule
strctMarker = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers(1);
  
iModelIndex = find(ismember({g_strctModule.m_astrctStereoTaxticModels.m_strName},strctMarker.m_strModelName));
iNumArmsInModel = length(g_strctModule.m_astrctStereoTaxticModels(iModelIndex).m_astrctArms);
acArmNames = cell(1,iNumArmsInModel);
for j=1:iNumArmsInModel
    acArmNames{j} = g_strctModule.m_astrctStereoTaxticModels(iModelIndex).m_astrctArms(j).m_strctRobot.name;
end
iArmIndex = find(ismember(acArmNames, strctMarker.m_strArmType));

% Convert the internal stuff to configuration vector
afRawValues= cat(1,strctMarker.m_astrctJointDescirptions.m_fValue)';
L=g_strctModule.m_astrctStereoTaxticModels(iModelIndex).m_astrctArms(iArmIndex).m_strctRobot.link;
iNumLinks = length(L);
abRotatory = zeros(1,iNumLinks)>0;
for j=1:iNumLinks
    abRotatory(j) = L{j}.sigma==0;
end
afArmConfiguration = afRawValues;
afArmConfiguration(abRotatory) = afRawValues(abRotatory) / 180 * pi; % Convert from deg to rad
% Build the configuration from readout values...
a2fChamberInStereoCoords = fnRobotForward(g_strctModule.m_astrctStereoTaxticModels(iModelIndex).m_astrctArms(iArmIndex).m_strctRobot,afArmConfiguration);
a2fChamberInStereoCoords(1:3,4)=10*a2fChamberInStereoCoords(1:3,4);
a2fRegToStereoTactic = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fRegToStereoTactic;
Tmp = inv(a2fRegToStereoTactic) * a2fChamberInStereoCoords; %#ok
Tmp(1:3,3) = -Tmp(1:3,3);
% Convert this from stereotaxtic to mri 
fnAddChamberAux(Tmp);
return;

