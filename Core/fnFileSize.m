function iSizeInBytes = fnFileSize(strFile)
try
    astrctFile = dir(strFile);
    iSizeInBytes=astrctFile.bytes;
catch
    iSizeInBytes = -1;
end
return;
