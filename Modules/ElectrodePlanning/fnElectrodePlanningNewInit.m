function bInitOK = fnElectrodePlanningNewInit(strctParams)
% The way module appearance is controlled is by g_strctModule.m_hWindowsPanel
% and g_strctModule.m_ahAxes, all other stuff are module-dependent
global g_strctModule g_strctWindows
g_strctModule.m_bVolumeLoaded = false;
bInitOK  = true;
%strDefaultFontName = 'Helvetica';


hSubMenu1 = uimenu(strctParams.m_hMenu,'Label','Electrode Planning Mode','callback',{@fnCallback,'SetNormalMode'});
hSubMenu2 = uimenu(strctParams.m_hMenu,'Label','Chamber Planning Mode','callback',{@fnCallback,'SetChamberMode'});
hSubMenu3 = uimenu(strctParams.m_hMenu,'Label','Atlas Planning Mode','callback',{@fnCallback,'SetAtlasMode'});
g_strctModule.m_strDefaultFilesFolder = fullfile('D:', 'Data', 'Doris', 'Planner',filesep);

g_strctModule.m_iCurrAnatVol = 0;
g_strctModule.m_iCurrFuncVol = 0;

g_strctModule.m_strctParams = strctParams;
g_strctModule.m_acAnatVol = {};
g_strctModule.m_acFuncVol = {};
g_strctModule.m_iCurrChamber = 0;
%g_strctModule.m_iCurrGrid = 0;
g_strctModule.m_fCurrentDepth = 0;
g_strctModule.m_ahRobotHandles = [];
g_strctModule.m_iLastSelectedGridHole = 0;

g_strctModule.m_strctGUIOptions.m_bShowChamber = true;
g_strctModule.m_strctGUIOptions.m_bShowTargets = true;
g_strctModule.m_strctGUIOptions.m_bShowSurface = true;
g_strctModule.m_strctGUIOptions.m_bShowROIs = true;
g_strctModule.m_strctGUIOptions.m_bShowLabels = true;

g_strctModule.m_strctGUIOptions.m_bShowAtlas = false;
g_strctModule.m_strctGUIOptions.m_bShowBloodVessels = true;
g_strctModule.m_strctGUIOptions.m_bShow3DPlanes = true;
g_strctModule.m_strctGUIOptions.m_bShow2DPlanes = true;
g_strctModule.m_strctGUIOptions.m_bShowFunctional = true;
g_strctModule.m_strctGUIOptions.m_bShowMarkers = true;
g_strctModule.m_strctGUIOptions.m_bShowTimeCourse = false;
g_strctModule.m_strctGUIOptions.m_bLongChamber = false;
g_strctModule.m_strctGUIOptions.m_bLongGrid = false;
g_strctModule.m_strctGUIOptions.m_bOpenGL = true;
g_strctModule.m_strctGUIOptions.m_bAtlas = true;
g_strctModule.m_strctGUIOptions.m_bShowFreesurferSurfaces = true;

g_strctModule.m_strctGUIOptions.m_bMIPFuncPos = true;
g_strctModule.m_strctGUIOptions.m_bMIPFuncNeg = true;
g_strctModule.m_strctGUIOptions.m_bMIPBlood = true;
g_strctModule.m_strctGUIOptions.m_bImageSeries = true;

g_strctModule.m_strctGUIOptions.m_bScaleBar = false;
g_strctModule.m_strctGUIOptions.m_fScaleBarLengthMM = 1;
g_strctModule.m_strctGUIOptions.m_strLocation = 'TopLeft';

g_strctModule.m_strctGUIOptions.m_bChamberAngles = false;

 g_strctModule.m_bShiftPressed = false;
g_strctModule.m_strctGUIOptions.m_fSelectRadiusMM = 4;

g_strctModule.m_bInChamberMode = false;

g_strctModule.m_strctGUIOptions.m_strSelectedKopfArm = 'Left';

g_strctModule.m_bMouseDown = false;
g_strctModule.m_bFirstInvalidate = true;
g_strctModule.m_bFuncVolLoaded = false;

g_strctModule.m_strctOverlay.m_pt2fLeft = [-20, 1];
g_strctModule.m_strctOverlay.m_pt2fRight = [-4, 0];

g_strctModule.m_strctOverlay.m_pt2fLeftPos = [4, 0];
g_strctModule.m_strctOverlay.m_pt2fRightPos = [20, 1];


g_strctModule.m_strctOverlay.m_afPvalueRange = [-30 30];

g_strctModule.m_strMouseMode = 'Scroll';
g_strctModule.m_strMouseIcon = [];
g_strctModule.m_strMouse3DMode = 'Rotate';
g_strctModule.m_strctPrevMouseOp = [];
g_strctModule.m_strctLastMouseDown = [];
g_strctModule.m_strctLastMouseUp = [];


%%
% Initialize stereotaxtic models
iNumModels = length(strctParams.m_strctConfig.m_acStereoModels.m_strctModel);
for iModelIter=1:iNumModels
    astrctStereoTaxticModels(iModelIter).m_strName = strctParams.m_strctConfig.m_acStereoModels.m_strctModel{iModelIter}.m_strctGeneral.m_strModelName;
    iNumArms = length(strctParams.m_strctConfig.m_acStereoModels.m_strctModel{iModelIter}.m_strctArm);
    for iArmIter=1:iNumArms
        if isstruct(strctParams.m_strctConfig.m_acStereoModels.m_strctModel{iModelIter}.m_strctArm)
            strctRobot = feval(strctParams.m_strctConfig.m_acStereoModels.m_strctModel{iModelIter}.m_strctArm.m_strModelFunction);
            astrctStereoTaxticModels(iModelIter).m_astrctArms(iArmIter).m_strModelFunc = strctParams.m_strctConfig.m_acStereoModels.m_strctModel{iModelIter}.m_strctArm.m_strModelFunction;
        else
            strctRobot = feval(strctParams.m_strctConfig.m_acStereoModels.m_strctModel{iModelIter}.m_strctArm{iArmIter}.m_strModelFunction);
            astrctStereoTaxticModels(iModelIter).m_astrctArms(iArmIter).m_strModelFunc = strctParams.m_strctConfig.m_acStereoModels.m_strctModel{iModelIter}.m_strctArm{iArmIter}.m_strModelFunction;
        end
        
        astrctStereoTaxticModels(iModelIter).m_astrctArms(iArmIter).m_strctRobot = strctRobot;
    end
end
g_strctModule.m_astrctStereoTaxticModels = astrctStereoTaxticModels;
g_strctModule.m_iStereoModelSelected = 1;
g_strctModule.m_iStereoArmSelected = 1;
g_strctModule.m_iJointSelected = 1;
%% Initialize Chamber modeles
iNumChamberModels = length(strctParams.m_strctConfig.m_acChamberModels.m_strctModel);
for iModelIter=1:iNumChamberModels
    strctChamber.m_strType = strctParams.m_strctConfig.m_acChamberModels.m_strctModel{iModelIter}.m_strModelName;
    strctChamber.m_strFuncName = strctParams.m_strctConfig.m_acChamberModels.m_strctModel{iModelIter}.m_strModelFunc;
    strctChamber.m_strctModel = eval(strctChamber.m_strFuncName);
    g_strctModule.m_astrctChamberModels(iModelIter) = strctChamber;
end
g_strctModule.m_strctVirtualChamber = g_strctModule.m_astrctChamberModels(1);
%% Initialize Grid Models

iNumGridModels = length(strctParams.m_strctConfig.m_acGridModels.m_strctModel);
for iModelIter=1:iNumGridModels
    
    strctGrid.m_strctGeneral = strctParams.m_strctConfig.m_acGridModels.m_strctModel{iModelIter}.m_strctParams;
    strctGrid.m_strType = strctParams.m_strctConfig.m_acGridModels.m_strctModel{iModelIter}.m_strctParams.m_strModelName;
    strctGrid.m_strName = strctParams.m_strctConfig.m_acGridModels.m_strctModel{iModelIter}.m_strctParams.m_strModelName;

    if isfield(strctParams.m_strctConfig.m_acGridModels.m_strctModel{iModelIter},'m_strctSpecialInstance')
        acSubModels = strctParams.m_strctConfig.m_acGridModels.m_strctModel{iModelIter}.m_strctSpecialInstance;
        iNumSubModels = length(acSubModels);
        for iSubModelIter=1:iNumSubModels
            strctGrid.m_acSubModels{iSubModelIter} = acSubModels{iSubModelIter};
        end
    else
        strctGrid.m_acSubModels = [];
    end
    
    g_strctModule.m_astrctGrids(iModelIter) = strctGrid;
end

fnCreatePanels(); 

g_strctModule.m_hMouseHook.m_fnMouseMove = get(g_strctWindows.m_hFigure,'WindowButtonMotionFcn');
g_strctModule.m_hMouseHook.m_fnMouseDown = get(g_strctWindows.m_hFigure,'WindowButtonDownFcn');
g_strctModule.m_hMouseHook.m_fnMouseUp = get(g_strctWindows.m_hFigure,'WindowButtonUpFcn');
g_strctModule.m_hMouseHook.m_fnfnMouseWheel = get(g_strctWindows.m_hFigure,'WindowScrollWheelFcn');


for k=1:length(g_strctModule.m_strctPanel.m_ahPanels)
    set(g_strctModule.m_strctPanel.m_ahPanels(k),'visible','off');
end;

return;




function fnCreatePanels()
global g_strctModule g_strctWindows
% Create the four-window display
aiWindowSize = get(g_strctWindows.m_hFigure,'Position');

%%

iOffset = 2;
iHeight = aiWindowSize(4);
iFigureWidth = aiWindowSize(3);

iRightPanelWidth = 300;

strctPanel.m_aiRightPanelSize = [iFigureWidth-iRightPanelWidth-iOffset 1 iRightPanelWidth iHeight-30];

strctPanel.m_ahRightPanels(1) = uipanel('Units','Pixels','Position',strctPanel.m_aiRightPanelSize);

%delete(strctPanel.m_ahRightPanels(1) )


strctPanel.m_aiWindowsPanelSize = [5 5  aiWindowSize(3)-strctPanel.m_aiRightPanelSize(3)-20 iHeight-30];
strctPanel.m_hWindowsPanel = uipanel('Units','Pixels','Position',strctPanel.m_aiWindowsPanelSize,'parent',g_strctWindows.m_hFigure);
%delete(strctPanel.m_hWindowsPanel)

iSeparationBetweenWindowsPix = 30;
iMaxWindowWidth = floor( strctPanel.m_aiWindowsPanelSize(3) /2) ;
iMaxWindowHeight = floor( strctPanel.m_aiWindowsPanelSize(4) /2) ;
iAxesSize = min(iMaxWindowHeight, iMaxWindowWidth)-iSeparationBetweenWindowsPix;

strctPanel.m_aiImageRes = [256,256,3];
strctPanel.m_aiAxesSize = [1 1 iAxesSize,iAxesSize];

