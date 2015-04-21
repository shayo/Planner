function [a2fVerticesNormals, a2fTriangleNormals] = fnGetMeshNormals(strctMesh)
% 1 Compute Triangle Normals
iNumFaces= size(strctMesh.m_a2iFaces,2);
iNumVertices = size(strctMesh.m_a2fVertices,2);
 V1 = strctMesh.m_a2fVertices(:,strctMesh.m_a2iFaces(1,:))';
 V2 = strctMesh.m_a2fVertices(:,strctMesh.m_a2iFaces(2,:))';
 V3 = strctMesh.m_a2fVertices(:,strctMesh.m_a2iFaces(3,:))';
Tmp =  fnCross3(V2-V1, V3-V2);
a2fTriangleNormals = Tmp./repmat(sqrt(sum(Tmp.^2,2)),1,3);

% 2 Compute Vertices Normals
a2fVerticesShift = zeros(3, iNumVertices);
aiCount = zeros(1,iNumVertices);
for iFaceIter=1:iNumFaces
    aiCount(strctMesh.m_a2iFaces(:,iFaceIter)) = aiCount(strctMesh.m_a2iFaces(:,iFaceIter)) + 1;
    
    a2fVerticesShift(:,    strctMesh.m_a2iFaces(1,iFaceIter)) =a2fVerticesShift(:,    strctMesh.m_a2iFaces(1,iFaceIter))  +  a2fTriangleNormals(iFaceIter,:)';
    a2fVerticesShift(:,    strctMesh.m_a2iFaces(2,iFaceIter)) =a2fVerticesShift(:,    strctMesh.m_a2iFaces(2,iFaceIter)) +  a2fTriangleNormals(iFaceIter,:)';
    a2fVerticesShift(:,    strctMesh.m_a2iFaces(3,iFaceIter)) = a2fVerticesShift(:,    strctMesh.m_a2iFaces(3,iFaceIter)) +  a2fTriangleNormals(iFaceIter,:)';
end
a2fVerticesShiftAvg = a2fVerticesShift ./ repmat(aiCount,3,1);
a2fVerticesNormals = a2fVerticesShiftAvg ./ repmat(sqrt(sum(a2fVerticesShiftAvg.^2,1)),3,1);
