function fnSetCurrFuncVol()
global g_strctModule

iNewVolSelected = get(g_strctModule.m_strctPanel.m_hFuncList,'value');
if ~isempty(iNewVolSelected)
    %g_strctModule.m_strctFuncVol = g_strctModule.m_acFuncVol{iNewVolSelected};
    
    g_strctModule.m_iCurrFuncVol = iNewVolSelected;
    fnInvalidate(true);
end;

return;