strctPanel.m_strct3D.m_aiPos = [iAxesSize+iSeparationBetweenWindowsPix 5 iAxesSize,iAxesSize];
strctPanel.m_strct3D.m_hPanel = uipanel('Units','Pixels','Position',strctPanel.m_strct3D.m_aiPos,'parent',strctPanel.m_hWindowsPanel);
strctPanel.m_strct3D.m_hAxes = axes('units','pixels','position',strctPanel.m_aiAxesSize,'parent',strctPanel.m_strct3D.m_hPanel,...
    'XTickLabel',[],'YTickLabel',[],'ZTickLabel',[],'FontName',g_strctWindows.m_strDefaultFontName);
axis(strctPanel.m_strct3D.m_hAxes,'vis3d');
axis(strctPanel.m_strct3D.m_hAxes,'ij');

strctPanel.m_hMenu3D_2 = uicontextmenu;
uimenu(strctPanel.m_hMenu3D_2, 'Label', 'Rotate', 'Callback', {@fnCallback,'SetRotateMode'});
uimenu(strctPanel.m_hMenu3D_2, 'Label', 'Zoom', 'Callback', {@fnCallback,'SetZoom3DMode'});
uimenu(strctPanel.m_hMenu3D_2, 'Label', 'Pan', 'Callback', {@fnCallback,'SetPan3DMode'});


strctPanel.m_strctStereoTactic.m_aiPos = [iAxesSize+iSeparationBetweenWindowsPix 5 iAxesSize,iAxesSize];
strctPanel.m_strctStereoTactic.m_hPanel = uipanel('Units','Pixels','Position',strctPanel.m_strctStereoTactic.m_aiPos,'parent',strctPanel.m_hWindowsPanel);
strctPanel.m_strctStereoTactic.m_hAxes = axes('units','pixels','position',strctPanel.m_aiAxesSize,'parent',strctPanel.m_strctStereoTactic.m_hPanel,...
    'XTickLabel',[],'YTickLabel',[],'ZTickLabel',[],'UIcontextmenu',strctPanel.m_hMenu3D_2,'FontName',g_strctWindows.m_strDefaultFontName);
set(strctPanel.m_strctStereoTactic.m_hAxes,'Visible','off');
hold(strctPanel.m_strctStereoTactic.m_hAxes,'on');
set(strctPanel.m_strctStereoTactic.m_hPanel,'visible','off');




strctPanel.m_strctTimeCourse.m_aiPos = [iAxesSize+iSeparationBetweenWindowsPix 5 iAxesSize,iAxesSize];
strctPanel.m_strctTimeCourse.m_hPanel = uipanel('Units','Pixels','Position',strctPanel.m_strctTimeCourse.m_aiPos,'parent',strctPanel.m_hWindowsPanel);
aiSmallAxes = strctPanel.m_aiAxesSize;
aiSmallAxes(1:2) = aiSmallAxes(1:2) + 30;
aiSmallAxes(3:4) = aiSmallAxes(3:4) - 30;
strctPanel.m_strctTimeCourse.m_hAxes = axes('units','pixels','position',aiSmallAxes,'parent',strctPanel.m_strctTimeCourse.m_hPanel,'FontName',g_strctWindows.m_strDefaultFontName);
set(strctPanel.m_strctTimeCourse.m_hAxes,'Visible','off');
hold(strctPanel.m_strctTimeCourse.m_hAxes,'on');
set(strctPanel.m_strctTimeCourse.m_hPanel,'visible','off');



strctPanel.m_strctXY.m_aiPos = [1 1 iAxesSize,iAxesSize];
strctPanel.m_strctXY.m_hPanel = uipanel('Units','Pixels','Position',strctPanel.m_strctXY.m_aiPos,'parent',strctPanel.m_hWindowsPanel);
strctPanel.m_strctXY.m_hAxes = axes('units','pixels','position',strctPanel.m_aiAxesSize,'parent',strctPanel.m_strctXY.m_hPanel,'FontName',g_strctWindows.m_strDefaultFontName);
set(strctPanel.m_strctXY.m_hAxes,'xlim',[1 strctPanel.m_aiImageRes(2)],'ylim',[1 strctPanel.m_aiImageRes(1)]);
strctPanel.m_strctXY.m_hImage = image([],[],zeros(strctPanel.m_aiImageRes),'parent',strctPanel.m_strctXY.m_hAxes);
set(strctPanel.m_strctXY.m_hAxes,'Visible','off');
hold(strctPanel.m_strctXY.m_hAxes,'on');

strctPanel.m_strctXY.m_ahTextHandles(1) = text(5,  128,'L','fontsize',21,'color',[1 1 1],'parent',strctPanel.m_strctXY.m_hAxes,'FontName',g_strctWindows.m_strDefaultFontName);
strctPanel.m_strctXY.m_ahTextHandles(2) = text(235,128,'R','fontsize',21,'color',[1 1 1],'parent',strctPanel.m_strctXY.m_hAxes,'FontName',g_strctWindows.m_strDefaultFontName);
strctPanel.m_strctXY.m_ahTextHandles(3) = text(128,15,'A','fontsize',21,'color',[1 1 1],'parent',strctPanel.m_strctXY.m_hAxes,'FontName',g_strctWindows.m_strDefaultFontName);
strctPanel.m_strctXY.m_ahTextHandles(4) = text(128,235,'P','fontsize',21,'color',[1 1 1],'parent',strctPanel.m_strctXY.m_hAxes,'FontName',g_strctWindows.m_strDefaultFontName);

strctPanel.m_strctXY.m_ahMouseRadiusSelect =[];
strctPanel.m_strctYZ.m_ahMouseRadiusSelect =[];
strctPanel.m_strctXZ.m_ahMouseRadiusSelect =[];



strctPanel.m_strctYZ.m_aiPos = [5 strctPanel.m_aiWindowsPanelSize(4)-iAxesSize-35,iAxesSize,iAxesSize];
strctPanel.m_strctYZ.m_hPanel = uipanel('Units','Pixels','Position',strctPanel.m_strctYZ.m_aiPos,'parent',strctPanel.m_hWindowsPanel);
strctPanel.m_strctYZ.m_hAxes = axes('units','pixels','position',strctPanel.m_aiAxesSize,'parent',strctPanel.m_strctYZ.m_hPanel,'FontName',g_strctWindows.m_strDefaultFontName);
set(strctPanel.m_strctYZ.m_hAxes,'xlim',[1 strctPanel.m_aiImageRes(2)],'ylim',[1 strctPanel.m_aiImageRes(1)]);
strctPanel.m_strctYZ.m_hImage = image([],[],zeros(strctPanel.m_aiImageRes),'parent',strctPanel.m_strctYZ.m_hAxes);
set(strctPanel.m_strctYZ.m_hAxes,'Visible','off');
hold(strctPanel.m_strctYZ.m_hAxes,'on');

strctPanel.m_strctYZ.m_ahTextHandles(1) = text(5,  128,'P','fontsize',21,'color',[1 1 1],'parent',strctPanel.m_strctYZ.m_hAxes,'FontName',g_strctWindows.m_strDefaultFontName);
strctPanel.m_strctYZ.m_ahTextHandles(2) = text(235,128,'A','fontsize',21,'color',[1 1 1],'parent',strctPanel.m_strctYZ.m_hAxes,'FontName',g_strctWindows.m_strDefaultFontName);
strctPanel.m_strctYZ.m_ahTextHandles(3) = text(128,15,'D','fontsize',21,'color',[1 1 1],'parent',strctPanel.m_strctYZ.m_hAxes,'FontName',g_strctWindows.m_strDefaultFontName);
strctPanel.m_strctYZ.m_ahTextHandles(4) = text(128,235,'V','fontsize',21,'color',[1 1 1],'parent',strctPanel.m_strctYZ.m_hAxes,'FontName',g_strctWindows.m_strDefaultFontName);



strctPanel.m_strctXZ.m_aiPos =[iAxesSize+iSeparationBetweenWindowsPix strctPanel.m_aiWindowsPanelSize(4)-iAxesSize-35 iAxesSize,iAxesSize];
strctPanel.m_strctXZ.m_hPanel = uipanel('Units','Pixels','Position',strctPanel.m_strctXZ.m_aiPos,'parent',strctPanel.m_hWindowsPanel);
strctPanel.m_strctXZ.m_hAxes = axes('units','pixels','position',strctPanel.m_aiAxesSize,'parent',strctPanel.m_strctXZ.m_hPanel,'FontName',g_strctWindows.m_strDefaultFontName);
set(strctPanel.m_strctXZ.m_hAxes,'xlim',[1 strctPanel.m_aiImageRes(2)],'ylim',[1 strctPanel.m_aiImageRes(1)]);
strctPanel.m_strctXZ.m_hImage = image([],[],zeros(strctPanel.m_aiImageRes),'parent',strctPanel.m_strctXZ.m_hAxes);
set(strctPanel.m_strctXZ.m_hAxes,'Visible','off');
hold(strctPanel.m_strctXZ.m_hAxes,'on');
strctPanel.m_strctXZ.m_ahTextHandles(1) = text(5,128,'L','fontsize',21,'color',[1 1 1],'parent',strctPanel.m_strctXZ.m_hAxes,'FontName',g_strctWindows.m_strDefaultFontName);
strctPanel.m_strctXZ.m_ahTextHandles(2) = text(235,128,'R','fontsize',21,'color',[1 1 1],'parent',strctPanel.m_strctXZ.m_hAxes,'FontName',g_strctWindows.m_strDefaultFontName);
strctPanel.m_strctXZ.m_ahTextHandles(3) = text(128,15,'D','fontsize',21,'color',[1 1 1],'parent',strctPanel.m_strctXZ.m_hAxes,'FontName',g_strctWindows.m_strDefaultFontName);
strctPanel.m_strctXZ.m_ahTextHandles(4) = text(128,235,'V','fontsize',21,'color',[1 1 1],'parent',strctPanel.m_strctXZ.m_hAxes,'FontName',g_strctWindows.m_strDefaultFontName);


strctPanel.m_strctYZ.m_ahTextHandles(5) = text(5,20,'AP 0','fontsize',10,'color',[1 1 0],'parent',strctPanel.m_strctYZ.m_hAxes,'FontName',g_strctWindows.m_strDefaultFontName);
strctPanel.m_strctYZ.m_ahTextHandles(6) = text(5,30,'ML 0','fontsize',10,'color',[1 1 0],'parent',strctPanel.m_strctYZ.m_hAxes,'FontName',g_strctWindows.m_strDefaultFontName);
strctPanel.m_strctYZ.m_ahTextHandles(7) = text(5,40,'DV 0','fontsize',10,'color',[1 1 0],'parent',strctPanel.m_strctYZ.m_hAxes,'FontName',g_strctWindows.m_strDefaultFontName);
strctPanel.m_strctYZ.m_ahTextHandles(8) = text(5,10,'Stereotax (Atlas)','fontsize',12,'color',[1 1 0],'parent',strctPanel.m_strctYZ.m_hAxes,'FontName',g_strctWindows.m_strDefaultFontName);

strctPanel.m_strctYZ.m_ahTextHandles(9) = text(5,256-30,'C 0','fontsize',10,'color',[1 1 0],'parent',strctPanel.m_strctYZ.m_hAxes,'FontName',g_strctWindows.m_strDefaultFontName);
strctPanel.m_strctYZ.m_ahTextHandles(10) = text(5,256-20,'W 0','fontsize',10,'color',[1 1 0],'parent',strctPanel.m_strctYZ.m_hAxes,'FontName',g_strctWindows.m_strDefaultFontName);
strctPanel.m_strctYZ.m_ahTextHandles(11) = text(5,256-10,' 0','fontsize',10,'color',[1 1 0],'parent',strctPanel.m_strctYZ.m_hAxes,'FontName',g_strctWindows.m_strDefaultFontName);

