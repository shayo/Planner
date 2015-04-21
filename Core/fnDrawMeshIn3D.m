function ahHandles = fnDrawMeshIn3D(astrctMesh,hAxes)
iNumMeshes = length(astrctMesh);
ahHandles = zeros(1,iNumMeshes);
for iMeshIter=1:iNumMeshes

    A.vertices =  astrctMesh(iMeshIter).m_a2fVertices(1:3,:)';
    A.faces = astrctMesh(iMeshIter).m_a2iFaces';
    ahHandles(iMeshIter) = patch(A,'facecolor',astrctMesh(iMeshIter).m_afColor,...
        'FaceAlpha',astrctMesh(iMeshIter).m_fOpacity,...
        'parent',hAxes);
end
return;