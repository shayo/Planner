function fnAddNewROIUsingAtlas()
global g_strctModule

if exist('Saleem_Logothetis_AtlasVolume.mat','file') && ~isfield(g_strctModule.m_strctAtlas,'m_a3iVolume')
    fprintf('Loading Atlas Volume...');
    strctTmp = load('Saleem_Logothetis_AtlasVolume.mat');
    fprintf('Done!\n');
    g_strctModule.m_strctAtlas.m_a3iVolume = strctTmp.a3iAtlasVolume;
    g_strctModule.m_strctAtlas.m_a2fCRS_To_XYZ= strctTmp.a2fCRS_TO_XYZ;
    g_strctModule.m_strctAtlas.m_acRegionNamesInVolume = strctTmp.acRegionNames;
end

aiSelectedRegions=listdlg('PromptString','Select Regins:','ListString',g_strctModule.m_strctAtlas.m_acRegionNamesInVolume,'SelectionMode','multiple','ListSize',[300 300]);
if isempty(aiSelectedRegions)
    return;
end;   
  
iSelectedROI= fnAddNewROI();

% Obtain the voxel coordinates in atlas space for the corresponding
% regions....
a3bSelected = fndllSelectLabels(g_strctModule.m_strctAtlas.m_a3iVolume, uint16(aiSelectedRegions)) > 0;
[aiI,aiJ,aiK] = ind2sub(size(a3bSelected), find(a3bSelected));
% Convert o mm space
a2fCRS_To_XYZ = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fReg*g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fM;
Tmp = inv(a2fCRS_To_XYZ) *  g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fAtlasReg*g_strctModule.m_strctAtlas.m_a2fCRS_To_XYZ * [aiJ-1, aiI-1, aiK-1, ones(size(aiI))]';
g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctROIs(iSelectedROI).m_aiVolumeIndices = sub2ind(size(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a3fVol), round(Tmp(2,:)),round(Tmp(1,:)),round(Tmp(3,:)));
 fnInvalidate(1);
return;

