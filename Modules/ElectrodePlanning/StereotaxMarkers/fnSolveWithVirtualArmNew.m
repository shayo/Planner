function fnSolveWithVirtualArmNew()
global g_strctModule

iSelectedChamber = get(g_strctModule.m_strctPanel.m_hChambersList,'value');
if isempty(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers)
    return;
end;

a2fCRS_To_XYZ = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fReg*g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fM; 
a2fChamberInMRI = a2fCRS_To_XYZ*g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(iSelectedChamber).m_a2fM_vox;
% FIXED! 18 Apr 2014.
a2fChamberInMRI(1:3,3) = -a2fChamberInMRI(1:3,3);
a2fChamberInStereoTacticCoord =  g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fRegToStereoTactic * a2fChamberInMRI;
% a2fChamberInStereoTacticCoord(1:3,4)=1/10*a2fChamberInStereoTacticCoord(1:3,4);

%% Validate....
% q_opt = fnRobotGetConfFromRobotStruct(g_strctModule.m_strctVirtualArm);
% fnRobotForward(g_strctModule.m_strctVirtualArm, q_opt)

iNumJoints = length(g_strctModule.m_strctVirtualArm.m_astrctJointsDescription);
acCombinations = cell(1,iNumJoints);
abFixed = zeros(1,iNumJoints) > 0;
abIsRotation = zeros(1,iNumJoints) > 0;
a2fMinMax = ones(2,iNumJoints);
a2fMinMax(1,:) = -Inf;
a2fMinMax(2,:) = +Inf;
for k=1:iNumJoints
    
    
    abFixed(k) = g_strctModule.m_strctVirtualArm.m_astrctJointsDescription(k).m_bFixed;
    abIsRotation(k) = g_strctModule.m_strctVirtualArm.m_a2fDH(k,5) == 0;
    if abIsRotation(k)
        a2fMinMax(1,k) = g_strctModule.m_strctVirtualArm.m_astrctJointsDescription(k).m_fMin/180*pi;
        a2fMinMax(2,k) = g_strctModule.m_strctVirtualArm.m_astrctJointsDescription(k).m_fMax/180*pi;
    else
        a2fMinMax(1,k) = g_strctModule.m_strctVirtualArm.m_astrctJointsDescription(k).m_fMin;
        a2fMinMax(2,k) = g_strctModule.m_strctVirtualArm.m_astrctJointsDescription(k).m_fMax;
    end
    
    if ~abFixed(k) && ~isempty(g_strctModule.m_strctVirtualArm.m_astrctJointsDescription(k).m_afDiscreteValues)
        abFixed(k) = true;
        if abIsRotation(k) 
            acCombinations{k} = g_strctModule.m_strctVirtualArm.m_astrctJointsDescription(k).m_afDiscreteValues / 180 * pi; % convert from deg to rad
        else
            acCombinations{k} = g_strctModule.m_strctVirtualArm.m_astrctJointsDescription(k).m_afDiscreteValues;
        end
    else
              if abIsRotation(k) 
                acCombinations{k} = g_strctModule.m_strctVirtualArm.m_astrctJointsDescription(k).m_fValue/180*pi;
              else
                  acCombinations{k} = g_strctModule.m_strctVirtualArm.m_astrctJointsDescription(k).m_fValue;
              end
    end
end


a2fConfigurations =fnGenComb(acCombinations);
iNumConfig = size(a2fConfigurations,1);

