function strctAtlas = fnConvertAtlasPolygonsToMesh(strctAtlas,bDuplicateBilateral)
% Sort slices....
[afSortedValues, aiInd]=sort(cat(1,strctAtlas.m_astrctSlices.m_fPositionMM));
astrctSortedSlices = strctAtlas.m_astrctSlices(aiInd);

afMLrange = strctAtlas.m_afXPixelToMM;
afDVrange = strctAtlas.m_afYPixelToMM;

%% Build Meshs
clear astrctMesh
 h = waitbar(0,'Reconstructing regions...');
 iCounter=1;
for k=1:length(strctAtlas.m_acRegions)
    waitbar(k/length(strctAtlas.m_acRegions),h);
    fprintf('%d out of %d\n',k,length(strctAtlas.m_acRegions));
    strctTmp = fnMeshRegionOfInterest(strctAtlas.m_acRegions{k},astrctSortedSlices,{strctAtlas.m_acRegions{k}},bDuplicateBilateral,0.2, 0,1,afMLrange,afDVrange);
    if ~isempty(strctTmp)
            astrctMesh(iCounter) = strctTmp;
            iCounter=iCounter+1;
    end
end
delete(h);

fMetaRegionSubSampling = 0.05;
% Append with "Meta Regions"
if isfield(strctAtlas,'m_astrctMetaRegions')
    clear astrctMeshMeta
     h = waitbar(0,'Reconstructing meta-regions...');
    for iIter=1:length(strctAtlas.m_astrctMetaRegions)
           waitbar(iIter/length(strctAtlas.m_astrctMetaRegions),h);
        astrctMeshMeta(iIter)= fnMeshRegionOfInterest(strctAtlas.m_astrctMetaRegions(iIter).m_strName,  astrctSortedSlices,strctAtlas.m_astrctMetaRegions(iIter).m_acRegions,true,0.2, 0,fMetaRegionSubSampling,afMLrange,afDVrange);
    end
    delete(h);
    strctAtlas.m_astrctMesh = [astrctMeshMeta,astrctMesh];
else
    strctAtlas.m_astrctMesh = [astrctMesh];
end

% Add default color and transparency information...
a2fColors = lines(length(strctAtlas.m_astrctMesh));
for iIter=1:length(strctAtlas.m_astrctMesh)
    strctAtlas.m_astrctMesh(iIter).color = a2fColors(iIter,:);
end

return;
