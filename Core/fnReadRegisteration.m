function [T, strSubjectName, strVolType,afVoxelSpacing] = fnReadRegisteration(strFilename)
hFileID = fopen(strFilename, 'rb');
strSubjectName = fgets(hFileID);

fdC = sscanf(fgets(hFileID),'%f');
if isempty(fdC)
    fdC = sscanf(fgets(hFileID),'%f');
end
fdR = sscanf(fgets(hFileID),'%f');
fdS = sscanf(fgets(hFileID),'%f');

T1 = sscanf(fgets(hFileID),'%e %e %e %e');
T2 = sscanf(fgets(hFileID),'%e %e %e %e');
T3 = sscanf(fgets(hFileID),'%e %e %e %e');
T4 = sscanf(fgets(hFileID),'%e %e %e %e');

T = [T1';T2';T3';T4'];
strVolType = fgets(hFileID);
afVoxelSpacing = [fdC, fdR, fdS];
fclose(hFileID);