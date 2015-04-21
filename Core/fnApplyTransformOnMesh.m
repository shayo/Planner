function astrctMesh= fnApplyTransformOnMesh(astrctMesh, a2fT)
for k=1:length(astrctMesh)
    Tmp = a2fT*[astrctMesh(k).m_a2fVertices; ones(1,size(astrctMesh(k).m_a2fVertices,2))];
    astrctMesh(k).m_a2fVertices = Tmp(1:3,:);
end;
return;