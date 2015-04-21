function fnZoomAxesAux(strField)
global g_strctModule            

iMaxRectSize =  min(g_strctModule.m_strctPanel.m_aiWindowsPanelSize(3:4))-30;
aiZoomPos = [g_strctModule.m_strctPanel.m_aiWindowsPanelSize(1:2), iMaxRectSize,iMaxRectSize];

strctAxes = getfield(g_strctModule.m_strctPanel,strField); %#ok
aiCurrPosition = get(strctAxes.m_hPanel,'Position');
if  all(strctAxes.m_aiPos-aiCurrPosition == 0)
    % Zoom in, hide all other windows
    fnSetAllWindowsMode('off');
    set(strctAxes.m_hPanel,'Position',aiZoomPos,'visible','on');
    set(strctAxes.m_hAxes,'Position',aiZoomPos);
else
    % set back to normal size
    fnSetAllWindowsMode('on');
    
   set(strctAxes.m_hPanel,'Position',strctAxes.m_aiPos,'visible','on');
    set(strctAxes.m_hAxes,'Position',g_strctModule.m_strctPanel.m_aiAxesSize);
    
 end;
return;
