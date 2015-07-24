function EntryPoint
clear global g_strctWindows g_strctApp g_strctModule g_acModules g_iCurrModule 
clear persistent
global g_strctWindows g_strctApp g_strctModule g_acModules g_iCurrModule 
% if ishandle(1,'figure')
%     close(1);
%     drawnow
% end;
warning off
%clear all
addpath(fullfile('.', 'MEX'));
addpath(genpath(fullfile('.', 'Modules')));
%addpath(genpath(fullfile('.', 'RegisterationMatrices')));
%addpath(genpath(fullfile('..', 'PublicLib')));

%addpath(genpath('D:\Code\Doris\MRI\PublicLib\FreeSurfer')); % to load anatomical volumes
%addpath('D:\Code\Doris\MRI\PublicLib\FreeSurfer_Matlab'); % to load structural volumes
%addpath('D:\Code\Doris\MRI\PublicDomainVolumeViewer');
dbstop if error
    
a2iMonitors = get(0,'MonitorPositions');
iNumMonitors = size(a2iMonitors,1);
if iNumMonitors > 1
    % Multiple monitors. ASk user which one to use
    acOptions = cell(1,iNumMonitors);
    for k=1:iNumMonitors
        acOptions{k} = sprintf('Screen %d, [%dx%d]',k,a2iMonitors(k,3)-a2iMonitors(k,1)+1,a2iMonitors(k,4)-a2iMonitors(k,2)+1);
    end
    [iSelectedMonitor] = listdlg('PromptString','Select a monitor:',...
        'SelectionMode','single',...
        'ListString',acOptions);
   if isempty(iSelectedMonitor)
       return;
   end;   
else
    iSelectedMonitor = 1;
end

iStartX = a2iMonitors(iSelectedMonitor,1);
iStartY = a2iMonitors(iSelectedMonitor,4);

if ishandle(1)
    delete(1)
end;
%strctOpenGL = opengl('Data');
%if isfield(strctOpenGL,'Renderer') && strcmpi(strctOpenGL.Renderer,'ATI Radeon HD 5800 Series')
%    fprintf('Detected ATI Radeon HD 5800 series card\n');
%    fprintf('Disabling opengl in hardware to prevent font flip\n');
%    opengl software
%end
g_strctWindows.m_hFigure = figure(1);
drawnow
set(g_strctWindows.m_hFigure,'Position', [ iStartX+50 0         150         120]);%[iStartX+50 iStartY-50 150 150]);

%set(g_strctWindows.m_hFigure,'Renderer','zbuffer');
%     

%painters | zbuffer | OpenGL
clf;
set(g_strctWindows.m_hFigure,'Units','Pixels',...
    'Name','Planner','Visible','on','Menubar','none','Toolbar','none','DockControls','off',...
    'NumberTitle','off');%,'CloseRequestFcn',@fnCloseKofiko);

if isnumeric(g_strctWindows.m_hFigure)
fnMaximizeWindow(g_strctWindows.m_hFigure);
else
    try
        
        fnMaximizeWindow(g_strctWindows.m_hFigure.Number);
    catch
        set(g_strctWindows.m_hFigure.Number,'units','normalized','outerposition',[0 0 1 1])
        set(g_strctWindows.m_hFigure.Number,'units','pixels');
    end
    
end
drawnow
drawnow update
% on a mac, allow some time
if strcmpi(computer,'MACI64')
    tic
    while toc < 1
        aiWindowSize = get(g_strctWindows.m_hFigure,'Position');
        drawnow
    end
end

aiWindowSize = get(g_strctWindows.m_hFigure,'Position');

g_strctWindows.m_hFileMenu = uimenu(g_strctWindows.m_hFigure,'Label','File');
uimenu(g_strctWindows.m_hFileMenu,'Label','Load Saved Session','Callback',{@fnModuleCallBack,'LoadSession'});
uimenu(g_strctWindows.m_hFileMenu,'Label','Save Session','Callback',{@fnModuleCallBack,'SaveSession'});
uimenu(g_strctWindows.m_hFileMenu,'Label','Exit','Callback','return');

g_strctWindows.m_hModulesMenu = uimenu(g_strctWindows.m_hFigure,'Label','Modules');

g_strctWindows.m_hAboutMenu = uimenu(g_strctWindows.m_hFigure,'Label','About');
uimenu(g_strctWindows.m_hAboutMenu,'Label','About Planner','Callback',@fnAboutPlanner);

strctParams = [];
%strctParams.AnatVol = MRIread('D:\Data\Doris\MRI\Rocco\Volumes\091310Stereo.mgz');
%strctParams.FuncVol = MRIread('D:\Data\Doris\MRI\Rocco\Volumes\Bremen_T\sig.bhdr');


