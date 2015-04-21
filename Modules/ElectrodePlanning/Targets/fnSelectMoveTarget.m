
function fnSelectMoveTarget()
global g_strctModule
aiCurrTarget = get(g_strctModule.m_strctPanel.m_hTargetList,'value');
if length(aiCurrTarget) > 1
    msgbox('This option is available only for one target');
    return;
end;
            
fnChangeMouseMode('MoveTarget');
return;