function [a3fCrossSectionXY,a3fCrossSectionYZ,a3fCrossSectionXZ]=fnInvalidateImageSeries(a3fCrossSectionXY,a3fCrossSectionYZ,a3fCrossSectionXZ)
global g_strctModule
a4fCrossSectionImages = zeros([size(a3fCrossSectionXY),3]);
a4fCrossSectionImages(:,:,:,1) = a3fCrossSectionXY;
a4fCrossSectionImages(:,:,:,2) = a3fCrossSectionYZ;
a4fCrossSectionImages(:,:,:,3) = a3fCrossSectionXZ;

astrctCrossSections = [g_strctModule.m_strctCrossSectionXY,g_strctModule.m_strctCrossSectionYZ,g_strctModule.m_strctCrossSectionXZ];
if isfield(g_strctModule.m_strctGUIOptions,'m_bImageSeries') && g_strctModule.m_strctGUIOptions.m_bImageSeries  && isfield(g_strctModule,'m_astrctImageSeries')
    iActiveSeries = get(g_strctModule.m_strctPanel.m_hImageSeriesList,'value');
    if iActiveSeries > 0 && length(g_strctModule.m_astrctImageSeries) >= iActiveSeries
        
        
        % Draw the box encompassing the image series to help visualizing
        % when it is being rotated...
        strctMesh = fnBuildImageSeriesBoundingBox();
        if ~isempty(strctMesh)
            
        end
        
        
        
        
        for iCrossSectionIter=1:3
            strctCrossSection = astrctCrossSections(iCrossSectionIter);
            fAngle = acos(sum(strctCrossSection.m_a2fM(1:3,3).*g_strctModule.m_astrctImageSeries(iActiveSeries).m_a2fImagePlaneTo3D(1:3,3)))/pi*180;
            % We can only display an "image series" if we are viewing the
            % correct plane (i.e., the image series plane)
            if fAngle < 0.01 % lets assume we are viewing the correct plane here...
                
                % Get the actual display plane coordinates in mm
                [a2fXmm,a2fYmm] = meshgrid(...
                    linspace(-strctCrossSection.m_fHalfWidthMM, strctCrossSection.m_fHalfWidthMM, strctCrossSection.m_iResWidth),...
                    linspace(-strctCrossSection.m_fHalfHeightMM, strctCrossSection.m_fHalfHeightMM, strctCrossSection.m_iResHeight));
                a2fZmm = zeros(size(a2fXmm));
                a2fOnes = ones(size(a2fZmm));
                apt3fInVolMM = inv(g_strctModule.m_astrctImageSeries(iActiveSeries).m_a2fImagePlaneTo3D)*strctCrossSection.m_a2fM  * [a2fXmm(:), a2fYmm(:),a2fZmm(:),a2fOnes(:)]';
                % Now, transform these coordinates using the image series
                % coordinate system
                % Z values should all be the same, just pick the first one.
                ZPlane = apt3fInVolMM(3,1);
                
                % Now, do we actually have a image series that matches this Z
                % plane?
                iNumImages = length(g_strctModule.m_astrctImageSeries(iActiveSeries).m_acImages);
                if iNumImages > 0
                    % Find the image with the closest Z. If Z is larger than
                    % the image series thickness, declare not found!
                    afZDist = zeros(1,iNumImages);
                    for iImageIter=1:iNumImages
                        afZDist(iImageIter)=abs(g_strctModule.m_astrctImageSeries(iActiveSeries).m_acImages{iImageIter}.m_fZOffsetMM-ZPlane);
                    end
                    [fMinimumDistToImagePlane, iSelectedImageInSeries]=min(afZDist);
                    if (fMinimumDistToImagePlane <= g_strctModule.m_astrctImageSeries(iActiveSeries).m_fImageThickness)
                        % OK, we now know from which image to sample!
                        % Apple the image-specific transformation (2D) and then
                        % sample values from the image data!
                        afXmm = apt3fInVolMM(1,:);
                        afYmm = apt3fInVolMM(2,:);
                        set(g_strctModule.m_strctPanel.m_hImageList,'value',iSelectedImageInSeries);
                        
                        
                        apt2fSubsampledCoordinates= g_strctModule.m_astrctImageSeries(iActiveSeries).m_acImages{iSelectedImageInSeries}.m_a2fSubSampling*g_strctModule.m_astrctImageSeries(iActiveSeries).m_acImages{iSelectedImageInSeries}.m_a2fMMtoPix * [afXmm;afYmm;a2fOnes(:)'];
                        
                        a3fRGB = zeros(strctCrossSection.m_iResHeight,strctCrossSection.m_iResWidth,3);
                        
                        if size(g_strctModule.m_astrctImageSeries(iActiveSeries).m_acImages{iSelectedImageInSeries}.m_Data,3) == 1
                            % Single channel
                            a2fDataSampled= reshape(fndllFastInterp2(g_strctModule.m_astrctImageSeries(iActiveSeries).m_acImages{iSelectedImageInSeries}.m_Data, ...
                                1+apt2fSubsampledCoordinates(1,:),1+apt2fSubsampledCoordinates(2,:),NaN), size(a2fXmm));
                            a3fRGB(:,:,1) = a2fDataSampled*g_strctModule.m_astrctImageSeries(iActiveSeries).m_afColorMapping(1);
                            a3fRGB(:,:,2) = a2fDataSampled*g_strctModule.m_astrctImageSeries(iActiveSeries).m_afColorMapping(2);
                            a3fRGB(:,:,3) = a2fDataSampled*g_strctModule.m_astrctImageSeries(iActiveSeries).m_afColorMapping(3);
                            
                        else
                            % Color image
                            
                            for iColorMap=1:3
                                a3fRGB(:,:,iColorMap) = reshape(fndllFastInterp2(g_strctModule.m_astrctImageSeries(iActiveSeries).m_acImages{iSelectedImageInSeries}.m_Data(:,:,iColorMap), ...
                                    1+apt2fSubsampledCoordinates(1,:),1+apt2fSubsampledCoordinates(2,:),NaN), size(a2fXmm));
                            end
                        end
                        a3fRGB = a3fRGB/double(max(g_strctModule.m_astrctImageSeries(iActiveSeries).m_acImages{iSelectedImageInSeries}.m_Data(:)));
                        a3bValid = ~isnan(a3fRGB);
                        a3fRGB(isnan(a3fRGB))=0;
% 
%                         E = edge(rgb2gray(a3fRGB/255),'canny');
%                          [H,S,V]=rgb2hsv(double(a3fRGB));
%                          %S(S<0.15)=0;
%                          %V(S<0.18)=0;
%                          a3fRGB= hsv2rgb(H,S,V);
%                           a3fRGB(:,:,1) = 0;
% %                          a3fRGB(:,:,2) = double(E);
%                             a3fRGB(:,:,2) = min(1,S*3);
%                           a3fRGB(:,:,3) = 0;
%                         
                    
%                         a4fCrossSectionImages(:,:,:,iCrossSectionIter) = fnMergeImagesCheckerboard(a4fCrossSectionImages(:,:,:,iCrossSectionIter), a3fRGB);

                        a3fCrossSec = a4fCrossSectionImages(:,:,:,iCrossSectionIter) ;
                        a3fCrossSec(a3bValid) = (1-g_strctModule.m_astrctImageSeries(iActiveSeries).m_fOpacity)*a3fCrossSec(a3bValid) + g_strctModule.m_astrctImageSeries(iActiveSeries).m_fOpacity*a3fRGB(a3bValid);
                        a4fCrossSectionImages(:,:,:,iCrossSectionIter) = a3fCrossSec;
                    end
                end
            end
        end
    end
end

a3fCrossSectionXY = a4fCrossSectionImages(:,:,:,1);
a3fCrossSectionYZ = a4fCrossSectionImages(:,:,:,2);
a3fCrossSectionXZ = a4fCrossSectionImages(:,:,:,3);

return


function a3fRGB = fnMergeImagesCheckerboard(a3fRGB1, a3fRGB2)
iHeight = size(a3fRGB1,1);
iWidth = size(a3fRGB1,2);
a3fRGB  = zeros(iHeight,iWidth,3);

iNumPixelsPerSquare = ceil(max(iHeight,iWidth)/10);
a2fCheckerBoard = checkerboard(iNumPixelsPerSquare, ceil(iHeight/iNumPixelsPerSquare), ceil(iWidth/iNumPixelsPerSquare));
a2bCheckerSmall = double(a2fCheckerBoard(1:iHeight,1:iWidth) > 0);
for k=1:3
    A = a3fRGB1(:,:,k);
    B = a3fRGB2(:,:,k);
    An = ~isnan(A) & a2bCheckerSmall;
    Bn = ~isnan(B) & ~a2bCheckerSmall;
    Tmp = zeros(iHeight,iWidth);
    Tmp(An)= A(An);
    Tmp(Bn) = B(Bn);
    
    a3fRGB(:,:,k) =  Tmp;
end
return