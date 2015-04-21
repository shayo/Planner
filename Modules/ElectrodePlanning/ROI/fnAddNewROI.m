function iNewROIIndex = fnAddNewROI()
global g_strctModule
if g_strctModule.m_iCurrAnatVol == 0
    iNewROIIndex = [];
    return;
end;
%strctROI.m_apt3fPoints = [];
strctROI.m_aiVolumeIndices = [];
strctROI.m_strName = 'ROI 1';
strctROI.m_strColor = [1 1 0];
strctROI.m_bVisible = true;

if ~isfield(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol},'m_astrctROIs') || ...
        isempty(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctROIs)
     g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctROIs = strctROI;
else
    iNumROI= length(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctROIs);    
    % Modifu the color and name...
    a2fColors = colorcube(50);
    strctROI.m_strColor = a2fColors(1+iNumROI,:);
    strctROI.m_strName = sprintf('ROI %d',1+iNumROI);
    g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctROIs(iNumROI+1) = strctROI;
end;
iNewROIIndex= length(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctROIs);
fnUpdateROIList();

return;

