function fnMoveFuncInList(strWhat)
global g_strctModule

switch strWhat
    case 'Up'
        if g_strctModule.m_iCurrFuncVol > 1
            Tmp = g_strctModule.m_acFuncVol(g_strctModule.m_iCurrFuncVol-1);
            g_strctModule.m_acFuncVol(g_strctModule.m_iCurrFuncVol-1) = g_strctModule.m_acFuncVol(g_strctModule.m_iCurrFuncVol);
            g_strctModule.m_acFuncVol(g_strctModule.m_iCurrFuncVol) = Tmp;
        end
    case 'Down'
        if g_strctModule.m_iCurrFuncVol < length(g_strctModule.m_acFuncVol)
            Tmp = g_strctModule.m_acFuncVol(g_strctModule.m_iCurrFuncVol+1);
            g_strctModule.m_acFuncVol(g_strctModule.m_iCurrFuncVol+1) = g_strctModule.m_acFuncVol(g_strctModule.m_iCurrFuncVol);
            g_strctModule.m_acFuncVol(g_strctModule.m_iCurrFuncVol) = Tmp;
        end
    case 'First'
            Tmp = g_strctModule.m_acFuncVol(1);
            g_strctModule.m_acFuncVol(1) = g_strctModule.m_acFuncVol(g_strctModule.m_iCurrFuncVol);
            g_strctModule.m_acFuncVol(g_strctModule.m_iCurrFuncVol) = Tmp;
    case 'Last'
            Tmp = g_strctModule.m_acFuncVol(end);
            g_strctModule.m_acFuncVol(end) = g_strctModule.m_acFuncVol(g_strctModule.m_iCurrFuncVol);
            g_strctModule.m_acFuncVol(g_strctModule.m_iCurrFuncVol) = Tmp;
end

fnUpdateFunctionalsList();
fnSetCurrFuncVol();
