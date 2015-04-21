

function fnSaveSession()
global g_strctModule %#ok
[strFile,strPath]=uiputfile('PlannerSession.mat');
if strFile(1) == 0
    return;
end;
if exist([strPath,strFile],'file') && fnFileSize([strPath,strFile]) > 0
    % Generate a backup (only if the current file is not empty...)
    fprintf('Generating a backup file before saving...\n');
    copyfile([strPath,strFile],[strPath,strFile,'_backup'],'f');
end
save([strPath,strFile],'g_strctModule','-v7.3');
fprintf('Session Saved to: %s\n',[strPath,strFile]);
msgbox('Session Saved');
return;

