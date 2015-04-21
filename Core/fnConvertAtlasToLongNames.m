function strctAtlas = fnConvertAtlasToLongNames(strctAtlas)
[acLongNames, acShortNames] = fnGetAtlasNamingTable();

for iRegionIter=1:length(strctAtlas.m_acRegions)
        iIndex = find(ismember(lower(acShortNames), lower(strctAtlas.m_acRegions{iRegionIter})),1,'first');
        if ~isempty(iIndex)
            strctAtlas.m_acRegions{iRegionIter} =  [acLongNames{iIndex},' (', strctAtlas.m_acRegions{iRegionIter},')'];
        end
end

for iSliceIter=1:length(strctAtlas.m_astrctSlices)
    for iRegionIter=1:length(    strctAtlas.m_astrctSlices(iSliceIter).m_acRegions)
        iIndex = find(ismember(lower(acShortNames), lower(strctAtlas.m_astrctSlices(iSliceIter).m_acRegions{iRegionIter}.m_strName)),1,'first');
        if ~isempty(iIndex)
            strctAtlas.m_astrctSlices(iSliceIter).m_acRegions{iRegionIter}.m_strName = [acLongNames{iIndex},' (',strctAtlas.m_astrctSlices(iSliceIter).m_acRegions{iRegionIter}.m_strName,')'];
        end
    end
end

for iMeshIter=1:length(strctAtlas.m_astrctMesh)
            iIndex = find(ismember(lower(acShortNames), lower(strctAtlas.m_astrctMesh(iMeshIter).name)),1,'first');
        if ~isempty(iIndex)
            strctAtlas.m_astrctMesh(iMeshIter).name =  [acLongNames{iIndex},' (', strctAtlas.m_astrctMesh(iMeshIter).name,')'];
        end
end

for iMetaIter=1:length(strctAtlas.m_astrctMetaRegions)
    for iRegionIter=1:length(strctAtlas.m_astrctMetaRegions(iMetaIter).m_acRegions)
        iIndex = find(ismember(lower(acShortNames), lower(strctAtlas.m_astrctMetaRegions(iMetaIter).m_acRegions{iRegionIter})),1,'first');
        if ~isempty(iIndex)
            strctAtlas.m_astrctMetaRegions(iMetaIter).m_acRegions{iRegionIter} =  [acLongNames{iIndex},' (',strctAtlas.m_astrctMetaRegions(iMetaIter).m_acRegions{iRegionIter},')'];
        end
    end
end
% Now,reorder by alphabetic order.... ?