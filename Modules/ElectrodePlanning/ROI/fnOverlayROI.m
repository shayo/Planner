function a3fCrossSection = fnOverlayROI(a3fCrossSection,a2bROI)
for k=1:3
    A=a3fCrossSection(:,:,k);
    A(a2bROI) = (double(k ==3) || double(k == 2));
    a3fCrossSection(:,:,k) = A;
end
return;