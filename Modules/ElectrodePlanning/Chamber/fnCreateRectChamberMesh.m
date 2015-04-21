function astrctMesh= fnCreateRectChamberMesh(fWidthMM, fHeightMM,fDepthMM,afColor)
% creates a bunch of triangles that correspond to a box (without the top
% and bottom faces, and with an inside edge to indicate the direction...
% 
% fWidthMM = 20;
% fHeightMM = 40;
% fDepthMM = 0;
% afColor = [1 0 1];


% add the inner edge

strctMesh.m_a2fVertices= [0, 0, 0;
                          0, +fWidthMM/2, 0;
                          0, 0, -fHeightMM;
                          0, +fWidthMM/2, -fHeightMM]';
                          
strctMesh.m_a2iFaces = [1, 3;
                        2, 4;
                        3, 2];
strctMesh.m_afColor = [0 1 1];
strctMesh.m_fOpacity = 0.4;

astrctMesh(1) = strctMesh;

astrctMesh(2) = fnCreateRectChamberMeshAux(fWidthMM, -fHeightMM, 0, afColor);

if fDepthMM > 0
    astrctMesh(3) = fnCreateRectChamberMeshAux(fWidthMM, -fHeightMM, -fHeightMM-fDepthMM, afColor*0.5);
end
% 
% a2fT = eye(4);
% a2fT(1:2,1:2) =  [cos(fOffset/180*pi), -sin(fOffset/180*pi);
%                    sin(fOffset/180*pi),cos(fOffset/180*pi)];
% 
% Tmp = a2fT * [a2fVertices;ones(1,size(a2fVertices,2))];
% 
% strctMesh.m_a2fVertices=Tmp(1:3,:);
% strctMesh.m_a2iFaces = zeros(3, iNumTriangles);
% strctMesh.m_afColor = afColor;
% for k=1:iQuat-1
%     strctMesh.m_a2iFaces(:,2*(k-1)+1) = [k, k+iQuat,k+iQuat+1];
%     strctMesh.m_a2iFaces(:,2*(k-1)+2) = [k+iQuat+1, k,k+1];
% end;
% 
% strctMesh.m_fOpacity = 0.4;
% astrctMesh(1) = strctMesh;
% 
%   A.vertices = strctMesh.m_a2fVertices;
%   A.faces = strctMesh.m_a2iFaces(:,1:8)'; 
%   figure(10);clf;patch(A,'facecolor','r','edgecolor','b')
%  axis equal
 %%
return;



function strctMesh = fnCreateRectChamberMeshAux(fWidthMM, fLowZ, fHighZ, afColor)
strctMesh.m_a2fVertices= [-fWidthMM/2, -fWidthMM/2, fLowZ;
                          -fWidthMM/2, +fWidthMM/2, fLowZ;
                          +fWidthMM/2, -fWidthMM/2, fLowZ;
                          +fWidthMM/2, +fWidthMM/2, fLowZ;
                          -fWidthMM/2, -fWidthMM/2, fHighZ;
                          -fWidthMM/2, +fWidthMM/2, fHighZ;
                          +fWidthMM/2, -fWidthMM/2, fHighZ;
                          +fWidthMM/2, +fWidthMM/2, fHighZ]';
                          
strctMesh.m_a2iFaces = [1, 1, 1, 3, 3, 3, 2, 4;
                        2, 6, 3, 5, 8, 4, 4, 6;
                        6, 5, 5, 7, 7, 8, 6, 8];
strctMesh.m_afColor = afColor;
strctMesh.m_fOpacity = 0.4;
return;
