function fnUnconformVolume( strConformedVolumeFile,  strUnconformedFile)
%strOrigVolumeFile = 'D:\Data\Doris\Planner\FreeSurfer Pipeline\001.nii';
%strConformedVolumeFile = 'D:\Data\Doris\Planner\FreeSurfer Pipeline\T1.mgz';
%strUnconformedFile = 'D:\Data\Doris\Planner\FreeSurfer Pipeline\T1_unconformed.mgz';
T=[ -0.5000         0         0   32.0000
         0         0    0.5000    3.9555
         0   -0.5000         0   30.8686
         0         0         0    1.0000];
strctVolConformed= MRIread(strConformedVolumeFile);
strctVolConformed.vol = permute(strctVolConformed.vol,[3 2 1]);
strctVolConformed.vol=strctVolConformed.vol(:,:,1:240);
for k=1:240
    strctVolConformed.vol(:,:,k) = rot90(strctVolConformed.vol(:,:,k)  ,2);
end
strctVolConformed.vox2ras0 = T*strctVolConformed.vox2ras0;
MRIwrite(strctVolConformed, strUnconformedFile);

return;
% 
% O=MRIread(strOrigVolumeFile);
% A=MRIread(strUnconformedFile);
% figure(50);
% clf;
% subplot(2,1,1);
% imshow(O.vol(:,:,150),[])
% subplot(2,1,2);
% imshow(A.vol(:,:,150),[])
