
function fnChangeMouseMode(strMouseMode, strDescription, strMouseIcon)
global g_strctModule
if ~exist('strDescription','var')
    switch strMouseMode
        case 'Crosshair'
            strDescription = 'Jump to new position';
        case 'Scroll'
            strDescription = 'Scroll Through Slices';
        case 'Contrast'
            strDescription = 'Modify Contrast Window';
        case 'Rotate2D'
            strDescription = 'Rotate View (in-plane)';
        case 'ChamberRotateAxis'
            strDescription = 'Rotate Chamber About Major Axis';
        case 'ChamberTransAxis'
            strDescription = 'Translate Chamber Along Major Axis';
        case 'MoveGrid'
            strDescription = 'Move Grid Along Chamber Axis';
        case 'MeasureDist'
            strDescription = 'Measure Distance';
        case 'MoveMarker'
            strDescription = 'Translate Marker Position';
        case 'ChamberTrans'
            strDescription = 'Translate Chamber (in plane)';
        case 'ChamberRot'
            strDescription = 'Rotate Chamber (in plane)';
        case 'MoveTarget'
            strDescription = 'Translate Target Position';
        case 'ZoomLinked'
            strDescription = 'Zoom (all views)';
        case 'Pan'
            strDescription = 'Pan Viewing Window';
        case 'Zoom'
            strDescription = 'Zoom';
        case 'MoveAtlas'
            strDescription = 'Translate Atlas';
        case 'RotateAtlas'
            strDescription = 'Rotate Atlas';
        case 'ScaleAtlas'
            strDescription = 'Scale Atlas';
        case 'QueryAtlas'
            strDescription = 'Query Atlas';
        case 'AddBloodVessel'
            strDescription = 'Add Blood Vessels';
        case 'RemoveBloodVessel'
            strDescription = 'Remove Blood Vessels';
            

        otherwise
            strDescription = 'Unknown';
    end
end
if ~exist('strMouseIcon','var')
    strMouseIcon = [];
end


if (~strcmpi(strMouseIcon,'Radius2D') && strcmpi(g_strctModule.m_strMouseIcon,'Radius2D'))  || ...
 (~strcmpi(strMouseIcon,'Radius3D') && strcmpi(g_strctModule.m_strMouseIcon,'Radius3D'))         
     % Erase the kernel from screen...
       if ~isempty(g_strctModule.m_strctPanel.m_strctXY.m_ahMouseRadiusSelect)
           delete(g_strctModule.m_strctPanel.m_strctXY.m_ahMouseRadiusSelect);
           g_strctModule.m_strctPanel.m_strctXY.m_ahMouseRadiusSelect = [];
       end
       if ~isempty(g_strctModule.m_strctPanel.m_strctYZ.m_ahMouseRadiusSelect)
           delete(g_strctModule.m_strctPanel.m_strctYZ.m_ahMouseRadiusSelect);
           g_strctModule.m_strctPanel.m_strctYZ.m_ahMouseRadiusSelect = [];
       end
       if ~isempty(g_strctModule.m_strctPanel.m_strctXZ.m_ahMouseRadiusSelect)
           delete(g_strctModule.m_strctPanel.m_strctXZ.m_ahMouseRadiusSelect);
           g_strctModule.m_strctPanel.m_strctXZ.m_ahMouseRadiusSelect = [];
       end
end
g_strctModule.m_strMouseMode = strMouseMode;
g_strctModule.m_strMouseIcon= strMouseIcon;
set(g_strctModule.m_strctPanel.hMouseModeText,'string',strDescription);
return;
