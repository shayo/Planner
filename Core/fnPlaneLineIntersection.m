function pt3fIntersectionPoint = fnPlaneLineIntersection(strctPlane, pt3iPointOnLine, afLineDir)
A = strctPlane.m_a2fM(1,3);
B = strctPlane.m_a2fM(2,3);
C = strctPlane.m_a2fM(3,3);
D = -(A*strctPlane.m_a2fM(1,4)+B*strctPlane.m_a2fM(2,4)+C*strctPlane.m_a2fM(3,4));

%A*(pt3iPointOnLine(1)+afLineDir(1)*t) + B*(pt3iPointOnLine(2)+afLineDir(2)*t) + C*(pt3iPointOnLine(3)+afLineDir(3)*t) + D = 0
t = (-D -A*pt3iPointOnLine(1) - B*pt3iPointOnLine(2)-C*pt3iPointOnLine(3)) / (A*afLineDir(1)+B*afLineDir(2) + C*afLineDir(3));
pt3fIntersectionPoint = pt3iPointOnLine+t*afLineDir;
return;


