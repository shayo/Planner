function fnAddChamberUsingTwoPoints(strctStartPoint,strctEndPoint)
global g_strctModule %#ok
strctCrossSection = fnAxesHandleToStrctCrossSection(strctStartPoint.m_hAxes);

pt3fStartPoint = fnCrossSection_Image_To_MM_3D(strctCrossSection, strctStartPoint.m_pt2fPos);
pt3fEndPoint = fnCrossSection_Image_To_MM_3D(strctCrossSection, strctEndPoint.m_pt2fPos);

afDirection = pt3fStartPoint-pt3fEndPoint;
afDirection = afDirection/norm(afDirection);
[afDirection1,afDirection2] = fnGramSchmidt(afDirection');

a2fM = eye(4);
a2fM(1:3,3) = afDirection;
a2fM(1:3,1) = afDirection1;
a2fM(1:3,2) = afDirection2;
a2fM(1:3,4) = pt3fStartPoint;
%strctChamberParams = fnGetStandardCristChamberParams(0);
fnAddChamberAux(a2fM);
fnInvalidate();
return;