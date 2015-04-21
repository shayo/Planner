function fnPlotAverageBOLDResponseAuxJulien(strctBOLD4D,iAnatomicalVolumeIndex,strROI,iSelectedFunctional, fWindowWidth, afRange)

apt3fPointsInFunctionalVolume = PlannerAPI('GetROI_Func_Coordinates_By_Name', iAnatomicalVolumeIndex,strROI,iSelectedFunctional);


% Now, sample the values of the bold in the ROI for each time point.
iNumTimePoints = strctBOLD4D.nframes;
afMeanFuncValue = zeros(1,iNumTimePoints );
afSEMFuncValue = zeros(1,iNumTimePoints );
iNumPointsInROI = size(apt3fPointsInFunctionalVolume,2);
a2fValues = zeros(iNumTimePoints, iNumPointsInROI);
for k=1:iNumTimePoints 
    a3fVol = strctBOLD4D.vol(:,:,:,k);
    afValues = fndllFastInterp3(a3fVol, 1+apt3fPointsInFunctionalVolume(1,:),1+apt3fPointsInFunctionalVolume(2,:),1+apt3fPointsInFunctionalVolume(3,:));
    a2fValues(k,:) = afValues;
end
% Convert RAW values to BOLD perc change
a2fBOLD_Perc =-1e2* (a2fValues ./ repmat( median(a2fValues,1), iNumTimePoints,1) - 1);
% Smooth bold values across time...
a2fBOLD_PercSmooth= conv2(a2fBOLD_Perc, fspecial('gaussian',[1 20],2)','same');
afMeanBoldResponse = median(a2fBOLD_PercSmooth,2);
afSEMBoldResponse = mad(a2fBOLD_PercSmooth,[],2) ./ sqrt(iNumPointsInROI);


afOpticalOnset = [32,160,288,352]/2;
afElectricalOnset = [96,160,224,352]/2;
figure(11);
clf;
plot(a2fBOLD_PercSmooth);
 hold on;
 for k=1:4
     plot(ones(1,2)*afOpticalOnset(k),[0 15],'linewidth',2,'color','b');
     plot(ones(1,2)*afElectricalOnset(k),[-15 0],'linewidth',2,'color','k');
 end

%%
aiInterval = -3:30;

afBoldResponseOptical = (afMeanBoldResponse(aiInterval + 16) + afMeanBoldResponse(aiInterval + 144))/2; 
afBoldResponseElectrical = (afMeanBoldResponse(aiInterval + 48) + afMeanBoldResponse(aiInterval + 112))/2;
afBoldResponseCombined = (afMeanBoldResponse(aiInterval + 80) + afMeanBoldResponse(aiInterval + 176))/2;
afBoldResponseRest= (afMeanBoldResponse(aiInterval + 32) + afMeanBoldResponse(aiInterval + 64) + ...
                     afMeanBoldResponse(aiInterval + 96) + afMeanBoldResponse(aiInterval + 128) + afMeanBoldResponse(aiInterval + 160)) / 5;


afBoldResponseOptical=afBoldResponseOptical-mean(afBoldResponseOptical(1:3));
afBoldResponseElectrical=afBoldResponseElectrical-mean(afBoldResponseElectrical(1:3));
afBoldResponseCombined=afBoldResponseCombined-mean(afBoldResponseCombined(1:3));

afBoldResponseRest = afBoldResponseRest - mean(afBoldResponseRest(1:3));

afSEMOptical =  (afSEMBoldResponse(aiInterval + 16) + afSEMBoldResponse(aiInterval + 144))/2; 
afSEMElectrical =  (afSEMBoldResponse(aiInterval + 48) + afSEMBoldResponse(aiInterval + 112))/2; 
afSEMBoth =  (afSEMBoldResponse(aiInterval + 80) + afSEMBoldResponse(aiInterval + 176))/2; 
afSEMRest =  (afSEMBoldResponse(aiInterval + 32) + afSEMBoldResponse(aiInterval + 64) + ...
                     afSEMBoldResponse(aiInterval + 96) + afSEMBoldResponse(aiInterval + 128) + afSEMBoldResponse(aiInterval + 160)) / 5;


afAllValues = [afBoldResponseElectrical+afSEMElectrical;afBoldResponseElectrical-afSEMElectrical;afBoldResponseOptical+afSEMOptical;afBoldResponseOptical-afSEMOptical;afBoldResponseCombined+afSEMBoth;afBoldResponseCombined-afSEMBoth];

if isempty(afRange)
    fMin = floor(min(afAllValues));
fMax = ceil(max(afAllValues));

else
    fMin = afRange(1);
    fMax = afRange(2);
end
% afSEMGray =  afSEMBoldResponse(1:20);
aiIntervalTime = 2*aiInterval;
figure(21);
clf;hold on;
rectangle('position',[0 fMin 32 fMax-fMin],'facecolor',[0.6 0.6 0.6],'edgecolor','none');
plot(aiIntervalTime,afBoldResponseElectrical,'k','LineWidth',2)
plot(aiIntervalTime,afBoldResponseElectrical+afSEMElectrical,'k--')
plot(aiIntervalTime,afBoldResponseElectrical-afSEMElectrical,'k--')
plot(aiIntervalTime,afBoldResponseOptical,'r','LineWidth',2)
plot(aiIntervalTime,afBoldResponseOptical+afSEMOptical,'r--')
plot(aiIntervalTime,afBoldResponseOptical-afSEMOptical,'r--')
plot(aiIntervalTime,afBoldResponseCombined,'b','LineWidth',2)
plot(aiIntervalTime,afBoldResponseCombined+afSEMBoth,'b--')
plot(aiIntervalTime,afBoldResponseCombined-afSEMBoth,'b--')

 plot(aiIntervalTime,afBoldResponseRest,'color',[0 0.5 0.5],'LineWidth',2);
 plot(aiIntervalTime,afBoldResponseRest+afSEMRest,'color',[0 0.5 0.5],'linestyle','--');
 plot(aiIntervalTime,afBoldResponseRest-afSEMRest,'color',[0 0.5 0.5],'linestyle','--')
% 
axis([-5 80 fMin fMax])
set(gcf,'Position',[1485         791         278         190])

