function bInitOK = fnRegisterationInit(strctParams)
% The way module appearance is controlled is by g_strctModule.m_hWindowsPanel
% and g_strctModule.m_ahAxes, all other stuff are module-dependent
global g_strctModule g_strctWindows
g_strctModule.m_bVolumeLoaded = false;


g_strctModule.m_strDefaultFilesFolder = 'D:\Data\Doris\MRI\Rocco\Volumes\';
g_strctModule.m_strctGUIOptions.m_bShow2DPlanes = true;
g_strctModule.m_strctStationaryVol = [];
g_strctModule.m_strctMovableVol = [];
g_strctModule.m_iDisplayMode  = 1;
g_strctModule.m_iNumDisplayModes = 4;
g_strctModule.m_bMouseDown = false;
g_strctModule.m_bFirstInvalidate = true;
g_strctModule.m_strMouseMode = 'Scroll';
g_strctModule.m_strctPrevMouseOp = [];
g_strctModule.m_strctLastMouseDown = [];
g_strctModule.m_strctLastMouseUp = [];
g_strctModule.m_a2fMarkersStat = zeros(0,3);
g_strctModule.m_a2fMarkersMov= zeros(0,3);
g_strctModule.m_bDrawMovInStat = false;
g_strctModule.m_bToggleFlip = false;
g_strctModule.m_iNumUndoOpBuffer = 100;
g_strctModule.m_a3fPrevReg = zeros(4,4,g_strctModule.m_iNumUndoOpBuffer);
g_strctModule.m_a3fPrevReg(:,:,1) = eye(4);
g_strctModule.m_iUndoIndex = 2;

fnCreatePanels(); 
bInitOK = true;
return;


function fnCreatePanels()
global g_strctModule g_strctWindows
aiWindowSize = get(g_strctWindows.m_hFigure,'Position');

%%

iOffset = 2;
iHeight = aiWindowSize(4);
iFigureWidth = aiWindowSize(3);

iRightPanelWidth = 300;

strctPanel.m_aiRightPanelSize = [iFigureWidth-iRightPanelWidth-iOffset 1 iRightPanelWidth iHeight-30];
strctPanel.m_hRightPanel = uipanel('Units','Pixels','Position',strctPanel.m_aiRightPanelSize);
strctPanel.m_aiWindowsPanelSize = [5 5  aiWindowSize(3)-strctPanel.m_aiRightPanelSize(3)-20 iHeight-30];
strctPanel.m_hWindowsPanel = uipanel('Units','Pixels','Position',strctPanel.m_aiWindowsPanelSize,'parent',g_strctWindows.m_hFigure);

iSeparationBetweenWindowsPix = 30;
iMaxWindowWidth = floor( strctPanel.m_aiWindowsPanelSize(3) /3) ;
iMaxWindowHeight = floor( strctPanel.m_aiWindowsPanelSize(4) /2) ;
iAxesSize = min(iMaxWindowHeight, iMaxWindowWidth)-iSeparationBetweenWindowsPix;

strctPanel.m_aiImageRes = [256,256,3];
strctPanel.m_aiAxesSize = [1 1 iAxesSize,iAxesSize];
acDesc = {'XY','YZ','XZ'};
for k=1:3
    strctPanel.m_astrctCrossSection(k).m_aiPos =[(k-1)*iAxesSize+(k-1)*iSeparationBetweenWindowsPix strctPanel.m_aiWindowsPanelSize(4)-iAxesSize-35 iAxesSize,iAxesSize];
    strctPanel.m_astrctCrossSection(k).m_hPanel = uipanel('Units','Pixels','Position',strctPanel.m_astrctCrossSection(k).m_aiPos,'parent',strctPanel.m_hWindowsPanel);
    strctPanel.m_astrctCrossSection(k).m_hAxes = axes('units','pixels','position',strctPanel.m_aiAxesSize,'parent',strctPanel.m_astrctCrossSection(k).m_hPanel);
    strctPanel.m_astrctCrossSection(k).m_hImage = image([],[],zeros(strctPanel.m_aiImageRes),'parent',strctPanel.m_astrctCrossSection(k).m_hAxes);
    set(strctPanel.m_astrctCrossSection(k).m_hAxes,'Visible','off');
    hold(strctPanel.m_astrctCrossSection(k).m_hAxes,'on');
    strctPanel.m_astrctCrossSection(k).m_hStatusLine = text(10,10,acDesc{k},'parent',strctPanel.m_astrctCrossSection(k).m_hAxes,'color',[1 1 1]);
end

