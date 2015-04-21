

function fnSelectNewChamberInPlanningMode()
global g_strctModule
% if strctAnatVol.m_a2fRegToStereoTatic
%     strctPanel.m_hChambersList
% end
iSelectedChamber = get(g_strctModule.m_strctPanel.m_hChambersList,'value');
fnSelectChamberAux(iSelectedChamber);
return;
