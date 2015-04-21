function strctAnatVol = fnQuickAddVolume(strFileName)
aiImageRes = [256,256];
strctMRI = MRIread(strFileName);
if size(strctMRI.vol,4) > 1
    strctMRI.vol = strctMRI.vol(:,:,:,1);
end;
[strctCrossSectionHoriz,strctCrossSectionSaggital,strctCrossSectionCoronal] = fnSetDefaultCrossSectionsCorrect(strctMRI.volsize, strctMRI.tkrvox2ras, strctMRI.vox2ras0, aiImageRes(1),aiImageRes(2));
strctLinearHistogramStretch = fnBuildDefaultContrastTransform(strctMRI.vol);
strctAnatVol.m_strFileName = strFileName;
[strPath,strFile]=fileparts(strctAnatVol.m_strFileName);
strctAnatVol.m_strName = strFile;
strctAnatVol.m_a2fEB0 = strctCrossSectionHoriz.m_a2fM;
strctAnatVol.m_a2fEB0(:,3) = -strctAnatVol.m_a2fEB0(:,3);
strctAnatVol.m_a3fVol = strctMRI.vol;
strctAnatVol.m_afVoxelSpacing = strctMRI.volres;
strctAnatVol.m_aiVolSize = size(strctMRI.vol);

strctAnatVol.m_a2fAtlasReg  = eye(4);
a2fTmp = inv(strctMRI.vox2ras0(1:3,1:3));
strctAnatVol.m_a2fAtlasReg(1:3,1) = a2fTmp(1:3,1) ./ norm(a2fTmp(1:3,1));
strctAnatVol.m_a2fAtlasReg(1:3,2) = a2fTmp(1:3,2) ./ norm(a2fTmp(1:3,2));
strctAnatVol.m_a2fAtlasReg(1:3,3) = a2fTmp(1:3,3) ./ norm(a2fTmp(1:3,3));
strctAnatVol.m_a2fAtlasReg(1:3,3) = -strctAnatVol.m_a2fAtlasReg(1:3,3);
strctAnatVol.m_a2fM =strctMRI.tkrvox2ras;

strctAnatVol.m_a2fReg = eye(4);
strctAnatVol.m_strctCrossSectionHoriz = strctCrossSectionHoriz;
strctAnatVol.m_strctCrossSectionSaggital = strctCrossSectionSaggital;
strctAnatVol.m_strctCrossSectionCoronal = strctCrossSectionCoronal;
strctAnatVol.m_strctContrastTransform = strctLinearHistogramStretch;


bFlipped = acos(dot(strctAnatVol.m_strctCrossSectionHoriz.m_a2fM(1:3,3),strctAnatVol.m_strctCrossSectionSaggital.m_a2fM(1:3,2)))/pi*180 > 90;
if (bFlipped) % Horizontal normal vector is incorrect!
    strctAnatVol.m_strctCrossSectionHoriz.m_a2fM(1:3,3) = -strctAnatVol.m_strctCrossSectionHoriz.m_a2fM(1:3,3);
end

% FIXED,6/17/2014
strctAnatVol.m_a2fRegToStereoTactic = 1/10*fnRotateVectorAboutAxis4D([1 0 0],pi)* inv(strctAnatVol.m_strctCrossSectionHoriz.m_a2fM);

% strctAnatVol.m_a2fRegToStereoTactic = fnRotateVectorAboutAxis4D([1 0 0],pi)* inv(strctAnatVol.m_strctCrossSectionHoriz.m_a2fM);

strctAnatVol.m_astrctChambers = [];
strctAnatVol.m_astrctTargets = [];
strctAnatVol.m_astrctROIs= [];
strctAnatVol.m_acSavedVirtualArms = {};
strctMRI = rmfield(strctMRI,'vol');
strctAnatVol.m_strctFreeSurfer = strctMRI;
strctAnatVol.m_strctSurface  = [];
strctAnatVol.m_strctBloodSurface  = [];
strctAnatVol.m_acFreeSurferSurfaces = [];

return;


