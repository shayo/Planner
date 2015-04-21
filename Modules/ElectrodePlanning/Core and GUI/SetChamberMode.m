function SetChamberMode()
global g_strctModule
g_strctModule.m_bInChamberMode = true;
g_strctModule.m_bInAtlasMode = false;

set(g_strctModule.m_strctPanel.m_ahRightPanels(2),'visible','on');
set(g_strctModule.m_strctPanel.m_ahRightPanels(1),'visible','off');
set(g_strctModule.m_strctPanel.m_ahRightPanels(3),'visible','off');
set(g_strctModule.m_strctPanel.m_strctStereoTactic.m_hPanel,'visible','on');
set(g_strctModule.m_strctPanel.m_strctStereoTactic.m_hAxes,'visible','on');
set(g_strctModule.m_strctPanel.m_strct3D.m_hPanel,'visible','off');
set(g_strctModule.m_strctPanel.m_strct3D.m_hAxes,'visible','off');
try
    set(g_strctModule.m_strctPanel.m_hMainVolSurface,'visible','off');
catch %#ok
end
if g_strctModule.m_iCurrAnatVol == 0
    return;
end;
fnInvalidateStereotactic();

% cameratoolbar('Show');
g_strctModule.m_strMouse3DMode = 'Rotate';
% set(g_strctModule.m_strctPanel.m_strctStereoTactic.m_hAxes,'CameraPosition',[165.484 367.893 122.855]);
% set(g_strctModule.m_strctPanel.m_strctStereoTactic.m_hAxes,'CameraPositionMode','manual');
% set(g_strctModule.m_strctPanel.m_strctStereoTactic.m_hAxes,'CameraTarget', [9.5 10 7.5]);
% set(g_strctModule.m_strctPanel.m_strctStereoTactic.m_hAxes,'CameraTargetMode','auto');
% set(g_strctModule.m_strctPanel.m_strctStereoTactic.m_hAxes,'CameraUpVector',[0.92368 -0.364689 -0.117546]);
% set(g_strctModule.m_strctPanel.m_strctStereoTactic.m_hAxes,'CameraUpVectorMode','manual');
% set(g_strctModule.m_strctPanel.m_strctStereoTactic.m_hAxes,'CameraViewAngle',6.60861);
% set(g_strctModule.m_strctPanel.m_strctStereoTactic.m_hAxes,'CameraViewAngleMode','manual');
%cameratoolbar('SetMode','orbit')
%cameratoolbar('SetCoordSys','x');
fnSelectMarker();
fnInvalidateVirtualArmList();
fnInvalidate(1);
% update 
% strctPanel.m_hChambersList
% strctPanel.m_hMarkersList

return;