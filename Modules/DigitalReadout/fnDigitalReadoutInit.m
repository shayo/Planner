function bInitOK = fnDigitalReadoutInit(strctParams)
% The way module appearance is controlled is by g_strctModule.m_hWindowsPanel
% and g_strctModule.m_ahAxes, all other stuff are module-dependent
global g_strctModule g_strctWindows

% Initialize DAQ
iBoardNum = 0;
g_strctModule.m_afCalibX = [-60 -50 -40 -30 -20 -10 0 10 20 30 40 50 60];
g_strctModule.m_afCalibY1 = NaN*ones(1,length(g_strctModule.m_afCalibX));
g_strctModule.m_afCalibY2 = NaN*ones(1,length(g_strctModule.m_afCalibX));
iHistoryLength = 1000;
g_strctModule.m_a2fHistory = zeros(iHistoryLength, 2);
g_strctModule.m_iHistoryIndex = 1;
g_strctModule.m_hTimer = [];
try
    fnDAQRedBox('Init',iBoardNum);
    fnCreatePanels();
    bInitOK  = true;
catch
   % This will not work in 64 bit mode....
    fprintf('Digital Readout module: Cannot initialize digital read out module. It requires 32 bit matlab\n');
    bInitOK  = false;
end
if exist('DigitalReadOutCalibration.mat','file')
    fprintf('Digital Readout module: Old calibraiton file found. Taking parameters from there...\n');
    strctTmp = load('DigitalReadOutCalibration.mat');
    g_strctModule.m_strctCalib1 = strctTmp.g_strctModule.m_strctCalib1;
    g_strctModule.m_strctCalib2 = strctTmp.g_strctModule.m_strctCalib2;
    
    
end
    


return;


function fnCreatePanels()
global g_strctModule g_strctWindows
aiWindowSize = get(g_strctWindows.m_hFigure,'Position');


iOffset = 2;
iHeight = aiWindowSize(4);
iFigureWidth = aiWindowSize(3);

iRightPanelWidth = 300;

strctPanel.m_aiRightPanelSize = [iFigureWidth-iRightPanelWidth-iOffset 1 iRightPanelWidth iHeight-30];
strctPanel.m_hRightPanel = uipanel('Units','Pixels','Position',strctPanel.m_aiRightPanelSize);
strctPanel.m_aiWindowsPanelSize = [5 5  aiWindowSize(3)-strctPanel.m_aiRightPanelSize(3)-20 iHeight-30];
strctPanel.m_hWindowsPanel = uipanel('Units','Pixels','Position',strctPanel.m_aiWindowsPanelSize,'parent',g_strctWindows.m_hFigure);

iSeparationBetweenWindowsPix = 30;
iMaxWindowWidth = floor( strctPanel.m_aiWindowsPanelSize(3) /2) ;
iMaxWindowHeight = floor( strctPanel.m_aiWindowsPanelSize(4) /2) ;
iAxesSize = min(iMaxWindowHeight, iMaxWindowWidth)-iSeparationBetweenWindowsPix;

strctPanel.m_aiAxesSize = [1 1 iAxesSize,iAxesSize];

strctPanel.m_hCalibrate =  uicontrol('style','pushbutton','String','Calibrate',...
    'Position',[10  strctPanel.m_aiRightPanelSize(4)-40 100 30],'parent',strctPanel.m_hRightPanel(1),'callback',{@fnCallback,'Calibrate'});


strctPanel.m_hResetCalibrate =  uicontrol('style','pushbutton','String','Reset Calibration',...
    'Position',[160  strctPanel.m_aiRightPanelSize(4)-40 100 30],'parent',strctPanel.m_hRightPanel(1),'callback',{@fnCallback,'ResetCalibrate'});


