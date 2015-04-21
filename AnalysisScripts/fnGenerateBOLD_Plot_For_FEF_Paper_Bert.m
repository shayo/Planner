iAnatomicalVolumeIndex = 1;

iSelectedFunctional = 2;

strSessionName = 'D:\Data\Doris\Planner\Bert\Bert_Planner_For_Optogenetics_Paper.mat';
PlannerAPI('StartPlanner');
bSuccessful = PlannerAPI('LoadSession', strSessionName);

% Now, load the relevant 4D functional volume
%strctBOLD4D = MRIread('D:\Data\Doris\Planner\Julien\120315Julien - Functionals in Arch\anal_smooth_mean.nii');
strctBOLD4D_All = MRIread('D:\Data\Doris\Planner\Bert\120613-14Bert - ChR2 and Electrical\anal_smooth_avgfunc.nii');

strctBOLD4D_Even = MRIread('D:\Data\Doris\Planner\Bert\120613-14Bert - ChR2 and Electrical\Even Runs\anal_even_avgfunc.nii');

%%
apt3fROI = fnPlotAverageBOLDResponseAuxBert(strctBOLD4D_All,iAnatomicalVolumeIndex,'Injection Site ChR2 Small',iSelectedFunctional,278,[])

afPValues = fndllFastInterp3(PlannerAPI('GetFuncVol', 2), 1+apt3fROI(1,:),1+apt3fROI(2,:),1+apt3fROI(3,:));
mean(afPValues )

afPValues = fndllFastInterp3(PlannerAPI('GetFuncVol', 3), 1+apt3fROI(1,:),1+apt3fROI(2,:),1+apt3fROI(3,:));
mean(afPValues)
afPValues = fndllFastInterp3(PlannerAPI('GetFuncVol', 4), 1+apt3fROI(1,:),1+apt3fROI(2,:),1+apt3fROI(3,:));
mean(afPValues)

fnPlotAverageBOLDResponseAuxBert(strctBOLD4D_Even,iAnatomicalVolumeIndex,'V1 Odd',iSelectedFunctional,150,[-3 4]);

fnPlotAverageBOLDResponseAuxBert(strctBOLD4D_Even,iAnatomicalVolumeIndex,'V2 Odd',iSelectedFunctional,150,[-3 3]);
fnPlotAverageBOLDResponseAuxBert(strctBOLD4D_Even,iAnatomicalVolumeIndex,'V2 Odd 2',iSelectedFunctional,150,[-3 3]);

fnPlotAverageBOLDResponseAuxBert(strctBOLD4D_Even,iAnatomicalVolumeIndex,'V4 Odd',iSelectedFunctional,150,[-3 3]);
fnPlotAverageBOLDResponseAuxBert(strctBOLD4D_Even,iAnatomicalVolumeIndex,'3a Odd',iSelectedFunctional,150,[-3 3]);


fnPlotAverageBOLDResponseAuxBert(strctBOLD4D_Even,iAnatomicalVolumeIndex,'RH V2',iSelectedFunctional,150,[-1.5 2]);set(gca,'yticklabel',[]);

fnPlotAverageBOLDResponseAuxBert(strctBOLD4D_Even,iAnatomicalVolumeIndex,'RH V4',iSelectedFunctional,150,[-2 2]);set(gca,'yticklabel',[]);
fnPlotAverageBOLDResponseAuxBert(strctBOLD4D_Even,iAnatomicalVolumeIndex,'RH 3a',iSelectedFunctional,150,[-2 2]);set(gca,'yticklabel',[]);
fnPlotAverageBOLDResponseAuxBert(strctBOLD4D_Even,iAnatomicalVolumeIndex,'RH F4',iSelectedFunctional,150,[-5 5]);
fnPlotAverageBOLDResponseAuxBert(strctBOLD4D_Even,iAnatomicalVolumeIndex,'ROI Somato',iSelectedFunctional,150,[-5 5]);


% generate the coronal slices ?
a2fM = [-1.0000         0         0  -16.6107
    0    1.0000         0  -10.6260
    0         0   -1.0000    2.0000
    0         0         0    1.0000];
fRangeMM = 21;
acFunctionals = {'120613-14_3Cond_E-G','120613-14_3Cond_O-G','120613-14_3Cond_OE-G','120816Bert_2xO-G'};
for iFuncIter=1:length(acFunctionals)
    [a3fI, astrctSurfs]= PlannerAPI('RenderCrossSection',iAnatomicalVolumeIndex,acFunctionals{iFuncIter},a2fM,fRangeMM,[-7 -3 3 7]);
    figure(21+iFuncIter);
    clf;
    tightsubplot(1,1,1);
    imshow(a3fI);hold on;
%     for k=1:length(astrctSurfs)
%         fnPlotLinesAsSinglePatch(gca,astrctSurfs(k).m_a2fLines,astrctSurfs(k).m_afColor);
%     end
    set(gcf,'position',[  1014         916         156         143]);
end



% %%
%
% if 0
% % do polynomial fitting and remove... (?)
% afPolyCoeff = polyfit(1:iNumTimePoints,afMeanFuncValue,2);
% afPolyVal = polyval(afPolyCoeff,1:iNumTimePoints);
% afValuesAdjustedPoly = afMeanFuncValue-afPolyVal;
% afBOLD_Perc = 1e2*( afMeanFuncValue./mean(afMeanFuncValue)-1);
%
% % Preset as % of mean?
% figure(20);
% clf;
% subplot(3,1,1);
% hold on;
% plot(afMeanFuncValue)
% plot(afPolyVal,'r');
% ylabel('RAW BOLD values');
% set(gca,'xlim',[1 iNumTimePoints])
% subplot(3,1,2);
% hold on;
% plot(afValuesAdjustedPoly)
% set(gca,'xlim',[1 iNumTimePoints])
% ylabel('BOLD, corrected');
% subplot(3,1,3);
% plot(1e2*( afMeanFuncValue./mean(afMeanFuncValue)-1))
% ylabel('Bold % Change');
% set(gca,'xlim',[1 iNumTimePoints])
%
% end