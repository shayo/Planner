function hAxes = fnGetActiveAxes(MousePos)
global g_strctWindows  g_strctModule
hAxes = [];
if ~isfield(g_strctModule,'m_strctPanel') || ~isfield(g_strctModule.m_strctPanel,'m_ahAxes')
    return;
end;
for k=1:length(g_strctModule.m_strctPanel.m_ahAxes)
    
    hParent = get(g_strctModule.m_strctPanel.m_ahAxes(k),'parent');
    if strcmp(get(hParent,'visible'),'off')
        continue;
    end;
    
    if get(g_strctModule.m_strctPanel.m_ahAxes(k),'parent') ~= g_strctWindows.m_hFigure
        %This should be a while loop....
        aiAxesRect = get(g_strctModule.m_strctPanel.m_ahAxes(k),'position');
        hParent = get(g_strctModule.m_strctPanel.m_ahAxes(k),'parent');
        while (1)
            aiParentRect = get(hParent ,'position');
            aiAxesRect(1:2) = aiAxesRect(1:2) + aiParentRect(1:2);
            hParent= get(hParent,'parent');
            if hParent == g_strctWindows.m_hFigure
                break;
            end;
            
        end;
    else
        aiAxesRect = get(g_strctModule.m_strctPanel.m_ahAxes(k),'position');
    end;

    
bInside =  (MousePos(1) > aiAxesRect(1) && ...
    MousePos(1) < aiAxesRect(1)+aiAxesRect(3) && ...
    MousePos(2) > aiAxesRect(2) &&  ...
    MousePos(2) < aiAxesRect(2)+aiAxesRect(4));
    
    
    if bInside
        hAxes = g_strctModule.m_strctPanel.m_ahAxes(k);
        return;
    end;
end;

return;