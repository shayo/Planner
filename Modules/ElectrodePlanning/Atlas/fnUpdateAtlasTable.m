function fnUpdateAtlasTable()
global g_strctModule

iNumRegions = length(g_strctModule.m_strctAtlas.m_astrctMesh);
a2cData = cell(iNumRegions,3);
for iIter=1:iNumRegions
    a2cData{iIter,1} = g_strctModule.m_strctAtlas.m_astrctMesh(iIter).name;
    a2cData{iIter,2} = g_strctModule.m_strctAtlas.m_astrctMesh(iIter).visible;
    R=(round(255*g_strctModule.m_strctAtlas.m_astrctMesh(iIter).color(1)));
    G=(round(255*g_strctModule.m_strctAtlas.m_astrctMesh(iIter).color(2)));
    B=(round(255*g_strctModule.m_strctAtlas.m_astrctMesh(iIter).color(3)));
    a2cData{iIter,3} = sprintf('<html><span style="background-color: #%02X%02X%02X;"> ______  </span></html>',R,G,B);
end
set(g_strctModule.m_strctPanel.m_hAtlasTable,'Data',a2cData);

return;
