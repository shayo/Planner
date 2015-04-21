

function fnSelectChamberAux(iChamber)
global g_strctModule
g_strctModule.m_iCurrChamber = iChamber;
if iChamber > 0
    g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_iLastSelectedChamber = iChamber;
    set(g_strctModule.m_strctPanel.m_hChamberList,'value',iChamber);
    set(g_strctModule.m_strctPanel.m_hGridList,'value',1);
    
    if ~isempty(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers) && ...
            g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber).m_bVisible
        set(g_strctModule.m_strctPanel.m_hChamberMenuVisible,'Checked','on')
    else
        set(g_strctModule.m_strctPanel.m_hChamberMenuVisible,'Checked','off')
    end
    
    
    fnUpdateGridList();
    fnUpdateGridAxes();
    fnUpdateChamberMIP();
    fnInvalidate();
end
return;