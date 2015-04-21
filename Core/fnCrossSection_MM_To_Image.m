function apt2iPointPix = fnCrossSection_MM_To_Image(strctCrossSection, apt2fPointMM)
% apt2fPointMM - Nx2

%pt2iPointPix =[ (((pt2fPointMM(1) / (strctCrossSection.m_fHalfWidthMM)) + 1) / 2) * (strctCrossSection.m_iResWidth-1) + 1,...
% (((pt2fPointMM(2) / (strctCrossSection.m_fHalfHeightMM)) + 1) / 2) * (strctCrossSection.m_iResHeight-1) + 1;];

apt2iPointPix =[ (((apt2fPointMM(:,1) / (strctCrossSection.m_fHalfWidthMM)) + 1) / 2) * (strctCrossSection.m_iResWidth-1) + 1,...
 (((apt2fPointMM(:,2) / (strctCrossSection.m_fHalfHeightMM)) + 1) / 2) * (strctCrossSection.m_iResHeight-1) + 1;];
