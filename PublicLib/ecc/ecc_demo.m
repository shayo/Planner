%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is a demo execution of ECC image alignment algorithm
% 
% 13/5/2012
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% uncomment one of the four following lines
% transform = 'translation';
%transform = 'affine';
%% transform = 'homography';

a2iRange = [1,199;
            200,303;
            304,380;
            381,399;
            400,454;
            455,485;
            486,501;
            502,722;
            723,755;
            756,771;
            772,1122;
            1123,1159;
            1160,1207];
iNumBlocks=size(a2iRange,1);
aiBlockTemplate = [  21         208         362         381         400         476         496         561         755         756         864        1159        1174];%zeros(1,iNumBlocks);
for iBlockIter=1:iNumBlocks
    % find the image which resembles the median the most and use it as a
    % template.
    iNumImagesInBlock = a2iRange(iBlockIter,2)-a2iRange(iBlockIter,1)+1;
    aiImages = a2iRange(iBlockIter,1):a2iRange(iBlockIter,2);
    a3iBuf = zeros([[1536,2048]/8,iNumImagesInBlock]);
    for iIter=1:iNumImagesInBlock
        strImageName = sprintf('D:\\Photos\\Work Related\\Bert Histology\\%04d.jpg',aiImages(iIter));
        fprintf('%s\n',strImageName);
        I=rgb2gray(imread(strImageName));
        a3iBuf(:,:,iIter)=I(1:8:end,1:8:end);
    end    
    a2iMedian = median(a3iBuf,3);
    afDistToMedian= zeros(1,iNumImagesInBlock);
    for iIter=1:iNumImagesInBlock
        strImageName = sprintf('D:\\Photos\\Work Related\\Bert Histology\\%04d.jpg',aiImages(iIter));
        fprintf('%s\n',strImageName);
        I=rgb2gray(imread(strImageName));
        a2fDiff = double(I(1:8:end,1:8:end))-a2iMedian;
        afDistToMedian(iIter)=mean(a2fDiff(:));
    end    
    [fDummy,iSelectedTemplate]=min(afDistToMedian);
    aiBlockTemplate(iBlockIter) = aiImages(iSelectedTemplate);
end

verbose = 1; %plot images at the end of execution
NoL = 1;  % number of pyramid-levels
NoI=20;
init = [1 0 0;
    0 1 0];
transform = 'euclidean'; % homography gives too much distortion.
 
for iBlockIter=1:iNumBlocks
   iNumImagesInBlock = a2iRange(iBlockIter,2)-a2iRange(iBlockIter,1)+1;
   aiImages = a2iRange(iBlockIter,1):a2iRange(iBlockIter,2);
   strTemplate = sprintf('D:\\Photos\\Work Related\\Bert Histology\\%04d.jpg',aiBlockTemplate(iBlockIter));
   ImTemplate = im2double(rgb2gray(imread(strTemplate)));
   % Resize by half to increase speed.
   
     ImTemplate=ImTemplate(1:2:end,1:2:end);
   nx = 1:size(ImTemplate,2);
   ny = 1:size(ImTemplate,1);
   
   for iIter=1:iNumImagesInBlock
       strImageToAlign = sprintf('D:\\Photos\\Work Related\\Bert Histology\\%04d.jpg',aiImages(iIter));
       ImToAlign = im2double(imread(strImageToAlign));
       ImToAlign=ImToAlign(1:2:end,1:2:end,:);
       fprintf('%s\n',strImageToAlign);
       % Sub sample for speed...
        ImToAlignSmall=im2double(rgb2gray(ImToAlign));
       % This function does all the work
       [results, final_warp]=ecc(ImToAlignSmall, ImTemplate, NoL, NoI, transform, init);
       IAligned(:,:,1)= spatial_interp(ImToAlign(:,:,1), final_warp, 'linear', transform, nx, ny);
       IAligned(:,:,2)= spatial_interp(ImToAlign(:,:,2), final_warp, 'linear', transform, nx, ny);
       IAligned(:,:,3)= spatial_interp(ImToAlign(:,:,3), final_warp, 'linear', transform, nx, ny);
       IAlignedGray = rgb2gray(IAligned);
       strAlignedImage = sprintf('D:\\Photos\\Work Related\\HistologyAligned\\A%04d.jpg',aiImages(iIter));
       imwrite(IAligned,strAlignedImage);
   end
end

template = double(template_demo);
figure(1);imshow(image2)
figure(2);imshow(template_demo)
figure(3);imshow(im_demo)
figure(4);imshow(im_demo-template_demo)
figure(5);imshow(image2-template_demo)


