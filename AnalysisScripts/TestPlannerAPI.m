iAnatomicalVolumeIndex = 1;
iROIIndex = 2;
iSelectedFunctional = 7;
strSessionName = 'D:\Data\Doris\Planner\Julien\Julien_Session_For_Optogenetics_Publication.mat';

bSuccessful = PlannerAPI('LoadSession', strSessionName);

apt3fPointsInFunctionalVolume = PlannerAPI('GetROI_Func_Coordinates_By_Index', iAnatomicalVolumeIndex,iROIIndex,iSelectedFunctional);

%strDesignFile = 'D:\Data\Doris\Planner\Julien\120315Julien - Functionals in Arch\paradigmfile_anal_smooth';
strDesignFile = 'D:\Data\Doris\Planner\Julien\120314Julien - ChR2 No Electrical\paradigmfile_anal_all_smooth';

% Now, load the relevant 4D functional volume 
%strctBOLD4D = MRIread('D:\Data\Doris\Planner\Julien\120315Julien - Functionals in Arch\anal_smooth_mean.nii');
strctBOLD4D = MRIread('D:\Data\Doris\Planner\Julien\120314Julien - ChR2 No Electrical\anal_all_smooth_avgfunc.nii');


% Now, sample the values of the bold in the ROI for each time point.
iNumTimePoints = strctBOLD4D.nframes;
afMeanFuncValue = zeros(1,iNumTimePoints );
afSEMFuncValue = zeros(1,iNumTimePoints );

for k=1:iNumTimePoints 
    a3fVol = strctBOLD4D.vol(:,:,:,k);
    afValues = 255-fndllFastInterp3(a3fVol, 1+apt3fPointsInFunctionalVolume(1,:),1+apt3fPointsInFunctionalVolume(2,:),1+apt3fPointsInFunctionalVolume(3,:));
     %Correct Values
    afMeanFuncValue(k) = mean(afValues);
    afSEMFuncValue(k) = std(afValues)/sqrt(length(afValues));
end


%
        hFileID = fopen(strDesignFile,'r');
        Tmp = textscan(hFileID,'%f %d %f %s');        
        fclose(hFileID);
       strctDesign = fnFreesurferDesignToMatlabFormat(Tmp);


% do polynomial fitting and remove... (?)
afPolyCoeff = polyfit(1:iNumTimePoints,afMeanFuncValue,2);
afPolyVal = polyval(afPolyCoeff,1:iNumTimePoints);
afValuesAdjustedPoly = afMeanFuncValue-afPolyVal;
afBOLD_Perc = 1e2*( afMeanFuncValue./mean(afMeanFuncValue)-1);
afBOLD_SEM_Perc = 1e2*( afSEMFuncValue./mean(afSEMFuncValue)-1);
% Preset as % of mean?
figure(20);
clf;
subplot(3,1,1);
hold on;
plot(afMeanFuncValue)
plot(afPolyVal,'r');
ylabel('RAW BOLD values');
set(gca,'xlim',[1 iNumTimePoints])
subplot(3,1,2);
hold on;
plot(afValuesAdjustedPoly)
set(gca,'xlim',[1 iNumTimePoints])
ylabel('BOLD, corrected');
subplot(3,1,3);
plot(1e2*( afMeanFuncValue./mean(afMeanFuncValue)-1))
ylabel('Bold % Change');
set(gca,'xlim',[1 iNumTimePoints])

TR = 2.0;
iOnsetOpticalTR  = 16;%strctDesign.m_astrctCond(2).m_afStartTime(1)/TR;
iOnsetElectricalTR= 48;%strctDesign.m_astrctCond(3).m_afStartTime(1)/TR;
iOnsetBothTR = 160/TR;
figure(21);
clf;hold on;
fMin = -10
fHeight = 10;
rectangle('Position',[0 fMin 16  fHeight],'FaceColor',[0.8 0.8 0.8]);
plot(-5:32,-afBOLD_Perc(iOnsetElectricalTR-5:iOnsetElectricalTR+32),'k','LineWidth',2)
plot(-5:32,-afBOLD_Perc(iOnsetOpticalTR-5:iOnsetOpticalTR+32),'k--','LineWidth',2)
plot(-5:32,-afBOLD_Perc(iOnsetBothTR-5:iOnsetBothTR+32),'r','LineWidth',2)
box on

