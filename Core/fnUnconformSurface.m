function fnUnconformSurface(strSurfaceFileConformed, strSurfaceFileUnconformed)
[vertex_coords, faces] = read_surf(strSurfaceFileConformed);
a2fTrans = fnGetUnconformTransformation();
 iNumVertices = size(vertex_coords,1);
verticesTransformed =  a2fTrans* [vertex_coords, ones(iNumVertices,1)]';
vertex_coords = verticesTransformed(1:3,:)';
write_surf(strSurfaceFileUnconformed, vertex_coords, faces);
return;
