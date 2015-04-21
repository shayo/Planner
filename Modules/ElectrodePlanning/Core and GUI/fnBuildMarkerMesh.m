function astrctMesh = fnBuildMarkerMesh(strctMarker, bSelected)
global g_strctModule
a2fCRS_To_XYZ = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fReg*g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fM;

pt3fMarkerMM = a2fCRS_To_XYZ*[strctMarker.m_pt3fPosition_vox(:);1];
if bSelected
    afColor = [1 0 0 ];
else
    afColor = [0.5 0 0];
end



if isfield(strctMarker,'m_afDirection_vox') && ~isnan(strctMarker.m_afDirection_vox(1))
    fCylinderDiameterMM = 8;
    fCylinderHeightMM = 15;
    fConeHeightMM = 20.2;
    astrctMesh(1) = fnBuildCylinderWithConeMesh(fCylinderDiameterMM,fCylinderHeightMM,fConeHeightMM,afColor);

    pt3fMarkerMMPlusDir = a2fCRS_To_XYZ*[strctMarker.m_pt3fPosition_vox(:)+strctMarker.m_afDirection_vox(1:3);1];
    afDirectionMM =  (pt3fMarkerMMPlusDir(1:3)-pt3fMarkerMM(1:3))/norm(pt3fMarkerMMPlusDir(1:3)-pt3fMarkerMM(1:3));
    
    afRotationVector = cross(afDirectionMM,[0 0 1]);
    fRotationAngle = acos(dot(afDirectionMM,[0 0 1]));
    % Rotate along desired direction.
    
    astrctMesh(1) = fnApplyTransformOnMesh(astrctMesh(1), fnRotateVectorAboutAxis4D(afRotationVector,fRotationAngle));
    
    a2fTrans = eye(4);
    a2fTrans(1,4) = pt3fMarkerMM(1);
    a2fTrans(2,4) = pt3fMarkerMM(2);
    a2fTrans(3,4) = pt3fMarkerMM(3);
    astrctMesh = fnApplyTransformOnMesh(astrctMesh, a2fTrans);
    
else
    astrctMesh(1) = fnBuildCubeMesh(...
        pt3fMarkerMM(1),...
        pt3fMarkerMM(2),....
        pt3fMarkerMM(3),...
        0.5,0.5,0.5,afColor);
end
return;
