
function fnApplyAnatInvTrans()
global g_strctModule
if g_strctModule.m_iCurrAnatVol == 0
    return;
end;
[strFile, strPath] = uigetfile([g_strctModule.m_strDefaultFilesFolder,'*.reg'],'Select transformation file');
if strFile(1) == 0
    return;
end;
a2fTrans = fnReadRegisteration([strPath, strFile]);
g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fReg = ...
    g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fReg * (a2fTrans);

fnUpdateSurfacePatch();

fnInvalidate(1);
%msgbox('Transformation applied!');
return;