function fnRemoveChamber()
global g_strctModule
if g_strctModule.m_iCurrChamber==0
    return;
end
strAnswer = questdlg({'Are you sure you want to remove this chamber?','It will remove all grids as well'},'Warning','Yes','No','No');
if strcmpi(strAnswer,'yes')
    %%fnDeleteChamberContours();
    g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber)= [];
    g_strctModule.m_iCurrChamber = length(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers);
    g_strctModule.m_iLastSelectedChamber = g_strctModule.m_iCurrChamber;
    set(g_strctModule.m_strctPanel.m_hChamberList,'value',max(1,g_strctModule.m_iCurrChamber));
    fnUpdateChamberList();
    %g_strctModule.m_iCurrGrid = 0;
    fnUpdateGridList();
    fnUpdateGridAxes();
    fnInvalidate(1);
end;
return;