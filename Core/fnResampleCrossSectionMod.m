function [a2fCrossSection, apt3fPlanePoints] = fnResampleCrossSectionMod(a3fVol, a2fXYZ_To_CRS, strctCrossSection)
% resamples a cross-section (plane) of a volume.
% Cross section is defined by a 3x3 rotation and position, emmbeded in a 4x4 matrix
% 
% Also returns the four corner of this plane in XYZ coordinates
%

[a2fXmm,a2fYmm] = meshgrid(...
    linspace(-strctCrossSection.m_fHalfWidthMM, strctCrossSection.m_fHalfWidthMM, strctCrossSection.m_iResWidth),...
    linspace(0, 2*strctCrossSection.m_fHalfHeightMM, strctCrossSection.m_iResHeight));

a2fZmm = zeros(size(a2fXmm));
a2fOnes = ones(size(a2fZmm));
apt2fPoints = a2fXYZ_To_CRS * strctCrossSection.m_a2fM  * [a2fXmm(:), a2fYmm(:),a2fZmm(:),a2fOnes(:)]';

a2fTmp = [strctCrossSection.m_a2fM  * [-strctCrossSection.m_fHalfWidthMM, -strctCrossSection.m_fHalfHeightMM, 0,1]',...
strctCrossSection.m_a2fM  * [-strctCrossSection.m_fHalfWidthMM, +strctCrossSection.m_fHalfHeightMM, 0,1]',...
strctCrossSection.m_a2fM  * [+strctCrossSection.m_fHalfWidthMM, -strctCrossSection.m_fHalfHeightMM, 0,1]',...
strctCrossSection.m_a2fM  * [+strctCrossSection.m_fHalfWidthMM, +strctCrossSection.m_fHalfHeightMM, 0,1]'];
apt3fPlanePoints = a2fTmp(1:3,:);

% This is a delicate point.
% Free surfer transformations are always relative to a volume which is
% represented relative to [0,0,0] (i.e., this is the first voxel).
% however, matlab representation is relative to [1,1,1].
% The fast interp 3 dll get indices which are relative to [1,1,1],
% therefore, we add one to all three dimensions.
a2fCrossSection = reshape(fndllFastInterp3(a3fVol, 1+apt2fPoints(1,:),1+apt2fPoints(2,:),1+apt2fPoints(3,:)), size(a2fXmm));
return;

