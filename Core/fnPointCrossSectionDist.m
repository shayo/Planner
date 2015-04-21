function fDist=  fnPointCrossSectionDist(pt3fPoint, a2fM)
d = -a2fM(1:3,3)' * a2fM(1:3,4);
fDist = a2fM(1:3,3)' *pt3fPoint(1:3)+d;
return;