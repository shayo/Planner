
function fnLoadFuncVol()
global g_strctModule
    
[strFuncFile, strPath] = uigetfile([g_strctModule.m_strDefaultFilesFolder,'*.bhdr;*.nii'],'Select Functional Volume');
if strFuncFile(1) == 0
    return;
end;
strInputVolfile = [strPath,strFuncFile];
% 
% [strFile, strPath] = uigetfile([g_strctModule.m_strDefaultFilesFolder,'*.reg;*.dat'],'Select registeration');
% if strFile(1) == 0
%     % no registeration available?
 strInputRegfile = 'Missing';
% a2fRegisteration = [1 0 0 0;
%     0 1 0 0;
%     0 0 1 0;
%     0 0 0 1];
% afVoxelSpacing = [1 1 1]; % unknown...
% else
%     strInputRegfile = [strPath,strFile];
%     [a2fRegisteration, strSubjectName, strVolType,afVoxelSpacing] = fnReadRegisteration(strInputRegfile);    
% end;

strctVol = MRIread(strInputVolfile);

if size(strctVol.vol,4) > 1 %#ok
   strAnswer= questdlg('You cannot load a 4D volumes (time series) into planner (usually you overlay 3D statistical maps). Do you want to take just the first time frame instead?','Important Question','Yes','No (Cancel)','No (Cancel)');
   if ~strcmpi(strAnswer,'Yes')
       return;
   end;
    strctVol.vol = strctVol.vol(:,:,:,1);
end

[strTmp, strctFuncVol.m_strName] = fileparts(strInputVolfile); %#ok
strctFuncVol.m_strFileName = strInputVolfile;
strctFuncVol.m_strRegisterationFileName = strInputRegfile;
strctFuncVol.m_afVoxelSpacing = strctVol.volres;
strctFuncVol.m_aiVolSize = size(strctVol.vol);
strctFuncVol.m_a3fVol = strctVol.vol;

% strctTransform = QuickOrientationWizard();
% if isempty(strctTransform)
%     return;
% end;

%a2fM = fnFreesurferToPlanner(strctVol);
a2fM=strctVol.tkrvox2ras;

strctFuncVol.m_a2fM = a2fM;

%strctFuncVol.m_a2fM = strctVol.tkrvox2ras;

strctFuncVol.m_a2fReg = eye(4);
%strctFuncVol.m_a2fRegVoxelSpacing = strctFuncVol.m_afVoxelSpacing;
strctFuncVol.m_strctFreeSurfer = rmfield(strctVol,'vol');
iNumFuncVols = length(g_strctModule.m_acFuncVol);
g_strctModule.m_iCurrFuncVol = iNumFuncVols+1;
g_strctModule.m_acFuncVol{iNumFuncVols+1} = strctFuncVol;

fnUpdateFunctionalsList();

if ~g_strctModule.m_bFuncVolLoaded 
    g_strctModule.m_bFuncVolLoaded  = true;
end;
fnInvalidate(true);
return;

