function fnVolumeViewerInit(strctParams)
% The way module appearance is controlled is by g_strctModule.m_hWindowsPanel
% and g_strctModule.m_ahAxes, all other stuff are module-dependent
global g_strctModule g_strctWindows
g_strctModule.m_bVolumeLoaded = false;


g_strctModule.m_strDefaultFilesFolder = 'D:\Data\Doris\MRI\Rocco\Volumes\';

g_strctModule.m_iCurrAnatVol = 0;
g_strctModule.m_iCurrFuncVol = 0;

g_strctModule.m_acAnatVol = {};
g_strctModule.m_acFuncVol = {};

g_strctModule.m_bMouseDown = false;
g_strctModule.m_bFirstInvalidate = true;
g_strctModule.m_bFuncVolLoaded = false;
g_strctModule.m_strctOverlay.m_pt2fLeft = [-8, 1];
g_strctModule.m_strctOverlay.m_pt2fRight = [-4, 0];
g_strctModule.m_afPvalueRange = [-15 0];
g_strctModule.m_strMouseMode = 'Scroll';
g_strctModule.m_strMouse3DMode = 'Rotate';
g_strctModule.m_bShow3DPlanes = true;
g_strctModule.m_bShow2DPlanes = true;
g_strctModule.m_bShowFunctional = true;
g_strctModule.m_strctPrevMouseOp = [];
g_strctModule.m_strctLastMouseDown = [];
g_strctModule.m_strctLastMouseUp = [];

fnCreatePanels(); 
if ~isempty(strctParams)
    fnCreateInitialCrossSections(strctParams);
end;

return;


function fnCreatePanels()
global g_strctModule g_strctWindows
% Create the four-window display
aiWindowSize = get(g_strctWindows.m_hFigure,'Position');


iRightPanelWidth = 300;
strctPanel.m_aiRightPanelSize = [aiWindowSize(3)-iRightPanelWidth+10 5 iRightPanelWidth-20 aiWindowSize(4)-aiWindowSize(2)];
strctPanel.m_hRightPanel = uipanel('Units','Pixels','Position',strctPanel.m_aiRightPanelSize);


strctPanel.m_aiWindowsPanelSize = [5 5  aiWindowSize(3)-strctPanel.m_aiRightPanelSize(3)-20 aiWindowSize(4)-aiWindowSize(2)];
strctPanel.m_hWindowsPanel = uipanel('Units','Pixels','Position',strctPanel.m_aiWindowsPanelSize,'parent',g_strctWindows.m_hFigure);

% Set the overlay axes
strctPanel.m_strctOverlayAxes.m_aiOverlaySize = [40 strctPanel.m_aiRightPanelSize(4)-150 iRightPanelWidth-70 100];
strctPanel.m_strctOverlayAxes.m_hAxes = axes('units','pixels','position',strctPanel.m_strctOverlayAxes.m_aiOverlaySize,'parent',strctPanel.m_hRightPanel);
grid(strctPanel.m_strctOverlayAxes.m_hAxes,'on');
box(strctPanel.m_strctOverlayAxes.m_hAxes ,'on');
hold(strctPanel.m_strctOverlayAxes.m_hAxes ,'on');

%strctPanel.m_hStatusLine = uicontrol('style','text','String','Status Line','Position',[5 aiWindowSize(4)-aiWindowSize(2) 600 15],'parent',g_strctWindows.m_hFigure);



strctPanel.m_hLoadVolBut =  uicontrol('style','pushbutton','String','Load Anatomical',...
    'Position',[10  strctPanel.m_aiRightPanelSize(4)-250 100 30],'parent',strctPanel.m_hRightPanel,'callback',{@fnCallback,'LoadAnatVol'});

strctPanel.m_hLoadVolBut =  uicontrol('style','pushbutton','String','Load Functional',...
    'Position',[160  strctPanel.m_aiRightPanelSize(4)-250 100 30],'parent',strctPanel.m_hRightPanel,'callback',{@fnCallback,'LoadFuncVol'});


strctPanel.m_hAnatList = uicontrol('style','listbox','String','',...
    'Position',[10  strctPanel.m_aiRightPanelSize(4)-430 120 150],'parent',strctPanel.m_hRightPanel,'callback',{@fnCallback,'SwitchAnat'});