acDesc = {'RAW X','RAW Y'};
acDesc2 = {'ANGLE X','ANGLE Y'};
strCol= 'rgbcym';
for k=1:2
    strctPanel.m_astrctReadOut(k).m_aiPos =[5+(k-1)*iAxesSize+(k-1)*iSeparationBetweenWindowsPix strctPanel.m_aiWindowsPanelSize(4)-iAxesSize-35 iAxesSize,iAxesSize];
    strctPanel.m_astrctReadOut(k).m_hPanel = uipanel('Units','Pixels','Position',strctPanel.m_astrctReadOut(k).m_aiPos,'parent',strctPanel.m_hWindowsPanel);
    strctPanel.m_astrctReadOut(k).m_hAxes =  axes('units','pixels','position',strctPanel.m_aiAxesSize,'parent',strctPanel.m_astrctReadOut(k).m_hPanel);
    strctPanel.m_astrctReadOut(k).m_hCurve = plot(strctPanel.m_astrctReadOut(k).m_hAxes, 1:10,1:10,strCol(k));
    
    strctPanel.m_astrctReadOut(2+k).m_aiPos =[5+(k-1)*iAxesSize+(k-1)*iSeparationBetweenWindowsPix strctPanel.m_aiWindowsPanelSize(4)-2*iAxesSize-2*35 iAxesSize,iAxesSize];
    strctPanel.m_astrctReadOut(2+k).m_hPanel = uipanel('Units','Pixels','Position',strctPanel.m_astrctReadOut(2+k).m_aiPos,'parent',strctPanel.m_hWindowsPanel);
    strctPanel.m_astrctReadOut(2+k).m_hAxes =  axes('units','pixels','position',strctPanel.m_aiAxesSize,'parent',strctPanel.m_astrctReadOut(2+k).m_hPanel);
    strctPanel.m_astrctReadOut(2+k).m_hStatusLine = text(0.1,0.2,acDesc2{k},'parent',strctPanel.m_astrctReadOut(2+k).m_hAxes,'color',strCol(2+k),'FontSize',48);
    strctPanel.m_astrctReadOut(k).m_hStatusLine = text(0.2,0.7,acDesc{k},'parent',strctPanel.m_astrctReadOut(2+k).m_hAxes,'color',strCol(k),'FontSize',48);
    
    %hold(strctPanel.m_astrctReadOut(2+k).m_hAxes,'on');
    %strctPanel.m_astrctReadOut(2+k).m_hCurve = plot(strctPanel.m_astrctReadOut(2+k).m_hAxes, 1:10,1:10,strCol(2+k));
end

acStr1 = cell(1,length(g_strctModule.m_afCalibX));
acStr2 = cell(1,length(g_strctModule.m_afCalibX));
for k=1:length(g_strctModule.m_afCalibX)
    acStr1{k} = sprintf('%-5d %d',g_strctModule.m_afCalibX(k),g_strctModule.m_afCalibY1(k));
    acStr2{k} = sprintf('%-5d %d',g_strctModule.m_afCalibX(k),g_strctModule.m_afCalibY2(k));
end


strctPanel.m_hCalib1List = uicontrol('style','listbox','String',char(acStr1),...
    'Position',[10  strctPanel.m_aiRightPanelSize(4)-400 iRightPanelWidth-20 200],...
    'parent',strctPanel.m_hRightPanel,'callback',{@fnCallback,'SelectEntry1'},'FontSize',15,'foregroundcolor','r');

strctPanel.m_hCalib2List = uicontrol('style','listbox','String',char(acStr2),...
    'Position',[10  strctPanel.m_aiRightPanelSize(4)-700 iRightPanelWidth-20 200],...
    'parent',strctPanel.m_hRightPanel,'callback',{@fnCallback,'SelectEntry2'},'FontSize',15,'foregroundcolor','g');

strctPanel.m_hSetValue1 =  uicontrol('style','pushbutton','String','Set Value',...
    'Position',[10  strctPanel.m_aiRightPanelSize(4)-140 200 60],'parent',strctPanel.m_hRightPanel(1),'callback',{@fnCallback,'SetValue1'},'FontSize',25,'foregroundcolor','r');

strctPanel.m_hSetValue1NaN =  uicontrol('style','pushbutton','String','NaN',...
    'Position',[220  strctPanel.m_aiRightPanelSize(4)-140 80 60],'parent',strctPanel.m_hRightPanel(1),'callback',{@fnCallback,'SetValue1NaN'},'FontSize',25,'foregroundcolor','r');


strctPanel.m_hSetValue2 =  uicontrol('style','pushbutton','String','Set Value',...
    'Position',[10  strctPanel.m_aiRightPanelSize(4)-480 200 60],'parent',strctPanel.m_hRightPanel(1),'callback',{@fnCallback,'SetValue2'},'FontSize',25,'foregroundcolor','g');

strctPanel.m_hSetValue2NaN =  uicontrol('style','pushbutton','String','NaN',...
    'Position',[220  strctPanel.m_aiRightPanelSize(4)-480 80 60],'parent',strctPanel.m_hRightPanel(1),'callback',{@fnCallback,'SetValue2NaN'},'FontSize',25,'foregroundcolor','g');

strctPanel.m_ahAxes = cat(1,strctPanel.m_astrctReadOut.m_hAxes);
strctPanel.m_ahPanels = [strctPanel.m_hRightPanel ,strctPanel.m_hWindowsPanel];

for k=1:length(strctPanel.m_ahPanels)
    set(strctPanel.m_ahPanels(k),'visible','off');
end
g_strctModule.m_strctPanel = strctPanel;



return;


function fnCallback(a,b,strEvent,varargin)
global g_strctModule
feval(g_strctModule.m_hCallbackFunc,strEvent,varargin{:});
return;
