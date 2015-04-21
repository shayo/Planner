function astrctMesh = fnBuildCylinderAlongDirection(pt3fOrigin, afDirection, fHeightDownMM,fHeightUpMM, fDiameter, afColor)
astrctMesh(1) = fnCreateCylinderMesh(fDiameter, -fHeightDownMM, fHeightUpMM, 20, afColor);
afRotationVector = cross(afDirection,[0 0 1]);
fRotationAngle = acos(dot(afDirection,[0 0 1]));
% Rotate along desired direction.

astrctMesh(1) = fnApplyTransformOnMesh(astrctMesh(1), fnRotateVectorAboutAxis4D(afRotationVector,fRotationAngle));

a2fTrans = eye(4);
a2fTrans(1,4) = pt3fOrigin(1);
a2fTrans(2,4) = pt3fOrigin(2);
a2fTrans(3,4) = pt3fOrigin(3);
astrctMesh = fnApplyTransformOnMesh(astrctMesh, a2fTrans);

return;
