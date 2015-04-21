function strctMesh = fnReadSurfWrapper(strSurfFile ,bApplyUnconform)
[vertex_coords, faces] = read_surf(strSurfFile);
if bApplyUnconform
    a2fTrans = fnGetUnconformTransformation();
     iNumVertices = size(vertex_coords,1);
    verticesTransformed =  a2fTrans* [vertex_coords, ones(iNumVertices,1)]';
    vertex_coords = verticesTransformed(1:3,:)';
end
[strP,strF,strExt]=fileparts(strSurfFile);
strctMesh.m_strFileName = strSurfFile;
strctMesh.m_bUnconformed= bApplyUnconform;
strctMesh.m_bVisible2D = true;
strctMesh.m_bVisible3D = true;
strctMesh.m_strName= [strF,strExt];
strctMesh.m_a2fVertices = vertex_coords';
strctMesh.m_a2iFaces =1+faces';
strctMesh.m_afColor = [0 1 0];
strctMesh.m_fOpacity =0.5;
strctMesh.m_acDerivedSurfaces = [];
return;