strctPanel.hMouseModeText = text(5,10,'Scroll','fontsize',14,'color',[1 1 1],'parent',strctPanel.m_strctXZ.m_hAxes,'FontName',g_strctWindows.m_strDefaultFontName);


strctPanel.m_strctYZ.m_ahTextHandles(12) = text(5,50,'Chamber Angles:','fontsize',10,'color',[1 1 0],'parent',strctPanel.m_strctYZ.m_hAxes,'FontName',g_strctWindows.m_strDefaultFontName,'visible','off');


strctPanel.m_hMeasureLine  = [];
strctPanel.m_hMeasureText  = [];

% strctPanel.m_hGridTitleText = uicontrol('style','text','String','Current Grid (Top View)',...
%     'Position',[20  strctPanel.m_aiRightPanelSize(4)-445 200 20],'parent',strctPanel.m_ahRightPanels(1),'horizontalalignment','center');
% 
% strctPanel.m_hGridAxesMenu = uicontextmenu('Callback',@fnMouseDownEmulator);
% uimenu(strctPanel.m_hGridAxesMenu, 'Label', 'Align to grid hole','Callback', {@fnCallback,'AlignToGridHole'});
% uimenu(strctPanel.m_hGridAxesMenu, 'Label', 'MIP Func (neg)','Callback', {@fnCallback,'GridMIPFuncNeg'});
% uimenu(strctPanel.m_hGridAxesMenu, 'Label', 'MIP Func (pos)','Callback', {@fnCallback,'GridMIPFuncPos'});
% uimenu(strctPanel.m_hGridAxesMenu, 'Label', 'MIP Vessels','Callback', {@fnCallback,'GridMIPVessels'});
% uimenu(strctPanel.m_hGridAxesMenu, 'Label', 'Cancel');
% 

% strctPanel.m_strctGrid.m_aiAxesSize = [30 strctPanel.m_aiRightPanelSize(4)-690 iRightPanelWidth-70 iRightPanelWidth-70];
% strctGrid.m_ahHoleHandles = [];
% strctPanel.m_strctGrid.m_hAxes = axes('units','pixels','position',...
%     strctPanel.m_strctGrid.m_aiAxesSize,'parent',strctPanel.m_ahRightPanels(1),'uicontextmenu',strctPanel.m_hGridAxesMenu);
% strctPanel.m_strctGrid.m_hImage = image(-10:10,-10:10,zeros(64,64,3),'parent',strctPanel.m_strctGrid.m_hAxes,'uicontextmenu',strctPanel.m_hGridAxesMenu,'visible','off');
% grid(strctPanel.m_strctGrid.m_hAxes,'on');
% box(strctPanel.m_strctGrid.m_hAxes ,'on');
% hold(strctPanel.m_strctGrid.m_hAxes,'on');
% axis(strctPanel.m_strctGrid.m_hAxes,'xy');
% set(strctPanel.m_strctGrid.m_hAxes,'visible','off');
% strctPanel.m_strctGrid.m_ahHoleHandles = [];
% strctPanel.m_strctGrid.m_hCurrGridHoleDir = ...
%     plot(strctPanel.m_strctGrid.m_hAxes, 0,0,'c','uicontextmenu',strctPanel.m_hGridAxesMenu);
% strctPanel.m_strctGrid.m_hCurrGridHole = ...
%     plot(strctPanel.m_strctGrid.m_hAxes, 0,0,'g','uicontextmenu',strctPanel.m_hGridAxesMenu);
% strctPanel.m_strctGrid.m_hCurrGridHoleTextPos = ...
%     text(-9,9,'','HorizontalAlignment','left','parent',strctPanel.m_strctGrid.m_hAxes,...
%     'color','b','fontweight','bold','uicontextmenu',strctPanel.m_hGridAxesMenu);
% 
% strctPanel.m_strctGrid.m_hCurrGridHoleTextInfo = ...
%     text(-9,-9,'','HorizontalAlignment','left','parent',strctPanel.m_strctGrid.m_hAxes,...
%     'color','b','fontweight','bold','uicontextmenu',strctPanel.m_hGridAxesMenu);
% 
% strctPanel.m_strctGrid.m_hScrollPos = [30 strctPanel.m_aiRightPanelSize(4)-740 iRightPanelWidth-70 20];
% 
% strctPanel.m_strctGrid.m_hScroll= uicontrol('style','slider','units','pixels','position',...
%     strctPanel.m_strctGrid.m_hScrollPos,'parent',strctPanel.m_ahRightPanels(1),'min',-180,'max',180,...
%     'SliderStep',[1/360 10/360],'callback', {@fnCallback,'RotateGrid'},'visible','off');
%%

% Set the overlay axes
strctPanel.m_strctOverlayAxes.m_aiOverlaySize = [45 strctPanel.m_aiRightPanelSize(4)-65 iRightPanelWidth-80 60];
strctPanel.m_strctOverlayAxes.m_hAxes = axes('units','pixels','position',strctPanel.m_strctOverlayAxes.m_aiOverlaySize,'parent',strctPanel.m_ahRightPanels(1),'FontName',g_strctWindows.m_strDefaultFontName);
grid(strctPanel.m_strctOverlayAxes.m_hAxes,'on');
box(strctPanel.m_strctOverlayAxes.m_hAxes ,'on');
hold(strctPanel.m_strctOverlayAxes.m_hAxes ,'on');

hold(strctPanel.m_strct3D.m_hAxes,'on');

% strctPanel.m_hStatusLine = uicontrol('style','text','String','Status Line','Position',...
%      [5 strctPanel.m_aiWindowsPanelSize(4)-20 600 15],'parent',strctPanel.m_hWindowsPanel);

strctPanel.m_hLoadAnatVolBut =  uicontrol('style','pushbutton','String','Load Anatomical',...
    'Position',[10  strctPanel.m_aiRightPanelSize(4)-140 100 30],'parent',strctPanel.m_ahRightPanels(1),'callback',{@fnCallback,'LoadAnatVol'});


strctPanel.m_hLoadFuncVolBut =  uicontrol('style','pushbutton','String','Load Overlay',...
    'Position',[160  strctPanel.m_aiRightPanelSize(4)-140 100 30],'parent',strctPanel.m_ahRightPanels(1),'callback',{@fnCallback,'LoadFuncVol'});


strctPanel.m_hAnatMenu = uicontextmenu;
%uimenu(strctPanel.m_hAnatMenu, 'Label', 'Correct Orientation','Callback', {@fnCallback,'CorrectOrientation'});
strctPanel.m_hAnatOriCopySubMenu = uimenu(strctPanel.m_hAnatMenu, 'Label', 'Copy orientation from');

uimenu(strctPanel.m_hAnatMenu, 'Label', 'Stereotax Helper','Callback', {@fnCallback,'StereotaxHelper'});

uimenu(strctPanel.m_hAnatMenu, 'Label', 'Surface Helper','Callback', {@fnCallback,'AddSurface'});
uimenu(strctPanel.m_hAnatMenu, 'Label', 'Add Blood Vessels','Callback', {@fnCallback,'AddBloodVessels'});

uimenu(strctPanel.m_hAnatMenu, 'Label', 'Rename','Callback', {@fnCallback,'RenameAnat'});
%uimenu(strctPanel.m_hAnatMenu, 'Label', 'Resize','Callback', {@fnCallback,'UnconformAnat',0});
uimenu(strctPanel.m_hAnatMenu, 'Label', 'Apply Transform','Callback', {@fnCallback,'fnApplyAnatTrans',0});
uimenu(strctPanel.m_hAnatMenu, 'Label', 'Apply Inv Transform','Callback', {@fnCallback,'fnApplyAnatInvTrans',0});
uimenu(strctPanel.m_hAnatMenu, 'Label', 'Export Reg Matrix','Callback', {@fnCallback,'ExportAnatRegMatrix',0});
uimenu(strctPanel.m_hAnatMenu, 'Label', 'Export','Callback', {@fnCallback,'ExportAnatVol'});
uimenu(strctPanel.m_hAnatMenu, 'Label', 'Info','Callback', {@fnCallback,'PrintInfoAnat'});
uimenu(strctPanel.m_hAnatMenu, 'Label', 'Remove','Callback', {@fnCallback,'RemoveAnat',0},'separator','on');

strctPanel.m_hAnatMoveMenu = uimenu(strctPanel.m_hAnatMenu, 'Label', 'Move in list');
uimenu(strctPanel.m_hAnatMoveMenu, 'Label', 'Down','Callback', {@fnCallback,'MoveAnatDown'});
uimenu(strctPanel.m_hAnatMoveMenu, 'Label', 'Up','Callback', {@fnCallback,'MoveAnatUp'});
uimenu(strctPanel.m_hAnatMoveMenu, 'Label', 'First','Callback', {@fnCallback,'MoveAnatFirst'});
uimenu(strctPanel.m_hAnatMoveMenu, 'Label', 'Last','Callback', {@fnCallback,'MoveAnatLast'});


strctPanel.m_hFuncMenu = uicontextmenu;
%uimenu(strctPanel.m_hFuncMenu, 'Label', 'Attach Avg. Time Course','Callback', {@fnCallback,'AddAvgTimeCourse',0},'separator','on');
uimenu(strctPanel.m_hFuncMenu, 'Label', 'Rename','Callback', {@fnCallback,'RenameFunc'});
%uimenu(strctPanel.m_hFuncMenu, 'Label', 'Resize','Callback', {@fnCallback,'UnconformFunc',0});
uimenu(strctPanel.m_hFuncMenu, 'Label', 'Apply Transform','Callback', {@fnCallback,'fnApplyFuncTrans',0});
uimenu(strctPanel.m_hFuncMenu, 'Label', 'Apply Inv Transform','Callback', {@fnCallback,'fnApplyFuncInvTrans',0});
uimenu(strctPanel.m_hFuncMenu, 'Label', 'Export Reg Matrix','Callback', {@fnCallback,'ExportFuncRegMatrix',0});
uimenu(strctPanel.m_hFuncMenu, 'Label', 'Export','Callback', {@fnCallback,'ExportFuncVol'});
uimenu(strctPanel.m_hFuncMenu, 'Label', 'Info','Callback', {@fnCallback,'PrintInfoFunc'});
uimenu(strctPanel.m_hFuncMenu, 'Label', 'Remove','Callback', {@fnCallback,'RemoveFunc',0},'separator','on');

strctPanel.m_hFuncMoveMenu = uimenu(strctPanel.m_hFuncMenu, 'Label', 'Move in list');
uimenu(strctPanel.m_hFuncMoveMenu, 'Label', 'Down','Callback', {@fnCallback,'MoveFuncDown'});
uimenu(strctPanel.m_hFuncMoveMenu, 'Label', 'Up','Callback', {@fnCallback,'MoveFuncUp'});
uimenu(strctPanel.m_hFuncMoveMenu, 'Label', 'First','Callback', {@fnCallback,'MoveFuncFirst'});
uimenu(strctPanel.m_hFuncMoveMenu, 'Label', 'Last','Callback', {@fnCallback,'MoveFuncLast'});





