
function fnUpdateChamberList()
global g_strctModule
iNumChambers = length(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers);
if iNumChambers == 0
    set(g_strctModule.m_strctPanel.m_hChamberList,'String','','value',1);
    return;
end;
if g_strctModule.m_iCurrChamber <= 0 ||  g_strctModule.m_iCurrChamber  > iNumChambers
        g_strctModule.m_iCurrChamber = 1;
end
    
strChambers = '';
for k=1:iNumChambers
    strChambers = [strChambers,'|', g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(k).m_strName]; %#ok
end;
if g_strctModule.m_iCurrChamber > iNumChambers
    g_strctModule.m_iCurrChamber = iNumChambers;
end;

set(g_strctModule.m_strctPanel.m_hChamberList,'String',strChambers(2:end),'value',g_strctModule.m_iCurrChamber);
set(g_strctModule.m_strctPanel.m_hChambersList,'String',strChambers(2:end),'value',g_strctModule.m_iCurrChamber);

return;