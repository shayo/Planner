function astrctMesh = fnBuildCylinderWithPlane(fHeight, fDiameter, afColor, fTilt, fInnerRotation, fCenterX, fCenterY,fOuterRotation,bLongGrid)
astrctMesh(1) = fnGenPlane(fDiameter,fHeight,afColor*0.6);
fLongGridMM = 80;
if bLongGrid
    astrctMesh(2) = fnCreateCylinderMesh(fDiameter, -fLongGridMM, 0, 20, afColor);
    astrctMesh(3) = fnCreateCylinderMesh(fDiameter, -fHeight, 0, 20, [0 1 0]);
else
    astrctMesh(2) = fnCreateCylinderMesh(fDiameter, -fHeight, 0, 20, afColor);
end

% Tilt
astrctMesh(1) = fnApplyTransformOnMesh(astrctMesh(1), fnRotateVectorAboutAxis4D([1 0 0],fTilt));
astrctMesh(2) = fnApplyTransformOnMesh(astrctMesh(2), fnRotateVectorAboutAxis4D([1 0 0],fTilt));
if bLongGrid
astrctMesh(3) = fnApplyTransformOnMesh(astrctMesh(3), fnRotateVectorAboutAxis4D([1 0 0],0));
end
% Then rotate
astrctMesh(1) = fnApplyTransformOnMesh(astrctMesh(1), fnRotateVectorAboutAxis4D([0 0 1],-fInnerRotation));
astrctMesh(2) = fnApplyTransformOnMesh(astrctMesh(2), fnRotateVectorAboutAxis4D([0 0 1],-fInnerRotation));
if bLongGrid
    astrctMesh(3) = fnApplyTransformOnMesh(astrctMesh(3), fnRotateVectorAboutAxis4D([0 0 1],-fInnerRotation));
end

a2fTrans = eye(4);
a2fTrans(1,4) = fCenterX;
a2fTrans(2,4) = fCenterY;
astrctMesh = fnApplyTransformOnMesh(astrctMesh, a2fTrans);

a2fOuterRot = fnRotateVectorAboutAxis4D([0 0 1],fOuterRotation);

astrctMesh = fnApplyTransformOnMesh(astrctMesh, a2fOuterRot);

return;

function strctMeshGridDir = fnGenPlane(fDiameter,fHeight,afColor)

% Generate a plane that will indicate the grid Theta rotation
strctMeshGridDir.m_a2fVertices = [                    0         0            0              0; ...
    fDiameter/2 0 fDiameter/2 0;...
    -fHeight -fHeight 0  0];

strctMeshGridDir.m_a2iFaces = [1,2,3; 2 3 4]';
strctMeshGridDir.m_afColor = afColor;
strctMeshGridDir.m_fOpacity = 0.6;
