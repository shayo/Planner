
function a3fCrossSection = fnOverlayBlood(a3fCrossSection,a2bBlood)
for k=2:3
    A=a3fCrossSection(:,:,k);
    A(a2bBlood) = (double(k == 3) || double(k == 2));
    a3fCrossSection(:,:,k) = A;
end
return;