%{
function [strctCrossSectionHoriz,strctCrossSectionSaggital,strctCrossSectionCoronal] = fnSetDefaultCrossSections(aiVolSize, a2fM,iResWidth,iResHeight )
% Project [0,0,0] and aiVolSize and find min and max
P = [0,0,0,1;
     aiVolSize,1];
 
[a2fCRS, afScale] = fnDecomposeVox2Ras(a2fM);

Pmm =  a2fM * P';

fRangeX = abs(Pmm(2,2)-Pmm(2,1));
fRangeY = abs(Pmm(1,2)-Pmm(1,1));
fRangeZ = abs(Pmm(3,2)-Pmm(3,1));

fHalfXYMM  =  max(fRangeX,fRangeY)/2;
fHalfYZMM  =  max(fRangeZ,fRangeY)/2;
fHalfXZMM =  max(fRangeX,fRangeZ)/2;
% prepare cross sections

% XY: sphenix
% strctCrossSectionHoriz.m_a2fM = [-1,0, 0  0;
%                                   0  0 1  0;
%                                   0  1  0  0;
%                                   0  0 0  1];
%
%  strctCrossSectionHoriz.m_a2fM = [ 0, -1, 0  0;
%                                    1  0  0  0;
%                                    0  0  1  0;
%                                    0  0 0  1];

strctCrossSectionHoriz.m_a2fM = eye(4);
strctCrossSectionHoriz.m_a2fM(1:3,1:3) = U*V';
% [...
%     -1.0000   -0.0000         0         0;
%     0               0               1.0000    0;
%     0.0000   -1.0000         0          0;
%     0               0                  0     1.0000];
strctCrossSectionHoriz.m_fHalfWidthMM = fHalfXYMM;
strctCrossSectionHoriz.m_fHalfHeightMM = fHalfXYMM;
strctCrossSectionHoriz.m_iResWidth = iResWidth;
strctCrossSectionHoriz.m_iResHeight = iResHeight;
strctCrossSectionHoriz.m_fViewOffsetMM = 0;
strctCrossSectionHoriz.m_bZFlip = false;
strctCrossSectionHoriz.m_bLRFlip = false;
strctCrossSectionHoriz.m_bUDFlip = false;

% XZ
% strctCrossSectionSaggital.m_a2fM = [0, 0, -1  0;
%                                     0  1  0  0;
%                                    -1  0 0  0;
%                                     0 0 0  1]; % This gives coronal slice such that Y = 0 is superior
                                
% strctCrossSectionSaggital.m_a2fM = [1, 0, 0  0;
%                                     0  0  1  0;
%                                     0  1  0  0;
%                                     0  0  0  1]; % This gives coronal slice such that Y = 0 is superior
strctCrossSectionSaggital.m_a2fM = eye(4);
strctCrossSectionSaggital.m_a2fM(1:3,1:3) = [    0     -1   0;    0     0     -1;    -1    0    0] * U*V';
% [...
%     0.0000         0                  -1.0000         0;
%     0                   1.0000         0         0;
%     1.0000         0                    0.0000         0;
%     0         0         0    1.0000];


                               
strctCrossSectionSaggital.m_fHalfWidthMM =  fHalfXZMM;
strctCrossSectionSaggital.m_fHalfHeightMM =  fHalfXZMM;
strctCrossSectionSaggital.m_iResWidth = iResWidth;
strctCrossSectionSaggital.m_iResHeight = iResHeight;
strctCrossSectionSaggital.m_fViewOffsetMM = 0;
strctCrossSectionSaggital.m_bZFlip = false;
strctCrossSectionSaggital.m_bLRFlip = false;
strctCrossSectionSaggital.m_bUDFlip = false;

% YZ
% strctCrossSectionCoronal.m_a2fM = [-1 0 0  0;
%                                    0  1 0  0;
%                                    0, 0,1  0;
%                                    0 0 0  1]; % This gives coronal slice such that Y = 0 is superior

% strctCrossSectionCoronal.m_a2fM = [0  0 1  0;
%                                    -1 0 0  0;
%                                    0, 1,0  0;
%                                    0 0 0  1]; % This gives coronal slice such that Y = 0 is superior
strctCrossSectionCoronal.m_a2fM = eye(4);
strctCrossSectionCoronal.m_a2fM(1:3,1:3) = [1 0 0;0 0 -1;0 -1 0] * U*V';
% [...
%     -1.0000         0   -0.0000         0;
%     0    1.0000         0         0;
%     0.0000         0   -1.0000         0;
%     0         0         0    1.0000];

strctCrossSectionCoronal.m_fHalfWidthMM = fHalfYZMM;
strctCrossSectionCoronal.m_fHalfHeightMM = fHalfYZMM;
strctCrossSectionCoronal.m_iResWidth = iResWidth;
strctCrossSectionCoronal.m_iResHeight = iResHeight;
strctCrossSectionCoronal.m_fViewOffsetMM = 0;
strctCrossSectionCoronal.m_bZFlip = false;
strctCrossSectionCoronal.m_bLRFlip = false;
strctCrossSectionCoronal.m_bUDFlip = false;


return;
%}


