function a3bOut = fnBinarizeRegionOfInterest(strName, astrctSortedSlices, acRegionsOfInterest, biLateral,  fSmooth,bFlipX, afMLrange,afDVrange)
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
afAP_Range = afAPpos(:);
iNumAPslices = max(afAP_Range) - min(afAP_Range)+1+2; % Adding two more to allow closed surfaces?
aiRelevantSlicesInd = 1:length(astrctSortedSlices);


[fDummy,iZeroMLIndex]=min(abs(afMLrange));
a3bVol = zeros(length(afDVrange),length(afMLrange), iNumAPslices,'uint8')>0;
if isempty(aiRelevantSlicesInd)
    a3bOut = [];
    return;
end;

for iSliceIter=1:length(aiRelevantSlicesInd)
    iNumRegionsInSlice = length(astrctSortedSlices(aiRelevantSlicesInd(iSliceIter)).m_acRegions);
    a2bSlice = zeros(length(afDVrange),length(afMLrange),'uint8')>0;
    for iRegionIter=1:iNumRegionsInSlice
        if ismember(astrctSortedSlices(aiRelevantSlicesInd(iSliceIter)).m_acRegions{iRegionIter}.m_strName, acRegionsOfInterest);
            if ~isempty(astrctSortedSlices(aiRelevantSlicesInd(iSliceIter)).m_acRegions{iRegionIter}.m_apt2fCoordinates)
                afX = astrctSortedSlices(aiRelevantSlicesInd(iSliceIter)).m_acRegions{iRegionIter}.m_apt2fCoordinates(:,1);
                afY = astrctSortedSlices(aiRelevantSlicesInd(iSliceIter)).m_acRegions{iRegionIter}.m_apt2fCoordinates(:,2);
                if bFlipX
                    afX = iZeroMLIndex-(afX-iZeroMLIndex);
                end
                
                
                if ~bFlipX && ~biLateral
                    afX = max(afX,iZeroMLIndex);
                end
                if bFlipX && ~biLateral
                    afX = min(afX,iZeroMLIndex);
                end

                
                a2bI = zeros(length(afDVrange),length(afMLrange),'uint8')>0;
                BW = roipoly(a2bI, afX,afY);
                a2bSlice = a2bSlice | BW;
                

            if biLateral
                a2bI = zeros(length(afDVrange),length(afMLrange),'uint8')>0;
                BW = roipoly(a2bI, iZeroMLIndex-(afX-iZeroMLIndex),afY);
                a2bSlice = a2bSlice | BW;    
            end
    
            end
        end
    end
    a3bVol(:,:,1+iSliceIter) = a2bSlice; % to allow closing later?
end

% Smooth binary volume....
if fSmooth > 0
    a3bOut=fnMyClose(a3bVol,fSmooth);
else
    a3bOut=a3bVol;
end
