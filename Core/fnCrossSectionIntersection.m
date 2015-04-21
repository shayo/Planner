function [pt2fP1, pt2fP2, bIntersect,afPoint1MM,afPoint2MM] = fnCrossSectionIntersection(strctPlaneA, strctPlaneB)
[pt3iPointOnLine, afLineDir] = fnPlanePlaneIntersection(strctPlaneA, strctPlaneB);

Tmp = (strctPlaneA.m_a2fM) \ [pt3iPointOnLine,1]';
pt2fPoint = Tmp(1:2);
Tmp = (strctPlaneA.m_a2fM(1:3,1:3)) \ afLineDir';
afDir = Tmp(1:2);
% Kinda silly.... 
P1 = pt2fPoint-afDir*512;
P2 = pt2fPoint+afDir*512;
 [x0,x1,y0,y1,bIntersect]=fndllCohenSutherland(P1(1),P2(1),P1(2),P2(2), -strctPlaneA.m_fHalfWidthMM,strctPlaneA.m_fHalfWidthMM,...
     -strctPlaneA.m_fHalfHeightMM,strctPlaneA.m_fHalfHeightMM);
afPoint1MM = [x0,y0];
afPoint2MM = [x1,y1];


 pt2fP1 = fnCrossSection_MM_To_Image(strctPlaneA, afPoint1MM);
 pt2fP2 = fnCrossSection_MM_To_Image(strctPlaneA, afPoint2MM);
 
%  
% pt2fP1 = [...
% (afPoint1MM(1) - (-strctPlaneA.m_fHalfWidthMM)) / (2*strctPlaneA.m_fHalfWidthMM) * (strctPlaneA.m_iResWidth-1) + 1,...
% (afPoint1MM(2) - (-strctPlaneA.m_fHalfHeightMM)) / (2*strctPlaneA.m_fHalfHeightMM) * (strctPlaneA.m_iResHeight-1) + 1];
% 
% pt2fP2 = [...
% (afPoint2MM(1) - (-strctPlaneA.m_fHalfWidthMM)) / (2*strctPlaneA.m_fHalfWidthMM) * (strctPlaneA.m_iResWidth-1) + 1,...
% (afPoint2MM(2) - (-strctPlaneA.m_fHalfHeightMM)) / (2*strctPlaneA.m_fHalfHeightMM) * (strctPlaneA.m_iResHeight-1) + 1];
% 


% % 
% % 
% % % second step, intersect the infinite line with the XYZ box
% % % points_on_line = pt3iPointOnLine + t * afLineDir
% % apt3fIntersections = zeros(6,3);
% % abIntersecting = zeros(1,6)>0;
% % fEps = 1e-5;
% % for k=1:3
% %     for j=1:2 % min/max
% %          
% %         if afLineDir(k) ~= 0
% %             iIndex= (k-1)*2+j;
% %             t = (afRangeMM(k,j) - pt3iPointOnLine(k)) / afLineDir(k);
% %             apt3fIntersections(iIndex,:)  = pt3iPointOnLine + t * afLineDir;
% %             abIntersecting(iIndex) = all(apt3fIntersections(iIndex,:) >= (afRangeMM(:,1)-fEps)' & apt3fIntersections(iIndex,:) <= (afRangeMM(:,2)+fEps)');
% %         end;
% %     end;
% % end;
% % aiIndices = find(abIntersecting,2,'first');
% % assert(length(aiIndices)>=2);
% % pt3fP1 =apt3fIntersections(aiIndices(1),:);
% % pt3fP2 =apt3fIntersections(aiIndices(2),:);
% % 
% % % Third step, convert it from 3D back to the 2D image coordinate:
% % Tmp = strctPlaneA.m_a2fM \ [pt3fP1,1]';
% % afPoint1MM = Tmp(1:2);
% % Tmp = strctPlaneA.m_a2fM \ [pt3fP2,1]';
% % afPoint2MM = Tmp(1:2);
% % 
% % %Now, convert from mm to pixel values.
% % % the values -m_fHalfWidthMM..m_fHalfWidthMM are mapped to 1,m_iResWidth
% % pt2fP1 = [...
% % (afPoint1MM(1) - (-strctPlaneA.m_fHalfWidthMM)) / (2*strctPlaneA.m_fHalfWidthMM) * (strctPlaneA.m_iResWidth-1) + 1,...
% % (afPoint1MM(2) - (-strctPlaneA.m_fHalfHeightMM)) / (2*strctPlaneA.m_fHalfHeightMM) * (strctPlaneA.m_iResHeight-1) + 1];
% % 
% % pt2fP2 = [...
% % (afPoint2MM(1) - (-strctPlaneA.m_fHalfWidthMM)) / (2*strctPlaneA.m_fHalfWidthMM) * (strctPlaneA.m_iResWidth-1) + 1,...
% % (afPoint2MM(2) - (-strctPlaneA.m_fHalfHeightMM)) / (2*strctPlaneA.m_fHalfHeightMM) * (strctPlaneA.m_iResHeight-1) + 1];

return;