
acDirs = parsedirs(genpath('.\Core'));
acDirs = [acDirs;parsedirs(genpath('.\Modules'));];
acDirs = [acDirs;parsedirs(genpath('.\AnalysisScripts'));];
acDirs = [acDirs;parsedirs(genpath('.\MEX_CODE'));];
acDirs = [acDirs;parsedirs(genpath('.\Utilities'));];


acDirs = parsedirs(genpath('Z:\AnalysisScripts'));
acDirs = [acDirs;parsedirs(genpath('Z:\Apps'));];
acDirs = [acDirs;parsedirs(genpath('Z:\MEX_Code'));];
acDirs = [acDirs;parsedirs(genpath('Z:\Paradigms'));];
acDirs = [acDirs;parsedirs(genpath('Z:\Utilities'));];



iCounter = 1;
clear acAvailFiles
for k=1:length(acDirs)
    astrctFiles = dir([acDirs{k}(1:end-1),'\*.m']);
    for j=1:length(astrctFiles)
        acAvailFiles{iCounter} = [acDirs{k}(1:end-1),'\',astrctFiles(j).name];
        iCounter=iCounter+1;
    end
    astrctFiles = dir([acDirs{k}(1:end-1),'\*.cpp']);
    for j=1:length(astrctFiles)
        acAvailFiles{iCounter} = [acDirs{k}(1:end-1),'\',astrctFiles(j).name];
        iCounter=iCounter+1;
    end
end

numLines=0;
for i=1:length(acAvailFiles)
    hFileID=fopen(acAvailFiles{i});
    D=fread(hFileID);
    fclose(hFileID);
    numLines=numLines+sum(D==10);
end