function TileOIB(strFolder)
%strFolder = 'D:\Photos\Work Related\Bert Confocal\High Mag Seroes 2 (NeuN, YFP)\0292_ZoomTop_20130212_113656\';
if strFolder(end) ~= filesep
    strFolder(end+1) = filesep;
end
strctXml  = xml2struct([strFolder,'MATL_Mosaic.log']);
for k=1:length(strctXml.Children)
    if strcmpi(strctXml.Children(k).Name,'Mosaic')
        for j=1:length(strctXml.Children(k).Children)
            if strcmpi(strctXml.Children(k).Children(j).Name,'XImages')
                aiTileSize(1) = str2num(strctXml.Children(k).Children(j).Children.Data);
            end
            if strcmpi(strctXml.Children(k).Children(j).Name,'YImages')
                aiTileSize(2) = str2num(strctXml.Children(k).Children(j).Children.Data);
            end
        end
    end
end
% Read the first image
[a4fData, strMetaData] = ReadOIB([strFolder,'Track0001\Image0001_01.oib']);
aiImageSize = size(a4fData);
%  allocate memory
a4fTile = zeros([size(a4fData,1) * aiTileSize(2), size(a4fData,2) * aiTileSize(1), size(a4fData,3), size(a4fData,4)],class(a4fData));

% Read individual images and place them in the correct location in the tile
iImageCounter = 1;
for y=1:aiTileSize(2)
    for x=1:aiTileSize(1)
        [a4fData, strMetaData] = ReadOIB(sprintf('%sTrack%04d\\Image%04d_01.oib',strFolder,iImageCounter,iImageCounter));
        aiXRange = aiImageSize(2) * (x-1) + 1 : aiImageSize(2) * (x) ;
        aiYRange = aiImageSize(2) * (y-1) + 1 : aiImageSize(2) * (y) ;
        a4fTile( aiYRange,aiXRange,:,:) = a4fData;
        iImageCounter=iImageCounter+1;
    end
end
strSessionName = strFolder(1+find(strFolder(1:end-1)==filesep,1,'last'):end-1);
fprintf('Saving large tile file to %s\n',strSessionName);
save([strFolder,strSessionName,'_Tile.mat'],'a4fTile','strMetaData','-V6');
% Z Project (sum) and same individual channels.
a3fTile = sum(a4fTile,4);
for iChannel = 1:size(a3fTile,3)
    fprintf('Writing Z projection, Channel %d\n',iChannel);
    strChName = [strFolder,strSessionName,'_Ch',num2str(iChannel),'.png'];
    a2fChannel = a3fTile(:,:,iChannel);
    imwrite(a2fChannel,strChName);
end
return;




