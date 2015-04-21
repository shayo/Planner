function [fDistance, pt2fClosestPointOnLine, fDistanceAlongLine,bInInterval] = fnPointLineDist2D(pt2fStart, pt2fEnd, pt2fPoint)
afDirection = pt2fEnd-pt2fStart;
fSegmentLength = norm(afDirection);
afDirection = afDirection / fSegmentLength;

t = dot(pt2fStart - pt2fPoint, afDirection);
fDistance = sqrt(sum((pt2fStart - pt2fPoint).^2) - t^2);
pt2fClosestPointOnLine = pt2fStart + t*afDirection;
fDistanceAlongLine = norm(pt2fClosestPointOnLine-pt2fStart);
iIndex = find(abs(afDirection) > 1e-5,1,'first');
t2 = (pt2fPoint(iIndex)-pt2fStart(iIndex))/afDirection(iIndex);
bInInterval = t2 >= 0 && t2 <= fSegmentLength;
return;

