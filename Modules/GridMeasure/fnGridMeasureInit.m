function GridMeasureInit(strctParams)
% The way module appearance is controlled is by g_strctModule.m_hWindowsPanel
% and g_strctModule.m_ahAxes, all other stuff are module-dependent
global g_strctModule g_strctWindows

g_strctModule.m_strDefaultFilesFolder = 'D:\Data\Doris\Grids\';

g_strctModule.m_iCurrGrid = 0;

g_strctModule.m_acGrids = {};

g_strctModule.m_strctGUIOptions.m_bShowEllipse = true;

g_strctModule.m_bMouseDown = false;
g_strctModule.m_bFirstInvalidate = true;

g_strctModule.m_strMouseMode = 'Scroll';
g_strctModule.m_strctPrevMouseOp = [];
g_strctModule.m_strctLastMouseDown = [];
g_strctModule.m_strctLastMouseUp = [];

fnCreatePanels(); 

return;


function fnCreatePanels()
global g_strctModule g_strctWindows
% Create the four-window display
aiWindowSize = get(g_strctWindows.m_hFigure,'Position');


if aiWindowSize(2) == 1
    iOffset = -30;
else
    iOffset = 10;
end;

iRightPanelWidth = 300;
strctPanel.m_aiRightPanelSize = [aiWindowSize(3)-iRightPanelWidth+10 5 iRightPanelWidth-20 aiWindowSize(4)-aiWindowSize(2)+iOffset];
strctPanel.m_hRightPanel = uipanel('Units','Pixels','Position',strctPanel.m_aiRightPanelSize);


strctPanel.m_aiWindowsPanelSize = [5 5  aiWindowSize(3)-strctPanel.m_aiRightPanelSize(3)-20 aiWindowSize(4)-aiWindowSize(2)];
strctPanel.m_hWindowsPanel = uipanel('Units','Pixels','Position',strctPanel.m_aiWindowsPanelSize,'parent',g_strctWindows.m_hFigure);

iSeparationBetweenWindowsPix = 30;
iMaxWindowWidth = floor( strctPanel.m_aiWindowsPanelSize(3) /2) ;
iMaxWindowHeight = floor( strctPanel.m_aiWindowsPanelSize(4) /2) ;
iAxesSize = min(iMaxWindowHeight, iMaxWindowWidth)-iSeparationBetweenWindowsPix;

strctPanel.m_aiImageRes = [256,256,3];
strctPanel.m_aiAxesSize = [1 1 iAxesSize,iAxesSize];
strctPanel.m_ahDrawHandles = [];

strctPanel.m_hMenu = uicontextmenu('Callback',@fnMouseDownEmulator);
uimenu(strctPanel.m_hMenu, 'Label', 'Pan Image', 'Callback', {@fnCallback,'SetPanMode'});
uimenu(strctPanel.m_hMenu, 'Label', 'Zoom Image', 'Callback', {@fnCallback,'SetZoomMode'});
uimenu(strctPanel.m_hMenu, 'Label', 'Reset View', 'Callback', {@fnCallback,'ResetView'});
uimenu(strctPanel.m_hMenu, 'Label', 'Move Ellipse', 'Callback', {@fnCallback,'SetMoveMode'},'separator','on');
uimenu(strctPanel.m_hMenu, 'Label', 'Scale X', 'Callback', {@fnCallback,'SetScaleXMode'});
uimenu(strctPanel.m_hMenu, 'Label', 'Scale Y', 'Callback', {@fnCallback,'SetScaleYMode'});
uimenu(strctPanel.m_hMenu, 'Label', 'Rotate Ellipse', 'Callback', {@fnCallback,'SetRotateMode'});
uimenu(strctPanel.m_hMenu, 'Label', 'Resize To Metric', 'Callback', {@fnCallback,'ResizeToMetric'});
uimenu(strctPanel.m_hMenu, 'Label', 'Show/Hide Grid Holes', 'Callback', {@fnCallback,'ShowHideHoles'},'separator','on');
uimenu(strctPanel.m_hMenu, 'Label', 'Pan Grid', 'Callback', {@fnCallback,'PanGrid'});
uimenu(strctPanel.m_hMenu, 'Label', 'Rotate Grid', 'Callback', {@fnCallback,'RotateGrid'});
uimenu(strctPanel.m_hMenu, 'Label', 'Add Hole', 'Callback', {@fnCallback,'AddHole'},'separator','on');
uimenu(strctPanel.m_hMenu, 'Label', 'Move Hole', 'Callback', {@fnCallback,'MoveHole'});
uimenu(strctPanel.m_hMenu, 'Label', 'Remove Hole', 'Callback', {@fnCallback,'RemoveHole'});
strctPanel.m_strctFront.m_aiPos =[5 strctPanel.m_aiWindowsPanelSize(4)-iAxesSize-35,iAxesSize,iAxesSize];
strctPanel.m_strctFront.m_hPanel = uipanel('Units','Pixels','Position',strctPanel.m_strctFront.m_aiPos,'parent',strctPanel.m_hWindowsPanel);
strctPanel.m_strctFront.m_hAxes = axes('units','pixels','position',strctPanel.m_aiAxesSize,'parent',strctPanel.m_strctFront.m_hPanel);
strctPanel.m_strctFront.m_hImage = image([],[],zeros(strctPanel.m_aiImageRes),'parent',strctPanel.m_strctFront.m_hAxes,'uicontextmenu',strctPanel.m_hMenu);
strctPanel.m_strctFront.m_aiAxisRange = [0 1 0 1];

