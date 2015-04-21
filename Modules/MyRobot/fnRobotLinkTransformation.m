function a2fT = fnRobotLinkTransformation(afLinkDH, fValue)
% Construct the Denavit-Hartenberg transformation
% Tn = Trans Zn-1(dn) * Rot Zn-1 (ThetaN) * Rot Xn (AlphaN)
% Where:
% Trans zn-1 = [1,0,0,0; 0,1,0,0;,0,0,1,dn; 0,0,0,1];
% Rot Zn-1 = [ct, -st, 0,0; st, ct,0,0; 0,0,1,0;0,0,0,1];
% Trans Xn(rn) = [1,0,0,rn; 0,1,0,0;0,0,1,0;,0,0,0,1];
% Rot Xn(alphan) = [1,0,0,0;0,ct,-st,0;0,st,ct,0;0,0,0,1];
fValueWithOffset = fValue + afLinkDH(6);
fAlpha = afLinkDH(1);
fAlphaN = afLinkDH(2);
if afLinkDH(5) == 0 % Rotatory
    fTheta = fValueWithOffset;
    fDn = afLinkDH(4);
else		% prismatic
    fTheta = afLinkDH(3);
    fDn = fValueWithOffset;
end

fSinAlpha = sin(fAlpha); 
fCosAlpha = cos(fAlpha);
fSinTheta = sin(fTheta); 
fCosTheta = cos(fTheta);

a2fT = [fCosTheta,	-fSinTheta*fCosAlpha, fSinTheta*fSinAlpha,   fAlphaN*fCosTheta;
        fSinTheta,   fCosTheta*fCosAlpha, -fCosTheta*fSinAlpha,  fAlphaN*fSinTheta;
        0        ,   fSinAlpha	        , fCosAlpha	          ,  fDn;
        0        ,   0                  , 0                   , 1];
    
return;
