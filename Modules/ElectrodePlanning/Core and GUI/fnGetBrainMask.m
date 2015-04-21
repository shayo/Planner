function a3bBrainMask=fnGetBrainMask()
global g_strctModule

if ~isfield(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol},'m_a2fAtlasReg')
    g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fAtlasReg = eye(4);
end;

iMetaRegionAll = 1;
P = [g_strctModule.m_strctAtlas.m_astrctMesh(iMetaRegionAll).vertices'; ...
    ones(1,size(g_strctModule.m_strctAtlas.m_astrctMesh(iMetaRegionAll).vertices,1))];
Pmm = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fAtlasReg * P;
 a2fXYZ_To_CRS = inv(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fM) * inv(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fReg);

% Convert back to CRS...
Pcrs = a2fXYZ_To_CRS* Pmm;
% Compute convex hull....
X = Pcrs(1:3,:)';
K=convhulln(X);
% binarize the convex hull somehow....
iNumSlices = size(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a3fVol,3);
a3bBrainMask = zeros(size(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a3fVol),'uint8')>0;
strctMeshConvexHull.m_a2fVertices = X';
strctMeshConvexHull.m_a2iFaces = K';
for iSliceIter=1:iNumSlices
    % construct a cross section for "Z = iSliceIter"
    strctCrossSection.m_a2fM = eye(4);
    strctCrossSection.m_a2fM(3,4) = iSliceIter;
    afPlane = [strctCrossSection.m_a2fM(1:3,3); -strctCrossSection.m_a2fM(1:3,3)' * strctCrossSection.m_a2fM(1:3,4);];
    a2bSlice = zeros(size(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a3fVol,1),size(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a3fVol,2))>0;
    a2fLines3D = fndllMeshPlaneIntersect(afPlane, strctMeshConvexHull.m_a2fVertices,strctMeshConvexHull.m_a2iFaces);
    if ~isempty(a2fLines3D)
        x=[a2fLines3D(1,:),a2fLines3D(4,:)];
        y=[a2fLines3D(2,:),a2fLines3D(5,:)];
        K2=convhull(x,y);
        a2bSliceWithPoly = roipoly(a2bSlice,x(K2),y(K2));
        a3bBrainMask(:,:,iSliceIter) = a2bSliceWithPoly;
    end
end
return;
