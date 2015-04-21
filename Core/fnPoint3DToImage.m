function [apt2fPoints,abInside] = fnPoint3DToImage(strctCrossSection, apt3fPoints)
iNumPoints = size(apt3fPoints,2);
apt2fP1_XYZ = [apt3fPoints(1:3,:); ones(1,iNumPoints)];

Tmp = inv(strctCrossSection.m_a2fM) * apt2fP1_XYZ;
apt2fP1 = Tmp(1:2,:);
abInside = apt2fP1(1,:) >= -strctCrossSection.m_fHalfWidthMM & apt2fP1(1,:) <=strctCrossSection.m_fHalfWidthMM & ...
                   apt2fP1(2,:) >= -strctCrossSection.m_fHalfHeightMM & apt2fP1(2,:) <=strctCrossSection.m_fHalfHeightMM ;

% Map to pixel values
apt2fPoints = fnCrossSection_MM_To_Image(strctCrossSection,[apt2fP1(1,:)',apt2fP1(2,:)']);

return;
