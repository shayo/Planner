
function fnZoomAxes(hAxes)
global g_strctModule 
if ~isempty(hAxes)
switch hAxes
    case g_strctModule.m_strctPanel.m_strctXY.m_hAxes
        fnZoomAxesAux('m_strctXY');
    case g_strctModule.m_strctPanel.m_strctXZ.m_hAxes
        fnZoomAxesAux('m_strctXZ');
    case g_strctModule.m_strctPanel.m_strctYZ.m_hAxes
        fnZoomAxesAux('m_strctYZ');
    case g_strctModule.m_strctPanel.m_strct3D.m_hAxes
        fnZoomAxesAux('m_strct3D');
    case g_strctModule.m_strctPanel.m_strctStereoTactic.m_hAxes
        fnZoomAxesAux('m_strctStereoTactic');
        
end;   
end;
    
return;

