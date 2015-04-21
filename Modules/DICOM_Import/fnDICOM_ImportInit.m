function bInitOK = fnDICOM_ImportInit(strctParams)
% The way module appearance is controlled is by g_strctModule.m_hWindowsPanel
% and g_strctModule.m_ahAxes, all other stuff are module-dependent
global g_strctModule g_strctWindows
g_strctModule.m_bVolumeLoaded = false;
if ~exist(  strctParams.m_strctConfig.m_strctDirectories.m_strSPM_Folder,'dir')
    bInitOK  = false;
    return;
else
    addpath(strctParams.m_strctConfig.m_strctDirectories.m_strSPM_Folder);
end;
fnCreatePanels(); 
bInitOK  = true;
return;


function fnCreatePanels()
global g_strctModule g_strctWindows
aiWindowSize = get(g_strctWindows.m_hFigure,'Position');

iOffset = 2;
iHeight = aiWindowSize(4);
iFigureWidth = aiWindowSize(3);
iRightPanelWidth = 300;
strctPanel.m_aiRightPanelSize = [iFigureWidth-iRightPanelWidth-iOffset 1 iRightPanelWidth iHeight-30];
strctPanel.m_ahRightPanels(1) = uipanel('Units','Pixels','Position',strctPanel.m_aiRightPanelSize);
strctPanel.m_ahPanels = [strctPanel.m_ahRightPanels];


strctPanel.m_hLoadFolder =  uicontrol('style','pushbutton','String','Load DICOM',...
    'Position',[10  strctPanel.m_aiRightPanelSize(4)-140 100 30],'parent',strctPanel.m_ahRightPanels(1),'callback',{@fnCallback,'LoadDICOM'});

set(strctPanel.m_ahRightPanels(1),'visible','off');
g_strctModule.m_strctPanel = strctPanel;



return;


function fnCallback(a,b,strEvent,varargin)
global g_strctModule
feval(g_strctModule.m_hCallbackFunc,strEvent,varargin{:});
return;
