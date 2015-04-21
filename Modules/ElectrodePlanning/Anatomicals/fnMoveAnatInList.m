function fnMoveAnatInList(strWhat)
global g_strctModule

switch strWhat
    case 'Up'
        if g_strctModule.m_iCurrAnatVol > 1
            Tmp = g_strctModule.m_acAnatVol(g_strctModule.m_iCurrAnatVol-1);
            g_strctModule.m_acAnatVol(g_strctModule.m_iCurrAnatVol-1) = g_strctModule.m_acAnatVol(g_strctModule.m_iCurrAnatVol);
            g_strctModule.m_acAnatVol(g_strctModule.m_iCurrAnatVol) = Tmp;
        end
    case 'Down'
        if g_strctModule.m_iCurrAnatVol < length(g_strctModule.m_acAnatVol)
            Tmp = g_strctModule.m_acAnatVol(g_strctModule.m_iCurrAnatVol+1);
            g_strctModule.m_acAnatVol(g_strctModule.m_iCurrAnatVol+1) = g_strctModule.m_acAnatVol(g_strctModule.m_iCurrAnatVol);
            g_strctModule.m_acAnatVol(g_strctModule.m_iCurrAnatVol) = Tmp;
        end
    case 'First'
            Tmp = g_strctModule.m_acAnatVol(1);
            g_strctModule.m_acAnatVol(1) = g_strctModule.m_acAnatVol(g_strctModule.m_iCurrAnatVol);
            g_strctModule.m_acAnatVol(g_strctModule.m_iCurrAnatVol) = Tmp;
    case 'Last'
            Tmp = g_strctModule.m_acAnatVol(end);
            g_strctModule.m_acAnatVol(end) = g_strctModule.m_acAnatVol(g_strctModule.m_iCurrAnatVol);
            g_strctModule.m_acAnatVol(g_strctModule.m_iCurrAnatVol) = Tmp;
end

fnUpdateAnatomicalsList();
fnSetCurrAnatVol();