for k=1:3
    strctPanel.m_astrctCrossSection(3+k).m_aiPos =[(k-1)*iAxesSize+(k-1)*iSeparationBetweenWindowsPix  strctPanel.m_aiWindowsPanelSize(4)-2*iAxesSize-70 iAxesSize,iAxesSize];
    strctPanel.m_astrctCrossSection(3+k).m_hPanel = uipanel('Units','Pixels','Position',strctPanel.m_astrctCrossSection(3+k).m_aiPos,'parent',strctPanel.m_hWindowsPanel);
    strctPanel.m_astrctCrossSection(3+k).m_hAxes = axes('units','pixels','position',strctPanel.m_aiAxesSize,'parent',strctPanel.m_astrctCrossSection(3+k).m_hPanel);
    strctPanel.m_astrctCrossSection(3+k).m_hImage = image([],[],zeros(strctPanel.m_aiImageRes),'parent',strctPanel.m_astrctCrossSection(3+k).m_hAxes);
    set(strctPanel.m_astrctCrossSection(3+k).m_hAxes,'Visible','off');
    hold(strctPanel.m_astrctCrossSection(3+k).m_hAxes,'on');
    strctPanel.m_astrctCrossSection(3+k).m_hStatusLine = text(10,10,acDesc{k},'parent',strctPanel.m_astrctCrossSection(3+k).m_hAxes,'color',[1 1 1]);
end


strctPanel.m_hLoadStationaryVolBut =  uicontrol('style','pushbutton','String','Load Stationary',...
    'Position',[10  strctPanel.m_aiRightPanelSize(4)-40 100 30],'parent',strctPanel.m_hRightPanel,'callback',{@fnCallback,'LoadStationary'});

strctPanel.m_hLoadMovableVolBut =  uicontrol('style','pushbutton','String','Load Movable',...
    'Position',[160  strctPanel.m_aiRightPanelSize(4)-40 100 30],'parent',strctPanel.m_hRightPanel,'callback',{@fnCallback,'LoadMovable'},'enable','off');

strctPanel.m_hSaveRegBut =  uicontrol('style','pushbutton','String','Save Registeration',...
    'Position',[10  strctPanel.m_aiRightPanelSize(4)-80 100 30],'parent',strctPanel.m_hRightPanel,'callback',{@fnCallback,'SaveReg'});

strctPanel.m_hLoadRegBut =  uicontrol('style','pushbutton','String','Load Registeration',...
    'Position',[160  strctPanel.m_aiRightPanelSize(4)-80 100 30],'parent',strctPanel.m_hRightPanel,'callback',{@fnCallback,'LoadReg'});

strctPanel.m_hAutoRegBut =  uicontrol('style','pushbutton','String','Automatic Registeration',...
    'Position',[10  strctPanel.m_aiRightPanelSize(4)-130 140 30],'parent',strctPanel.m_hRightPanel,'callback',{@fnCallback,'AutoReg'});

strctPanel.m_hAddMarker =  uicontrol('style','pushbutton','String','Add Marker',...
    'Position',[10  strctPanel.m_aiRightPanelSize(4)-130 140 30],'parent',strctPanel.m_hRightPanel,'callback',{@fnCallback,'AddMarker'});

strctPanel.m_hDelMarker =  uicontrol('style','pushbutton','String','Delete Marker',...
    'Position',[10  strctPanel.m_aiRightPanelSize(4)-180 130 30],'parent',strctPanel.m_hRightPanel,'callback',{@fnCallback,'DelMarker'});

strctPanel.m_hUpdateMarker =  uicontrol('style','pushbutton','String','Update Marker',...
    'Position',[160  strctPanel.m_aiRightPanelSize(4)-180 130 30],'parent',strctPanel.m_hRightPanel,'callback',{@fnCallback,'UpdateMarker'});


strctPanel.m_hUndo =  uicontrol('style','pushbutton','String','Undo',...
    'Position',[160  strctPanel.m_aiRightPanelSize(4)-130 130 30],'parent',strctPanel.m_hRightPanel,'callback',{@fnCallback,'Undo'});

strctPanel.m_hSolveMarkers =  uicontrol('style','pushbutton','String','Solve Correspondence',...
    'Position',[10  strctPanel.m_aiRightPanelSize(4)-230 130 30],'parent',strctPanel.m_hRightPanel,'callback',{@fnCallback,'SolveMarkers'});

strctPanel.m_hFlirt =  uicontrol('style','pushbutton','String','Run FLIRT',...
    'Position',[160  strctPanel.m_aiRightPanelSize(4)-230 130 30],'parent',strctPanel.m_hRightPanel,'callback',{@fnCallback,'RunFLIRT'});


strctPanel.m_hResetReg =  uicontrol('style','pushbutton','String','Reset To I',...
    'Position',[10  strctPanel.m_aiRightPanelSize(4)-280 130 30],'parent',strctPanel.m_hRightPanel,'callback',{@fnCallback,'ResetReg'});