set(strctPanel.m_strctFront.m_hAxes,'Visible','off');
hold(strctPanel.m_strctFront.m_hAxes,'on');

strctPanel.m_strctBack.m_aiPos = [1 1 iAxesSize,iAxesSize];
strctPanel.m_strctBack.m_hPanel = uipanel('Units','Pixels','Position',strctPanel.m_strctBack.m_aiPos,'parent',strctPanel.m_hWindowsPanel);
strctPanel.m_strctBack.m_hAxes = axes('units','pixels','position',strctPanel.m_aiAxesSize,'parent',strctPanel.m_strctBack.m_hPanel);
strctPanel.m_strctBack.m_hImage = image([],[],zeros(strctPanel.m_aiImageRes),'parent',strctPanel.m_strctBack.m_hAxes,'uicontextmenu',strctPanel.m_hMenu);
strctPanel.m_strctBack.m_aiAxisRange = [0 1 0 1];
set(strctPanel.m_strctBack.m_hAxes,'Visible','off');
hold(strctPanel.m_strctBack.m_hAxes,'on');


strctPanel.m_hStatusLine = uicontrol('style','text','String','Status Line','Position',...
     [5 strctPanel.m_aiWindowsPanelSize(4)-20 600 15],'parent',strctPanel.m_hWindowsPanel);

strctPanel.m_hGridMenu = uicontextmenu;
uimenu(strctPanel.m_hGridMenu, 'Label', 'Add New Grid', 'Callback', {@fnCallback,'AddNewGrid'});
uimenu(strctPanel.m_hGridMenu, 'Label', 'Load Front', 'Callback', {@fnCallback,'LoadFront'});
uimenu(strctPanel.m_hGridMenu, 'Label', 'Load Back', 'Callback', {@fnCallback,'LoadBack'});
uimenu(strctPanel.m_hGridMenu, 'Label', 'Rename', 'Callback', {@fnCallback,'RenameGrid'});
uimenu(strctPanel.m_hGridMenu, 'Label', 'Set Full Grid', 'Callback', {@fnCallback,'SetFullGrid'});
uimenu(strctPanel.m_hGridMenu, 'Label', 'Export', 'Callback', {@fnCallback,'ExportGrid'},'separator','on');
uimenu(strctPanel.m_hGridMenu, 'Label', 'Remove', 'Callback', {@fnCallback,'RemoveGrid'},'separator','on');
 
strctPanel.m_hGridList = uicontrol('style','listbox','String','',...
    'Position',[10  strctPanel.m_aiRightPanelSize(4)-170 strctPanel.m_aiRightPanelSize(3)-20 150],'parent',...
    strctPanel.m_hRightPanel,'callback',{@fnCallback,'SelectGrid'},'uicontextmenu',strctPanel.m_hGridMenu);



strctPanel.m_ahAxes = [strctPanel.m_strctFront.m_hAxes, strctPanel.m_strctBack.m_hAxes];
strctPanel.m_ahPanels = [strctPanel.m_hRightPanel ,strctPanel.m_hWindowsPanel];
g_strctModule.m_strctPanel = strctPanel;

return;

function pt2fMouseDownPosition = fnGetMouseCoordinate(hAxes)
pt2fMouseDownPosition = get(hAxes,'CurrentPoint');
if size(pt2fMouseDownPosition,2) ~= 3
    pt2fMouseDownPosition = [-1 -1];
else
    pt2fMouseDownPosition = [pt2fMouseDownPosition(1,1), pt2fMouseDownPosition(1,2)];
end;
return;


function fnMouseDownEmulator(a,b)
global g_strctModule g_strctWindows
strctMouseOp.m_hAxes = fnGetActiveAxes(get(g_strctWindows.m_hFigure,'CurrentPoint'));
strctMouseOp.m_pt2fPos = fnGetMouseCoordinate(strctMouseOp.m_hAxes);
g_strctModule.m_strctMouseOpMenu = strctMouseOp;
return;

function fnCallback(a,b,strEvent,varargin)
global g_strctModule
feval(g_strctModule.m_hCallbackFunc,strEvent,varargin{:});
return;
