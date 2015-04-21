

function fnSetNewPanLevel(hAxes, afDelta)
global g_strctModule
if ~isempty(hAxes)
switch hAxes
    
    case g_strctModule.m_strctPanel.m_strctXY.m_hAxes
        pt3fCurrPos = g_strctModule.m_strctCrossSectionXY.m_a2fM(1:3,4);
        pt3fNewPos = pt3fCurrPos + ...
        -afDelta(1) * g_strctModule.m_strctCrossSectionXY.m_a2fM(1:3,1) + ...
        -afDelta(2) * g_strctModule.m_strctCrossSectionXY.m_a2fM(1:3,2);
        g_strctModule.m_strctCrossSectionXY.m_a2fM(1:3,4) = pt3fNewPos;
    case g_strctModule.m_strctPanel.m_strctYZ.m_hAxes
        pt3fCurrPos = g_strctModule.m_strctCrossSectionYZ.m_a2fM(1:3,4);
        pt3fNewPos = pt3fCurrPos + ...
        -afDelta(1) * g_strctModule.m_strctCrossSectionYZ.m_a2fM(1:3,1) + ...
        -afDelta(2) * g_strctModule.m_strctCrossSectionYZ.m_a2fM(1:3,2);
        g_strctModule.m_strctCrossSectionYZ.m_a2fM(1:3,4) = pt3fNewPos;
    case g_strctModule.m_strctPanel.m_strctXZ.m_hAxes
       pt3fCurrPos = g_strctModule.m_strctCrossSectionXZ.m_a2fM(1:3,4);
        pt3fNewPos = pt3fCurrPos + ...
        -afDelta(1) * g_strctModule.m_strctCrossSectionXZ.m_a2fM(1:3,1) + ...
        -afDelta(2) * g_strctModule.m_strctCrossSectionXZ.m_a2fM(1:3,2);
        g_strctModule.m_strctCrossSectionXZ.m_a2fM(1:3,4) = pt3fNewPos;
end;

fnInvalidate();
end;
return;
