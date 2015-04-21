
function [fDist, fDistFromCenter,afPenDir] = fnGetDistanceToLine(pt2fPos, hAxes)
afX = get(hAxes,'xdata');
afY = get(hAxes,'ydata');
fDist = abs(((afX(2)-afX(1)) * (afY(1)-pt2fPos(2)) - (afX(1)-pt2fPos(1))*(afY(2)-afY(1))) / sqrt( (afX(2)-afX(1))^2 + (afY(2)-afY(1))^2));
fDistFromCenter = sqrt( (mean(afX) - pt2fPos(1))^2 + (mean(afY) - pt2fPos(2))^2);
afPenDir = [afY(1)-afY(2), afX(2)-afX(1)] ./ sqrt((afX(2)-afX(1)).^2+ (afY(2)-afY(1)).^2);
return;
