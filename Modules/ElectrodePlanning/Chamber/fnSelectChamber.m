function fnSelectChamber()
global g_strctModule
iSelectedChamber = get(g_strctModule.m_strctPanel.m_hChamberList,'value');
if ~isempty(iSelectedChamber)
    fnSelectChamberAux(iSelectedChamber);
end;
return;