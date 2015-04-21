

function fnApplyAnatTrans()
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
     inv(a2fTrans) * g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fReg; %#ok

fnUpdateSurfacePatch();
fnSetCurrAnatVol();
fnSetDefaultCrossSections();%g_strctModule.m_strctPanel.m_aiImageRes(2),g_strctModule.m_strctPanel.m_aiImageRes(1));

fnInvalidate(1);
return;
