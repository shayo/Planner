function [fDistance, pt3fClosestPointOnLine, fDistanceAlongLine] = fnPointLineDist3D(pt3fPointOnLine, afDirection, pt3fPoint)
%iNumPoints = size(pt3fPoint,2);
% t = sum((repmat(pt3fPointOnLine,1,iNumPoints) - pt3fPoint) .* repmat(afDirection, 1,iNumPoints),1);
% afDistance = sqrt(sum((repmat(pt3fPointOnLine,1,iNumPoints) - pt3fPoint).^2) - t.^2);
% apt3fClosestPointOnLine = repmat(pt3fPointOnLine,1,iNumPoints) + repmat(t, 3,1).*repmat(afDirection,1,iNumPoints);
% afDistanceAlongLine = sqrt(sum((apt3fClosestPointOnLine- repmat(pt3fPointOnLine,1,iNumPoints)).^2,1));
% 
% [fDistance, iIndex] = min(afDistance);
% pt3fClosestPointOnLine = apt3fClosestPointOnLine(:,iIndex);
% fDistanceAlongLine = afDistanceAlongLine(iIndex);
% 
t = dot(pt3fPointOnLine - pt3fPoint, afDirection);
fDistance = sqrt(sum((pt3fPointOnLine - pt3fPoint).^2) - t^2);
pt3fClosestPointOnLine = pt3fPointOnLine + t*afDirection;
fDistanceAlongLine = norm(pt3fClosestPointOnLine-pt3fPointOnLine);

return;

