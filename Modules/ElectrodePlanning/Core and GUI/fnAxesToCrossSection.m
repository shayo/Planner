function [strctCrossSection,strName] = fnAxesToCrossSection(hAxes)
strName = [];
    global g_strctModule
    switch hAxes %#ok
    case g_strctModule.m_strctPanel.m_strctXY.m_hAxes
        strctCrossSection =g_strctModule.m_strctCrossSectionXY;
        strName = 'XY';
    case g_strctModule.m_strctPanel.m_strctYZ.m_hAxes
        strctCrossSection =g_strctModule.m_strctCrossSectionYZ;
        strName = 'YZ';
    case g_strctModule.m_strctPanel.m_strctXZ.m_hAxes
        strctCrossSection =g_strctModule.m_strctCrossSectionXZ;
        strName = 'XZ';
    otherwise
        strctCrossSection =[];
end;
return;