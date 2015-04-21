function fnPlotRegionOfInterest(strctAtlas, astrctSortedSlices, strRegionOfInterest, a2bSlicesRegionMatch,strColor)
iRegionIndex = find(ismember(strctAtlas.m_acRegions, strRegionOfInterest));
aiRelevantSlicesInd = find(a2bSlicesRegionMatch(:,iRegionIndex));

afAP_Range = cat(1,astrctSortedSlices(aiRelevantSlicesInd).m_fPositionMM);
iNumAPslices = max(afAP_Range) - min(afAP_Range);

for iSliceIter=1:length(aiRelevantSlicesInd)
    iNumRegionsInSlice = length(astrctSortedSlices(aiRelevantSlicesInd(iSliceIter)).m_acRegions);
    for iRegionIter=1:iNumRegionsInSlice
        if strcmpi(astrctSortedSlices(aiRelevantSlicesInd(iSliceIter)).m_acRegions{iRegionIter}.m_strName, strRegionOfInterest);
            afX = astrctSortedSlices(aiRelevantSlicesInd(iSliceIter)).m_acRegions{iRegionIter}.m_apt2fCoordinates(:,1);
            afY = astrctSortedSlices(aiRelevantSlicesInd(iSliceIter)).m_acRegions{iRegionIter}.m_apt2fCoordinates(:,2);
            [afML, afDV] = fnConvertCroppedImageCoordsToAtlasCoords(afX,afY);
            plot3(afML([1:end,1]),afDV([1:end,1]), ones(1,1+length(afX))*astrctSortedSlices(aiRelevantSlicesInd(iSliceIter)).m_fPositionMM,'color',strColor);
        end
    end
end