strctPanel.m_hFuncList = uicontrol('style','listbox','String','',...
    'Position',[140  strctPanel.m_aiRightPanelSize(4)-430 120 150],'parent',strctPanel.m_hRightPanel,'callback',{@fnCallback,'SwitchFunc'});



strctPanel.m_strctOverlayAxes.hLine1 = plot(strctPanel.m_strctOverlayAxes.m_hAxes,[g_strctModule.m_afPvalueRange(1) g_strctModule.m_strctOverlay.m_pt2fLeft(1)],...
    [g_strctModule.m_strctOverlay.m_pt2fLeft(2) g_strctModule.m_strctOverlay.m_pt2fLeft(2)],'b','LineWidth',2);
strctPanel.m_strctOverlayAxes.hLine2 = plot(strctPanel.m_strctOverlayAxes.m_hAxes,...
    [g_strctModule.m_strctOverlay.m_pt2fLeft(1) g_strctModule.m_strctOverlay.m_pt2fRight(1)],...
    [g_strctModule.m_strctOverlay.m_pt2fLeft(2) g_strctModule.m_strctOverlay.m_pt2fRight(2)],'b','LineWidth',2);
strctPanel.m_strctOverlayAxes.hLine3 = plot(strctPanel.m_strctOverlayAxes.m_hAxes,[g_strctModule.m_strctOverlay.m_pt2fRight(1) g_strctModule.m_afPvalueRange(2) ],...
    [g_strctModule.m_strctOverlay.m_pt2fRight(2) g_strctModule.m_strctOverlay.m_pt2fRight(2)],'b','LineWidth',2);

strctPanel.m_strctOverlayAxes.hLeftPoint = plot( strctPanel.m_strctOverlayAxes.m_hAxes,...
 g_strctModule.m_strctOverlay.m_pt2fLeft(1),g_strctModule.m_strctOverlay.m_pt2fLeft(2),'r.','markersize',31);
strctPanel.m_strctOverlayAxes.hRightPoint = plot( strctPanel.m_strctOverlayAxes.m_hAxes,...
 g_strctModule.m_strctOverlay.m_pt2fRight(1),g_strctModule.m_strctOverlay.m_pt2fRight(2),'r.','markersize',31);

axis(strctPanel.m_strctOverlayAxes.m_hAxes,[g_strctModule.m_afPvalueRange 0 1]);
xlabel(strctPanel.m_strctOverlayAxes.m_hAxes,'p-value');
ylabel(strctPanel.m_strctOverlayAxes.m_hAxes,'Opacity');

iSeparationBetweenWindowsPix = 30;
iMaxWindowWidth = floor( strctPanel.m_aiWindowsPanelSize(3) /2) ;
iMaxWindowHeight = floor( strctPanel.m_aiWindowsPanelSize(4) /2) ;
iAxesSize = min(iMaxWindowHeight, iMaxWindowWidth)-iSeparationBetweenWindowsPix;

strctPanel.m_aiImageRes = [256,256,3];

% Set XY Panel
strctPanel.m_strctXY.m_aiPos = [5 5 iAxesSize,iAxesSize];
strctPanel.m_strctXY.m_hAxes = axes('units','pixels','position',strctPanel.m_strctXY.m_aiPos,'parent',strctPanel.m_hWindowsPanel);
strctPanel.m_strctXY.m_hImage = image([],[],zeros(strctPanel.m_aiImageRes),'parent',strctPanel.m_strctXY.m_hAxes);
set(strctPanel.m_strctXY.m_hAxes,'Visible','off');
hold(strctPanel.m_strctXY.m_hAxes,'on');

strctPanel.m_strctYZ.m_aiPos = [5 strctPanel.m_aiWindowsPanelSize(4)-iAxesSize-45,iAxesSize,iAxesSize];
strctPanel.m_strctYZ.m_hAxes = axes('units','pixels','position',strctPanel.m_strctYZ.m_aiPos,'parent',strctPanel.m_hWindowsPanel);
strctPanel.m_strctYZ.m_hImage = image([],[],zeros(strctPanel.m_aiImageRes),'parent',strctPanel.m_strctYZ.m_hAxes);
set(strctPanel.m_strctYZ.m_hAxes,'Visible','off');
hold(strctPanel.m_strctYZ.m_hAxes,'on');

