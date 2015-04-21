function [a4fData, strMetaData] = ReadOIB(strFileName)
% read all Z-sections
[strPath,strFile,strExt]=fileparts(strFileName);
strMatFile = [strPath,filesep,strFile,'.mat'];
if ~exist(strMatFile,'file')
    fprintf('Reading %s...',strFileName);
    
    %[vol]=imreadBF(datname,zplanes,tframes,channel)
    meta = imreadBFmeta(strFileName);
    strMetaData=meta.raw.toString.toCharArray';
    %[im, format, pages, Pos, strMetaData] = bimread(strFileName,1);
    a4fData = zeros(meta.height,meta.width,meta.channels,meta.zsize,'uint16');
    %[im, format, pages, xyzr, metatxt] = bimread(strFileName,1);
    for iChannel=1:meta.channels
        vol = imreadBF(strFileName, 1:meta.zsize, 1, iChannel);
        a4fData(:,:,iChannel,:) = vol;
    end;
    fprintf('Done!\n');
    % Save a matlab file for faster access....
    fprintf('Dumping data to a matlab file for faster read access!\n');
    Tmp=dir(strFileName);
    if Tmp.bytes/1e6 > 100
        save(strMatFile,'a4fData','strMetaData');
    end
else
    fprintf('Reading cached matlab file instead of OIB (%s)...',strMatFile);
    load(strMatFile);
     fprintf('Done!\n');
   
end
return;
