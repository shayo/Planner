% Small script to overlay wide field flu image (/high magnification /
% annotations) on MRI slice

%% 1. Load ImageRegis data base
strImageRegisDataBaseFile = 'ImageRegisCache.mat';
strctFluorescence = load(strImageRegisDataBaseFile);


%% 2. Load The Planner Session
%strPlannerSession = 'C:\Users\shayo\SkyDrive\Planner Data\PlannerSessionBert_Histology_21_Mar_2013.mat';
strPlannerSession = 'C:\Users\shayo\SkyDrive\Planner Data\PlannerSessionBert_Histology_13_Jun_2013.mat';

strctPlanner = load(strPlannerSession);


iAnatomical = 1;
iChamber = 1;
iGrid = 3;
astrctElectrodeProjectionToTissueBlock=fnProjectElectrodeOnTissueBlock(strctPlanner, iAnatomical, iChamber, iGrid);
acTissueBlocksRegisteredInPlanner = {astrctElectrodeProjectionToTissueBlock.m_strFileName};
%% Update the flurescence structure to contain electrode projection...
iNumTissueBlock = length(strctFluorescence.astrctTissueBlock);
for k=1:iNumTissueBlock
    iIndex = find(ismember(acTissueBlocksRegisteredInPlanner,strctFluorescence.astrctTissueBlock(k).m_strFullPath));
    if ~isempty(iIndex)
        strctFluorescence.astrctTissueBlock(k).m_a2fElectrodeProjectionLines = astrctElectrodeProjectionToTissueBlock(iIndex).m_a2fLines;
    end
end
astrctTissueBlock = strctFluorescence.astrctTissueBlock;
% save(strImageRegisDataBaseFile,'astrctTissueBlock');

%% Convert annotation to MRI 3D coordinates
[apt3fAnnotationInMRImm, acAnnotationType, acSliceName,aiAnnotationIndex]=fnConvertAnnotationToMRICoordinates(strctFluorescence, strctPlanner);
iNumAnnotations = size(apt3fAnnotationInMRImm,1);

