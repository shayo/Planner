%%
strSurfaceFile = 'D:\Data\Doris\Planner\FreeSurfer Pipeline\lh.orig.nofix';

clear all
strctVolConformedA = fnQuickAddVolume('D:\Data\Doris\Planner\FreeSurfer Pipeline\001_conformed.nii');
strctVol= fnQuickAddVolume('D:\Data\Doris\Planner\FreeSurfer Pipeline\001.nii');
a2fCRS_To_XYZ = strctVol.m_a2fReg * strctVol.m_a2fM;
a2fCRS_To_XYZ_ConformedA = strctVolConformedA.m_a2fReg * strctVolConformedA.m_a2fM;
IAc=fnResampleCrossSection(strctVolConformedA.m_a3fVol, inv(a2fCRS_To_XYZ_ConformedA), strctVolConformedA.m_strctCrossSectionCoronal);
IA=fnResampleCrossSection(strctVol.m_a3fVol, inv(a2fCRS_To_XYZ), strctVol.m_strctCrossSectionCoronal);
T =[    -1     0     0     0
     0     0    -1     0
     0     1     0     0
     0     0     0     1];
 strctMeshConformed = fnReadSurfWrapper('D:\Data\Doris\Planner\FreeSurfer Pipeline\lh.orig.nofix');
strctMeshWhiteAc = fnApplyTransformOnMesh(strctMeshConformed,T);
a2fLinesPixWhiteAc = fnMeshCrossSectionIntersection(strctMeshWhiteAc, strctVolConformedA.m_strctCrossSectionCoronal);

strctMeshWhiteA = fnApplyTransformOnMesh(strctMeshConformed, a2fCRS_To_XYZ*inv(a2fCRS_To_XYZ_ConformedA)*T);
a2fLinesPixWhiteA = fnMeshCrossSectionIntersection(strctMeshWhiteA, strctVol.m_strctCrossSectionCoronal);

figure(3);
clf;
subplot(1,2,1);
imshow(IAc,[]);
hold on;
fnPlotLinesAsSinglePatch(gca, a2fLinesPixWhiteAc, [1 0 1]); 
subplot(1,2,2);
imshow(IA,[]);
hold on;
fnPlotLinesAsSinglePatch(gca, a2fLinesPixWhiteA, [1 0 1]); 

% 
% ahHandles=fnDrawMeshIn3D(strctMeshWhiteA,gca)
% set(ahHandles,'edgecolor','none');


%%
clear all
[curv, fnum] = read_curv('D:\Data\Doris\Planner\FreeSurfer Pipeline\lh.curv');
strctVolConformedA = fnQuickAddVolume('D:\Data\Doris\Planner\FreeSurfer Pipeline\T1.mgz');

a2fCRS_To_XYZ_ConformedA = strctVolConformedA.m_a2fReg * strctVolConformedA.m_a2fM;
IA=fnResampleCrossSection(strctVolConformedA.m_a3fVol, inv(a2fCRS_To_XYZ_ConformedA), strctVolConformedA.m_strctCrossSectionCoronal);
a2fLinesPixWhiteA = fnMeshCrossSectionIntersection(strctMeshWhiteA, strctVolConformedA.m_strctCrossSectionCoronal);
%

%%
 figure(3);clf;
 subplot(1,2,1);
 imshow(IA,[]);
fnPlotLinesAsSinglePatch(gca, a2fLinesPixWhiteA, [1 0 1]); 



a2fVox2Vox = inv(strctVolConformedB.m_strctFreeSurfer.vox2ras0)*(strctVolConformedA.m_strctFreeSurfer.vox2ras0);
%strctVol = fnQuickAddVolume('D:\Data\Doris\Planner\FreeSurfer Pipeline\001.nii');
%%
a2fCRS_To_XYZ_ConformedA = strctVolConformedA.m_a2fReg * strctVolConformedA.m_a2fM;

[a2fI,a2fJ] = meshgrid(1:256,1:256);
a2fK = ones(size(a2fI))*55;
PA = [a2fI(:),a2fJ(:),a2fK(:),ones(size(a2fI(:),1),1)]';
iMode=1;
 a2fCrossSectionA = reshape(interp3fast_double(strctVolConformedA.m_a3fVol, 1+PA(2,:),1+PA(1,:),1+PA(3,:),iMode), size(a2fI));
PB=a2fVox2Vox*PA;
a2fCrossSectionB = reshape(interp3fast_double(strctVolConformedB.m_a3fVol, 1+PB(2,:),1+PB(1,:),1+PB(3,:),iMode), size(a2fI));

 subplot(1,2,2);
 imshow(a2fCrossSectionB,[]);
 
fn
strctVolConformedA.m_a3fVol(50,50,50)
strctVolConformedB.m_a3fVol(Q(1),Q(2),Q(3))
 
  [IA, apt3fPlanePoints,a2fXmm,a2fYmm,a2fXmmT,a2fYmmT,a2fZmmT,apt3fInVolMM] = fnResampleCrossSection(strctVolConformedA.m_a3fVol, inv(a2fCRS_To_XYZ_ConformedA), strctVolConformedA.m_strctCrossSectionCoronal);

figure(2);
clf;
subplot(1,2,1);
imshow(IA,[]);


%%
strctMeshWhiteConformed = fnReadSurfWrapper('D:\Data\Doris\Planner\FreeSurfer Pipeline\lh.orig.nofix');
a2fCRS_To_XYZ = strctVol.m_a2fReg * strctVol.m_a2fM;
a2fCRS_To_XYZ_Conformed = strctVolConformed.m_a2fReg * strctVolConformed.m_a2fM;

