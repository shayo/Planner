
function fnUpdateGridAxes(bHideAfter)
global g_strctModule g_strctWindows
if ~exist('bHideAfter','var')
    bHideAfter = true;
end;
% delete(g_strctModule.m_strctPanel.m_strctGrid.m_ahHoleHandles(ishandle(g_strctModule.m_strctPanel.m_strctGrid.m_ahHoleHandles)));
% g_strctModule.m_strctPanel.m_strctGrid.m_ahHoleHandles = [];
% bNoGrid = false;
% set(g_strctModule.m_strctPanel.m_strctGrid.m_hCurrGridHoleDir,'visible','off');
% set(g_strctModule.m_strctPanel.m_strctGrid.m_hCurrGridHole,'visible','off');
bNoGrid = false;
if g_strctModule.m_iCurrChamber == 0 || isempty(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers)
    bNoGrid = true;
else
   iSelectedGrid = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber).m_iGridSelected;
    if isempty(iSelectedGrid) || iSelectedGrid == 0
        bNoGrid = true;
    end
end;

if bNoGrid
    % Hide / close grid gui
    if isfield(g_strctModule,'m_hGridHelperGUI') && ishandle(g_strctModule.m_hGridHelperGUI)
        set(g_strctModule.m_hGridHelperGUI,'visible','off');
    end
    return;
end

% Open Grid Helper GUI
strctGrid = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber).m_astrctGrids(iSelectedGrid);


strctPlannerInfo.m_iAnatomicalIndex = g_strctModule.m_iCurrAnatVol;
strctPlannerInfo.m_iChamberIndex = g_strctModule.m_iCurrChamber;
strctPlannerInfo.m_iGridIndex = iSelectedGrid;
strctPlannerInfo.m_strCallback = 'fnElectrodePlanningNewCallback';
if ~isfield(strctGrid,'m_strctGeneral') || ~isfield(strctGrid.m_strctGeneral,'m_strGUI')
    % Assume older version....
    strctGrid.m_strctGeneral.m_strGUI = 'GridHelper';
end

if isfield(g_strctModule,'m_strActiveGridHelperGUI') && ~strcmp(g_strctModule.m_strActiveGridHelperGUI, strctGrid.m_strctGeneral.m_strGUI) && ishandle(g_strctModule.m_hGridHelperGUI)
    close(g_strctModule.m_hGridHelperGUI);
end;


try
g_strctModule.m_hGridHelperGUI=feval(strctGrid.m_strctGeneral.m_strGUI, 'InitNewGrid',strctPlannerInfo, strctGrid.m_strctModel, strctGrid.m_strctGeneral,strctGrid.m_strName);
g_strctModule.m_strActiveGridHelperGUI = strctGrid.m_strctGeneral.m_strGUI;
catch %#ok
end

if bHideAfter
    figure(g_strctWindows.m_hFigure);
end
return;

