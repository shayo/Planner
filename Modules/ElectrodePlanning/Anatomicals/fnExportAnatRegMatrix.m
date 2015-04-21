
function fnExportAnatRegMatrix()
global g_strctModule
if g_strctModule.m_iCurrAnatVol == 0
    return;
end;
[strFile, strPath] = uiputfile([g_strctModule.m_strDefaultFilesFolder,'*.reg'],'Select transformation file');
if strFile(1) == 0
    return;
end;
strFilename =fullfile(strPath,strFile);
strVolType = 'round'; % make it compatible with FSL ?!?!??!
afVoxelSpacing = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_afVoxelSpacing;
fnWriteRegisteration(strFilename,g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fReg, 'Unknown', strVolType,afVoxelSpacing);
h=msgbox('Saved');
waitfor(h);
return;