strctPanel.m_hChamberMenu = uicontextmenu;
uimenu(strctPanel.m_hChamberMenu, 'Label', 'Align Axes To Chamber','Callback', {@fnCallback,'fnAlignToChamber'});
strctPanel.m_hChamberMenuVisible = uimenu(strctPanel.m_hChamberMenu, 'Label', 'Visible','Callback', {@fnCallback,'fnShowHideChamber'});
uimenu(strctPanel.m_hChamberMenu, 'Label', 'Rename','Callback', {@fnCallback,'RenameChamber'});
strctPanel.m_AnatCopySubMenu = uimenu(strctPanel.m_hChamberMenu, 'Label', 'Copy To');
uimenu(strctPanel.m_hChamberMenu, 'Label', 'Remove','Callback', {@fnCallback,'RemoveChamber'},'separator','on');

strctPanel.m_hChamberMenuSubMenu = uimenu(strctPanel.m_hChamberMenu, 'Label', 'Change type');
for k=1:length(g_strctModule.m_astrctChamberModels)
   uimenu(strctPanel.m_hChamberMenuSubMenu,'Label',g_strctModule.m_astrctChamberModels(k).m_strType,'callback',{@fnCallback,'ChangeChamberType',k});
end

strctPanel.m_hAnatListText = uicontrol('style','text','String','Anatomicals',...
    'Position',[10  strctPanel.m_aiRightPanelSize(4)-165 100 20],'parent',strctPanel.m_ahRightPanels(1));



strctPanel.m_hAnatList = uicontrol('style','listbox','String','',...
    'Position',[10  strctPanel.m_aiRightPanelSize(4)-230 120 70],'parent',...
    strctPanel.m_ahRightPanels(1),'callback',{@fnCallback,'SwitchAnat'},'UIcontextmenu',strctPanel.m_hAnatMenu);

strctPanel.m_hFuncListText = uicontrol('style','text','String','Overlays',...
    'Position',[160  strctPanel.m_aiRightPanelSize(4)-165 100 20],'parent',strctPanel.m_ahRightPanels(1));

strctPanel.m_hFuncList = uicontrol('style','listbox','String','',...
    'Position',[140  strctPanel.m_aiRightPanelSize(4)-230 120 70],...
    'parent',strctPanel.m_ahRightPanels(1),'callback',{@fnCallback,'SwitchFunc'},'UIcontextmenu',strctPanel.m_hFuncMenu);

strctPanel.m_hChamberListText = uicontrol('style','text','String','Chambers',...
    'Position',[10  strctPanel.m_aiRightPanelSize(4)-260 100 20],'parent',strctPanel.m_ahRightPanels(1));

strctPanel.m_hChamberList = uicontrol('style','listbox','String','',...
    'Position',[10  strctPanel.m_aiRightPanelSize(4)-320 120 60],'parent',...
    strctPanel.m_ahRightPanels(1),'callback',{@fnCallback,'SelectChamber'},...
    'UIcontextmenu',strctPanel.m_hChamberMenu);

strctPanel.m_hGridListText = uicontrol('style','text','String','Grids',...
    'Position',[160  strctPanel.m_aiRightPanelSize(4)-260 100 20],'parent',strctPanel.m_ahRightPanels(1));


strctPanel.m_hGridMenu = uicontextmenu;
hGridSubMenu = uimenu(strctPanel.m_hGridMenu, 'Label', 'Add Grid');
iNumModels = length(g_strctModule.m_astrctGrids);
for iGridModelIter=1:iNumModels
    iNumSubModels = length(g_strctModule.m_astrctGrids(iGridModelIter).m_acSubModels);
    if iNumSubModels == 0
        hGridSubMenuModel = uimenu(hGridSubMenu, 'Label', g_strctModule.m_astrctGrids(iGridModelIter).m_strType,'Callback', {@fnCallback,'AddGrid',iGridModelIter});
    else
        hGridSubMenuModel = uimenu(hGridSubMenu, 'Label', g_strctModule.m_astrctGrids(iGridModelIter).m_strType);
    end
    for iSubModelsIter=1:iNumSubModels
        uimenu(hGridSubMenuModel, 'Label', g_strctModule.m_astrctGrids(iGridModelIter).m_acSubModels{iSubModelsIter}.m_strName, ...
            'Callback', {@fnCallback,'AddGrid',iGridModelIter,iSubModelsIter});
    end
end

uimenu(strctPanel.m_hGridMenu, 'Label', 'Duplicate Grid','callback',{@fnCallback,'DuplicateGrid'});

uimenu(strctPanel.m_hGridMenu, 'Label', 'Rename Grid','callback',{@fnCallback,'RenameGrid'});
uimenu(strctPanel.m_hGridMenu, 'Label', 'Print Grid','callback',{@fnCallback,'PrintGrid'});
uimenu(strctPanel.m_hGridMenu, 'Label', 'Remove Grid','callback',{@fnCallback,'RemoveGrid'},'separator','on');




strctPanel.m_hGridList = uicontrol('style','listbox','String','',...
    'Position',[140  strctPanel.m_aiRightPanelSize(4)-320 120 60],...
    'parent',strctPanel.m_ahRightPanels(1),'callback',{@fnCallback,'SelectGrid'},'UIContextMenu',strctPanel.m_hGridMenu);

strctPanel.m_hTargetListText = uicontrol('style','text','String','Targets',...
    'Position',[10  strctPanel.m_aiRightPanelSize(4)-350 100 20],'parent',strctPanel.m_ahRightPanels(1));

strctPanel.m_hTargetListMenu = uicontextmenu;
uimenu(strctPanel.m_hTargetListMenu, 'Label', 'Rename', 'Callback', {@fnCallback,'TargetRename'});
uimenu(strctPanel.m_hTargetListMenu, 'Label', 'Keep View', 'Callback', {@fnCallback,'TargetKeepView'});
uimenu(strctPanel.m_hTargetListMenu, 'Label', 'Find Closest Hole(No Grid Rotation)', 'Callback', {@fnCallback,'TargetFindHole'});
%uimenu(strctPanel.m_hTargetListMenu, 'Label', 'Find Closest Hole(Allow Grid Rotation)', 'Callback', {@fnCallback,'TargetFindHoleWithGridRotation'});
uimenu(strctPanel.m_hTargetListMenu, 'Label', 'Optimal Grid Analysis', 'Callback', {@fnCallback,'TargetFindGridAndHole'});
uimenu(strctPanel.m_hTargetListMenu, 'Label', 'Project Blood Pattern On Surface', 'Callback', {@fnCallback,'ProjectBloodPattern'});

strctPanel.m_TargetCopySubMenu = uimenu(strctPanel.m_hTargetListMenu, 'Label', 'Copy To');
uimenu(strctPanel.m_hTargetListMenu, 'Label', 'Remove', 'Callback', {@fnCallback,'RemoveTarget'},'separator','on');


strctPanel.m_hTargetList = uicontrol('style','listbox','String','',...
    'Position',[10  strctPanel.m_aiRightPanelSize(4)-420 120 60],...
    'parent',strctPanel.m_ahRightPanels(1),'callback',{@fnCallback,'SelectTarget'},'UIContextMenu',strctPanel.m_hTargetListMenu);




strctPanel.m_hROIListText = uicontrol('style','text','String','Region of Interest',...
    'Position',[160  strctPanel.m_aiRightPanelSize(4)-350 100 20],'parent',strctPanel.m_ahRightPanels(1));

strctPanel.m_hROIListMenu = uicontextmenu;
uimenu(strctPanel.m_hROIListMenu, 'Label', 'New ROI', 'Callback', {@fnCallback,'AddNewROI'});
uimenu(strctPanel.m_hROIListMenu, 'Label', 'New ROI From Atlas', 'Callback', {@fnCallback,'AddNewROIUsingAtlas'});
uimenu(strctPanel.m_hROIListMenu, 'Label', 'Toggle Visibility', 'Callback', {@fnCallback,'ToggleVisibilityROI'});
uimenu(strctPanel.m_hROIListMenu, 'Label', 'Rename ROI', 'Callback', {@fnCallback,'RenameROI'});
%uimenu(strctPanel.m_hROIListMenu, 'Label', 'Project On Surface', 'Callback', {@fnCallback,'ProjectROIonSurface'});
uimenu(strctPanel.m_hROIListMenu, 'Label', 'Clear ROI', 'Callback', {@fnCallback,'ClearROI'});
uimenu(strctPanel.m_hROIListMenu, 'Label', 'Delete ROI', 'Callback', {@fnCallback,'DeleteROI'});


strctPanel.m_hROIList = uicontrol('style','listbox','String','',...
    'Position',[160  strctPanel.m_aiRightPanelSize(4)-420 120 60],...
    'parent',strctPanel.m_ahRightPanels(1),'callback',{@fnCallback,'SelectROI'},'UIContextMenu',strctPanel.m_hROIListMenu);

strctPanel.m_hSurfaceListMenu = uicontextmenu;
uimenu(strctPanel.m_hSurfaceListMenu, 'Label', 'Add New Surface', 'Callback', {@fnCallback,'AddFreesurferSurface'});
%uimenu(strctPanel.m_hSurfaceListMenu, 'Label', 'Add Derived Surface', 'Callback', {@fnCallback,'AddDerivedFreesurferSurface'});
uimenu(strctPanel.m_hSurfaceListMenu, 'Label', 'Toggle Visibility 2D', 'Callback', {@fnCallback,'ToggleSurfaceVisibility2D'});
uimenu(strctPanel.m_hSurfaceListMenu, 'Label', 'Toggle Visibility 3D', 'Callback', {@fnCallback,'ToggleSurfaceVisibility3D'});
uimenu(strctPanel.m_hSurfaceListMenu, 'Label', 'Change Color', 'Callback', {@fnCallback,'ChangeSurfaceColor'});
uimenu(strctPanel.m_hSurfaceListMenu, 'Label', 'Rename Surface', 'Callback', {@fnCallback,'RenameSurface'});
uimenu(strctPanel.m_hSurfaceListMenu, 'Label', 'Delete Surface', 'Callback', {@fnCallback,'DeleteSurface'});

% strctPanel.m_hDerivedSurfaceListMenu = uicontextmenu;
% uimenu(strctPanel.m_hSurfaceListMenu, 'Label', 'Show in separate window', 'Callback', {@fnCallback,'ShowDerivedSurface'});


strctPanel.m_hSurfaceList = uicontrol('style','listbox','String','',...
    'Position',[10  strctPanel.m_aiRightPanelSize(4)-520 120 60],...
    'parent',strctPanel.m_ahRightPanels(1),'callback',{@fnCallback,'SelectSurface'},'UIContextMenu',strctPanel.m_hSurfaceListMenu);

strctPanel.m_hSurfacesListText = uicontrol('style','text','String','Surfaces',...
    'Position',[10  strctPanel.m_aiRightPanelSize(4)-460 100 20],'parent',strctPanel.m_ahRightPanels(1));





