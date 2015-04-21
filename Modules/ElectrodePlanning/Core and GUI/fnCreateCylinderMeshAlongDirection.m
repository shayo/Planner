function strctMesh= fnCreateCylinderMeshAlongDirection(fDiameterMM, fZdepthDown,fZdepthUp, iQuat,afColor)
% Generates a 3D clyinder of diameter fDiameterMM, at depth range
% fZdepthDown to fZdepthUp, with a given circle quantization and color
fRadius = fDiameterMM/2;
afAngles = linspace(0,2*pi, iQuat);
afX = cos(afAngles) * fRadius;
afY = sin(afAngles) * fRadius;
afOnes = ones(1,iQuat) ;

apt2fUpVertices = [afX;afY;afOnes*fZdepthUp];
apt2fDownVertices     = [afX;afY;afOnes*fZdepthDown];

iNumTriangles = 2*(iQuat-1);
strctMesh.m_a2fVertices = [apt2fDownVertices,apt2fUpVertices];
strctMesh.m_a2iFaces = zeros(3, iNumTriangles);
strctMesh.m_afColor = afColor;
strctMesh.m_fOpacity = 0.6;

for k=1:iQuat-1
    strctMesh.m_a2iFaces(:,2*(k-1)+1) = [k, k+iQuat,k+iQuat+1];
    strctMesh.m_a2iFaces(:,2*(k-1)+2) = [k+iQuat+1, k,k+1];
end;

% A.vertices = strctMesh.m_a2fVertices'; A.faces = strctMesh.m_a2iFaces'; 
% figure(10);clf;patch(A,'facecolor','r','edgecolor','b')
return;