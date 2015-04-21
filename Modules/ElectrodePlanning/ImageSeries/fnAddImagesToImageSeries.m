function fnAddImagesToImageSeries()
% Save per image series, one transformation that determines the Global
% orientation of the series.
% Save per image:

global g_strctModule

if isempty(g_strctModule.m_acAnatVol) || ~isfield(g_strctModule,'m_astrctImageSeries')
    return;
end;

iActiveSeries = get(g_strctModule.m_strctPanel.m_hImageSeriesList,'value');
if iActiveSeries == 0 || length(g_strctModule.m_astrctImageSeries) < iActiveSeries
    set(g_strctModule.m_strctPanel.m_hImageList,'String','','value',1);
    return;
end

[acFiles, strPath]=uigetfile('*.tif;*.jpg','MultiSelect','on');
if isnumeric(acFiles) && acFiles == 0
    return;
end;

if ~iscell(acFiles)
    acFiles = {acFiles};
end

if isempty(g_strctModule.m_astrctImageSeries(iActiveSeries).m_acImages)
    fOffset = -g_strctModule.m_astrctImageSeries(iActiveSeries).m_fInterImageDist;
    iImageOffset = 1;
    
    if strcmpi(g_strctModule.m_astrctImageSeries(iActiveSeries).m_strOrientation,'coronal')
        g_strctModule.m_astrctImageSeries(iActiveSeries).m_a2fImagePlaneTo3D = g_strctModule.m_strctCrossSectionXZ.m_a2fM;
    elseif strcmpi(g_strctModule.m_astrctImageSeries(iActiveSeries).m_strOrientation,'horizontal')
        g_strctModule.m_astrctImageSeries(iActiveSeries).m_a2fImagePlaneTo3D = g_strctModule.m_strctCrossSectionXY.m_a2fM;
    else
        g_strctModule.m_astrctImageSeries(iActiveSeries).m_a2fImagePlaneTo3D = g_strctModule.m_strctCrossSectionYZ.m_a2fM;
    end
    
else
    iImageOffset = 1+length(g_strctModule.m_astrctImageSeries(iActiveSeries).m_acImages);
    fOffset = g_strctModule.m_astrctImageSeries(iActiveSeries).m_acImages{iImageOffset-1}.m_fZOffsetMM;
end

if strcmpi(g_strctModule.m_astrctImageSeries(iActiveSeries).m_strOrientation,'coronal')
       fHalfWidthMM = g_strctModule.m_strctCrossSectionXZ.m_fHalfWidthMM;
elseif strcmpi(g_strctModule.m_astrctImageSeries(iActiveSeries).m_strOrientation,'horizontal')
       fHalfWidthMM = g_strctModule.m_strctCrossSectionXY.m_fHalfWidthMM;        
else
       fHalfWidthMM = g_strctModule.m_strctCrossSectionYZ.m_fHalfWidthMM;        
end



iNumFiles = length(acFiles);

for k=1:iNumFiles
    fprintf('Reading %s\n',[strPath,acFiles{k}]);
    [strP,strF]=fileparts(acFiles{k});
    strctImage.m_strName = strF;
    strctImage.m_strFileName = [strPath,acFiles{k}];
    strctImage.m_fZOffsetMM = fOffset + k*g_strctModule.m_astrctImageSeries(iActiveSeries).m_fInterImageDist;
    
    I = imread(strctImage.m_strFileName);
    if (size(I,1) > g_strctModule.m_astrctImageSeries(iActiveSeries).m_iResizePix || size(I,2) > g_strctModule.m_astrctImageSeries(iActiveSeries).m_iResizePix)
        % Sub sampling / scaling.... but keep aspect ratio!
        afXYRatio = size(I,2)/size(I,1);
        if afXYRatio<1
            % Vertical Image
            NewHeight = g_strctModule.m_astrctImageSeries(iActiveSeries).m_iResizePix;
            NewWidth = ceil(NewHeight*afXYRatio);
        else
            % Horizontal Image
            NewWidth= g_strctModule.m_astrctImageSeries(iActiveSeries).m_iResizePix;
            NewHeight  = ceil(NewWidth/afXYRatio);
        end
        fScaleX = NewWidth/size(I,2);
        fScaleY = NewHeight/size(I,1);
        J = zeros(NewHeight,NewWidth, size(I,3), class(I));
        for plane=1:size(I,3)
            J(:,:,plane) = imresize(I(:,:,plane),[NewHeight,NewWidth]);
        end
        strctImage.m_Data = J;
        strctImage.m_a2fSubSampling = [fScaleX 0 0;
                                       0 fScaleY 0;
                                       0  0     1];
    else
        strctImage.m_Data = I;
        strctImage.m_a2fSubSampling = eye(3);
    end
    
    % We basically want to have a default transformation such that the
    % loaded image will "appear" on screen. We just map 1/2 of fHalfWidthMM
    % to the image coordinates:
    % i.e.:
    % 0.5*[-fHalfWidthMM,-fHalfWidthMM] goes to [0,0]
    % and 0.5*[fHalfWidthMM,fHalfWidthMM] goes to [size(I,2),size(I,1)
    %
    a2fMMtoPix = eye(3);
    a2fMMtoPix(1,1) = (size(I,2)-1) / fHalfWidthMM;
    a2fMMtoPix(1,3) = (size(I,2)-1) / 2;
    a2fMMtoPix(2,2) = (size(I,1)-1) / fHalfWidthMM;
    a2fMMtoPix(2,3) = (size(I,1)-1) / 2;
     
    strctImage.m_a2fMMtoPix = a2fMMtoPix; % Must make this more sophisitcated such that it actually appears on the screen...
    strctImage.m_astrctAnnotation = [];
    g_strctModule.m_astrctImageSeries(iActiveSeries).m_acImages{iImageOffset+k-1} = strctImage;
end

fnInvalidateImagesInSeriesList();
fnInvalidate(1);

return;