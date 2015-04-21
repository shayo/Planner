function strctMesh= fnCreateChamberMesh(fDiameterMM, fZdepthDown0,fZdepthDownPi,fZdepthUp, iQuat,afColor)
fRadius = fDiameterMM/2;
afAngles = linspace(0,2*pi, iQuat);
afX = cos(afAngles) * fRadius;
afY = sin(afAngles) * fRadius;
afOnes = ones(1,iQuat) ;

apt2fUpVertices = [afX;afY;afOnes*fZdepthUp];

afTheta = 0:360;
afDecrease = fZdepthDown0 + [0:180]/180 * (fZdepthDownPi-fZdepthDown0);
afIncrease = fZdepthDownPi + [1:180]/180 * (fZdepthDown0-fZdepthDownPi);
afProfile = [afDecrease,afIncrease];
afZHeight = interp1(afTheta, afProfile,afAngles/pi*180); % + Correction...?
apt2fDownVertices     = [afX;afY;afZHeight];

iNumTriangles = 2*(iQuat-1);
a2fVertices = [apt2fDownVertices,apt2fUpVertices];

% Rotate Vertices by pi/2
fOffset = 90;
a2fT = eye(4);
a2fT(1:2,1:2) =  [cos(fOffset/180*pi), -sin(fOffset/180*pi);
                   sin(fOffset/180*pi),cos(fOffset/180*pi)];

Tmp = a2fT * [a2fVertices;ones(1,size(a2fVertices,2))];

strctMesh.m_a2fVertices=Tmp(1:3,:);
strctMesh.m_a2iFaces = zeros(3, iNumTriangles);
strctMesh.m_afColor = afColor;
for k=1:iQuat-1
    strctMesh.m_a2iFaces(:,2*(k-1)+1) = [k, k+iQuat,k+iQuat+1];
    strctMesh.m_a2iFaces(:,2*(k-1)+2) = [k+iQuat+1, k,k+1];
end;

strctMesh.m_fOpacity = 0.4;

%  A.vertices = strctMesh.m_a2fVertices'; A.faces = strctMesh.m_a2iFaces'; 
%  figure(10);clf;patch(A,'facecolor','r','edgecolor','b')
% axis equal
return;