function bSolved = fnSolveRegistration()
global g_strctModule
% Aggregate values
bSolved = false;
if ~isfield(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol},'m_astrctMarkers')
    errordlg('Please add markers first!');
    return;
end;
iNumMarkers = length(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers);
if iNumMarkers < 4
    errordlg('Need at least 3 markers to solve this problem.');
    return;
end;

%% Forward Kinematics. Compute coordinates from read out values
[apt3fMarkersStereoTaticCoord, apt3fMarkersMRIMetricCoord]=fnSolveRegistrationAux();

% Remove non-enabled markers from computation

if ~isfield(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers(1),'m_bEnabled')
    for k=1:length(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers)
        g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers(k).m_bEnabled = true;
    end
end

abEnabled = zeros(1,iNumMarkers) >0;
for k=1:iNumMarkers
     abEnabled(k) = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers(k).m_bEnabled;
end
apt3fMarkersStereoTaticCoord = apt3fMarkersStereoTaticCoord(:,abEnabled);
apt3fMarkersMRIMetricCoord= apt3fMarkersMRIMetricCoord(:,abEnabled);
iNumMarkers = size(apt3fMarkersMRIMetricCoord,2);
if iNumMarkers < 4
   errordlg('Need at least 3 markers to solve this problem.');
    return;
end;

% Plot the problem.
hfig = figure(11);
clf;
subplot(3,1,1);
plot3(apt3fMarkersStereoTaticCoord(1,:),apt3fMarkersStereoTaticCoord(2,:),apt3fMarkersStereoTaticCoord(3,:),'b.');
hold on;
for k=1:size(apt3fMarkersStereoTaticCoord,2)
    text(apt3fMarkersStereoTaticCoord(1,k),apt3fMarkersStereoTaticCoord(2,k),apt3fMarkersStereoTaticCoord(3,k),num2str(k));
end;
axis equal
cameratoolbar(hfig);
title('Stereotactic Markers');
%figure(12);
%clf;
subplot(3,1,2);
plot3(apt3fMarkersMRIMetricCoord(1,:),apt3fMarkersMRIMetricCoord(2,:),apt3fMarkersMRIMetricCoord(3,:),'ro');
hold on;
for k=1:size(apt3fMarkersMRIMetricCoord,2)
    text(apt3fMarkersMRIMetricCoord(1,k),apt3fMarkersMRIMetricCoord(2,k),apt3fMarkersMRIMetricCoord(3,k),num2str(k));
end;
axis equal
%cameratoolbar(12);
title('MRI Markers');
%%
% %  apt3fMarkersStereoTaticCoord = apt3fMarkersStereoTaticCoord(:,1:8);
% %  apt3fMarkersMRIMetricCoord=apt3fMarkersMRIMetricCoord(:,1:8);
%% Absolute Orienation Problem

% Find the mapping FROM MRI coordinate system TO Stereotatic
[s, R, T, err] = fnAbsoluteOrientation( apt3fMarkersMRIMetricCoord, apt3fMarkersStereoTaticCoord, 0, 0.1); % Scale is 0.1 because scans MRI space is in mm, while stereo frame read out values are in cm
%  apt3fMarkersStereoTaticCoord2 = s * R* apt3fMarkersMRIMetricCoord +  repmat(T, [1,size(apt3fMarkersMRIMetricCoord,2)])
% We assume s = 0.1, since measurements are in cm...
apt3fMarkersStereoTaticCoord2 = s * R* apt3fMarkersMRIMetricCoord +  repmat(T, [1,size(apt3fMarkersMRIMetricCoord,2)]);

R2=R;
R2(:,2)=-R2(:,2);
StereotaxCMtoMRIspaceMM = [1/s*[inv(R2), -inv(R2)*T]; 0,0,0,1];
StereotaxMMtoMRIspaceMM = [[inv(R2), -inv(R2)*T]; 0,0,0,1];

%%%%%%%%%%%%%%%%%
if 1
    for selectedMarker =1:length(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers)
        strctMarker = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers(selectedMarker);
        
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
        Tmp = fnRobotForward(g_strctModule.m_astrctStereoTaxticModels(iModelIndex).m_astrctArms(iArmIndex).m_strctRobot,afArmConfiguration);
        pt3MarkerInStereotacticCoordinatesCM = Tmp(1:3,4);
        
        
        ReconstructedMarkerPositionInMRIspaceMM = StereotaxCMtoMRIspaceMM*[pt3MarkerInStereotacticCoordinatesCM;1];
        
        a2fCRS_To_XYZ = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fReg*g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fM;
        pt3fMarkerMaunalAnnotationInMRIspace= a2fCRS_To_XYZ*[strctMarker.m_pt3fPosition_vox(:);1];
        
        afErrorInMMInMRIspace(selectedMarker)=norm(pt3fMarkerMaunalAnnotationInMRIspace-ReconstructedMarkerPositionInMRIspaceMM);
    end
