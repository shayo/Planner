function fnUpdateMarkerList()
global g_strctModule
if ~isfield(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol},'m_astrctMarkers')
    set(g_strctModule.m_strctPanel.m_hMarkersList,'String','');
else
    strName = '';
    iNumMarkers = length(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers);

    for k=1:iNumMarkers
        if ~isfield(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers(k),'m_bEnabled')
            g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers(k).m_bEnabled = true;
        end
        if g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers(k).m_bEnabled
            strName = [strName,'|',num2str(k),':',g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers(k).m_strName]; %#ok
        else
            strName = [strName,'|',num2str(k),': DISABLED(',g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers(k).m_strName,')']; %#ok
        end
    end;
    iValue = min(iNumMarkers,get(g_strctModule.m_strctPanel.m_hMarkersList,'value'));
    if isempty(iValue)
        iValue = iNumMarkers;
    end;
    if iNumMarkers == 0
        iValue = 1;
    end;    
    set(g_strctModule.m_strctPanel.m_hMarkersList,'String',strName(2:end),'value',iValue,'min',1,'max',max(1,iNumMarkers));
end;

% Update Markers axes
%fnUpdateMarkerAxes();
return;