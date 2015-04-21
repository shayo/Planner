function strctMesh = fnMeshRegionOfInterest(strName, astrctSortedSlices, acRegionsOfInterest, biLateral, fScaleDownFactor, fSmooth,fReduceFacesFactor, afMLrange,afDVrange)
iNumSlices = length(astrctSortedSlices);

% Find relevant slices
abRelevantSlices= zeros(1,iNumSlices)>0;
for iSliceIter=1:iNumSlices
    iNumRegionsInThisSlice = length(astrctSortedSlices(iSliceIter).m_acRegions);
    for iRegionIter=1:iNumRegionsInThisSlice
        if ismember(astrctSortedSlices(iSliceIter).m_acRegions{iRegionIter}.m_strName,acRegionsOfInterest)
           abRelevantSlices(iSliceIter)=true; 
        end
    end
end

afAPpos = cat(1,astrctSortedSlices.m_fPositionMM);
afAP_Range = afAPpos(abRelevantSlices);
iNumAPslices = max(afAP_Range) - min(afAP_Range)+1+2; % Adding two more to allow closed surfaces?
aiRelevantSlicesInd = find(abRelevantSlices);
if isempty(aiRelevantSlicesInd)
    strctMesh = [];
    return;
end;


a3bVol = zeros(length(afDVrange)*fScaleDownFactor,length(afMLrange)*fScaleDownFactor, iNumAPslices,'uint8')>0;
for iSliceIter=1:length(aiRelevantSlicesInd)
    iNumRegionsInSlice = length(astrctSortedSlices(aiRelevantSlicesInd(iSliceIter)).m_acRegions);
    a2bSlice = zeros(length(afDVrange)*fScaleDownFactor,length(afMLrange)*fScaleDownFactor,'uint8')>0;
    for iRegionIter=1:iNumRegionsInSlice
        if ismember(astrctSortedSlices(aiRelevantSlicesInd(iSliceIter)).m_acRegions{iRegionIter}.m_strName, acRegionsOfInterest);
            if ~isempty(astrctSortedSlices(aiRelevantSlicesInd(iSliceIter)).m_acRegions{iRegionIter}.m_apt2fCoordinates)
                afX = astrctSortedSlices(aiRelevantSlicesInd(iSliceIter)).m_acRegions{iRegionIter}.m_apt2fCoordinates(:,1);
                afY = astrctSortedSlices(aiRelevantSlicesInd(iSliceIter)).m_acRegions{iRegionIter}.m_apt2fCoordinates(:,2);
                
                a2bI = zeros(length(afDVrange)*fScaleDownFactor,length(afMLrange)*fScaleDownFactor,'uint8')>0;
                BW = roipoly(a2bI, afX*fScaleDownFactor,afY*fScaleDownFactor);
                a2bSlice = a2bSlice | BW;
            end
%             [afML, afDV] = fnConvertCroppedImageCoordsToAtlasCoords(afX,afY);
%             plot3(afML([1:end,1]),afDV([1:end,1]), ones(1,1+length(afX))*astrctSortedSlices(aiRelevantSlicesInd(iSliceIter)).m_fPositionMM,'color',strColor);
        end
    end
    a3bVol(:,:,iSliceIter) = a2bSlice;
end

% Smooth binary volume....
if fSmooth > 0
    a3bOut=fnMyClose(a3bVol,fSmooth);
else
    a3bOut=a3bVol;
end


afAP_Range_InVol = min(afAP_Range)-1:max(afAP_Range)+1 ;

if size(a3bOut,3) == 1
    % Tricky.... just one slice. 
    % We generate two and duplicate ? 
    a3bOutTmp = zeros( size(a3bOut,1), size(a3bOut,2), 2);
    a3bOutTmp(:,:,1) = a3bOut;
    a3bOutTmp(:,:,2) = a3bOut;
    strctMesh = isosurface(afMLrange(1:1/fScaleDownFactor:end) ,afDVrange(1:1/fScaleDownFactor:end), [afAP_Range_InVol-0.5,afAP_Range_InVol+0.5]',a3bOutTmp,0.5);
else
    strctMesh = isosurface(afMLrange(1:1/fScaleDownFactor:end) ,afDVrange(1:1/fScaleDownFactor:end), afAP_Range_InVol',a3bOut,0.5);
end

if fReduceFacesFactor ~= 1
    strctMesh = reducepatch(strctMesh, fReduceFacesFactor) ;
end

if biLateral
    a2fFlippedML = strctMesh.vertices;
    a2fFlippedML(:,1) = -a2fFlippedML(:,1);
    
    strctMesh.vertices = [strctMesh.vertices; a2fFlippedML];
    strctMesh.faces = [strctMesh.faces; strctMesh.faces+ size(a2fFlippedML,1)];
end
strctMesh.name = strName;

% 
% figure(2);
% clf;
% h=patch(fv);
% 
% set(h,'FaceColor','b','EdgeColor','none','facealpha',0.6);
%         camlight('right')
%         lighting('gouraud');
% axis equal

% 
% X=imread('D:\Code\Doris\MRI\planner\AtlasMarker\Pictures\Test_rect.bmp');
% figure(10);
% clf;
% imshow(X)
% [x,y]=ginput(1)
% [ML,DV]=fnConvertCroppedImageCoordsToAtlasCoords(x,y)