function [strctCrossSectionHoriz,strctCrossSectionSaggital,strctCrossSectionCoronal] = fnSetDefaultCrossSections(aiVolSize, a2fM,iResWidth,iResHeight,strctOrientation, a2fPateientOri)
% Project [0,0,0] and aiVolSize and find min and max
P0 = a2fM * [0;0;0;1];

Pc = a2fM * [aiVolSize(1);0;0;1];
Pr = a2fM * [0;aiVolSize(2);0;1];
Ps = a2fM * [0;0;aiVolSize(2);1];

PCenter = a2fM * [aiVolSize(1)/2;aiVolSize(2)/2;aiVolSize(3)/2;1];

% Assume a2fM is in "RAS"  (CRS)

fSpanRightMM = norm(Pc-P0);
fSpanAnteriorMM = norm(Pr-P0);
fSpanSuperiorMM = norm(Ps-P0);

[a2fCRS, afScale] = fnDecomposeVox2Ras(a2fPateientOri(1:3,1:3));

% a2fM in strctCrosssection maps the plane Z=0 (in mm space) to the desired horizontal
% cross section using the given RAS matrix

strctCrossSectionHoriz.m_a2fM = eye(4);
strctCrossSectionHoriz.m_a2fM(1:3,4) = PCenter(1:3);
strctCrossSectionHoriz.m_a2fM(1:3,1:3) = a2fCRS * strctOrientation.m_a2fHoriz;
strctCrossSectionHoriz.m_fHalfWidthMM = min(fSpanRightMM/2,fSpanAnteriorMM/2);
strctCrossSectionHoriz.m_fHalfHeightMM = min(fSpanRightMM/2,fSpanAnteriorMM/2);
strctCrossSectionHoriz.m_iResWidth = iResWidth;
strctCrossSectionHoriz.m_iResHeight = iResHeight;
strctCrossSectionHoriz.m_fViewOffsetMM = 0;
strctCrossSectionHoriz.m_bZFlip = false;
strctCrossSectionHoriz.m_bLRFlip = false;
strctCrossSectionHoriz.m_bUDFlip = false;


strctCrossSectionSaggital.m_a2fM = eye(4);
strctCrossSectionSaggital.m_a2fM(1:3,4) = PCenter(1:3);
strctCrossSectionSaggital.m_a2fM(1:3,1:3) = a2fCRS *strctOrientation.m_a2fSaggital;
strctCrossSectionSaggital.m_fHalfWidthMM =  min(fSpanAnteriorMM/2,fSpanSuperiorMM/2);
strctCrossSectionSaggital.m_fHalfHeightMM = min(fSpanAnteriorMM/2,fSpanSuperiorMM/2);
strctCrossSectionSaggital.m_iResWidth = iResWidth;
strctCrossSectionSaggital.m_iResHeight = iResHeight;
strctCrossSectionSaggital.m_fViewOffsetMM = 0;
strctCrossSectionSaggital.m_bZFlip = false;
strctCrossSectionSaggital.m_bLRFlip = false;
strctCrossSectionSaggital.m_bUDFlip = false;

strctCrossSectionCoronal.m_a2fM = eye(4);
strctCrossSectionCoronal.m_a2fM(1:3,4) = PCenter(1:3);
strctCrossSectionCoronal.m_a2fM(1:3,1:3) = a2fCRS * strctOrientation.m_a2fCoronal;
strctCrossSectionCoronal.m_fHalfWidthMM = min(fSpanRightMM/2,fSpanSuperiorMM/2);
strctCrossSectionCoronal.m_fHalfHeightMM = min(fSpanRightMM/2,fSpanSuperiorMM/2);
strctCrossSectionCoronal.m_iResWidth = iResWidth;
strctCrossSectionCoronal.m_iResHeight = iResHeight;
strctCrossSectionCoronal.m_fViewOffsetMM = 0;
strctCrossSectionCoronal.m_bZFlip = false;
strctCrossSectionCoronal.m_bLRFlip = false;
strctCrossSectionCoronal.m_bUDFlip = false;


return;




function [strctCrossSectionHoriz,strctCrossSectionSaggital,strctCrossSectionCoronal] = fnSetDefaultCrossSectionsCorrect(aiVolSize, a2fM, a2fM_RAS,iResWidth,iResHeight)
% To be compatible with registration issues, planner also uses the
% tkregister convension of a2fM_TK for placing the volume in mm space
% However, this leads to the problem that the directions
% (anterios,right,superior) are not correct anymore.
% to aleviate this, we use the cross section trick, which takes this
% information from vox2raw0
%
% According to NIFTI's convension:
% +x = Right  +y = Anterior  +z = Superior.
%
%
% We need to define three default cross sections.
% Those are easy to define in the mm space according to the above
% definition.
%
%
% Determine the span of the volume in mm space first.

