function [strName,strctCrossSection] = fnAxesToName(hAxes)
global g_strctModule
if isempty(hAxes)
            strctCrossSection =[];
        strName=[];
return;
end

switch hAxes
    case g_strctModule.m_strctPanel.m_strctXY.m_hAxes
        strName = 'XY';
        strctCrossSection =g_strctModule.m_strctCrossSectionXY;
    case g_strctModule.m_strctPanel.m_strctYZ.m_hAxes
        strName = 'YZ';
        strctCrossSection =g_strctModule.m_strctCrossSectionYZ;
    case g_strctModule.m_strctPanel.m_strctXZ.m_hAxes
        strName = 'XZ';
        strctCrossSection =g_strctModule.m_strctCrossSectionXZ;
    otherwise
        strctCrossSection =[];
        strName=[];
end;
return;
