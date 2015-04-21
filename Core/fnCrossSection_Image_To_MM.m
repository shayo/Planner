function pt2fPointMM = fnCrossSection_Image_To_MM(strctCrossSection, pt2iPointPix)
pt2fPointMM = (2*((pt2iPointPix-1) ./ [(strctCrossSection.m_iResWidth-1), (strctCrossSection.m_iResHeight-1)]) - 1) .*  [...
    strctCrossSection.m_fHalfWidthMM, strctCrossSection.m_fHalfHeightMM];

return;