% Convert annotation representation to [Z (relative to grid top), r
% (distance from electrode), Theta (rotation relative to chamber/grid
% orientation)


% First, convert chamber/grid to MM space
a2fXYZ_To_CRS = inv(strctPlanner.g_strctModule.m_acAnatVol{iAnatomical}.m_a2fM) * inv(strctPlanner.g_strctModule.m_acAnatVol{iAnatomical}.m_a2fReg);  
a2fChamberVox = strctPlanner.g_strctModule.m_acAnatVol{iAnatomical}.m_astrctChambers(iChamber).m_a2fM_vox;
a2fChamberMM = inv(a2fXYZ_To_CRS)*a2fChamberVox;
a2fChamberMM(1:3,3) = -a2fChamberMM(1:3,3); % Positive direction is now down...
% Shift the chamber center and align the origin with the electrode of
% interest....

iChR2_Hole = 50;
iArch_Hole = 79;
iHalo_Hole = 96;
% figure(11);
% clf;
% plot(strctPlanner.g_strctModule.m_acAnatVol{iAnatomical}.m_astrctChambers(iChamber).m_astrctGrids(iGrid).m_strctModel.m_afGridHolesX,...
%     strctPlanner.g_strctModule.m_acAnatVol{iAnatomical}.m_astrctChambers(iChamber).m_astrctGrids(iGrid).m_strctModel.m_afGridHolesY,'ko');
% hold on;
% plot(strctPlanner.g_strctModule.m_acAnatVol{iAnatomical}.m_astrctChambers(iChamber).m_astrctGrids(iGrid).m_strctModel.m_afGridHolesX(iChR2_Hole),...
%     strctPlanner.g_strctModule.m_acAnatVol{iAnatomical}.m_astrctChambers(iChamber).m_astrctGrids(iGrid).m_strctModel.m_afGridHolesY(iChR2_Hole),'bo','LineWidth',4);
% plot(strctPlanner.g_strctModule.m_acAnatVol{iAnatomical}.m_astrctChambers(iChamber).m_astrctGrids(iGrid).m_strctModel.m_afGridHolesX(iArch_Hole),...
%     strctPlanner.g_strctModule.m_acAnatVol{iAnatomical}.m_astrctChambers(iChamber).m_astrctGrids(iGrid).m_strctModel.m_afGridHolesY(iArch_Hole),'go','LineWidth',4);
% plot(strctPlanner.g_strctModule.m_acAnatVol{iAnatomical}.m_astrctChambers(iChamber).m_astrctGrids(iGrid).m_strctModel.m_afGridHolesX(iHalo_Hole),...
%     strctPlanner.g_strctModule.m_acAnatVol{iAnatomical}.m_astrctChambers(iChamber).m_astrctGrids(iGrid).m_strctModel.m_afGridHolesY(iHalo_Hole),'yo','LineWidth',4);

%%
aiInjectionSites = find(strctPlanner.g_strctModule.m_acAnatVol{iAnatomical}.m_astrctChambers(iChamber).m_astrctGrids(iGrid).m_strctModel.m_strctGridParams.m_abSelectedHoles);
iInjectionSiteIndex = 1; % ChR2

fX_Offset = strctPlanner.g_strctModule.m_acAnatVol{iAnatomical}.m_astrctChambers(iChamber).m_astrctGrids(iGrid).m_strctModel.m_afGridHolesX(aiInjectionSites(iInjectionSiteIndex));
fY_Offset = strctPlanner.g_strctModule.m_acAnatVol{iAnatomical}.m_astrctChambers(iChamber).m_astrctGrids(iGrid).m_strctModel.m_afGridHolesY(aiInjectionSites(iInjectionSiteIndex));
a2fGridMM = a2fChamberMM;
a2fGridMM(1:3,4) = a2fChamberMM(1:3,4) - a2fChamberMM(1:3,1) * fX_Offset + a2fChamberMM(1:3,2) * fY_Offset;



afDistRelativeToGridTopMM = zeros(1,iNumAnnotations);
afRadiusMM = zeros(1,iNumAnnotations);
afAngleDeg = zeros(1,iNumAnnotations);
apt3fNearestPointOnPlane  = zeros(3,iNumAnnotations);
apt2fImageMM= zeros(2,iNumAnnotations);
for iIter=1:iNumAnnotations
    [apt3fNearestPointOnPlane(:,iIter), apt2fImageMM(:,iIter),afDistRelativeToGridTopMM(iIter)] = fnProjectPointOnCrossSection(a2fGridMM, apt3fAnnotationInMRImm(iIter,:)');
    afRadiusMM(iIter) = norm(apt2fImageMM(:,iIter));
    afAngleDeg(iIter) = atan2(apt2fImageMM(2,iIter),apt2fImageMM(1,iIter))/pi*180;
end
% Final plot. Density / number of cells as a function of height and radius
% figure(22);
% clf;hold on;
% plot(afRadiusMM,afDistRelativeToGridTopMM,'g.');
% %plot(afRadiusMM(abNeuN),afDistRelativeToGridTopMM(abNeuN),'o','color',[0.5 0.5 0.5]);
% %plot(afRadiusMM(abYFP_PV),afDistRelativeToGridTopMM(abYFP_PV),'m*');
% xlabel('Distance from injection site (mm)');
% ylabel('Depth (mm)');
% axis ij
% [x,y]=ginput(1)
% [fDummy,iIndex]=min((afRadiusMM-x).^2+(afDistRelativeToGridTopMM-y).^2);
% acSliceName{iIndex}
% 
% aiAnnotationIndex(iIndex)


% 
% afXRange = 20:0.05:33;
% afYRange = 0:0.05:4;
% a2fKernel = fspecial('gaussian',[10 10],5);
% a2fKernel = a2fKernel/sum(a2fKernel(:));
% a2fHist = conv2(hist2mod(afDistRelativeToGridTopMM(abYFP),afRadiusMM(abYFP), afXRange,afYRange),a2fKernel,'same');
% figure(5);
% imagesc(afYRange,afXRange,a2fHist');
% colorbar





afXRangeHigh = 28.5-1.5:0.05:33;
afYRangeHigh = 0:0.05:4;
[a2fX,a2fY] = meshgrid(afXRangeHigh,afYRangeHigh);
afXRange = 28.5-1.5:0.1:33;
afYRange = 0:0.1:4;
a2fHist = hist2mod(afDistRelativeToGridTopMM,afRadiusMM, afXRange,afYRange);
a2fSuperSampled = griddata(afXRange,afYRange,a2fHist,a2fX,a2fY,'cubic');
figure(18);
imagesc(afYRangeHigh,afXRangeHigh-28.5,a2fSuperSampled',[0 15]);

X=colormap('hot');
Y=X(:,[2,1,3]);
colormap(Y);
% colorbar('location','NorthOutside')
set(gca,'ytick',-4:4,'xtick',0:1:4)
set(gca,'fontsize',7);
set(gcf,'position',[   1278         864         116         234]);
hold on;
if iInjectionSiteIndex == 1
    rectangle('position',[0.1 2 0.5 0.5],'edgecolor','r');
end
% xlabel('Distance from injection site/electrode (mm)');
% ylabel('Depth relative to grid top (mm)');
% cbar_handle = findobj(gcf,'tag','Colorbar');

% figure(6);clf;
% [afHist,afCent]=hist(afAngleDeg,-180:10:180)
% plot(afCent,afHist,'k','LineWidth',2);
% set(gca,'fontsize',7,'xticklabel',[]);
% set(gcf,'position',[1068         993         172*0.7         105*0.7])



iNumRounds = 15000;
% Draw random numbers
a2fRand = rand(iNumRounds, 2);
afRandDepth = a2fRand(:,1)*5-1; % random samples between -1 and 5
afRandRadius = a2fRand(:,2)*2; % Between 0..2
afDistRelativeToInjection = afDistRelativeToGridTopMM-28.5;
afDist = zeros(1,iNumRounds);
W = 0.25;
for k=1:iNumRounds
    afDist(k) = sum(afDistRelativeToInjection >= afRandDepth(k) - W/2 & afDistRelativeToInjection <= afRandDepth(k) + W/2 & ...
         afRadiusMM >= afRandRadius(k)-W/2 &    afRadiusMM <= afRandRadius(k)+W/2);
end
 %Count how many are close to the speial site
 fDepthOfInterest = 2.2;
 fRadiusOfInterest = 0.5;
 iSumAtSpecialSite = sum(afDistRelativeToInjection >= fDepthOfInterest - W/2 & afDistRelativeToInjection <= fDepthOfInterest + W/2 & ...
         afRadiusMM >= fRadiusOfInterest-W/2 &    afRadiusMM <= fRadiusOfInterest+W/2);

sum(afDist >iSumAtSpecialSite) / iNumRounds

afHistBins = 0:0.1:5;
[afHist]=histc(afRadiusMM(afDistRelativeToGridTopMM > 28), afHistBins);
afCircumference = 2*pi*afHistBins;
figure(7);
clf;
[ax,h1,h2]=plotyy(afHistBins,afHist,afHistBins,afHist./afCircumference);
set(h1,'color','k','linewidth',2);
set(h2,'color',[0.5 0.5 0.5],'linewidth',2,'linestyle','-');
set(ax(1),'yColor','k','fontsize',7,'xticklabel',[]);
set(ax(2),'ycolor',[0.5 0.5 0.5],'fontsize',7,'xticklabel',[]);
set(ax(1),'xtick',0:1:4,'xlim',[0 4],'fontsize',7)
set(ax(2),'xtick',0:1:4,'xlim',[0 4],'fontsize',7)
set(gcf,'position',[1068         593         172*0.7         105*0.7])
set(gca,'YAxisLocation','left','xticklabel',[],'ytick',[0 100 200])
set(gca,'fontsize',7);

% plot(afHistBins,afHist./afCircumference,'k','LineWidth',2);
% set(gca,'xtick',0:1:4,'xlim',[0 4],'fontsize',7)
% set(gcf,'position',[1068         593         172*0.7         105*0.7])
% set(gca,'YAxisLocation','left','xtick',[],'xticklabel',[],'ytick',[0 50])
% set(gca,'fontsize',7);



[afHist]=histc(afDistRelativeToGridTopMM(afRadiusMM< 2)-28.5, -1.5:0.1:4.5)
figure(8);
clf;
plot(afHist,-1.5:0.1:4.5,'k','LineWidth',2);
axis ij
set(gca,'ylim',[-1.5 4.5])
set(gca,'xtick',[ 0 50 100],'YAxisLocation','right');

set(gcf,'position',[1068         617         120         235])
set(gca,'fontsize',7);
hold on;
%%

% 
% 
% a2fCol = jet(16);
% a2fColors = flipud(a2fCol([1 5 7 10 14],:));
% figure(9);clf;hold on;
% for k=1:size(afYRangeSmall,2)
%     plot(afXRangeSmall-22,a2fHistSmall(k,:),'color',a2fColors(k,:),'linewidth',2);
%     acY{k}=afYRangeSmall(k);
% end;
% set(gca,'xlim',[0 10]);
% legend(acY);





% % Plot Annotation relative to chamber
figure(111);
clf;hold on;
plot3(a2fChamberMM(1,4),a2fChamberMM(2,4),a2fChamberMM(3,4),'b*');
plot3(a2fChamberMM(1,4)+[0,a2fChamberMM(1,3)*50],a2fChamberMM(2,4)+[0,a2fChamberMM(2,3)*50],a2fChamberMM(3,4)+[0,a2fChamberMM(3,3)*50],'k');
plot3(a2fChamberMM(1,4)+[0,a2fChamberMM(1,1)*10],a2fChamberMM(2,4)+[0,a2fChamberMM(2,1)*10],a2fChamberMM(3,4)+[0,a2fChamberMM(3,1)*10],'r');
plot3(a2fChamberMM(1,4)+[0,a2fChamberMM(1,2)*10],a2fChamberMM(2,4)+[0,a2fChamberMM(2,2)*10],a2fChamberMM(3,4)+[0,a2fChamberMM(3,2)*10],'m');

plot3(a2fGridMM(1,4)+[0,a2fGridMM(1,3)*50],a2fGridMM(2,4)+[0,a2fGridMM(2,3)*50],a2fGridMM(3,4)+[0,a2fGridMM(3,3)*50],'b','LineWidth',2);



iNumHoles = length(strctPlanner.g_strctModule.m_acAnatVol{iAnatomical}.m_astrctChambers(iChamber).m_astrctGrids(iGrid).m_strctModel.m_afGridHolesX);
afX = strctPlanner.g_strctModule.m_acAnatVol{iAnatomical}.m_astrctChambers(iChamber).m_astrctGrids(iGrid).m_strctModel.m_afGridHolesX;
afY = strctPlanner.g_strctModule.m_acAnatVol{iAnatomical}.m_astrctChambers(iChamber).m_astrctGrids(iGrid).m_strctModel.m_afGridHolesY;
aiInjectionSites = find(strctPlanner.g_strctModule.m_acAnatVol{iAnatomical}.m_astrctChambers(iChamber).m_astrctGrids(iGrid).m_strctModel.m_strctGridParams.m_abSelectedHoles);
for k=1:iNumHoles
    pt3fPos = a2fChamberMM(1:3,4) - a2fChamberMM(1:3,1) * afX(k) + a2fChamberMM(1:3,2) * afY(k);
    
    if sum(k == aiInjectionSites) > 0
        plot3(pt3fPos(1),pt3fPos(2),pt3fPos(3),'ro');
        text(pt3fPos(1),pt3fPos(2),pt3fPos(3),num2str(k));
    else
        plot3(pt3fPos(1),pt3fPos(2),pt3fPos(3),'ko');
    end
end
axis equal


plot3(a2fGridMM(1,4),a2fGridMM(2,4),a2fGridMM(3,4),'g*');

plot3(a2fGridMM(1,4)+[0,a2fGridMM(1,3)*30.5],a2fGridMM(2,4)+[0,a2fGridMM(2,3)*30.5],a2fGridMM(3,4)+[0,a2fGridMM(3,3)*30.5],'m*');

plot3(apt3fAnnotationInMRImm(:,1),apt3fAnnotationInMRImm(:,2),apt3fAnnotationInMRImm(:,3),'k.');

% % Convert annotation to voxel coordinates for verification purposes...
% 
% apt3fAnnotationVoxels = a2fXYZ_To_CRS*[apt3fAnnotationInMRImm'; ones(1,iNumAnnotations)];


fnSampleImagePatchAtAnnotation(strctFluorescence, strctPlanner);


% 

% 
% 
% acTissueBlockName = cell(1,iNumTissueBlock);
% for j=1:iNumTissueBlock
%     acTissueBlockName{j}=strctPlanner.g_strctModule.m_astrctImageSeries(iTissueBlockSeries).m_acImages{j}.m_strFileName;
% end
% 
% for k=1:length(strctFluorescence.astrctTissueBlock)
%     iIndex = find(ismember(acTissueBlockName,strctFluorescence.astrctTissueBlock(k).m_strFullPath));
%     if ~isempty(iIndex)
%         iNumWideField = length(strctFluorescence.astrctTissueBlock(k));
%         for iWideFieldIter=1:iNumWideField 
%             % Convert wide field annotation
%             strctFluorescence.astrctTissueBlock(k).m_astrctWideField(iWideFieldIter).m_astrctAnnoation
%         end
%         
%     end
% end
% 
% 
% 
% 
% 
% 
% %% Run  Planner
% 
% PlannerAPI('StartPlanner')
% PlannerAPI('LoadSession',strPlannerSession);
%  
% 
% %% 3. Pick an image
% iSelectedWideField = 1; % Useually we have only one wide field fluoresence per tissue block
% 
% iSelectedSeries = 1;
% strSelectedTissueBlock = '0452.jpg'; 
% iSelectedTissueBlockImage = find(ismember({strctFluorescence.astrctTissueBlock.m_strName},strSelectedSeries));;
% 
% [p,strSlice]=fileparts(strctFluorescence.astrctTissueBlock(iSelectedTissueBlockImage).m_strName);
% 
% fprintf('Rendering %s\n',strSlice);
% 
% %% 4. Search for this image in planner database...
% iIndexInPlanner = -1;
% for k=1:length(strctPlanner.g_strctModule.m_astrctImageSeries(iSelectedSeries).m_acImages)
%     if strcmpi(strctPlanner.g_strctModule.m_astrctImageSeries(iSelectedSeries).m_acImages{k}.m_strName,strSlice)
%         iIndexInPlanner = k;
%         break;
%     end
% end
% if (iIndexInPlanner == -1)
%     fprintf('Failed to find that slice in planner image series...\n');
%     return;
% end
% 
% %% 5. Find the cross section transformation to render
% a2fM = strctPlanner.g_strctModule.m_astrctImageSeries(iSelectedSeries).m_a2fImagePlaneTo3D;
% a2fM(1:3,4) = a2fM(1:3,4) + a2fM(1:3,3) * strctPlanner.g_strctModule.m_astrctImageSeries(iSelectedSeries).m_acImages{iIndexInPlanner}.m_fZOffsetMM;
% 
% 
% %% Render MRI slice.
% 
% 
% [a3fMRI,~,strctCrossSection,a2fXmm,a2fYmm] = PlannerAPI('RenderCrossSection',1,[],a2fM,32);
% iResHeight = size(a3fMRI,1);
% iResWidth = size(a3fMRI,2);
% 
% %% Render Tissue block in MRI coordinates
% 
% a2fMMtoPix = strctPlanner.g_strctModule.m_astrctImageSeries(iSelectedSeries).m_acImages{iIndexInPlanner}.m_a2fMMtoPix;
% a2fResample = strctPlanner.g_strctModule.m_astrctImageSeries(iSelectedSeries).m_acImages{iIndexInPlanner}.m_a2fSubSampling;
% a2fImagePlaneTo3D = strctPlanner.g_strctModule.m_astrctImageSeries(iSelectedSeries).m_a2fImagePlaneTo3D;
% 
% a2fZmm = zeros(size(a2fXmm));
% a2fOnes = ones(size(a2fZmm));
% apt3fInVolMM = inv(a2fImagePlaneTo3D)*a2fM  * [a2fXmm(:), a2fYmm(:),a2fZmm(:),a2fOnes(:)]';
% ZPlane = apt3fInVolMM(3,1);
% afXmmT = apt3fInVolMM(1,:);
% afYmmT = apt3fInVolMM(2,:);
%                 
%               
% a2fTissueBlockCoordPix= a2fResample * a2fMMtoPix * [afXmmT;afYmmT;a2fOnes(:)'];                        
% 
% a3fTissueBlockinMRI = zeros(iResHeight,iResWidth,3);
% for iColorMap=1:3
%     a3fTissueBlockinMRI(:,:,iColorMap) = reshape(fndllFastInterp2(strctPlanner.g_strctModule.m_astrctImageSeries(iSelectedSeries).m_acImages{iIndexInPlanner}.m_Data(:,:,iColorMap), ...
%         1+a2fTissueBlockCoordPix(1,:),1+a2fTissueBlockCoordPix(2,:),NaN), size(a2fXmm))/255;
% end
% 
% 
% %% Render wide field fluorescence in MRI coordinates.
% % Load wide field image to memory
% strctWideField=strctFluorescence.astrctTissueBlock(iSelectedTissueBlockImage).m_astrctWideField(iSelectedWideField);
% [a4fWideField, astrctWideFieldChannels] = fnReadWideFieldFluoresenceImage(strctWideField.m_strFullPath);
% 
% % We have the 2D pixel coordinates in tissue block, so now lets transform
% % them to wide field coordinates...
% a2fWideFieldCoordPix = (strctWideField.m_a2fRegToTissueBlock) * a2fTissueBlockCoordPix;
% iNumColorMaps = length(astrctWideFieldChannels);
% 
% a3fWideFieldinMRI = zeros(iResHeight,iResWidth,iNumColorMaps);
% for iColorMap=1:iNumColorMaps
%     a3fWideFieldinMRI(:,:,iColorMap) = reshape(fndllFastInterp2(...
%         a4fWideField(:,:,iColorMap), ...
%         1+a2fWideFieldCoordPix(1,:),1+a2fWideFieldCoordPix(2,:),NaN), size(a2fXmm));
% end
% 
% %%
% a3fRGB = zeros(iResHeight,iResWidth,3);
% for k=1:3
%     a2fWideField = a3fTissueBlockinMRI(:,:,k);
%     a2bValid = ~isnan(a2fWideField);
%     a2fMRI = a3fMRI(:,:,k);
%     a2fMRI(a2bValid) = a2fWideField(a2bValid);
%     a3fRGB(:,:,k) = a2fMRI;
% end
% % Map a channel in wide field to MRI
% iSelectedWideFieldChannel = 3;
% a2fWideFieldFluo = a3fWideFieldinMRI(:,:,iSelectedWideFieldChannel);
% a2bValid = ~isnan(a2fWideFieldFluo);
% a2fRGB = a3fRGB(:,:,1);
% a2fRGB(a2bValid) = min(1,a2fWideFieldFluo(a2bValid)/4096);
%  a3fRGB(:,:,1) = a2fRGB;
%  
% figure(2);clf;imshow(a3fRGB)
%  
% %%
% 
% figure(2);clf;imshow(a3fRGB)
% 
% 
% 
% % Render High Magnification
% 
% % Render annotations
% 
