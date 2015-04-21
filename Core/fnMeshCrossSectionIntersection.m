function [a2fLinesPix,a2fLines3D,aiFaces] = fnMeshCrossSectionIntersection(strctMesh, strctCrossSection)
% Finds the intersection between a triangular mesh model and a cross
% section (cropped plane).
% strctMesh.m_a2fVertices - 3 X N [x,y,z]
% strctMesh.m_a2iFaces - 3 x M [triangle vertices indices]
% 
% Returns:
% a2fLinesPix - Q x 4 (Q is the number of lines on the cross-section)
%
afPlane = [strctCrossSection.m_a2fM(1:3,3); -strctCrossSection.m_a2fM(1:3,3)' * strctCrossSection.m_a2fM(1:3,4);];

[a2fLines3D,aiFaces] = fndllMeshPlaneIntersect(afPlane, ...
    strctMesh.m_a2fVertices,strctMesh.m_a2iFaces);

if isempty(a2fLines3D)
    a2fLinesPix = [];
    return;
end;

% Rotate coordinates back to [0,0,1] plane
iNumLines = size(a2fLines3D,2);
apt2fP1_XYZ = [a2fLines3D(1:3,:); ones(1,iNumLines)];
apt2fP2_XYZ = [a2fLines3D(4:6,:); ones(1,iNumLines)];

Tmp = inv(strctCrossSection.m_a2fM) * apt2fP1_XYZ;
apt2fP1 = Tmp(1:2,:);
Tmp = inv(strctCrossSection.m_a2fM) * apt2fP2_XYZ;
apt2fP2= Tmp(1:2,:);

[afX0, afX1, afY0, afY1, abIntersect] = fndllCohenSutherland(...
    apt2fP1(1,:), apt2fP2(1,:), apt2fP1(2,:), apt2fP2(2,:),...
    -strctCrossSection.m_fHalfWidthMM,strctCrossSection.m_fHalfWidthMM,...
    -strctCrossSection.m_fHalfHeightMM,strctCrossSection.m_fHalfHeightMM);

a2fLinesMM = [afX0(abIntersect)', afY0(abIntersect)',afX1(abIntersect)', afY1(abIntersect)'];

if sum(abIntersect) == 0
    a2fLinesPix =  [];
else
% Map to pixel values
a2fLinesPix = [fnCrossSection_MM_To_Image(strctCrossSection,[afX0(abIntersect)', afY0(abIntersect)']),...
               fnCrossSection_MM_To_Image(strctCrossSection,[afX1(abIntersect)', afY1(abIntersect)'])];
end

% 
% a2fLinesPix = [...
% (afX0(abIntersect)' - (-strctCrossSection.m_fHalfWidthMM)) / (2*strctCrossSection.m_fHalfWidthMM) * (strctCrossSection.m_iResWidth-1) + 1,...
% (afY0(abIntersect)' - (-strctCrossSection.m_fHalfHeightMM)) / (2*strctCrossSection.m_fHalfHeightMM) * (strctCrossSection.m_iResHeight-1) + 1,...
% (afX1(abIntersect)' - (-strctCrossSection.m_fHalfWidthMM)) / (2*strctCrossSection.m_fHalfWidthMM) * (strctCrossSection.m_iResWidth-1) + 1,...
% (afY1(abIntersect)' - (-strctCrossSection.m_fHalfHeightMM)) / (2*strctCrossSection.m_fHalfHeightMM) * (strctCrossSection.m_iResHeight-1) + 1];

return;

% 
% 
% 
% [a2fX,a2fY] = meshgrid(-strctCrossSection.m_fHalfWidthMM:strctCrossSection.m_fHalfWidthMM,...
%                        -strctCrossSection.m_fHalfHeightMM:strctCrossSection.m_fHalfHeightMM);
% 
% a2fZ = (a2fX*afPlane(1) +a2fY*afPlane(2) + afPlane(4))/-afPlane(3);
% figure(10);
% clf;
% % surf(a2fX,a2fY,a2fZ);
% hold on;
% A.vertices = strctMesh.m_a2fVertices'; A.faces = strctMesh.m_a2iFaces'; 
% patch(A,'facecolor','none','edgecolor','b')
% for k=1:size(a2fLines3D,2)
%     plot3([a2fLines3D(1,k) a2fLines3D(4,k)], [a2fLines3D(2,k) a2fLines3D(5,k)],[a2fLines3D(3,k) a2fLines3D(6,k)],'c');
% end;
% 
% figure(5);
% clf;
% hold on;
% for k=1:size(apt2fP1,2)
% plot([apt2fP1(1,k) apt2fP2(1,k)],[apt2fP1(2,k) apt2fP2(2,k)],'b');
% end;
% 
% plot([-strctCrossSection.m_fHalfWidthMM -strctCrossSection.m_fHalfWidthMM],...
%      [-strctCrossSection.m_fHalfHeightMM strctCrossSection.m_fHalfHeightMM],'g');
% plot([-strctCrossSection.m_fHalfWidthMM strctCrossSection.m_fHalfWidthMM],...
%      [-strctCrossSection.m_fHalfHeightMM -strctCrossSection.m_fHalfHeightMM],'g');
% plot([strctCrossSection.m_fHalfWidthMM strctCrossSection.m_fHalfWidthMM],...
%      [-strctCrossSection.m_fHalfHeightMM strctCrossSection.m_fHalfHeightMM],'g');
% plot([-strctCrossSection.m_fHalfWidthMM strctCrossSection.m_fHalfWidthMM],...
%      [strctCrossSection.m_fHalfHeightMM strctCrossSection.m_fHalfHeightMM],'g');
%  
% axis equal
%  
% 
%  % Remap to pixel values
% for k=1:size(apt2fP1,2)
%     if abIntersect(k)
%         plot([afX0(k) afX1(k)],[afY0(k) afY1(k)],'r');
%     end;
% end;
