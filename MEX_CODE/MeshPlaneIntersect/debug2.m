load('Y:\DebugMeshPlaneIntersect.mat');
addpath('Y:\MEX\Win_x64');
[a2fLines3D, aiFace] = fndllMeshPlaneIntersect(afPlane,  strctMesh.m_a2fVertices,strctMesh.m_a2iFaces);
afLengthMM=sqrt(sum((a2fLines3D(1:3,:)-a2fLines3D(4:6,:)).^2,1));
[fMax,iDummyIndex]=max(afLengthMM)
aiFace(iDummyIndex)


P.faces = 1+strctMesh.m_a2iFaces;
P.vertices = strctMesh.m_a2fVertices';
figure(3);
clf;
    h=patch(P,'facecolor','b','facealpha',0.2,'edgecolor','none');
LIGHTING PHONG
camlight;  camlight(-80,-10); 
axis equal

figure(11);
clf;
hold on;
for j=1:size(a2fLines3D,2)
    plot3([a2fLines3D(1,j),a2fLines3D(4,j)], [a2fLines3D(2,j) a2fLines3D(5,j)],[a2fLines3D(3,j) a2fLines3D(6,j)],'c');
end
axis equal

V1=strctMesh.m_a2fVertices(:,v(1));
V2=strctMesh.m_a2fVertices(:,v(2));
V3=strctMesh.m_a2fVertices(:,v(3));

figure(11);
clf;hold on;
plot3([V1(1) V2(1)],[V1(2) V2(2)],[V1(3) V2(3)]);
plot3([V2(1) V3(1)],[V2(2) V3(2)],[V2(3) V3(3)]);
plot3([V1(1) V3(1)],[V1(2) V3(2)],[V1(3) V3(3)]);


plot3([a2fLines3D(1,880),a2fLines3D(4,880)],[a2fLines3D(2,880),a2fLines3D(5,880)],[a2fLines3D(3,880),a2fLines3D(6,880)],'r');


afLengthMM=sqrt(sum((a2fLines3D(1:3,880)-a2fLines3D(4:6,880)).^2,1));

v=strctMesh.m_a2iFaces(:,120226);
% Face=120226 -> generates segment 880

afLengthMM=sqrt(sum((a2fLines3D(1:3,:)-a2fLines3D(4:6,:)).^2,1));
afLengthMM(880)
figure;plot(afLengthMM)