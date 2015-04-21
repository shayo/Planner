
function fnLongChamber()
global g_strctModule
g_strctModule.m_strctGUIOptions.m_bLongChamber = ~g_strctModule.m_strctGUIOptions.m_bLongChamber;
fnInvalidate(1);
% profile clear
% profile on
% for k=1:10
%     fnInvalidate(1);
% end
% profile off
% profile viewer
return;
