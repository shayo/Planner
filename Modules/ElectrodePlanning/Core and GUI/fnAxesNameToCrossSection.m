function [strctCrossSection, hAxes] = fnAxesNameToCrossSection(strName)
global g_strctModule
switch strName
    case 'XY';
        strctCrossSection =g_strctModule.m_strctCrossSectionXY;
        hAxes = g_strctModule.m_strctPanel.m_strctXY.m_hAxes;
    case 'YZ'
        strctCrossSection =g_strctModule.m_strctCrossSectionYZ;
        hAxes = g_strctModule.m_strctPanel.m_strctYZ.m_hAxes;
    case 'XZ'
        strctCrossSection =g_strctModule.m_strctCrossSectionXZ;
        hAxes = g_strctModule.m_strctPanel.m_strctXZ.m_hAxes;
    otherwise
        strctCrossSection =[];
        hAxes=[];
end;
return;
