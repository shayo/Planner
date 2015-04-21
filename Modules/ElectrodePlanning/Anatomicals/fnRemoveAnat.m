function fnRemoveAnat()
global g_strctModule
if length(g_strctModule.m_acAnatVol) <= 1
    msgbox('You cannot remove this volume');
    return;
end;

strAnswer = questdlg({'Are you sure you want to remove this volume?', 'It will remove all chambers, grids and targets'},'Warning','Yes','No','No');
if strcmpi(strAnswer,'yes')
    g_strctModule.m_acAnatVol(g_strctModule.m_iCurrAnatVol) = [];
    g_strctModule.m_iCurrAnatVol = length(g_strctModule.m_acAnatVol);    
    fnUpdateAnatomicalsList();
    fnSetCurrAnatVol();
end;

return;
