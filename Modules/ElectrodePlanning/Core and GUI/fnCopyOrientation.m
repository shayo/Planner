
function fnCopyOrientation(a,b,iAnatVolFrom) %#ok
global g_strctModule
g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_strctCrossSectionCoronal = g_strctModule.m_acAnatVol{iAnatVolFrom}.m_strctCrossSectionCoronal;
g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_strctCrossSectionHoriz = g_strctModule.m_acAnatVol{iAnatVolFrom}.m_strctCrossSectionHoriz;
g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_strctCrossSectionSaggital = g_strctModule.m_acAnatVol{iAnatVolFrom}.m_strctCrossSectionSaggital;
g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fEB0  = g_strctModule.m_acAnatVol{iAnatVolFrom}.m_a2fEB0;
g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fRegToStereoTactic  = g_strctModule.m_acAnatVol{iAnatVolFrom}.m_a2fRegToStereoTactic;
if ~isfield(g_strctModule.m_acAnatVol{iAnatVolFrom},'m_a2fAtlasReg')
    g_strctModule.m_acAnatVol{iAnatVolFrom}.m_a2fAtlasReg = eye(4);
end;
g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fAtlasReg  = g_strctModule.m_acAnatVol{iAnatVolFrom}.m_a2fAtlasReg;

fnSetDefaultCrossSections();
fnInvalidate();

return;



 