strctPanel.m_hSaveMarkers =  uicontrol('style','pushbutton','String','Reset To I',...
    'Position',[160  strctPanel.m_aiRightPanelSize(4)-280 130 30],'parent',strctPanel.m_hRightPanel,'callback',{@fnCallback,'SaveMarkers'});


% strctPanel.m_hFlirt =  uicontrol('style','pushbutton','String','Run FLIRT',...
%     'Position',[160  strctPanel.m_aiRightPanelSize(4)-230 130 30],'parent',strctPanel.m_hRightPanel,'callback',{@fnCallback,'RunFLIRT'});

% 
% strctPanel.m_hMarkersListText = uicontrol('style','text','String','Markers',...
%     'Position',[10  strctPanel.m_aiRightPanelSize(4)-350 100 20],'parent',strctPanel.m_hRightPanel);

strctPanel.m_hMarkersList = uicontrol('style','listbox','String','',...
    'Position',[10  strctPanel.m_aiRightPanelSize(4)-660 iRightPanelWidth-20 200],...
    'parent',strctPanel.m_hRightPanel,'callback',{@fnCallback,'SelectMarker'});%,'UIContextMenu',strctPanel.m_hTargetListMenu);


strctPanel.m_hMenu = uicontextmenu('Callback',@fnMouseDownEmulator);
% uimenu(strctPanel.m_hMenu, 'Label', 'Translate Movable', 'Callback', {@fnCallback,'SetTranslateMovable'});
% uimenu(strctPanel.m_hMenu, 'Label', 'Rotate Movable', 'Callback', {@fnCallback,'SetRotateMovable'});
% uimenu(strctPanel.m_hMenu, 'Label', 'Contrast Stationary', 'Callback', {@fnCallback,'SetContrastModeStationary'});
% uimenu(strctPanel.m_hMenu, 'Label', 'Contrast Movable', 'Callback', {@fnCallback,'SetContrastModeMovable'});

uimenu(strctPanel.m_hMenu, 'Label', 'Scroll', 'Callback', {@fnCallback,'SetSlicesMode'});
uimenu(strctPanel.m_hMenu, 'Label', 'Contrast', 'Callback', {@fnCallback,'SetContrastMode'});

uimenu(strctPanel.m_hMenu, 'Label', 'Zoom', 'Callback', {@fnCallback,'SetZoomMode'});
uimenu(strctPanel.m_hMenu, 'Label', 'Zoom (Linked)', 'Callback', {@fnCallback,'SetZoomLinkedMode'});

uimenu(strctPanel.m_hMenu, 'Label', 'Rotate', 'Callback', {@fnCallback,'SetRotate2DMode'});
uimenu(strctPanel.m_hMenu, 'Label', 'Move', 'Callback', {@fnCallback,'SetPanMode'});

uimenu(strctPanel.m_hMenu, 'Label', 'Reset View', 'Callback', {@fnCallback,'SetDefaultView'}, 'Separator','on');
uimenu(strctPanel.m_hMenu, 'Label', 'Crosshair(on/off)', 'Callback', {@fnCallback,'ShowHideCrosshairs'});

for k=1:6
    set(strctPanel.m_astrctCrossSection(k).m_hImage, 'UIContextMenu', strctPanel.m_hMenu);
end
 
strctPanel.m_ahAxes = cat(1,strctPanel.m_astrctCrossSection.m_hAxes);
strctPanel.m_ahPanels = [strctPanel.m_hRightPanel ,strctPanel.m_hWindowsPanel];
for k=1:length(strctPanel.m_ahPanels)
    set(strctPanel.m_ahPanels(k),'visible','off');
end
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

function pt2fMouseDownPosition = fnGetMouseCoordinateScreen()
global g_strctWindows
pt2fMouseDownPosition = get(g_strctWindows.m_hFigure,'CurrentPoint');
%pt2fMouseDownPosition = pt2fMouseDownPosition(3:4)
return;

function fnMouseDownEmulator(a,b)
global g_strctModule g_strctWindows
% strctMouseOp.m_strButton = fnGetClickType();
% strctMouseOp.m_strAction = 'Down';
strctMouseOp.m_hAxes = fnGetActiveAxes(get(g_strctWindows.m_hFigure,'CurrentPoint'));
strctMouseOp.m_pt2fPos = fnGetMouseCoordinate(strctMouseOp.m_hAxes);
g_strctModule.m_strctMouseOpMenu = strctMouseOp;
% strctMouseOp.m_pt2fPosScr = fnGetMouseCoordinateScreen();
% strctMouseOp.m_hObjectSelected = [];
% feval(g_strctModule.m_hCallbackFunc,'MouseDown',strctMouseOp);
return;


function fnCallback(a,b,strEvent,varargin)
global g_strctModule
feval(g_strctModule.m_hCallbackFunc,strEvent,varargin{:});
return;
