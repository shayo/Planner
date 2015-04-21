
function fRotationAngle=fnRotatePlaneExactAuxComputeRotationAngle(pt3fPosIn3DSpace,strctCrossSection1,strctCrossSection2,strctCrossSection3, hAxes)
    
[pt2fP1, pt2fP2] = fnCrossSectionIntersection(strctCrossSection1,strctCrossSection2);
    
pt3fLine1=fnGet3DCoordAux(pt2fP1,  hAxes);
pt3fLine2=fnGet3DCoordAux(pt2fP2, hAxes );

pt3iPointOnLine = fnPlanePlaneIntersection(strctCrossSection2,strctCrossSection3 );
% Project pt3iPointOnLine on CrossSection XY
[pt3fRotationPoint, pt2fImageMM] = fnProjectPointOnCrossSection(strctCrossSection1, pt3iPointOnLine'); %#ok
% Now, compute how much we need to rotate...
afVecNew = pt3fPosIn3DSpace(1:3)-pt3fRotationPoint;
afVecNew = afVecNew /norm(afVecNew);
%a2fDirections =
a2fVecDir = [pt3fLine1(1:3)-pt3fRotationPoint, pt3fLine2(1:3)-pt3fRotationPoint];
a2fVecDir(:,1) = a2fVecDir(:,1)./norm(a2fVecDir(:,1));
a2fVecDir(:,2) = a2fVecDir(:,2)./norm(a2fVecDir(:,2));

afAngle = [acos(dot(afVecNew, a2fVecDir(:,1)));acos(dot(afVecNew, a2fVecDir(:,2)));];
% afAngle(1) = min(afAngle(1), abs(pi-afAngle(1)));
% afAngle(2) = min(afAngle(2), abs(pi-afAngle(2)));
[fDummy,iIndex]=min(abs(afAngle)); %#ok
afRotationDirection = cross(a2fVecDir(:,iIndex), afVecNew);
afRotationDirection = afRotationDirection / norm(afRotationDirection);
strctCrossSection1.m_a2fM(1:3,3)
if acos(dot(afRotationDirection, strctCrossSection1.m_a2fM(1:3,3)))/pi*180 > 90
    fRotationAngle = afAngle(iIndex);
else
    fRotationAngle = -afAngle(iIndex);
end
return;
