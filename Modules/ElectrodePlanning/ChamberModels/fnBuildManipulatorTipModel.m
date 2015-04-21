function [strctModel] = fnBuildManipulatorTipModel()
% A chamber must have only two strctures that describe the 3D geometry
% One is "short" (normal size) and one is "long" to see its projection in
% the volume. 
%
% Future versions may automatically do this projection so only the short
% version will be needed.

% These values are for a Plastic1, part number:  C313GT 
strctParams.m_strManufacterer = 'Kopf';
strctParams.m_strName = sprintf('Kopf 1460 Tip');


    fCylinderDiameterMM = 8;
    fCylinderHeightMM = 190;
    fConeHeightMM = 20;
    astrctMesh(1) = fnBuildCylinderWithConeMesh(fCylinderDiameterMM,fCylinderHeightMM,fConeHeightMM);
%     
%     afDirectionMM = a2fCRS_To_XYZ(1:3,1:3)*strctMarker.m_afDirection_vox(1:3);
%     
%     afRotationVector = cross(afDirectionMM,[0 0 1]);
%     fRotationAngle = acos(dot(afDirectionMM,[0 0 1]));
%     % Rotate along desired direction.
%     
%     astrctMesh(1) = fnApplyTransformOnMesh(astrctMesh(1), fnRotateVectorAboutAxis4D(afRotationVector,fRotationAngle));
%     
%     a2fTrans = eye(4);
%     a2fTrans(1,4) = pt3fMarkerMM(1);
%     a2fTrans(2,4) = pt3fMarkerMM(2);
%     a2fTrans(3,4) = pt3fMarkerMM(3);
%     astrctMesh = fnApplyTransformOnMesh(astrctMesh, a2fTrans);

strctModel.m_astrctMeshShort = astrctMesh;
strctModel.m_astrctMeshLong  = astrctMesh;
return;
