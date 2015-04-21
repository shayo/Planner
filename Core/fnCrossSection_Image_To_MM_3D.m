function pt3fPosMM = fnCrossSection_Image_To_MM_3D(strctCrossSection, pt2fPos)
pt2fPosMM = fnCrossSection_Image_To_MM(strctCrossSection, pt2fPos);
pt3fPosMMOnPlane = [pt2fPosMM,0,1]';
pt3fPosMM = strctCrossSection.m_a2fM*pt3fPosMMOnPlane;
pt3fPosMM = pt3fPosMM(1:3);
return;