addpath('D:\Code\Doris\MRI\Planning\MEX');
afplane = [0 0.3 1 0];
afplane(1:3) = afplane(1:3)/norm(afplane);
vertices = [0 0 1;
            0 6 0;
            -1 2 1.5];
faces = [1
         2
         3];
lines = fndllMeshPlaneIntersect(afplane, vertices,faces);

figure(1);
clf;
[a2fX,a2fY] = meshgrid(-5:5,-5:5);
a2fZ = (a2fX*afplane(1) +a2fY*afplane(2) + afplane(4))/-afplane(3);
mesh(a2fX,a2fY,a2fZ);
hold on;

A.vertices = vertices';
A.faces = faces';
patch(A,'facecolor','r')
for k=1:size(lines,2)
    plot3([lines(1,k) lines(4,k)],...
           [lines(2,k) lines(5,k)],...
           [lines(3,k) lines(6,k)],'b','LineWidth',2);
end;
  