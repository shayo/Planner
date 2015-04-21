
function fnRenameMarker()
global g_strctModule
if isempty(g_strctModule.m_iCurrAnatVol)
    return;
end;
iSelectedMarker = get(g_strctModule.m_strctPanel.m_hMarkersList,'value');
if length(iSelectedMarker) > 1
    msgbox('This option is available for only one marker');
    return;
end;
if iSelectedMarker > 0
    answer=inputdlg({'New Marker Name'},'Change Marker Name',1,{g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers(iSelectedMarker).m_strName});
    if isempty(answer)
        return;
    end;
    g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers(iSelectedMarker).m_strName = answer{1};
    fnUpdateMarkerList();
end;

return;


