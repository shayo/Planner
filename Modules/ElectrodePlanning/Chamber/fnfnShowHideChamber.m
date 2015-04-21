
function fnfnShowHideChamber()
global g_strctModule
if g_strctModule.m_iCurrChamber == 0
    return;
end;
g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber).m_bVisible = ~g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber).m_bVisible;
if g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber).m_bVisible
    set(g_strctModule.m_strctPanel.m_hChamberMenuVisible,'Checked','on')
else
    set(g_strctModule.m_strctPanel.m_hChamberMenuVisible,'Checked','off')
end
fnInvalidate();
return;
