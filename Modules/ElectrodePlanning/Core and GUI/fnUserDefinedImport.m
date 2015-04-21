function strctOrientation=fnUserDefinedImport()
% User defined function to import a volume to planner.
% Planner uses tkregister way of accessing the volume.
% i.e., it uses the following matrix to convert voxels to "XYZ" metrix
% coordinates: (here, assuming scaling = 1)
% M = [-1 0 0 Nc/2
%       0 0 1 -Ns/2
%       0 -1 0 Nr/2];
%
% However, it also uses the DICOM stored information (i.e. vox2ras).
% The way Planner defines the three cross sections that users can play with
% is by mapping them to vox2ras via a permutation matrix (+ mirroring).
% For example, the following matrices are the default ones that
% work if the patient was scanned in a horizontal magnet, HFS
% and orientation in the NIFTI file was properly fixed using 
% sphnix correction tool.

             strctOrientation.m_a2fSaggital= [0  0  1;
                                             0  -1  0;
                                             -1  0  0];
            
            strctOrientation.m_a2fCoronal= [-1 0 0;
                                            0 -1 0;
                                            0 0 1];
            strctOrientation.m_a2fHoriz  = [-1 0 0;
                                            0 0 1;  
                                            0 1 0];

% Note, these matrices will multiply vox2ras from the right.

return;
