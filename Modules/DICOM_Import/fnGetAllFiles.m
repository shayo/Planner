function acFiles = fnGetAllFiles(acPaths, strFilter)
if ~iscell(acPaths)
    acPaths = {acPaths};
end;
acFiles = cell(0);
for k=1:length(acPaths)
     
    astrctFiles = dir([acPaths{k},strFilter]);
    aiFileIndices = find(~cat(1,astrctFiles.isdir));
    if ~isempty(aiFileIndices)
        for j=1:length(aiFileIndices)
        acFiles = [acFiles, [acPaths{k},astrctFiles(aiFileIndices(j)).name]];
        end
    end
    
end
return;