strConfigFile = fullfile('.', 'Config', 'PlannerConfig.xml');
if ~exist(strConfigFile,'file')
    fprintf('Could not find XML configuation file at %s\n',strConfigFile);
    fprintf('ABORTING!\n');
    close(g_strctWindows.m_hFigure);
    return;
end;
try
    strctConfig = fnMyXMLToStruct(strConfigFile);
catch
    addpath(genpath(pwd()));
    strctConfig = fnMyXMLToStruct(strConfigFile);
end

g_strctWindows. m_strDefaultFontName = strctConfig.m_strctGUI.m_strDefaultFontName;

iNumModules = length(strctConfig.m_acModules.m_strctModule);
if iNumModules == 1
strctConfig.m_acModules.m_strctModule = {strctConfig.m_acModules.m_strctModule};
end


iModuleCounter = 1;
for iModuleIter=1:iNumModules
    g_strctModule = [];
    g_strctModule.m_strName = strctConfig.m_acModules.m_strctModule{iModuleIter}.m_strctGeneral.m_strName;
    g_strctModule.m_hInitFunc = strctConfig.m_acModules.m_strctModule{iModuleIter}.m_strctGeneral.m_strInitFunc;
    g_strctModule.m_hCallbackFunc = strctConfig.m_acModules.m_strctModule{iModuleIter}.m_strctGeneral.m_strCallbackFunc;
    g_strctModule.m_bInitialized = false;
    hMenu = uimenu(g_strctWindows.m_hModulesMenu,'Label',g_strctModule.m_strName,'callback',{@fnSetActiveModule,iModuleCounter});
    strctParams.m_strctConfig = strctConfig.m_acModules.m_strctModule{iModuleIter};
    strctParams.m_hMenu = hMenu;
    if ~isempty(g_strctModule.m_hInitFunc)
        bInitOK = feval(g_strctModule.m_hInitFunc,strctParams);
        if ~bInitOK
            fprintf('Critical Error. Could not initialize module %s\n',g_strctModule.m_strName);
            delete(hMenu);
            continue;
            %return;
        end;
    end
    g_strctModule.m_bInitialized = true;
    g_strctModule.m_strctConfig = strctConfig.m_acModules.m_strctModule{iModuleIter};
    g_acModules{iModuleCounter} = g_strctModule;
    iModuleCounter = iModuleCounter + 1;
end

% Start with the first module...

fnSetActiveModule([],[],1);

drawnow
set(g_strctWindows.m_hFigure,'WindowButtonMotionFcn',@fnMouseMove);
set(g_strctWindows.m_hFigure,'WindowButtonDownFcn',@fnMouseDown);
set(g_strctWindows.m_hFigure,'WindowButtonUpFcn',@fnMouseUp);
set(g_strctWindows.m_hFigure,'WindowScrollWheelFcn',@fnMouseWheel);
set(g_strctWindows.m_hFigure,'KeyPressFcn',@fnKeyDown);
set(g_strctWindows.m_hFigure,'KeyReleaseFcn',@fnKeyUp);
set(g_strctWindows.m_hFigure,'CloseRequestFcn',@fnCloseRequest);
feval(g_strctModule.m_hCallbackFunc,'Invalidate');
return;

function fnCloseRequest(a,b)
global g_strctModule
% Send close command to current module
if ~isempty(g_strctModule)
    feval(g_strctModule.m_hCallbackFunc,'AppClose');
end
delete(get(0,'Children'));
return;


function fnAboutPlanner(a,b)
acMessage = {'Planner, V1.0 Build 1000, Nov 4 2011',...
             'Developed by Shay Ohayon at California Institute of Technology',...
             '',...
             'This software is protected under provisional patent CIT-5890-P',...
             '"A Novel Method to Target Brain Structures using MRI and a Stereotactic manipulator"',...
             '',...
             'Documentation and updated versions are available at http://tsaolab.caltech.edu',...
             'Contact <shayo@caltech.edu> for more information.'};
msgbox(acMessage,'About Planner','horizontalalignment','center');
return;

function fnModuleCallBack(a,b,strEvent)
global g_strctModule 
feval(g_strctModule.m_hCallbackFunc,strEvent);
return;

% function fnEvokeCallback(a,b,strCallback, varargin)
% global g_strctModule
% feval(g_strctModule.m_hCallbackFunc, strCallback,varargin{:});
% return;


function fnMouseMove(obj,eventdata)
global g_strctModule g_strctWindows
if isempty(g_strctModule) || ~g_strctModule.m_bInitialized
    return;
end;

