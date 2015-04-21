function a2fTranI = fnContrastTransform(a2fI, strctTransform)
if strcmp(strctTransform.m_strType,'Linear');
    a = 1 / (2*strctTransform.m_fWidth);
    b = -a * (strctTransform.m_fCenter -strctTransform.m_fWidth);
    a2fTranI= a*a2fI + b;
    a2fTranI(a2fI <= (strctTransform.m_fCenter-strctTransform.m_fWidth)) = 0;
    a2fTranI(a2fI >=(strctTransform.m_fCenter+strctTransform.m_fWidth)) = 1;
    a2fTranI(a2fTranI < 0) = 0;
    a2fTranI(a2fTranI > 1) = 1;
end;
return;