
function fnUpdateGridList()
global g_strctModule
if isempty(g_strctModule.m_iCurrChamber)
    set(g_strctModule.m_strctPanel.m_hGridList,'string','','value',1);
    return;
end;
if g_strctModule.m_iCurrChamber == 0 || isempty(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers)
    set(g_strctModule.m_strctPanel.m_hGridList,'string','','value',0);
    return;
end;
if g_strctModule.m_iCurrChamber > length(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers)
    g_strctModule.m_iCurrChamber = length(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers);
end

iNumGrids = length(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber).m_astrctGrids);
if iNumGrids == 0
    set(g_strctModule.m_strctPanel.m_hGridList,'string','','value',1);
 else
    strGrids = '';
    for k=1:iNumGrids
        strctGrid = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber).m_astrctGrids(k);
        if isfield(strctGrid,'m_strName')
            strGrids = [strGrids,'|',strctGrid.m_strName]; %#ok
        elseif isfield(strctGrid,'m_strGridName')
            strGrids = [strGrids,'|',strctGrid.m_strGridName]; %#ok
        else
            strGrids = [strGrids,'|','Unknown']; %#ok
        end
        
    end;
    set(g_strctModule.m_strctPanel.m_hGridList,'string',strGrids(2:end),'value',g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber).m_iGridSelected);
end;

return;
