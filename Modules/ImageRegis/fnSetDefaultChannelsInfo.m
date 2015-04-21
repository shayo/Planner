function astrctChannels=fnSetDefaultChannelsInfo(strMetaData,a4fData)
acChannelNames = fnGetChannelNamesFromMetaData(strMetaData);
iNumChannels = length(acChannelNames);
a2fColors = [0,0,1;
             0,1,0;
             1,0,0;
             1,1,1;
             1,0,1;
             0,1,1;
             1,1,0];
         
for iChannel=1:iNumChannels
    astrctChannels(iChannel).m_strName = acChannelNames{iChannel};
    switch astrctChannels(iChannel).m_strName
        case 'DAPI'
            astrctChannels(iChannel).m_afColorMap = [0 0 1];
        case 'Cy3'
            astrctChannels(iChannel).m_afColorMap = [1 0 0];
        case 'Cy5'
            astrctChannels(iChannel).m_afColorMap = [1 1 1];
        case 'EYFP'
            astrctChannels(iChannel).m_afColorMap = [0 1 0];
        otherwise
            astrctChannels(iChannel).m_afColorMap = a2fColors(iChannel,:);
    end
    % Set the default contrast transforms
    fMaxValue = double(max(max(max(a4fData(:,:,iChannel,:)))));
    fMinValue = double(min(min(min(a4fData(:,:,iChannel,:)))));
    strctContrastTransform.m_fMin = fMinValue;
    strctContrastTransform.m_fMax = fMaxValue;
    
    strctContrastTransform.m_fLeftX = fMinValue;
    strctContrastTransform.m_fLeftY = 0;
    strctContrastTransform.m_fRightX = fMaxValue;
    strctContrastTransform.m_fRightY = 1;
    astrctChannels(iChannel).m_strctContrastTransform = strctContrastTransform;
end
return