strctPanel.m_hImageSeriesMenu = uicontextmenu;
uimenu(strctPanel.m_hImageSeriesMenu , 'Label', 'New Series', 'Callback', {@fnCallback,'NewImageSeries'});
uimenu(strctPanel.m_hImageSeriesMenu , 'Label', 'Modify Series Properties', 'Callback', {@fnCallback,'ModifyImageSeries'});

uimenu(strctPanel.m_hImageSeriesMenu , 'Label', 'Delete Series', 'Callback', {@fnCallback,'DeleteImageSeries'});

strctPanel.m_hImageSeriesList = uicontrol('style','listbox','String','',...
    'Position',[10  strctPanel.m_aiRightPanelSize(4)-610 120 60],...
    'parent',strctPanel.m_ahRightPanels(1),'callback',{@fnCallback,'SelectImageSeries'},'UIContextMenu',strctPanel.m_hImageSeriesMenu);

strctPanel.m_hImageSeriesText = uicontrol('style','text','String','Image Series',...
    'Position',[10  strctPanel.m_aiRightPanelSize(4)-550 100 20],'parent',strctPanel.m_ahRightPanels(1));


strctPanel.m_hImageListMenu = uicontextmenu;
uimenu(strctPanel.m_hImageListMenu , 'Label', 'Add Image(s)', 'Callback', {@fnCallback,'AddImagesToImageSeries'});
uimenu(strctPanel.m_hImageListMenu , 'Label', 'Delete Image(s)', 'Callback', {@fnCallback,'RemoveImagesFromImageSeries'});

strctPanel.m_hImageList = uicontrol('style','listbox','String','',...
    'Position',[160  strctPanel.m_aiRightPanelSize(4)-610 120 60],...
    'parent',strctPanel.m_ahRightPanels(1),'callback',{@fnCallback,'SelectImageFromSeries'},'UIContextMenu',strctPanel.m_hImageListMenu);

strctPanel.m_hImageListText = uicontrol('style','text','String','Images',...
    'Position',[160  strctPanel.m_aiRightPanelSize(4)-550 100 20],'parent',strctPanel.m_ahRightPanels(1));


% strctPanel.m_hDerivedSurfaceList = uicontrol('style','listbox','String','',...
%     'Position',[160  strctPanel.m_aiRightPanelSize(4)-520 120 60],...
%     'parent',strctPanel.m_ahRightPanels(1),'callback',{@fnCallback,'SelectDerivedSurface'},'UIContextMenu',strctPanel.m_hDerivedSurfaceListMenu);

% strctPanel.m_hDerivedSurfacesListText = uicontrol('style','text','String','Derived Surfaces',...
%     'Position',[160  strctPanel.m_aiRightPanelSize(4)-460 100 20],'parent',strctPanel.m_ahRightPanels(1));

strctPanel.m_strctOverlayAxes.hLine2 = plot(strctPanel.m_strctOverlayAxes.m_hAxes,...
    [g_strctModule.m_strctOverlay.m_pt2fLeft(1) g_strctModule.m_strctOverlay.m_pt2fRight(1)],...
    [g_strctModule.m_strctOverlay.m_pt2fLeft(2) g_strctModule.m_strctOverlay.m_pt2fRight(2)],'b','LineWidth',2);

strctPanel.m_strctOverlayAxes.hLeftPoint = plot( strctPanel.m_strctOverlayAxes.m_hAxes,...
 g_strctModule.m_strctOverlay.m_pt2fLeft(1),g_strctModule.m_strctOverlay.m_pt2fLeft(2),'r.','markersize',31);

strctPanel.m_strctOverlayAxes.hRightPoint = plot( strctPanel.m_strctOverlayAxes.m_hAxes,...
 g_strctModule.m_strctOverlay.m_pt2fRight(1),g_strctModule.m_strctOverlay.m_pt2fRight(2),'r.','markersize',31);


strctPanel.m_strctOverlayAxes.hLeftPointPos = plot( strctPanel.m_strctOverlayAxes.m_hAxes,...
 g_strctModule.m_strctOverlay.m_pt2fLeftPos(1),g_strctModule.m_strctOverlay.m_pt2fLeftPos(2),'g.','markersize',31);

strctPanel.m_strctOverlayAxes.hRightPointPos = plot( strctPanel.m_strctOverlayAxes.m_hAxes,...
 g_strctModule.m_strctOverlay.m_pt2fRightPos(1),g_strctModule.m_strctOverlay.m_pt2fRightPos(2),'g.','markersize',31);


strctPanel.m_strctOverlayAxes.hLine4 = plot(strctPanel.m_strctOverlayAxes.m_hAxes,...
    [g_strctModule.m_strctOverlay.m_pt2fLeftPos(1) g_strctModule.m_strctOverlay.m_pt2fRightPos(1)],...
    [g_strctModule.m_strctOverlay.m_pt2fLeftPos(2) g_strctModule.m_strctOverlay.m_pt2fRightPos(2)],'k','LineWidth',2);


axis(strctPanel.m_strctOverlayAxes.m_hAxes,[g_strctModule.m_strctOverlay.m_afPvalueRange -0.2 1.2]);
xlabel(strctPanel.m_strctOverlayAxes.m_hAxes,'p-value');
ylabel(strctPanel.m_strctOverlayAxes.m_hAxes,'Opacity');


strctPanel.m_hMenu = uicontextmenu('Callback',@fnMouseDownEmulator);
uimenu(strctPanel.m_hMenu, 'Label', 'Scroll', 'Callback', {@fnCallback,'SetSlicesMode'});
uimenu(strctPanel.m_hMenu, 'Label', 'Rotate', 'Callback', {@fnCallback,'SetRotate2DMode'});
uimenu(strctPanel.m_hMenu, 'Label', 'Contrast', 'Callback', {@fnCallback,'SetContrastMode'});

strctPanel.m_hEditMenu = uimenu(strctPanel.m_hMenu, 'Label', 'Edit');
uimenu(strctPanel.m_hEditMenu, 'Label', 'Erase 3D', 'Callback', {@fnCallback,'SetEraseMode','3D'});
uimenu(strctPanel.m_hEditMenu, 'Label', 'Erase 2D', 'Callback', {@fnCallback,'SetEraseMode','2D'});

uimenu(strctPanel.m_hMenu, 'Label', 'Full Screen', 'Callback', {@fnCallback,'SetFullScreen'});
uimenu(strctPanel.m_hMenu, 'Label', 'Zoom', 'Callback', {@fnCallback,'SetZoomMode'});
uimenu(strctPanel.m_hMenu, 'Label', 'Zoom (Linked)', 'Callback', {@fnCallback,'SetLinkedZoomMode'});

strctPanel.m_hZoomMenu = uimenu(strctPanel.m_hMenu, 'Label', 'Zoom (Accurate)');

uimenu(strctPanel.m_hZoomMenu, 'Label', '10 mm', 'Callback', {@fnCallback,'SetFixedZoom',10});
uimenu(strctPanel.m_hZoomMenu, 'Label', '50 mm', 'Callback', {@fnCallback,'SetFixedZoom',50});
uimenu(strctPanel.m_hZoomMenu, 'Label', '100 mm', 'Callback', {@fnCallback,'SetFixedZoom',100});
uimenu(strctPanel.m_hZoomMenu, 'Label', 'Other', 'Callback', {@fnCallback,'SetFixedZoom'});
%            g_strctModule.m_strctCrossSectionXY.m_fHalfHeightMM = max(1,g_strctModule.m_strctCrossSectionXY.m_fHalfHeightMM + fDiff);


uimenu(strctPanel.m_hMenu, 'Label', 'Pan', 'Callback', {@fnCallback,'SetPanMode'});
uimenu(strctPanel.m_hMenu, 'Label', 'Focus', 'Callback', {@fnCallback,'SetFocus'});

strctPanel.m_hDistMenu = uimenu(strctPanel.m_hMenu, 'Label', 'Measure');
uimenu(strctPanel.m_hDistMenu , 'Label', 'Add Ruler', 'Callback', {@fnCallback,'AddRuler'});

uimenu(strctPanel.m_hDistMenu , 'Label', 'Point-to-point', 'Callback', {@fnCallback,'MeasureDist'});
uimenu(strctPanel.m_hDistMenu , 'Label', 'Point-to-top grid', 'Callback', {@fnCallback,'MeasureDistTopGrid'});


% strctPanel.m_hTrackMenu = uimenu(strctPanel.m_hMenu, 'Label', 'Tracking', 'Separator','on');
% uimenu(strctPanel.m_hTrackMenu, 'Label', 'Set Depth', 'Callback', {@fnCallback,'SetDepth'});
% uimenu(strctPanel.m_hTrackMenu, 'Label', 'Track', 'Callback', {@fnCallback,'Track'});

strctPanel.m_hChamberMenu = uimenu(strctPanel.m_hMenu, 'Label', 'Chamber/Grid', 'Separator','on');
uimenu(strctPanel.m_hChamberMenu, 'Label', 'Add (normal to plane)',  'Callback', {@fnCallback,'AddChamberSinglePoint'});
uimenu(strctPanel.m_hChamberMenu, 'Label', 'Add (in plane)',  'Callback', {@fnCallback,'AddChamberTwoPoints'});
uimenu(strctPanel.m_hChamberMenu, 'Label', 'Add (normal to 3D surface)',  'Callback', {@fnCallback,'AddChamber3D'});
uimenu(strctPanel.m_hChamberMenu, 'Label', 'Add (normal to target)',  'Callback', {@fnCallback,'AddChamber3DTowardsTarget'});
uimenu(strctPanel.m_hChamberMenu, 'Label', 'Move Chamber', 'Callback', {@fnCallback,'SetChamberTrans'},'Separator','on');
uimenu(strctPanel.m_hChamberMenu, 'Label', 'Move Chamber (along axis)', 'Callback', {@fnCallback,'SetChamberTransAxis'},'Separator','off');
uimenu(strctPanel.m_hChamberMenu, 'Label', 'Rotate Chamber (along axis)', 'Callback', {@fnCallback,'SetChamberRotateAxis'},'Separator','on');
uimenu(strctPanel.m_hChamberMenu, 'Label', 'Flip Chamber axis', 'Callback', {@fnCallback,'FlipChamberAxis'},'Separator','on');

uimenu(strctPanel.m_hChamberMenu, 'Label', 'Rotate Chamber', 'Callback', {@fnCallback,'SetChamberRot'});
uimenu(strctPanel.m_hChamberMenu, 'Label', 'Rotate Chamber (Accurate)', 'Callback', {@fnCallback,'RotChamberAccurate'});
uimenu(strctPanel.m_hChamberMenu, 'Label', 'Rotate Chamber 3D', 'Callback', {@fnCallback,'SetRotateChamber3DMode'},'Separator','on');

uimenu(strctPanel.m_hChamberMenu, 'Label', 'Flip direction', 'Callback', {@fnCallback,'FlipChamberAxis'},'Separator','on');

uimenu(strctPanel.m_hChamberMenu, 'Label', 'Move Grid', 'Callback', {@fnCallback,'SetGridTrans'});
uimenu(strctPanel.m_hChamberMenu, 'Label', 'Add Grid Using Direction', 'Callback', {@fnCallback,'AddGridUsingDirection'},'Separator','on');