strctPanel.m_strctXZ.m_aiPos =[iAxesSize+iSeparationBetweenWindowsPix strctPanel.m_aiWindowsPanelSize(4)-iAxesSize-45 iAxesSize,iAxesSize];
strctPanel.m_strctXZ.m_hAxes = axes('units','pixels','position',strctPanel.m_strctXZ.m_aiPos,'parent',strctPanel.m_hWindowsPanel);
strctPanel.m_strctXZ.m_hImage = image([],[],zeros(strctPanel.m_aiImageRes),'parent',strctPanel.m_strctXZ.m_hAxes);
set(strctPanel.m_strctXZ.m_hAxes,'Visible','off');
hold(strctPanel.m_strctXZ.m_hAxes,'on');

strctPanel.m_strct3D.m_aiPos = [iAxesSize+iSeparationBetweenWindowsPix 5 iAxesSize,iAxesSize];
strctPanel.m_strct3D.m_hAxes = axes('units','pixels','position',strctPanel.m_strct3D.m_aiPos,'parent',strctPanel.m_hWindowsPanel,...
    'Color',[0 0 0],'XTickLabel',[],'YTickLabel',[],'ZTickLabel',[]);
axis(strctPanel.m_strct3D.m_hAxes,'vis3d')

g_strctModule.m_strctPanel.m_hMenu = uicontextmenu;
uimenu(g_strctModule.m_strctPanel.m_hMenu, 'Label', 'Scroll', 'Callback', {@fnCallback,'SetSlicesMode'});
uimenu(g_strctModule.m_strctPanel.m_hMenu, 'Label', 'Contrast', 'Callback', {@fnCallback,'SetContrastMode'});
uimenu(g_strctModule.m_strctPanel.m_hMenu, 'Label', 'Zoom', 'Callback', {@fnCallback,'SetZoomMode'});
uimenu(g_strctModule.m_strctPanel.m_hMenu, 'Label', 'Pan', 'Callback', {@fnCallback,'SetPanMode'});
uimenu(g_strctModule.m_strctPanel.m_hMenu, 'Label', 'Reset View', 'Callback', {@fnCallback,'SetDefaultView'}, 'Separator','on');
uimenu(g_strctModule.m_strctPanel.m_hMenu, 'Label', 'Crosshair(on/off)', 'Callback', {@fnCallback,'ShowHideCrosshairs'});
uimenu(g_strctModule.m_strctPanel.m_hMenu, 'Label', 'Functional Overlay(on/off)', 'Callback', {@fnCallback,'ShowFunctional'});


set(strctPanel.m_strctXY.m_hImage, 'UIContextMenu', g_strctModule.m_strctPanel.m_hMenu);
set(strctPanel.m_strctYZ.m_hImage, 'UIContextMenu', g_strctModule.m_strctPanel.m_hMenu);
set(strctPanel.m_strctXZ.m_hImage, 'UIContextMenu', g_strctModule.m_strctPanel.m_hMenu);

strctPanel.m_hMenu3D = uicontextmenu;
uimenu(strctPanel.m_hMenu3D, 'Label', 'Rotate', 'Callback', {@fnCallback,'SetRotateMode'});
uimenu(strctPanel.m_hMenu3D, 'Label', 'Zoom', 'Callback', {@fnCallback,'SetZoom3DMode'});
uimenu(strctPanel.m_hMenu3D, 'Label', 'Pan', 'Callback', {@fnCallback,'SetPan3DMode'});
uimenu(strctPanel.m_hMenu3D, 'Label', 'Hide/Show Planes', 'Callback',{@fnCallback,'HideShowPlanes'});

set(strctPanel.m_strct3D.m_hAxes, 'UIContextMenu', strctPanel.m_hMenu3D);

% 
strctPanel.m_ahAxes = [strctPanel.m_strctXY.m_hAxes, strctPanel.m_strctYZ.m_hAxes, ...
    strctPanel.m_strctXZ.m_hAxes,...
    strctPanel.m_strct3D.m_hAxes,...
    strctPanel.m_strctOverlayAxes.m_hAxes];

strctPanel.m_ahPanels = [strctPanel.m_hRightPanel ,strctPanel.m_hWindowsPanel];


g_strctModule.m_strctPanel = strctPanel;

return;

function fnCallback(a,b,strEvent)
global g_strctModule
feval(g_strctModule.m_hCallbackFunc,strEvent);
return;
