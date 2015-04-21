function fnDrawScaleBar()
global g_strctModule
if ~isfield(g_strctModule.m_strctPanel.m_strctXZ,'m_hScaleBar')
    g_strctModule.m_strctPanel.m_strctXZ.m_hScaleBar = [];
end
if ~isfield(g_strctModule.m_strctPanel.m_strctYZ,'m_hScaleBar')
    g_strctModule.m_strctPanel.m_strctYZ.m_hScaleBar = [];
end
if ~isfield(g_strctModule.m_strctPanel.m_strctXY,'m_hScaleBar')
    g_strctModule.m_strctPanel.m_strctXY.m_hScaleBar = [];
end
if ~isfield(g_strctModule.m_strctGUIOptions,'m_bScaleBar')
    g_strctModule.m_strctGUIOptions.m_bScaleBar = false; 
end



if g_strctModule.m_strctGUIOptions.m_bScaleBar 
    
    Tmp = fnCrossSection_MM_To_Image(g_strctModule.m_strctCrossSectionXZ,[0 1])-fnCrossSection_MM_To_Image(g_strctModule.m_strctCrossSectionXZ,[0 0]);
    fPixelToMM=Tmp(2);
    if isempty(g_strctModule.m_strctPanel.m_strctXZ.m_hScaleBar)
        g_strctModule.m_strctPanel.m_strctXZ.m_hScaleBar = rectangle('position',[20,20,g_strctModule.m_strctGUIOptions.m_fScaleBarLengthMM*fPixelToMM,fPixelToMM],'parent',g_strctModule.m_strctPanel.m_strctXZ.m_hAxes,'facecolor',[1 1 1 ],'uicontextmenu',g_strctModule.m_strctPanel.m_hMenu);
    else
        set(g_strctModule.m_strctPanel.m_strctXZ.m_hScaleBar,'position',[20,20,g_strctModule.m_strctGUIOptions.m_fScaleBarLengthMM*fPixelToMM,fPixelToMM]);
    end

    Tmp = fnCrossSection_MM_To_Image(g_strctModule.m_strctCrossSectionYZ,[0 1])-fnCrossSection_MM_To_Image(g_strctModule.m_strctCrossSectionYZ,[0 0]);
    fPixelToMM=Tmp(2);
    if isempty(g_strctModule.m_strctPanel.m_strctYZ.m_hScaleBar)
        g_strctModule.m_strctPanel.m_strctYZ.m_hScaleBar = rectangle('position',[20,20,g_strctModule.m_strctGUIOptions.m_fScaleBarLengthMM*fPixelToMM,fPixelToMM],'parent',g_strctModule.m_strctPanel.m_strctYZ.m_hAxes,'facecolor',[1 1 1 ],'uicontextmenu',g_strctModule.m_strctPanel.m_hMenu);
    else
        set(g_strctModule.m_strctPanel.m_strctYZ.m_hScaleBar,'position',[20,20,g_strctModule.m_strctGUIOptions.m_fScaleBarLengthMM*fPixelToMM,fPixelToMM]);
    end    
    
    Tmp = fnCrossSection_MM_To_Image(g_strctModule.m_strctCrossSectionXY,[0 1])-fnCrossSection_MM_To_Image(g_strctModule.m_strctCrossSectionXY,[0 0]);
    fPixelToMM=Tmp(2);
    if isempty(g_strctModule.m_strctPanel.m_strctXY.m_hScaleBar)
        g_strctModule.m_strctPanel.m_strctXY.m_hScaleBar = rectangle('position',[20,20,g_strctModule.m_strctGUIOptions.m_fScaleBarLengthMM*fPixelToMM,fPixelToMM],'parent',g_strctModule.m_strctPanel.m_strctXY.m_hAxes,'facecolor',[1 1 1 ],'uicontextmenu',g_strctModule.m_strctPanel.m_hMenu);
    else
        set(g_strctModule.m_strctPanel.m_strctXY.m_hScaleBar,'position',[20,20,g_strctModule.m_strctGUIOptions.m_fScaleBarLengthMM*fPixelToMM,fPixelToMM]);
    end    
    
end


% 
% 
% switch strLocation
%     case 'TopLeft'
%     case 'TopRight'
%     case 'BottomLeft'
%     case 'BottomRight';
% end
% 
% 