strctPanel.m_hTargetMenu = uimenu(strctPanel.m_hMenu, 'Label', 'Target', 'Separator','on');
uimenu(strctPanel.m_hTargetMenu, 'Label', 'Add Target', 'Callback', {@fnCallback,'AddTarget'});
uimenu(strctPanel.m_hTargetMenu, 'Label', 'Move Target', 'Callback', {@fnCallback,'MoveTarget'});



strctPanel.m_hImageSeriesMenu = uimenu(strctPanel.m_hMenu, 'Label', 'Image Series', 'Separator','on');
uimenu(strctPanel.m_hImageSeriesMenu, 'Label', 'Move Series', 'Callback', {@fnCallback,'MoveEntireImageSeries'});
uimenu(strctPanel.m_hImageSeriesMenu, 'Label', 'Rotate Series', 'Callback', {@fnCallback,'RotateEntireImageSeries'});
uimenu(strctPanel.m_hImageSeriesMenu, 'Label', 'Scale Series', 'Callback', {@fnCallback,'ScaleEntireImageSeries'});
uimenu(strctPanel.m_hImageSeriesMenu, 'Label', 'Scale Series (keep aspect)', 'Callback', {@fnCallback,'ScaleEntireImageSeriesKeepAspect'});
uimenu(strctPanel.m_hImageSeriesMenu, 'Label', 'Move Image', 'Callback', {@fnCallback,'MoveImageInImageSeries'},'separator','on');
uimenu(strctPanel.m_hImageSeriesMenu, 'Label', 'Rotate Image', 'Callback', {@fnCallback,'RotateImageInImageSeries'});
uimenu(strctPanel.m_hImageSeriesMenu, 'Label', 'Scale Image', 'Callback', {@fnCallback,'ScaleImageInImageSeries'});
uimenu(strctPanel.m_hImageSeriesMenu, 'Label', 'Scale Image (kee aspect)', 'Callback', {@fnCallback,'ScaleImageInImageSeriesKeepAspect'});

strctPanel.m_hROIMenu = uimenu(strctPanel.m_hMenu, 'Label', 'ROI', 'Separator','on');
strctPanel.m_hROIMenu2D = uimenu(strctPanel.m_hROIMenu, 'Label', '2D');
uimenu(strctPanel.m_hROIMenu2D, 'Label', 'ROI Add', 'Callback', {@fnCallback,'SetROIAdd','2D'});
uimenu(strctPanel.m_hROIMenu2D, 'Label', 'ROI Subtract', 'Callback', {@fnCallback,'SetROISubtract','2D'});
strctPanel.m_hROIMenu3D = uimenu(strctPanel.m_hROIMenu, 'Label', '3D');
uimenu(strctPanel.m_hROIMenu3D, 'Label', 'ROI Add', 'Callback', {@fnCallback,'SetROIAdd','3D'});
uimenu(strctPanel.m_hROIMenu3D, 'Label', 'ROI Subtract', 'Callback', {@fnCallback,'SetROISubtract','3D'});
strctPanel.m_hROIMenuSeed = uimenu(strctPanel.m_hROIMenu, 'Label', 'Seed');
uimenu(strctPanel.m_hROIMenuSeed, 'Label', 'Select Seed Point', 'Callback', {@fnCallback,'ROIFromFunctional'});
uimenu(strctPanel.m_hROIMenuSeed, 'Label', 'Set Threshold', 'Callback', {@fnCallback,'ROIFromFunctionalThreshold'});

strctPanel.m_hBloodVesselMenu = uimenu(strctPanel.m_hMenu, 'Label', 'Blood Vessels', 'Separator','on');
uimenu(strctPanel.m_hBloodVesselMenu , 'Label', 'Add blood vessel mode', 'Callback', {@fnCallback,'AddBloodVesselMode'});
uimenu(strctPanel.m_hBloodVesselMenu , 'Label', 'Remove Blood Vessel mode', 'Callback', {@fnCallback,'RemoveBloodVesselMode'});
uimenu(strctPanel.m_hBloodVesselMenu , 'Label', 'Regenerate Surface', 'Callback', {@fnCallback,'RegenerateBloodSurface'});

strctPanel.m_hAtlasMenu = uimenu(strctPanel.m_hMenu, 'Label', 'Atlas', 'Separator','on');
uimenu(strctPanel.m_hAtlasMenu, 'Label', 'Toggle Atlas', 'Callback', {@fnCallback,'ToggleAtlas'});
uimenu(strctPanel.m_hAtlasMenu, 'Label', 'Move Atlas', 'Callback', {@fnCallback,'MoveAtlasMouse'});
uimenu(strctPanel.m_hAtlasMenu, 'Label', 'Rotate Atlas', 'Callback', {@fnCallback,'RotateAtlasMouse'});
uimenu(strctPanel.m_hAtlasMenu, 'Label', 'Scale Atlas', 'Callback', {@fnCallback,'ScaleAtlasMouse'});
uimenu(strctPanel.m_hAtlasMenu, 'Label', 'What is ?', 'Callback', {@fnCallback,'QueryAtlasMode'});
uimenu(strctPanel.m_hAtlasMenu, 'Label', 'Print all slices', 'Callback', {@fnCallback,'PrintSlices'});

