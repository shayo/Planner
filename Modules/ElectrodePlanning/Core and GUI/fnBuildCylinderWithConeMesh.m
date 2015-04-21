function strctMesh = fnBuildCylinderWithConeMesh(fCylinderDiameterMM,fCylinderHeightMM,fConeHeightMM,afColor)
if ~exist('afColor','var')
    afColor = [1 0 0];
end
% Build a cylinder attached to a cone. Tip is at [0,0,0]
% 
% fCylinderDiameterMM = 8;
% fCylinderHeightMM = 15;
% fConeHeightMM = 20;
%fConeAngleDeg = atan( (fCylinderDiameterMM/2) / fConeHeightMM)/pi*180;

% First, build the cone.
iQuant = 20;
% Generate a circle.
afAngles = linspace(0,2*pi,iQuant);
afX = cos(afAngles) * fCylinderDiameterMM/2;
afY = sin(afAngles) * fCylinderDiameterMM/2;
% Generate vertices for cone.

apt3fVertices = [0,afX,afX,0,0;
                 0,afY,afY,0,0;
                 0,ones(1,iQuant)*fConeHeightMM,ones(1,iQuant)*(fConeHeightMM+fCylinderHeightMM),fConeHeightMM,(fConeHeightMM+fCylinderHeightMM)];
a2iEdges = zeros(4*iQuant-3,3);
% Build edges.
clear a2iEdges
for i=1:iQuant
    if i==iQuant
        a2iEdges(i,:) = [1 i 2];
    else
        a2iEdges(i,:) = [1 i i+1];
    end
end
for i=1:iQuant
    a2iEdges(iQuant+i,:) = [1+i 2+i 1+iQuant+i];
end
for i=1:iQuant-1
    a2iEdges(2*iQuant+i,:) = [1+iQuant+i 2+iQuant+i 2+i];
end
for i=1:iQuant-1
    a2iEdges(2*iQuant+i,:) = [1+iQuant+i 2+iQuant+i 2+i];
end
 for i=1:iQuant-1
     a2iEdges(3*iQuant+i-1,:) = [1+i 2+i 2+2*iQuant];
 end
 for i=1:iQuant-1
     a2iEdges(4*iQuant+i-2,:) = [1+i+iQuant 2+i+iQuant 2+2*iQuant+1];
 end
 
strctMesh.m_a2fVertices  = apt3fVertices;
strctMesh.m_a2iFaces = a2iEdges';
strctMesh.m_afColor = afColor;        
strctMesh.m_fOpacity = 0.6;
 
% strctSurface.Vertices = apt3fVertices';
% strctSurface.Faces = a2iEdges;
% figure(11);
% clf;
% patch(strctSurface,'facecolor','r');
% axis equal
% 
%     
% 
% 