strctMouseOp.m_strButton = []; 
strctMouseOp.m_strAction = 'Move';
strctMouseOp.m_hAxes = fnGetActiveAxes(get(g_strctWindows.m_hFigure,'CurrentPoint'));
strctMouseOp.m_pt2fPos = fnGetMouseCoordinate(strctMouseOp.m_hAxes);
strctMouseOp.m_pt2fPosScr = fnGetMouseCoordinateScreen();
strctMouseOp.m_hObjectSelected = [];
feval(g_strctModule.m_hCallbackFunc,'MouseMove',strctMouseOp);
return;

function fnMouseUp(obj,eventdata)
global g_strctModule g_strctWindows
strctMouseOp.m_strButton = fnGetClickType(g_strctWindows.m_hFigure);
strctMouseOp.m_strAction = 'Up';
strctMouseOp.m_hAxes = fnGetActiveAxes(get(g_strctWindows.m_hFigure,'CurrentPoint'));
strctMouseOp.m_pt2fPos = fnGetMouseCoordinate(strctMouseOp.m_hAxes);
strctMouseOp.m_pt2fPosScr = fnGetMouseCoordinateScreen();
strctMouseOp.m_hObjectSelected = [];
feval(g_strctModule.m_hCallbackFunc,'MouseUp',strctMouseOp);
return;

function fnKeyDown(a,b)
global g_strctModule
if ~isempty(g_strctModule)
    feval(g_strctModule.m_hCallbackFunc,'KeyDown',b);
end
return;

function fnKeyUp(a,b)
global g_strctModule
feval(g_strctModule.m_hCallbackFunc,'KeyUp',b);
return;

function fnMouseDown(obj,eventdata)
global g_strctModule g_strctWindows
strctMouseOp.m_strButton = fnGetClickType(g_strctWindows.m_hFigure);
strctMouseOp.m_strAction = 'Down';
strctMouseOp.m_hAxes = fnGetActiveAxes(get(g_strctWindows.m_hFigure,'CurrentPoint'));
strctMouseOp.m_pt2fPos = fnGetMouseCoordinate(strctMouseOp.m_hAxes);
strctMouseOp.m_pt2fPosScr = fnGetMouseCoordinateScreen();
strctMouseOp.m_hObjectSelected = [];
feval(g_strctModule.m_hCallbackFunc,'MouseDown',strctMouseOp);
return;

function fnMouseWheel(obj,eventdata)
global g_strctModule g_strctWindows
strctMouseOp.m_strButton = fnGetClickType(g_strctWindows.m_hFigure);
strctMouseOp.m_strAction = 'Wheel';
strctMouseOp.m_hAxes = fnGetActiveAxes(get(g_strctWindows.m_hFigure,'CurrentPoint'));
strctMouseOp.m_pt2fPos = fnGetMouseCoordinate(strctMouseOp.m_hAxes);
strctMouseOp.m_pt2fPosScr = fnGetMouseCoordinateScreen();
strctMouseOp.m_iScroll = eventdata.VerticalScrollCount;
strctMouseOp.m_hObjectSelected = [];
feval(g_strctModule.m_hCallbackFunc,'MouseWheel',strctMouseOp);
return;

function fnSetActiveModule(a,b,iNewModule)
global g_iCurrModule g_strctModule g_acModules g_strctWindows
feval(g_strctModule.m_hCallbackFunc,'PrepareForModuleSwitch');
if ~isempty(g_iCurrModule)
    if isfield(g_strctModule,'m_strctPanel')
        for k=1:length(g_strctModule.m_strctPanel.m_ahPanels)
            set(g_strctModule.m_strctPanel.m_ahPanels(k),'visible','off');
        end;
    end
    g_acModules{g_iCurrModule} =  g_strctModule;
end;

set(g_strctWindows.m_hFigure,'Name',['Planner - ',g_acModules{iNewModule}.m_strName]);
g_iCurrModule = iNewModule;
g_strctModule = g_acModules{iNewModule};
if isfield(g_strctModule,'m_strctPanel')
    for k=1:length(g_strctModule.m_strctPanel.m_ahPanels)
        set(g_strctModule.m_strctPanel.m_ahPanels(k),'visible','on');	
    end;
end

feval(g_strctModule.m_hCallbackFunc,'Invalidate');
feval(g_strctModule.m_hCallbackFunc,'ModuleSwitch');
return;

        

function [bInside] = fnInsideImage(window_handle,MousePos)
AxesRect = get(window_handle,'Position');
bInside =  (MousePos(1) > AxesRect(1) && ...
    MousePos(1) < AxesRect(1)+AxesRect(3) && ...
    MousePos(2) > AxesRect(2) &&  ...
    MousePos(2) < AxesRect(2)+AxesRect(4));
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

