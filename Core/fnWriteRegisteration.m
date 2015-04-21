function fnWriteRegisteration(strFilename,T, strSubjectName, strVolType,afVoxelSpacing)
hFileID = fopen(strFilename, 'wb');
fprintf(hFileID,'%s\n',strSubjectName);

fprintf(hFileID,'%f\n',afVoxelSpacing(1));
fprintf(hFileID,'%f\n',afVoxelSpacing(2));
fprintf(hFileID,'%f\n',afVoxelSpacing(3));

for k=1:4
    fprintf(hFileID,'%e %e %e %e \n',T(k,1),T(k,2),T(k,3),T(k,4));
end;

fprintf(hFileID,'%s\n',strVolType);

fclose(hFileID);