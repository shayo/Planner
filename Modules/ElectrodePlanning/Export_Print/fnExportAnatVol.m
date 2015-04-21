function fnExportAnatVol
global g_strctModule
strctMRI = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_strctFreeSurfer;
strctMRI.vol = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a3fVol;

[Dummy,strOrigFileName]=fileparts(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_strName); %#ok
[strFile,strPath]=uiputfile([strOrigFileName,'.nii']);
if strFile(1) == 0
    return;
end;
MRIwrite(strctMRI,fullfile(strPath,strFile));
return;
        
