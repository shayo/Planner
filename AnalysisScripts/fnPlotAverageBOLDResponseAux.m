function fnPlotAverageBOLDResponseAux(strctBOLD4D,iAnatomicalVolumeIndex,strROI,iSelectedFunctional, fWindowWidth, afRange)

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


%%
aiInterval = -3:30;

afBoldResponseOptical = (afMeanBoldResponse(aiInterval + 16) + afMeanBoldResponse(aiInterval + 144))/2; 
afBoldResponseElectrical = (afMeanBoldResponse(aiInterval + 48) + afMeanBoldResponse(aiInterval + 112))/2;
afBoldResponseCombined = (afMeanBoldResponse(aiInterval + 80) + afMeanBoldResponse(aiInterval + 176))/2;
afBoldResponseOptical=afBoldResponseOptical-mean(afBoldResponseOptical(1:3));
afBoldResponseElectrical=afBoldResponseElectrical-mean(afBoldResponseElectrical(1:3));
afBoldResponseCombined=afBoldResponseCombined-mean(afBoldResponseCombined(1:3));

afSEMOptical =  (afSEMBoldResponse(aiInterval + 16) + afSEMBoldResponse(aiInterval + 144))/2; 
afSEMElectrical =  (afSEMBoldResponse(aiInterval + 48) + afSEMBoldResponse(aiInterval + 112))/2; 
afSEMBoth =  (afSEMBoldResponse(aiInterval + 80) + afSEMBoldResponse(aiInterval + 176))/2; 

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
% plot(aiIntervalTimeGray,afBoldResponseGray,'color',[0.5 0.5 0.5],'LineWidth',2);
% plot(aiIntervalTimeGray,afBoldResponseGray+afSEMGray,'color',[0.5 0.5 0.5],'linestyle','--');
% plot(aiIntervalTimeGray,afBoldResponseGray-afSEMGray,'color',[0.5 0.5 0.5],'linestyle','--')
% 
axis([-5 80 fMin fMax])
set(gcf,'Position',[1485 826 fWindowWidth 155])

