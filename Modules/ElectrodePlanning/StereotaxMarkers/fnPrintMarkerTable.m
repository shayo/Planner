function fnPrintMarkerTable()
global g_strctModule
if ~isfield(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol},'m_astrctMarkers')
    errordlg('Please add markers first!');
    return;
end;
iNumMarkers = length(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers);

strctMarker = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers(1);
acRowNames= {strctMarker.m_astrctJointDescirptions.m_strName};
a2cData = cell( length(acRowNames), iNumMarkers);
for k=1:iNumMarkers
    strctMarker = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers(k);
    for j=1:length(acRowNames)
        a2cData{j,k} = num2str(strctMarker.m_astrctJointDescirptions(j).m_fValue);
    end
end

f = figure('Position',[100 100 1200 300]);
t = uitable('Data',a2cData,'RowName',acRowNames,... 
            'Parent',f,'Position',[20 20 1200 250]); %#ok
return;        