% Project [0,0,0] and aiVolSize and find min and max
P0 = a2fM * [0;0;0;1];

Pc = a2fM * [aiVolSize(1);0;0;1];
Pr = a2fM * [0;aiVolSize(2);0;1];
Ps = a2fM * [0;0;aiVolSize(2);1];

PCenter = a2fM * [aiVolSize(1)/2;aiVolSize(2)/2;aiVolSize(3)/2;1];

fSpanRightMM = norm(Pc-P0);
fSpanAnteriorMM = norm(Pr-P0);
fSpanSuperiorMM = norm(Ps-P0);

% Horizontal cross section

%a2fInvM = inv(a2fM);
% afDirection_Right =[1;0;0];
% afDirection_Anterior =[0;-1;0];
% afDirection_Superior =[0;0;-1];%a2fInvM(1:3,3) / norm(a2fInvM(1:3,3));
a2fInvRAS = inv(a2fM_RAS);
afDirection_Right = -a2fInvRAS(1:3,1) ./ norm(a2fInvRAS(1:3,1));
afDirection_Anterior = a2fInvRAS(1:3,3) ./ norm(a2fInvRAS(1:3,3));
afDirection_Superior = a2fInvRAS(1:3,2) ./ norm(a2fInvRAS(1:3,2));

strctCrossSectionHoriz.m_a2fM = eye(4);
strctCrossSectionHoriz.m_a2fM(1:3,4) = PCenter(1:3);
strctCrossSectionHoriz.m_a2fM(1:3,1:3) = [afDirection_Right,afDirection_Anterior,afDirection_Superior];

strctCrossSectionHoriz.m_fHalfWidthMM = min(fSpanRightMM/2,fSpanAnteriorMM/2);
strctCrossSectionHoriz.m_fHalfHeightMM = min(fSpanRightMM/2,fSpanAnteriorMM/2);
strctCrossSectionHoriz.m_iResWidth = iResWidth;
strctCrossSectionHoriz.m_iResHeight = iResHeight;
strctCrossSectionHoriz.m_fViewOffsetMM = 0;
strctCrossSectionHoriz.m_bZFlip = false;
strctCrossSectionHoriz.m_bLRFlip = false;
strctCrossSectionHoriz.m_bUDFlip = false;


strctCrossSectionSaggital.m_a2fM = eye(4);
strctCrossSectionSaggital.m_a2fM(1:3,4) = PCenter(1:3);
strctCrossSectionSaggital.m_a2fM(1:3,1:3) = [-afDirection_Anterior,-afDirection_Superior,afDirection_Right];

strctCrossSectionSaggital.m_fHalfWidthMM =  min(fSpanAnteriorMM/2,fSpanSuperiorMM/2);
strctCrossSectionSaggital.m_fHalfHeightMM = min(fSpanAnteriorMM/2,fSpanSuperiorMM/2);
strctCrossSectionSaggital.m_iResWidth = iResWidth;
strctCrossSectionSaggital.m_iResHeight = iResHeight;
strctCrossSectionSaggital.m_fViewOffsetMM = 0;
strctCrossSectionSaggital.m_bZFlip = false;
strctCrossSectionSaggital.m_bLRFlip = false;
strctCrossSectionSaggital.m_bUDFlip = false;

strctCrossSectionCoronal.m_a2fM = eye(4);
strctCrossSectionCoronal.m_a2fM(1:3,4) = PCenter(1:3);
strctCrossSectionCoronal.m_a2fM(1:3,1:3) = [afDirection_Right,-afDirection_Superior,afDirection_Anterior];

strctCrossSectionCoronal.m_fHalfWidthMM = min(fSpanRightMM/2,fSpanSuperiorMM/2);
strctCrossSectionCoronal.m_fHalfHeightMM = min(fSpanRightMM/2,fSpanSuperiorMM/2);
strctCrossSectionCoronal.m_iResWidth = iResWidth;
strctCrossSectionCoronal.m_iResHeight = iResHeight;
strctCrossSectionCoronal.m_fViewOffsetMM = 0;
strctCrossSectionCoronal.m_bZFlip = false;
strctCrossSectionCoronal.m_bLRFlip = false;
strctCrossSectionCoronal.m_bUDFlip = false;


return;