% strctPanel.m_hAtlasExportMenu = uimenu(strctPanel.m_hAtlasMenu, 'Label', 'Export', 'Separator','on');
% 
% uimenu(strctPanel.m_hAtlasExportMenu, 'Label', 'Export Coronal', 'Callback', {@fnCallback,'ExportCoronal'}');
% uimenu(strctPanel.m_hAtlasExportMenu, 'Label', 'Export Sagittal', 'Callback', {@fnCallback,'ExportSagittal'}');

strctPanel.m_hMarkerMenu = uimenu(strctPanel.m_hMenu, 'Label', 'Markers', 'Separator','on');
uimenu(strctPanel.m_hMarkerMenu, 'Label', 'Add Marker', 'Callback', {@fnCallback,'AddMarker'});
uimenu(strctPanel.m_hMarkerMenu, 'Label', 'Add Marker (with direction)', 'Callback', {@fnCallback,'AddMarkerSmart'});
uimenu(strctPanel.m_hMarkerMenu, 'Label', 'Move Marker', 'Callback', {@fnCallback,'MoveMarker'});
uimenu(strctPanel.m_hMarkerMenu, 'Label', 'Rotate Marker', 'Callback', {@fnCallback,'RotateMarker'});

strctPanel.m_hViewMenu = uimenu(strctPanel.m_hMenu, 'Label', 'Reset View', 'Separator','on');
uimenu(strctPanel.m_hViewMenu, 'Label', 'Default View', 'Callback', {@fnCallback,'SetDefaultView'}, 'Separator','on');
% uimenu(strctPanel.m_hViewMenu, 'Label', 'Stereotax View', 'Callback', {@fnCallback,'SetStereotaxView'}, 'Separator','on');
uimenu(strctPanel.m_hViewMenu, 'Label', 'Atlas View', 'Callback', {@fnCallback,'SetAtlasView'}, 'Separator','on');
uimenu(strctPanel.m_hViewMenu, 'Label', 'Set this as default view', 'Callback', {@fnCallback,'SetNewDefaultView'}, 'Separator','on');



strctPanel.m_hOnOffMenu = uimenu(strctPanel.m_hMenu, 'Label', '(on/off)');%, 'Callback', {@fnCallback,'ShowHideCrosshairs'});
uimenu(strctPanel.m_hOnOffMenu, 'Label', 'Crosshair', 'Callback', {@fnCallback,'ShowHideCrosshairs'});
uimenu(strctPanel.m_hOnOffMenu, 'Label', 'Functional Overlay', 'Callback', {@fnCallback,'ShowFunctional'});
uimenu(strctPanel.m_hOnOffMenu, 'Label', 'Chamber', 'Callback', {@fnCallback,'ShowHideChamber'});
uimenu(strctPanel.m_hOnOffMenu, 'Label', 'Targets', 'Callback', {@fnCallback,'ShowHideTargets'});
uimenu(strctPanel.m_hOnOffMenu, 'Label', 'Blood Vessels', 'Callback', {@fnCallback,'ShowHideBloodVessels'});
uimenu(strctPanel.m_hOnOffMenu, 'Label', 'Markers', 'Callback', {@fnCallback,'ShowHideMarkers'});
uimenu(strctPanel.m_hOnOffMenu, 'Label', 'Time Course', 'Callback', {@fnCallback,'ShowHideTimeCourse'});
uimenu(strctPanel.m_hOnOffMenu, 'Label', 'Long Chamber','Callback', {@fnCallback,'LongChamber'});
uimenu(strctPanel.m_hOnOffMenu, 'Label', 'Long Grid','Callback', {@fnCallback,'LongGrid'});
uimenu(strctPanel.m_hOnOffMenu, 'Label', 'OpenGL Rendering','Callback', {@fnCallback,'RendererToggle'});
uimenu(strctPanel.m_hOnOffMenu, 'Label', 'Atlas','Callback', {@fnCallback,'ToggleAtlas'});
uimenu(strctPanel.m_hOnOffMenu, 'Label', 'ROIs', 'Callback', {@fnCallback,'ToggleROIsVisibility'});
uimenu(strctPanel.m_hOnOffMenu, 'Label', 'Labels', 'Callback', {@fnCallback,'ToggleLabelsVisibility'});
uimenu(strctPanel.m_hOnOffMenu, 'Label', 'Chamber angles', 'Callback', {@fnCallback,'ToggleChambeAnglesVisibility'});
strctPanel.m_hScaleBarMenu = uimenu(strctPanel.m_hOnOffMenu, 'Label', 'Scale bar');
uimenu(strctPanel.m_hScaleBarMenu, 'Label', 'On/Off', 'Callback', {@fnCallback,'ToggleScaleBar'});

strctPanel.m_hScaleBarMenu2 = uimenu(strctPanel.m_hScaleBarMenu, 'Label', 'Length');
uimenu(strctPanel.m_hScaleBarMenu2, 'Label', '1 mm', 'Callback', {@fnCallback,'SetScaleBarLength',1});
uimenu(strctPanel.m_hScaleBarMenu2, 'Label', '2 mm', 'Callback', {@fnCallback,'SetScaleBarLength',2});
uimenu(strctPanel.m_hScaleBarMenu2, 'Label', '5 mm', 'Callback', {@fnCallback,'SetScaleBarLength',5});
uimenu(strctPanel.m_hScaleBarMenu2, 'Label', '10 mm', 'Callback', {@fnCallback,'SetScaleBarLength',10});
uimenu(strctPanel.m_hScaleBarMenu2, 'Label', '50 mm', 'Callback', {@fnCallback,'SetScaleBarLength',50});

uimenu(strctPanel.m_hScaleBarMenu, 'Label', 'Top Left', 'Callback', {@fnCallback,'SetScaleBarLocation','TopLeft'});
uimenu(strctPanel.m_hScaleBarMenu, 'Label', 'Top Right', 'Callback', {@fnCallback,'SetScaleBarLocation','TopRight'});
uimenu(strctPanel.m_hScaleBarMenu, 'Label', 'Bottom Left', 'Callback', {@fnCallback,'SetScaleBarLocation','BottomLeft'});
uimenu(strctPanel.m_hScaleBarMenu, 'Label', 'Bottom Right', 'Callback', {@fnCallback,'SetScaleBarLocation','BottomRight'});



set(strctPanel.m_strctXY.m_hImage, 'UIContextMenu', strctPanel.m_hMenu);
set(strctPanel.m_strctYZ.m_hImage, 'UIContextMenu', strctPanel.m_hMenu);
set(strctPanel.m_strctXZ.m_hImage, 'UIContextMenu', strctPanel.m_hMenu);

strctPanel.m_hMenu3D = uicontextmenu;
uimenu(strctPanel.m_hMenu3D, 'Label', 'Rotate', 'Callback', {@fnCallback,'SetRotateMode'});
uimenu(strctPanel.m_hMenu3D, 'Label', 'Pan', 'Callback', {@fnCallback,'Pan3D'});
uimenu(strctPanel.m_hMenu3D, 'Label', 'Move Light Source', 'Callback', {@fnCallback,'MoveLightSource'});

%uimenu(strctPanel.m_hMenu3D, 'Label', 'Rotate Volume (Def View)', 'Callback', {@fnCallback,'SetRotateVolumeMode'});
%uimenu(strctPanel.m_hMenu3D, 'Label', 'Zoom', 'Callback', {@fnCallback,'SetZoom3DMode'});
%uimenu(strctPanel.m_hMenu3D, 'Label', 'Pan', 'Callback', {@fnCallback,'SetPan3DMode'});
uimenu(strctPanel.m_hMenu3D, 'Label', 'Hide/Show Planes', 'Callback',{@fnCallback,'HideShowPlanes'});
uimenu(strctPanel.m_hMenu3D, 'Label', 'Hide/Show Surface', 'Callback',{@fnCallback,'HideShowSurface'});
uimenu(strctPanel.m_hMenu3D, 'Label', 'Hide/Show Blood Vessels', 'Callback',{@fnCallback,'HideShowBloodVessels'});
%uimenu(strctPanel.m_hMenu3D, 'Label', 'Change Isosurface Threshold', 'Callback',{@fnCallback,'IsoSurfaceThresholdMode'});

set(strctPanel.m_strct3D.m_hAxes, 'UIContextMenu', strctPanel.m_hMenu3D);

 
 axes( strctPanel.m_strct3D.m_hAxes);
 L1=light();
 L2=light();
 lightangle(L1, 80, -3.4);
 lightangle(L2, -70, -54);
 
  
% 
strctPanel.m_ahAxes = [strctPanel.m_strctXY.m_hAxes, strctPanel.m_strctYZ.m_hAxes, ...
    strctPanel.m_strctXZ.m_hAxes,...
    strctPanel.m_strct3D.m_hAxes,...
    strctPanel.m_strctStereoTactic.m_hAxes,...
    strctPanel.m_strctTimeCourse.m_hAxes,...
    strctPanel.m_strctOverlayAxes.m_hAxes,...
       ]; %strctPanel.m_strctGrid.m_hAxes 


set(strctPanel.m_ahRightPanels(1),'visible','off');
strctPanel.m_ahRightPanels(2) = uipanel('Units','Pixels','Position',strctPanel.m_aiRightPanelSize);


%% Generate the stereotaxtic alignment controls
strctPanel.m_hMarkersListText = uicontrol('style','text','String','Markers (MRI Features)',...
    'Position',[10  strctPanel.m_aiRightPanelSize(4)-30 160 20],'parent',strctPanel.m_ahRightPanels(2),'horizontalalignment','left','foregroundcolor',[1 0 0]);

strctPanel.m_hMarkersListMenu = uicontextmenu;
uimenu(strctPanel.m_hMarkersListMenu, 'Label', 'Rename', 'Callback', {@fnCallback,'RenameMarker'});
uimenu(strctPanel.m_hMarkersListMenu, 'Label', 'Remove', 'Callback', {@fnCallback,'RemoveMarker'},'separator','on');
uimenu(strctPanel.m_hMarkersListMenu, 'Label', 'Print Table', 'Callback', {@fnCallback,'PrintMarkerTable'},'separator','on');
uimenu(strctPanel.m_hMarkersListMenu, 'Label', 'Set Arm', 'Callback', {@fnCallback,'SetArmOnMarker'},'separator','on');
uimenu(strctPanel.m_hMarkersListMenu, 'Label', 'Enable/Disable', 'Callback', {@fnCallback,'SwithMarker'},'separator','on');

strctPanel.m_hMarkersList = uicontrol('style','listbox','String','',...
    'Position',[10  strctPanel.m_aiRightPanelSize(4)-100 strctPanel.m_aiRightPanelSize(3)-20 70],'parent',...
    strctPanel.m_ahRightPanels(2),'callback',...
    {@fnCallback,'SwitchMarker'},'FontSize',10,'UIcontextmenu',strctPanel.m_hMarkersListMenu);

iNumModels = length(g_strctModule.m_astrctStereoTaxticModels);
acModelNames = {g_strctModule.m_astrctStereoTaxticModels.m_strName};

strctPanel.m_hStereoFramesText = uicontrol('style','text','String','Stereotactic frame and arm models','horizontalalignment','left',...
    'Position',[5  strctPanel.m_aiRightPanelSize(4)-150 230 40],'parent',...
    strctPanel.m_ahRightPanels(2),'FontSize',10,'foregroundcolor',[1 0 0]);

strctPanel.m_hStereoFramesList = uicontrol('style','listbox','String',char(acModelNames),...
    'Position',[5  strctPanel.m_aiRightPanelSize(4)-170 100 40],'parent',...
    strctPanel.m_ahRightPanels(2),'callback',...
    {@fnCallback,'SwitchStereoModel'},'FontSize',10,'value',g_strctModule.m_iStereoModelSelected);

iNumArms = length(g_strctModule.m_astrctStereoTaxticModels(g_strctModule.m_iStereoModelSelected).m_astrctArms);
acArmNames = cell(1,iNumArms);
for k=1:iNumArms
    acArmNames{k} = g_strctModule.m_astrctStereoTaxticModels(g_strctModule.m_iStereoModelSelected).m_astrctArms(k).m_strctRobot.m_strName;        
end


%strctPanel.m_hArmCalibMenu = uicontextmenu;
%uimenu(strctPanel.m_hArmCalibMenu, 'Label', 'Calibrate', 'Callback', {@fnCallback,'CalibrateArm'});

strctPanel.m_hStereoArmsList = uicontrol('style','listbox','String',char(acArmNames),...
    'Position',[110  strctPanel.m_aiRightPanelSize(4)-170 180 40],'parent',...
    strctPanel.m_ahRightPanels(2),'callback',...
    {@fnCallback,'SwitchStereoArm'},'FontSize',10,'value',g_strctModule.m_iStereoArmSelected);


iNumJoints = length(g_strctModule.m_astrctStereoTaxticModels(g_strctModule.m_iStereoModelSelected).m_astrctArms(g_strctModule.m_iStereoArmSelected).m_strctRobot.m_astrctJointsDescription);
acJointsNamesAndValues = cell(1,iNumJoints);% {.m_strName};
for k=1:iNumJoints
    acJointsNamesAndValues{k} = sprintf('%-10.3f %s',...
        g_strctModule.m_astrctStereoTaxticModels(g_strctModule.m_iStereoModelSelected).m_astrctArms(g_strctModule.m_iStereoArmSelected).m_strctRobot.m_astrctJointsDescription(k).m_fValue,...
        g_strctModule.m_astrctStereoTaxticModels(g_strctModule.m_iStereoModelSelected).m_astrctArms(g_strctModule.m_iStereoArmSelected).m_strctRobot.m_astrctJointsDescription(k).m_strName);
end;

strctPanel.m_hStereoJointsList = uicontrol('style','listbox','String',char(acJointsNamesAndValues),...
    'Position',[5  strctPanel.m_aiRightPanelSize(4)-320 strctPanel.m_aiRightPanelSize(3)-15 140],'parent',...
    strctPanel.m_ahRightPanels(2),'callback',...
    {@fnCallback,'SwitchJoint'},'FontSize',10,'value',g_strctModule.m_iJointSelected);

strctPanel.m_hEditText = uicontrol('style','text','String','Joint Value:','HorizontalAlignment','left',...
    'Position',[10 strctPanel.m_aiRightPanelSize(4)-350 130 25],...
    'parent',strctPanel.m_ahRightPanels(2),'FontSize',14);

strctPanel.m_hJointEdit = uicontrol('style','edit','String','0.0',...
    'Position',[140  strctPanel.m_aiRightPanelSize(4)-350 130 25],'parent',...
    strctPanel.m_ahRightPanels(2),'callback',...
    {@fnCallback,'JointEdit'},'FontSize',14,'backgroundcolor',[1 1 1]);


strctPanel.m_hChamberListText = uicontrol('style','text','String','Chambers','horizontalalignment','left',...
    'Position',[5  strctPanel.m_aiRightPanelSize(4)-370 230 20],'parent',...
    strctPanel.m_ahRightPanels(2),'FontSize',10,'foregroundcolor',[1 0 0]);


strctPanel.m_hChamberPlanningListMenu = uicontextmenu;
uimenu(strctPanel.m_hChamberPlanningListMenu, 'Label', 'Solve with V. Arm', 'Callback', {@fnCallback,'SolveWithVirtualArm'});
uimenu(strctPanel.m_hChamberPlanningListMenu, 'Label', 'Align to chamber', 'Callback', {@fnCallback,'fnAlignToChamber'});

strctPanel.m_hChambersList = uicontrol('style','listbox','String','',...
    'Position',[10  strctPanel.m_aiRightPanelSize(4)-440 strctPanel.m_aiRightPanelSize(3)-20 70],'parent',...
    strctPanel.m_ahRightPanels(2),'callback',...
    {@fnCallback,'SwitchChamber'},'FontSize',14,'UIcontextmenu',strctPanel.m_hChamberPlanningListMenu);

 
strctPanel.m_hRegister = uicontrol('style','pushbutton','string','Register',...
     'Position',[10  strctPanel.m_aiRightPanelSize(4)-475 140 30],'parent',...
     strctPanel.m_ahRightPanels(2),'callback',...
     {@fnCallback,'SolveRegistration'},'FontSize',11);%,'UIcontextmenu',strctPanel.m_hAnatMenu);

strctPanel.m_hRegisterEB0 = uicontrol('style','radiobutton','string','Ear Bar Zero',...
     'Position',[155  strctPanel.m_aiRightPanelSize(4)-465 120 25],'parent',...
     strctPanel.m_ahRightPanels(2),'callback',...
     {@fnCallback,'EarBarZeroRegistration'},'FontSize',9,'value',1);%,'UIcontextmenu',strctPanel.m_hAnatMenu);

strctPanel.m_hRegisterFeatures = uicontrol('style','radiobutton','string','Using Features',...
     'Position',[155  strctPanel.m_aiRightPanelSize(4)-485 120 25],'parent',...
     strctPanel.m_ahRightPanels(2),'callback',...
     {@fnCallback,'FeaturesRegistration'},'FontSize',9,'enable','off');%,'UIcontextmenu',strctPanel.m_hAnatMenu);
 
strctPanel.m_hVirtualArmText = uicontrol('style','text','String','Virtual Arm','HorizontalAlignment','left',...
    'Position',[10 strctPanel.m_aiRightPanelSize(4)-510 70 20],...
    'parent',strctPanel.m_ahRightPanels(2),'FontSize',9,'fontweight','bold','foregroundcolor',[1 0 0]);


