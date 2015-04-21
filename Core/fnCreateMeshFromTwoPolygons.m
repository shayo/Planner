function strctMesh= fnCreateMeshFromTwoPolygons(apt2fUpVertices, apt2fDownVertices, afColor)
% Generates a triangular mesh from a polygon that has the same number of
% vertices on the upper and lower planes.
% Inputs:
% apt2fUpVertices, apt2fDownVertices - Nx3
iNumVertices = size(apt2fUpVertices,1);

iNumTriangles = 2*(iNumVertices-1);
strctMesh.m_a2fVertices = [apt2fDownVertices;apt2fUpVertices]';
strctMesh.m_a2iFaces = zeros(3, iNumTriangles);
strctMesh.m_afColor = afColor;
strctMesh.m_fOpacity = 0.6;
for k=1:iNumVertices-1
    strctMesh.m_a2iFaces(:,2*(k-1)+1) = [k, k+iNumVertices,k+iNumVertices+1];
    strctMesh.m_a2iFaces(:,2*(k-1)+2) = [k+iNumVertices+1, k,k+1];
end;

% A.vertices = strctMesh.m_a2fVertices'; A.faces = strctMesh.m_a2iFaces'; 
% figure(10);clf;patch(A,'facecolor','r','edgecolor','b')
return;