end
%%%%%%%%%%%%%%%%%%

subplot(3,1,3);
%figure(13);
%clf;
hold on;
plot3(apt3fMarkersStereoTaticCoord(1,:),apt3fMarkersStereoTaticCoord(2,:),apt3fMarkersStereoTaticCoord(3,:),'b.');
plot3(apt3fMarkersStereoTaticCoord2(1,:),apt3fMarkersStereoTaticCoord2(2,:),apt3fMarkersStereoTaticCoord2(3,:),'ro');

for k=1:size(apt3fMarkersStereoTaticCoord,2)
    text(apt3fMarkersStereoTaticCoord(1,k),apt3fMarkersStereoTaticCoord(2,k),apt3fMarkersStereoTaticCoord(3,k),num2str(k));
end;
axis equal
% cameratoolbar(13);
title(sprintf('Registration Error (mm) is : %.3f ',err*10));



% 
% 
%    answer = questdlg({sprintf('Registration mean error is: %.2f mm\n',err*10), 'Remove markers iteratively to improve?'}, ...
%                          'Question?', ...
%                          'Yes', 'No', 'Yes');
% 
% if strcmp(answer,'Yes')
%     
% aiCurrentSet = setdiff(1:iNumMarkers,[6,12]);
% iNumRounds = max(1,iNumMarkers-9); % Keep at least 5 markers
% aiWroseFeature = zeros(1,iNumRounds);
% afMinErrorAtRound = zeros(1,iNumRounds);
% 
% for iRound=1:iNumRounds
%     
% afError = zeros(1,length(aiCurrentSet));
% for k=1:length(aiCurrentSet)
%     aiSubset = setdiff(aiCurrentSet,k);
%     % set one marker aside...
%     
%     apt3fMarkersMRIMetricCoord_Subset = apt3fMarkersMRIMetricCoord(:,aiSubset);
%     apt3fMarkersStereoTaticCoord_Subset = apt3fMarkersStereoTaticCoord(:,aiSubset);
%     [s, R, T, afError(k)] = fnAbsoluteOrientation( apt3fMarkersMRIMetricCoord_Subset, apt3fMarkersStereoTaticCoord_Subset, 0, 0.1);  %#ok
%     % Scale is 0.1 because scans MRI space is in mm, while stereo frame read out values are in cm 
% end
% [afMinErrorAtRound(iRound), iIndex] = min(afError);
% aiWroseFeature(iRound) = aiCurrentSet(iIndex);
% aiCurrentSet=setdiff(aiCurrentSet, aiCurrentSet(iIndex));
% end
% 
% [s, R, T, err] = fnAbsoluteOrientation( apt3fMarkersMRIMetricCoord(:,aiCurrentSet), apt3fMarkersStereoTaticCoord(:,aiCurrentSet), 0, 0.1);  %#ok
% % Scale is 0.1 because scans MRI space is in mm, while stereo frame read out values are in cm %#ok 
%     
% end


%%

% R(:,2)=-R(:,2);
% a2fTrans = [R, T;0,0,0,1];

%%

% Ans=questdlg(sprintf('Registration mean error is: %.2f mm\n',err*10),'Non Linear Optimization','No','Yes','Yes');
% 
% if strcmp(Ans,'Yes')
%     global g_optTmp 
%     g_optTmp.m_apt3fMarkersStereoTaticCoord= apt3fMarkersStereoTaticCoord;
%     N=size(apt3fMarkersStereoTaticCoord,2);
%     X=[apt3fMarkersMRIMetricCoord(:)'];
%     options = optimset('Display','iter','TolFun',1e-20,'TolX',1e-20);
%     [Xopt,er]=fminunc(@fnNonLinearOptErrFnc, X,options);
%     NewMarkersPosMRI = reshape(Xopt,3,N);
%     NewMarkersPosMRI-apt3fMarkersMRIMetricCoord
%     [s, Ropt, Topt, err] = fnAbsoluteOrientation( NewMarkersPosMRI, apt3fMarkersStereoTaticCoord, 0, 0.1); % Scale is 0.1 because scans MRI space is in mm, while stereo frame read out values are in cm
%     
%     fprintf('Error after non linear optimization and correction of MRI placed coordinates: %.4f\n',err*10);
%     %  apt3fMarkersStereoTaticCoord = s * R* apt3fMarkersMRIMetricCoord + T
%     % We assume s = 0.1, since measurements are in cm...
%     a2fTrans = [s*Ropt, Topt;0,0,0,1];
% end

%g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fRegToStereoTactic = a2fTrans;

g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fRegToStereoTactic = inv(StereotaxCMtoMRIspaceMM);

set(g_strctModule.m_strctPanel.m_hRegisterFeatures,'enable','on','value',1);
set(g_strctModule.m_strctPanel.m_hRegisterEB0,'value',0);

fnInvalidateStereotactic();
bSolved = true;
return;