apt3fVerticesVoxels_Conformed =[strctMeshWhiteConformed.m_a2fVertices;ones(1,size(strctMeshWhiteConformed.m_a2fVertices,2))];
apt3fVertices = a2fCRS_To_XYZ*a2fVox2Vox*apt3fVerticesVoxels_Conformed;

strctMeshWhite.m_a2iFaces = strctMeshWhiteConformed.m_a2iFaces;
strctMeshWhite.m_a2fVertices = apt3fVertices(1:3,:);

a2fLinesPixWhite = fnMeshCrossSectionIntersection(strctMeshWhite, strctVol.m_strctCrossSectionCoronal);

a2fLinesPixWhiteConformed = fnMeshCrossSectionIntersection(strctMeshWhiteConformed, strctVolConformed.m_strctCrossSectionCoronal);


I=fnResampleCrossSection(strctVol.m_a3fVol, inv(a2fCRS_To_XYZ), strctVol.m_strctCrossSectionCoronal);
Ic=fnResampleCrossSection(strctVolConformed.m_a3fVol, inv(a2fCRS_To_XYZ_Conformed), strctVolConformed.m_strctCrossSectionCoronal);

figure(2);
clf;
subplot(1,2,1);
imshow(I,[]);
hold on;
ahHandles = fnPlotLinesAsSinglePatch(gca, a2fLinesPixWhite, [1 0 1]); 

subplot(1,2,2);
imshow(Ic,[]);
hold on;
ahHandles = fnPlotLinesAsSinglePatch(gca, a2fLinesPixWhiteConformed, [1 0 1]); 
%%













    
clear P P1
P.faces = 1+faces;
 P.vertices =vertex_coords;
 P1.faces = 1+faces(iFaceToHighlight,:);
 P1.vertices =vertex_coords;
 figure(3);clf;
 hold on;
    h=patch(P,'facecolor','r','facealpha',0.2,'edgecolor','none');
     h=patch(P1,'facecolor','b','facealpha',1,'edgecolor','k');
LIGHTING PHONG
camlight;  camlight(-80,-10); 
axis equal

for j=1:size(a2fLines3D,2)
    if j == iIndex
        plot3([a2fLines3D(1,j),a2fLines3D(4,j)], [a2fLines3D(2,j) a2fLines3D(5,j)],[a2fLines3D(3,j) a2fLines3D(6,j)],'g','LineWidth',2);
    else
        plot3([a2fLines3D(1,j),a2fLines3D(4,j)], [a2fLines3D(2,j) a2fLines3D(5,j)],[a2fLines3D(3,j) a2fLines3D(6,j)],'c');
    end
end


% [a2fX,a2fY] = meshgrid(-128:5:128,-128:5:128);
% a2fZ = zeros(size(a2fX));
% R=[a2fX(:),a2fY(:),a2fZ(:),ones(size(a2fX(:)))];
% r=strctVol.m_strctCrossSectionCoronal.m_a2fM * R';
% %P3=patch(r(1,:),r(2,:),r(3,:),'facecolor','c');
% plot3(r(1,:),r(2,:),r(3,:),'c.');





  L=bwlabeln(abs(strctVol.m_a3fVol - 110) < 5);
 [ f,v] = isosurface(L==22,0.5);
% Convert [i,j,k] to mm
vmm=a2fCRS_To_XYZ * [v'; ones(1,size(v,1))];
clear P
P.faces = f;
 P.vertices = vmm(1:3,:)';
 Psmall=reducepatch(P,0.1);
 figure(3);clf;
 hold on;
    h=patch(Psmall,'facecolor','r','facealpha',0.2,'edgecolor','none');
LIGHTING PHONG
camlight;  camlight(-80,-10); 
axis equal

afLengthMM=sqrt(sum((a2fLines3D(1:3,:)-a2fLines3D(4:6,:)).^2,1));
figure;plot(afLengthMM)

for j=1:size(a2fLines3D,2)
    plot3([a2fLines3D(1,j),a2fLines3D(4,j)], [a2fLines3D(2,j) a2fLines3D(5,j)],[a2fLines3D(3,j) a2fLines3D(6,j)],'c');
end

Q.faces = 1+faces;
 Q.vertices = vertex_coords;
  hold on;
h=patch(Q);
 set(h,'EdgeColor','none','FaceColor','g','facealpha',0.2);
 
% Draw the cross section
[a2fX,a2fY] = meshgrid(-128:128,-128:128);
a2fZ = zeros(size(a2fX));
R=[a2fX(:),a2fY(:),a2fZ(:),ones(size(a2fX(:)))];
r=strctVol.m_strctCrossSectionCoronal.m_a2fM * R';
% plot3(r(1,:),r(2,:),r(3,:),'c.');
 ahHandles = fnPlotLinesAsSinglePatch(gca, a2fLinesMM, [1 0 1]); 
 
% Overlay surface and volume slice.
%%
%   -60.9048  -89.1676  -21.7569
%     0.8429   56.9045   73.7499



%%

 iNumVertices=size(vertex_coords,1);
N = 100;
a2fJet = gray(N);
fScale = (max(curv(:))-min(curv(:)))/2;
curv_rescaled = min(N,max(1,1+(N-1)* (curv-min(curv(:))) / fScale));  % 1..N
R=interp1(a2fJet(:,1),curv_rescaled);
G=interp1(a2fJet(:,2),curv_rescaled);
B=interp1(a2fJet(:,3),curv_rescaled);
a2fColors =  [R,G,B];
clear P
P.faces = 1+faces;
 P.vertices = vertex_coords;
 figure(3);clf;
 hold on;
h=patch(P);
 set(h,'EdgeColor','none', 'FaceVertexCData',a2fColors,'FaceColor','interp','facealpha',0.1);
 axis equal

 P2.faces = 1+faces(880,:);
 P2.vertices = vertex_coords;
h2=patch(P2,'facecolor','r');

%%
