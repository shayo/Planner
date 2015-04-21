function fnExportFuncVol()
global g_strctModule
strctMRI = g_strctModule.m_acFuncVol{g_strctModule.m_iCurrFuncVol}.m_strctFreeSurfer;
strctMRI.vol = g_strctModule.m_acFuncVol{g_strctModule.m_iCurrFuncVol}.m_a3fVol;

[Dummy,strOrigFileName]=fileparts(g_strctModule.m_acFuncVol{g_strctModule.m_iCurrFuncVol}.m_strName); %#ok
[strFile,strPath]=uiputfile([strOrigFileName,'.nii']);
if strFile(1) == 0
    return;
end;
MRIwrite(strctMRI,fullfile(strPath,strFile));

return;
    