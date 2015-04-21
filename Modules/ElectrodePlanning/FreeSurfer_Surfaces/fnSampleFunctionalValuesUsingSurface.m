function fnSampleFunctionalValuesUsingSurface(strWhiteMatterSurface, strThicknessFile, fThicknessFraction, strGraySurface)
 % Basically, we need to dilate the original surface by a fraction of the
 % thickness
 % But we want to keep the same number of vertics so we could later use the
 % inflated version of the white matter surface / flat map
 
 strWhiteMatterSurface = 'D:\Data\Doris\Planner\FreeSurfer Pipeline\lh.white';
 strThicknessFile = 'D:\Data\Doris\Planner\FreeSurfer Pipeline\lh.thickness';
 strGraySurface = 'D:\Data\Doris\Planner\FreeSurfer Pipeline\lh.gray';
 fThicknessFraction = 0.5;
 
 [v,f]=read_surf(strWhiteMatterSurface);
 t=read_curv(strThicknessFile);
 % Compute triangle normals...
 V1 = v(1+f(:,1),:);
 V2 = v(1+f(:,2),:);
 V3 = v(1+f(:,3),:);
 
Tmp =  fnCross3(V2-V1, V3-V2);
TriangleNormals = Tmp./repmat(sqrt(sum(Tmp.^2,2)),1,3);

iNumVertices = size(v,1);
iNumFaces = size(f,1);
a2fVerticesShift = zeros(3, iNumVertices); 
aiCount = zeros(1,iNumVertices);

for iFaceIter=1:iNumFaces
    aiCount(1+f(iFaceIter,:)) = aiCount(1+f(iFaceIter,:)) + 1;
    a2fVerticesShift(:,     1+f(iFaceIter,1)) = a2fVerticesShift(:,     1+f(iFaceIter,1)) +  TriangleNormals(iFaceIter,:)';
    a2fVerticesShift(:,     1+f(iFaceIter,2)) = a2fVerticesShift(:,     1+f(iFaceIter,2)) +  TriangleNormals(iFaceIter,:)';
    a2fVerticesShift(:,     1+f(iFaceIter,3)) = a2fVerticesShift(:,     1+f(iFaceIter,3)) +  TriangleNormals(iFaceIter,:)';
end
a2fVerticesShiftAvg = a2fVerticesShift ./ repmat(aiCount,3,1);
a2fVerticesShiftNorm = a2fVerticesShiftAvg ./ repmat(sqrt(sum(a2fVerticesShiftAvg.^2,1)),3,1);

vnew=v+a2fVerticesShiftNorm' .* [t,t,t];
write_surf(strGraySurface,vnew,f);

return;


