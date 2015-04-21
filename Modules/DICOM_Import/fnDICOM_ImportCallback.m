function fnDICOM_ImportCallback(strCallback, varargin)

switch strCallback
    case 'LoadDICOM'
        strInputRootPath = uigetdir('','Enter Input Folder with DICOM files');
        strOutputPath = uigetdir(strInputRootPath,'Enter Output Folder to store NIFTI files');
        strDicomFilter = '*.dcm'; % assume this is the file extention
        strOutputformat = 'nii'; % 'nii' or 'img' 
        acFiles = fnGetAllFiles(fnRecursiveGetSubDirectories(strInputRootPath),strDicomFilter);
        % Generate output root path
        if ~exist(strOutputPath,'dir')
            mkdir(strOutputPath);
        end;
        
        strCurrPwd = pwd;
        cd(strOutputPath);
        fprintf('Scanning DICOM headers\n');
        hdr = spm_dicom_headers(char(acFiles), true);
        out = spm_dicom_convert(hdr,'all','flat',strOutputformat);
        cd(strCurrPwd);
        fprintf('All Done!\n');
        iNumFilesCreated = length(out.files);
        
        
        

end

return;

