function [abROIHit, abHitFaces]= fnProjectROIToSurface(strctMesh, afThicknessMM, a3bROI, a2fXYA_To_IJK)
[a2fVerticesNormals, a2fTriangleNormals] = fnGetMeshNormals(strctMesh);
iNumVertices = size(strctMesh.m_a2fVertices,2);
iNumFaces = size(strctMesh.m_a2iFaces,2);
abROIHit = zeros(1,iNumVertices);
for iVertexIter=1:iNumVertices
    if mod(iVertexIter,10000)==0
        fprintf('%.1f%% ',iVertexIter/iNumVertices*1e2);
    end;
    afLine = 0:0.1: afThicknessMM(iVertexIter);
    % Build the coordinates to sample.
    apt3fLineMM = [strctMesh.m_a2fVertices(1,iVertexIter) + a2fVerticesNormals(1,iVertexIter) * afLine;
                                 strctMesh.m_a2fVertices(2,iVertexIter) + a2fVerticesNormals(2,iVertexIter) * afLine;       
                                 strctMesh.m_a2fVertices(3,iVertexIter) + a2fVerticesNormals(3,iVertexIter) * afLine];
    apt3fLineVox = a2fXYA_To_IJK * [apt3fLineMM;ones(1,size(apt3fLineMM,2))];
    % Resample bilinear interpolation
    afValues = fndllFastInterp3(a3bROI, 1+apt3fLineVox(1,:),1+apt3fLineVox(2,:),1+apt3fLineVox(3,:));
    abROIHit(iVertexIter) = sum(afValues>0.5)>0;
end
aiRelevantVertices = find(abROIHit);
fprintf('Done!\n');
abHitFaces = ismember(strctMesh.m_a2iFaces(1,:),aiRelevantVertices) | ismember(strctMesh.m_a2iFaces(2,:),aiRelevantVertices) | ismember(strctMesh.m_a2iFaces(3,:),aiRelevantVertices);