%% Solve the inverse Kinematic problem
fprintf('Trying to rotate chamber along its axis to get best possible solution...');
tic
a2fErrPos = NaN*ones(360,iNumConfig);
a2fErrAng = NaN*ones(360,iNumConfig);
a2bFeasible = zeros(360,iNumConfig)>0;
a3fConf = zeros(360,iNumConfig,iNumJoints);
h=waitbar(0,'Running inverse kinematics...');
for iPertubChamberOrientation=1:360
    if ~ishandle(h)
        break
    else
        waitbar(iPertubChamberOrientation/360,h);
    end
    a2fChamberInStereoTacticCoordPertubed = fnRotateVectorAboutFixedAxis(...
        a2fChamberInStereoTacticCoord(1:3,3),(iPertubChamberOrientation-180)/180*pi,...
        a2fChamberInStereoTacticCoord(1:3,4))*a2fChamberInStereoTacticCoord;
    
    q = zeros(iNumConfig,iNumJoints);
    a3fT = zeros(4,4,iNumConfig);
    afErrPosCM = NaN*ones(1,iNumConfig);
    afErrRotDeg = NaN*ones(1,iNumConfig);
    qinit = zeros(iNumJoints,1);
    acConfig = cell(1,iNumConfig);
    abFeasible = zeros(1,iNumConfig)>0;
    for k=1:iNumConfig
        acConfig{k} = num2str(k);
        Temp = fnRobotInverse( g_strctModule.m_strctVirtualArm,a2fChamberInStereoTacticCoordPertubed,abFixed,a2fConfigurations(k,:),qinit',150);
        
        if ~isempty(Temp)
            abFeasible(k) = fnRobotIsFeasible(g_strctModule.m_strctVirtualArm,Temp);
            q(k,:) = Temp;
            a3fConf(iPertubChamberOrientation,k,:) = Temp;
            a3fT(:,:,k) = fnRobotForward(g_strctModule.m_strctVirtualArm,q(k,:));
            afErrPosCM(k) = 10*sqrt(sum((a2fChamberInStereoTacticCoord(1:3,4)-a3fT(1:3,4,k)).^2));
            fAngle = max(-1,min(1,dot(a2fChamberInStereoTacticCoord(1:3,3), a3fT(1:3,3,k))));
            afErrRotDeg(k) = acos(fAngle)/pi*180; % Only Z matters...
            
            a2fErrPos(iPertubChamberOrientation,k) = afErrPosCM(k);
            a2fErrAng(iPertubChamberOrientation,k) = afErrRotDeg(k);
            a2bFeasible(iPertubChamberOrientation,k) =  abFeasible(k);
        end
    end
    
end
toc
if ishandle(h)
    delete(h);
end
aiFeasible = find(a2bFeasible(:) & a2fErrPos(:) < 0.01);
fprintf('Done!\n');
if ~isempty(aiFeasible)
    
    fprintf('Found multiple solutions that are closer than 1mm...\n');
% automatically pick the best solution....
    [fAngularErrorDeg,iIndex]=min(a2fErrAng(aiFeasible));
    fprintf('Minimal angle error found : %.2f Deg\n',fAngularErrorDeg)
    [iPertubationIndex, iConfigIndex]=ind2sub(size(a2bFeasible),aiFeasible(iIndex));
    afSolution = squeeze(a3fConf(iPertubationIndex,iConfigIndex,:));
    afErrPosCM = a2fErrPos(iPertubationIndex,iConfigIndex);
    afErrRotDeg = a2fErrAng(iPertubationIndex,iConfigIndex)/180*pi;
else

        h=msgbox('Failed to find any reasonable solution');
        waitfor(h);
        return;
   
end

%%
a2fData = afSolution(:);
%a2fData = q';
a2fData(abIsRotation,:) = a2fData(abIsRotation,:) / pi * 180;
a2cData = cell(size(a2fData));
for j=1:size(a2fData,2)
    for k=1:size(a2fData,1)
        a2cData{k,j} = sprintf('%.3f',a2fData(k,j));
    end
    a2cData{iNumJoints+2,j} = sprintf('%.3f',afErrPosCM(j));
    a2cData{iNumJoints+3,j} = sprintf('%.3f',afErrRotDeg(j));
end

acRowNames = [{g_strctModule.m_strctVirtualArm.m_astrctJointsDescription.m_strName},' ','Error Position (mm)','Error Rotation (deg)'];
f = figure('Position',[100 100 800 500]);
t = uitable('Data',a2cData,'RowName',acRowNames,... 
            'Parent',f,'Position',[20 20 700 450]); %#ok

%iSelectedConf =    iConfigIndex;     
% [iSelectedConf] = listdlg('PromptString','Select Solution',...
%     'SelectionMode','single',...
%     'ListString',acConfig,'ListSize',[500 200]);
%  
% if isempty(iSelectedConf)
%     return;
% end;

% Update Virtual arm and controllers with proposed solution

for iLinkIter=1:iNumJoints
 fnModifyLinkValueEditSlider(iLinkIter, a2fData(iLinkIter,1));
end
fnUpdateChamberContour();
fnInvalidateStereotactic();

return;

