
function fnSearchAtlasRegion()
global g_strctModule
strSearchPattern = get(g_strctModule.m_strctPanel.m_hRegionSearchEdit,'String');


jUIScrollPane = findjobj(g_strctModule.m_strctPanel.m_hAtlasTable);
jUITable = jUIScrollPane(2).getViewport.getView;
jUITable.setRowSelectionAllowed(0);
jUITable.setColumnSelectionAllowed(0);


acMatches = strfind(lower({g_strctModule.m_strctAtlas.m_astrctMesh.name}), lower(strSearchPattern));
for k=1:length(acMatches)
    if ~isempty(acMatches{k})
       jUITable.changeSelection(k-1,0, false, false);
       return;
    end
end


return;