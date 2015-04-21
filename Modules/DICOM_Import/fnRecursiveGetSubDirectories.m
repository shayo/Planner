function [acstrResult] = fnRecursiveGetSubDirectories(strStartDir)
% This function returns all sub-directories of strStartDir (recursively)
% It is used mainly to get the list of all sub-directories that include
% matlab code(so they could be entered to matlab path upon exeution...)
%
strAllSubPaths = [';',genpath(strStartDir)];
aiIndices = find(strAllSubPaths == ';');
iNumSubDirs = length(aiIndices)-1;
acstrResult = cell(1,iNumSubDirs);
for iIter=1:iNumSubDirs
    acstrResult{iIter} = fnDirSlash(strAllSubPaths(aiIndices(iIter)+1:aiIndices(iIter+1)-1));
end;

return;
function strDir = fnDirSlash(strDir)
if (strDir(end) ~= '\')
    strDir(end+1) = '\';
end;