iNumModels = length(g_strctModule.m_astrctStereoTaxticModels);
acModelWithArmName = cell(0);
aiModelIndex = [];
aiArmIndex = [];
iCounter = 1;
for iModelIter=1:iNumModels
    iNumArms = length(g_strctModule.m_astrctStereoTaxticModels(iModelIter).m_astrctArms);
    for iArmIter=1:iNumArms 
       aiModelIndex(iCounter) = iModelIter;
       aiArmIndex(iCounter) = iArmIter;
       acModelWithArmName{iCounter} = sprintf('%s with %s',...
           g_strctModule.m_astrctStereoTaxticModels(iModelIter).m_strName,...
           g_strctModule.m_astrctStereoTaxticModels(iModelIter).m_astrctArms(iArmIter).m_strctRobot.m_strName);
       iCounter=iCounter+1;
    end
end
iDefaultManipualtor = 1;
strctPanel.m_aiArmIndex = aiArmIndex;
strctPanel.m_aiModelIndex = aiModelIndex;

strctPanel.m_hVirtualArmType = uicontrol('style','popupmenu','String',acModelWithArmName,'HorizontalAlignment','left',...
    'Position',[80 strctPanel.m_aiRightPanelSize(4)-505 210 20],...
    'parent',strctPanel.m_ahRightPanels(2),'FontSize',8,'callback',{@fnCallback,'SetNewVirtualArmType'},...
    'value',iDefaultManipualtor);



strctPanel.m_hVirtualArmList = uicontrol('style','listbox','String','',...
    'Position',[10  strctPanel.m_aiRightPanelSize(4)-590 160 50],'parent',...
    strctPanel.m_ahRightPanels(2),'callback',...
    {@fnCallback,'SwitchVirtualArm'},'FontSize',9);%,'UIcontextmenu',strctPanel.m_hAnatMenu);
 
strctPanel.m_hVirtualArmToolText = uicontrol('style','text','String','Virtual Chamber:','HorizontalAlignment','left',...
    'Position',[10 strctPanel.m_aiRightPanelSize(4)-535 110 20],...
    'parent',strctPanel.m_ahRightPanels(2),'FontSize',9,'fontweight','bold','foregroundcolor',[1 0 0]);


strctPanel.m_hVirtualArmToolType = uicontrol('style','popupmenu','String',{g_strctModule.m_astrctChamberModels.m_strType},'HorizontalAlignment','left',...
    'Position',[130 strctPanel.m_aiRightPanelSize(4)-535 160 20],...
    'parent',strctPanel.m_ahRightPanels(2),'FontSize',8,'callback',{@fnCallback,'SetNewVirtualChamberType'},...
    'value',iDefaultManipualtor);



strctPanel.m_hVirtualArmListSave = uicontrol('style','pushbutton','String','Save',...
    'Position',[180  strctPanel.m_aiRightPanelSize(4)-565 110 25],'parent',...
    strctPanel.m_ahRightPanels(2),'callback',...
    {@fnCallback,'VirtualArmSave'},'FontSize',11);%,'UIcontextmenu',strctPanel.m_hAnatMenu);

strctPanel.m_hVirtualArmListAddChamber = uicontrol('style','pushbutton','String','Add Chamber',...
    'Position',[180  strctPanel.m_aiRightPanelSize(4)-590 110 25],'parent',...
    strctPanel.m_ahRightPanels(2),'callback',...
    {@fnCallback,'VirtualArmAddChamber'},'FontSize',11);%,'UIcontextmenu',strctPanel.m_hAnatMenu);

iStartY = 590;
g_strctModule.m_strctVirtualArm = g_strctModule.m_astrctStereoTaxticModels(1).m_astrctArms(1).m_strctRobot;
[strctPanel.m_ahLinkFixed,strctPanel.m_ahLinkSlider, strctPanel.m_ahLinkEdit, iNextY] = ...
    fnGenerateControllersForVirtualArm(strctPanel,g_strctModule.m_strctVirtualArm.m_astrctJointsDescription, iStartY);


%% Generate the Atlas panel
set(strctPanel.m_ahRightPanels(1),'visible','off');
set(strctPanel.m_ahRightPanels(2),'visible','off');
strctPanel.m_ahRightPanels(3) = uipanel('Units','Pixels','Position',strctPanel.m_aiRightPanelSize);


strctPanel.m_hActiveAtlasText = uicontrol('style','text','String','Active Atlas:',...
    'Position',[10  strctPanel.m_aiRightPanelSize(4)-35 80 20],'parent',...
   strctPanel.m_ahRightPanels(3),'horizontalalignment','left','foregroundcolor',[1 0 0]);


strctPanel.m_hAtlasRegionText = uicontrol('style','text','String','Atlas regions:',...
    'Position',[10  strctPanel.m_aiRightPanelSize(4)-60 160 20],'parent',...
   strctPanel.m_ahRightPanels(3),'horizontalalignment','left','foregroundcolor',[1 0 0]);


if exist('Saleem_Logothetis_Atlas.mat','file')
    strctTmp = load('Saleem_Logothetis_Atlas');
    strctAtlas = strctTmp.strctAtlas;
    for k=1:length(strctAtlas.m_astrctMesh)
        strctAtlas.m_astrctMesh(k).visible = k==1;
    end
    acAtlasOptions = {'Saleem-Logothetis','Load...'};
elseif  exist('Saleem_Logothetis_Atlas_Cropped.mat','file')
    strctTmp = load('Saleem_Logothetis_Atlas_Cropped');
    strctAtlas = strctTmp.strctAtlas;
    for k=1:length(strctAtlas.m_astrctMesh)
        strctAtlas.m_astrctMesh(k).visible = k==1;
    end
    acAtlasOptions = {'Saleem-Logothetis','Load...'};
else    
    strctAtlas.m_acRegions = {};
    acAtlasOptions = {'Load...'};
end
strctAtlas=fnConvertAtlasToLongNames(strctAtlas);


strctPanel.m_hAtlasList = uicontrol('style','popupmenu','String',acAtlasOptions,'HorizontalAlignment','left',...
    'Position',[90 strctPanel.m_aiRightPanelSize(4)-40 180 30],...
    'parent',strctPanel.m_ahRightPanels(3),'FontSize',8,'callback',{@fnCallback,'SetNewAtlas'},...
    'value',1,'Fontsize',12);

g_strctModule.m_strctAtlas = strctAtlas;


a2cData = cell(0,3);
strctPanel.m_hAtlasTable = uitable('parent',strctPanel.m_ahRightPanels(3),'position',...
    [10 strctPanel.m_aiRightPanelSize(4)-260 iRightPanelWidth-20 200],...
    'ColumnName',{'Region','Visible','Color'},'Data',a2cData,'ColumnFormat',{'char','logical','char'},'columneditable',...
    [false true false],'CellSelectionCallback',@fnConditionCellSelectCallback,'CellEditCallback',@fnConditionCellEditCallback);


strctPanel.m_hRegionSearchEdit= uicontrol('style','edit','String','',...
    'Position',[10  strctPanel.m_aiRightPanelSize(4)-290 strctPanel.m_aiRightPanelSize(3)/2-30 20],'parent',...
    strctPanel.m_ahRightPanels(3),'callback',...
    {@fnCallback,'SearchAtlasRegion'},'FontSize',10,'backgroundcolor',[1 1 1]);

strctPanel.m_hLocalizeRegionInVolume = uicontrol('style','pushbutton','String','Localize',...
    'Position',[180  strctPanel.m_aiRightPanelSize(4)-290 strctPanel.m_aiRightPanelSize(3)/2-30 20],'parent',...
    strctPanel.m_ahRightPanels(3),'callback',...
    {@fnCallback,'LocalizeRegion'},'FontSize',10);

% 
% strctPanel=  fnAddAtlasButtons(strctPanel, 'Translation', 295, 'MoveAtlas');
% strctPanel=  fnAddAtlasButtons(strctPanel, 'Rotation', 450, 'RotateAtlas');
% strctPanel=  fnAddAtlasButtons(strctPanel, 'Scale', 600, 'ScaleAtlas');

%%



strctPanel.m_ahPanels = [strctPanel.m_ahRightPanels ,strctPanel.m_hWindowsPanel];
for k=1:length(strctPanel.m_ahRightPanels)
    if k== 1
        set(strctPanel.m_ahRightPanels(k),'visible','on');
    else
        set(strctPanel.m_ahRightPanels(k),'visible','off');
    end
end

g_strctModule.m_strctPanel = strctPanel;


fnUpdateAtlasTable();

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

function strctPanel=  fnAddAtlasButtons(strctPanel, strWhat, fOffset, strCallback)
acCtrlName = {'AP','ML','DV'};

strctPanel.m_hAtlasText = uicontrol('style','text','String',strWhat,...
    'Position',[10  strctPanel.m_aiRightPanelSize(4)-fOffset 160 20],'parent',strctPanel.m_ahRightPanels(3),'fontsize',15);

for k=1:3
    
strctPanel.m_ahAtlasCtrl(k) = uicontrol('style','text','String',acCtrlName{k},...
    'Position',[120  strctPanel.m_aiRightPanelSize(4)-30-fOffset-30*(k-1) 60 20],'parent',strctPanel.m_ahRightPanels(3),'fontsize',15);

strctPanel.m_ahMoveAtlasneg(k)= uicontrol('style','pushbutton','String','-',...
    'Position',[60  strctPanel.m_aiRightPanelSize(4)-30-fOffset-5-30*(k-1) 60 25],'parent',...
    strctPanel.m_ahRightPanels(3),'callback',...
    {@fnCallback,strCallback,acCtrlName{k},1},'FontSize',15);

strctPanel.m_ahMoveAtlaspos(k)= uicontrol('style','pushbutton','String','+',...
    'Position',[180  strctPanel.m_aiRightPanelSize(4)-30-fOffset-5-30*(k-1) 60 25],'parent',...
    strctPanel.m_ahRightPanels(3),'callback',...
    {@fnCallback,strCallback,acCtrlName{k},-1},'FontSize',15);
end



function fnConditionCellSelectCallback(hTable,Tmp)
global g_strctModule
aiIndices=Tmp.Indices;
if size(aiIndices,1) == 1 && aiIndices(2) == 3
    iRegionIndex = aiIndices(1);
     RGB=uisetcolor();
     if length(RGB) == 3
        g_strctModule.m_strctAtlas.m_astrctMesh(iRegionIndex).color = RGB;
        fnUpdateAtlasTable;
        feval(g_strctModule.m_hCallbackFunc,'Invalidate');
     end
end
return;

function fnConditionCellEditCallback(hTable,Tmp)
global g_strctModule

aiIndices=Tmp.Indices;
if size(aiIndices,1) == 1 && aiIndices(2) == 2
    iRegionIndex = aiIndices(1);
    g_strctModule.m_strctAtlas.m_astrctMesh(iRegionIndex).visible = ~g_strctModule.m_strctAtlas.m_astrctMesh(iRegionIndex).visible;
     fnUpdateAtlasTable;
    feval(g_strctModule.m_hCallbackFunc,'Invalidate');
end
return;

