function [a4fData, astrctChannels] = fnReadWideFieldFluoresenceImage(strFileName)
[strPath,strFile,strExt]=fileparts(strFileName);
switch lower(strExt)
    case '.oib'
        % Up to 1 Z stack, and 4 channels
        [a4fData, strMetaData] = ReadOIB(strFileName);
    case '.mat'
        fprintf('Reading %s\n',strFileName);
        strctTmp = load(strFileName);
        a4fData = strctTmp.a4fTile;
        strMetaData = strctTmp.strMetaData;
end
astrctChannels = fnSetDefaultChannelsInfo(strMetaData,a4fData);
