function [aiIntersectingTriangles, apt3fIntersectionPoints,afDistanceFromP0] = fnMeshLineIntersection(strctMesh, P0,Dir)
% Iterate over triangles.
% per triangle, build the plane and check for plane-line intersection
% (always exist). Check that the intersection point is inside the
% triangle...
iNumFaces = size(strctMesh.m_a2iFaces,2);
[a2fVerticesNormals, a2fTriangleNormals] = fnGetMeshNormals(strctMesh);

abInside = zeros(1,iNumFaces)>0;
apt3fIntersectionPoints = zeros(3,iNumFaces);
afDistanceFromP0 = zeros(1,iNumFaces);
for iFaceIter=1:iNumFaces
% Use triangle normal as the plane normal...
% Take one vertex to find "D"
apt3fTriangle = strctMesh.m_a2fVertices(:, strctMesh.m_a2iFaces(:,iFaceIter));
D=-sum(a2fTriangleNormals(iFaceIter,:) .* apt3fTriangle(:,1)');
% Now, find the line plane intersection
t=(-D-sum(a2fTriangleNormals(iFaceIter,:).*P0(:)')) / sum(a2fTriangleNormals(iFaceIter,:).*Dir(:)');
afDistanceFromP0(iFaceIter) = t;
apt3fIntersectionPoints(:,iFaceIter) = P0+t*Dir;
abInside(iFaceIter) = fnPointInTriangle(apt3fIntersectionPoints(:,iFaceIter)', apt3fTriangle(:,1)',apt3fTriangle(:,2)',apt3fTriangle(:,3)');
% Is this inside the triangle?
end
aiIntersectingTriangles=find(abInside);
apt3fIntersectionPoints=apt3fIntersectionPoints(:,abInside);
afDistanceFromP0 = afDistanceFromP0(abInside);

return;



function bSameSide = fnSameSide(p1,p2, a,b)
cp1 = fnCross3(b-a, p1-a);
cp2 = fnCross3(b-a, p2-a);
bSameSide =  dot(cp1, cp2) >= 0 ;
return;
    

function bInside = fnPointInTriangle(p, a,b,c)
    bInside = fnSameSide(p,a, b,c) && fnSameSide(p,b, a,c)&&fnSameSide(p,c, a,b);
    return;
    
