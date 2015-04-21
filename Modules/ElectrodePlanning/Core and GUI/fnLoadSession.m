function fnLoadSession()
global g_strctModule
[strFile, strPath] = uigetfile([g_strctModule.m_strDefaultFilesFolder,'*.mat'],'Select previous session');
if strFile(1) == 0
    return;
end;
strFullFileName = [strPath,strFile];
bSuccessful = fnLoadSessionAux(strFullFileName);
if ~bSuccessful
    h=msgbox('Invalid file');
    waitfor(h);
end
return;
