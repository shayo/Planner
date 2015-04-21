function [apt3fAnnotationInMRImm, acAnnotationType, acSliceName, aiAnnotationIndex]=fnConvertAnnotationToMRICoordinates(strctFluorescence, strctPlanner)
%% Convert annotation to MRI coordinates
% This is tricky. it involves multiple transformations
% and the data is in two separate sources (strctFluorescence,
% strctPlanner)....

apt3fAnnotationInMRImm= zeros(0,3);
iCounter = 1;
acAnnotationType = cell(0);
acSliceName = cell(0);
aiAnnotationIndex = zeros(0);
for iTissueBlockIter=1:length(strctFluorescence.astrctTissueBlock)
    
    [p,strSlice]=fileparts(strctFluorescence.astrctTissueBlock(iTissueBlockIter).m_strName);
    iIndexInPlanner = -1;
    iSeriesIndexInPlanner = -1;
    for iSeriesIter=1:length(strctPlanner.g_strctModule.m_astrctImageSeries)
        for k=1:length(strctPlanner.g_strctModule.m_astrctImageSeries(iSeriesIter).m_acImages)
            if strcmpi(strctPlanner.g_strctModule.m_astrctImageSeries(iSeriesIter).m_acImages{k}.m_strName,strSlice)
                iIndexInPlanner = k;
                iSeriesIndexInPlanner = iSeriesIter;
                break;
            end
        end
    end
    if iIndexInPlanner == -1
        % No knowledge about this in planner...
        fprintf('Skipping %s (no planner data)\n',strctFluorescence.astrctTissueBlock(iTissueBlockIter).m_strName);
        continue;
    end
    for iWideFieldIter=1:length(strctFluorescence.astrctTissueBlock(iTissueBlockIter).m_astrctWideField)
        
        % Convert annotations represented in wide field coordinates
        if ~isempty(strctFluorescence.astrctTissueBlock(iTissueBlockIter).m_astrctWideField(iWideFieldIter).m_astrctAnnoation)
            for iIter=1:length(strctFluorescence.astrctTissueBlock(iTissueBlockIter).m_astrctWideField(iWideFieldIter).m_astrctAnnoation)
                % Convert coordinates to cross section
                pt3fWideFieldPix = strctFluorescence.astrctTissueBlock(iTissueBlockIter).m_astrctWideField(iWideFieldIter).m_astrctAnnoation(iIter).m_pt3fPosition; 
                a2fRegToTissueBlock = strctFluorescence.astrctTissueBlock(iTissueBlockIter).m_astrctWideField(iWideFieldIter).m_a2fRegToTissueBlock;
                pt3fMRI_Coord=fnWideFieldPixToMRImm(pt3fWideFieldPix, strctPlanner,iSeriesIndexInPlanner,iIndexInPlanner,a2fRegToTissueBlock);
                
                apt3fAnnotationInMRImm(iCounter,:) = pt3fMRI_Coord(1:3);
                acAnnotationType{iCounter} = strctFluorescence.astrctTissueBlock(iTissueBlockIter).m_astrctWideField(iWideFieldIter).m_astrctAnnoation(iIter).m_strDescription;
                acSliceName{iCounter} =  strctFluorescence.astrctTissueBlock(iTissueBlockIter).m_strName;
                aiAnnotationIndex(iCounter) = iIter;
                iCounter=iCounter+1;
                % Project this back to the cross section to see if it make
                % sense?
                
%                 a2fPlane = strctPlannerInfo.m_a2fImagePlaneTo3D;
%                 a2fPlane(1:3,4) = a2fPlane(1:3,4)+a2fPlane(1:3,3) * strctPlannerInfo.m_acImages{iIndexInPlanner}.m_fZOffsetMM;
%                 
%                  [pt3fNearestPointOnPlane, pt2fImageMM,Dist] = fnProjectPointOnCrossSection(a2fPlane, pt3fMRI_Coord);
%                  
%                 apt2iPointPix = fnCrossSection_MM_To_Image(strctCrossSection, pt2fImageMM');
%                 figure(10);clf;
%                 imshow(a3fTissueBlockinMRI,[]);
%                 hold on;
%                 plot(apt2iPointPix(1),apt2iPointPix(2),'r+');
%                
                
            end
            
         
            
        end
        
           
        % Now convert the high magnification annotation
        
        iNumHighRes = length(strctFluorescence.astrctTissueBlock(iTissueBlockIter).m_astrctWideField(iWideFieldIter).m_astrctHighMag);
        for iHighResIter=1:iNumHighRes
            iNumAnnotations = length(strctFluorescence.astrctTissueBlock(iTissueBlockIter).m_astrctWideField(iWideFieldIter).m_astrctHighMag(iHighResIter).m_astrctAnnoation);
            for iAnnoIter=1:iNumAnnotations
                pt3fPos = [strctFluorescence.astrctTissueBlock(iTissueBlockIter).m_astrctWideField(iWideFieldIter).m_astrctHighMag(iHighResIter).m_astrctAnnoation(iAnnoIter).m_pt3fPosition(1:2)';1];
                % Coordinate is in high mag. Need to convert to wide field
                % first...
                pt3fWideFieldPix = inv(strctFluorescence.astrctTissueBlock(iTissueBlockIter).m_astrctWideField(iWideFieldIter).m_astrctHighMag(iHighResIter).m_a2fRegToWideField) * pt3fPos;
                a2fRegToTissueBlock = strctFluorescence.astrctTissueBlock(iTissueBlockIter).m_astrctWideField(iWideFieldIter).m_a2fRegToTissueBlock;
                pt3fMRI_Coord=fnWideFieldPixToMRImm(pt3fWideFieldPix, strctPlanner,iSeriesIndexInPlanner,iIndexInPlanner,a2fRegToTissueBlock);
                apt3fAnnotationInMRImm(iCounter,:) = pt3fMRI_Coord(1:3);
                acAnnotationType{iCounter} = strctFluorescence.astrctTissueBlock(iTissueBlockIter).m_astrctWideField(iWideFieldIter).m_astrctHighMag(iHighResIter).m_astrctAnnoation(iAnnoIter).m_strDescription;
                acSliceName{iCounter} =  strctFluorescence.astrctTissueBlock(iTissueBlockIter).m_strName;
                aiAnnotationIndex(iCounter) = iAnnoIter;
                iCounter=iCounter+1;

            end
            
        end
        
        dbg = 1;
        
    end
end



function pt3fMRI_Coord=fnWideFieldPixToMRImm(pt3fWideFieldPix, strctPlanner,iSeriesIndexInPlanner,iIndexInPlanner,a2fRegToTissueBlock)

pt2fTissueBlockCoordPix = inv(a2fRegToTissueBlock) * [pt3fWideFieldPix(1);pt3fWideFieldPix(2);1];
% Register tissue block coordinates to MRI

strctPlannerInfo = strctPlanner.g_strctModule.m_astrctImageSeries(iSeriesIndexInPlanner);
a2fMMtoPix = strctPlannerInfo.m_acImages{iIndexInPlanner}.m_a2fMMtoPix;

pt2fCrossSectionMM = inv(a2fMMtoPix) * pt2fTissueBlockCoordPix;
pt3fCrossSectionMMwithHeight = [pt2fCrossSectionMM(1);pt2fCrossSectionMM(2);strctPlannerInfo.m_acImages{iIndexInPlanner}.m_fZOffsetMM ;1];

pt3fMRI_Coord = strctPlannerInfo.m_a2fImagePlaneTo3D * pt3fCrossSectionMMwithHeight;
