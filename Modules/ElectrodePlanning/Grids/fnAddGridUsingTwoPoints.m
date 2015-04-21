function fnAddGridUsingTwoPoints(strctStartPoint,strctEndPoint)
global g_strctModule 

strctCrossSection = fnAxesHandleToStrctCrossSection(strctStartPoint.m_hAxes);

pt3fStartPoint = fnCrossSection_Image_To_MM_3D(strctCrossSection, strctStartPoint.m_pt2fPos);
pt3fEndPoint = fnCrossSection_Image_To_MM_3D(strctCrossSection, strctEndPoint.m_pt2fPos);
a2fCRS_To_XYZ = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fReg * g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fM;
a2fChamber = a2fCRS_To_XYZ*g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber).m_a2fM_vox;


afDesiredDirection = pt3fEndPoint-pt3fStartPoint;
afDesiredDirection = afDesiredDirection / norm(afDesiredDirection);
if acos(dot(afDesiredDirection, a2fChamber(1:3,3)))/pi*180 < 90
    afDesiredDirection = -afDesiredDirection;
end;
afChamberZ = a2fChamber(1:3,3);
afChamberX = a2fChamber(1:3,1);
afChamberY = a2fChamber(1:3,2);

% Now both the chamber direction is facing outside of the brain and 
% the desired direction is facing to the brain


% Project the desired direction on the chamber plane 
afDesiredX = afChamberX * afDesiredDirection'*afChamberX;
afDesiredY = afChamberY * afDesiredDirection'*afChamberY;
afDesiredProj = afDesiredX+afDesiredY;
afDesiredProj = afDesiredProj / norm(afDesiredProj);
% now, measure the angle between the Y direction of the chamber and the
% desired direction. This will give the rotation of the grid (up to
% ambiguity of pi, which will be determined b the tilt (positive only...)
fDesiredRotationRad = acos(dot(afDesiredProj, afChamberY));
fDesiredRotationDeg = fDesiredRotationRad/pi*180;

% Desired tilt?
fDesiredTiltRad = pi-acos(dot(afDesiredDirection, afChamberZ));
fDesiredTiltDeg = fDesiredTiltRad/pi*180;


% Verify. Take a normal, tilt it, then rotatet it and see if it aligns with
% the desired rotation. If not, rotate it by 360-rotation

afTest = fnRotateVectorAboutAxis(afChamberZ, fDesiredRotationRad) * fnRotateVectorAboutAxis(afChamberX, fDesiredTiltRad) * -afChamberZ;
afTest2 = fnRotateVectorAboutAxis(afChamberZ, 2*pi-fDesiredRotationRad) * fnRotateVectorAboutAxis(afChamberX, fDesiredTiltRad) * -afChamberZ;
if acos(dot(afTest, afDesiredDirection)) > acos(dot(afTest2, afDesiredDirection)) 
    fDesiredRotationRad = 2*pi-fDesiredRotationRad;
    fDesiredRotationDeg = fDesiredRotationRad/pi*180;
end

% Now to find the closest grid hole... (if at all inside the grid...)
% project the desired line to the chamber plane and find the distance along
% the X and Y directions....
% x=Px + ux * t (where Px is a point on the line and u ix the desired direction
% on the other hand, A*x+B*y+C*z+D = 0....
% 
% Find D first.
%P = pt3fStartPoint;
%N = afChamberZ;
D= -a2fChamber(1:3,4)' * afChamberZ;
%U = afDesiredDirection;
%P(1)*N(1) + U(1)*N(1)*t + P(2)*N(2) + U(2)*N(2)*t  +P(3)*N(3) + U(3)*N(3)*t  + D = 0
%pt3fStartPoint'*afChamberZ + (afDesiredDirection'*afChamberZ)*t+D = 0
t = (-D-pt3fStartPoint'*afChamberZ) / (afDesiredDirection'*afChamberZ);
afPointOnPlane = pt3fStartPoint+afDesiredDirection*t;
afDirectionToHoleOnPlane = afPointOnPlane-a2fChamber(1:3,4);

fHoleDistanceX= -afDirectionToHoleOnPlane'*a2fChamber(1:3,1);
fHoleDistanceY= afDirectionToHoleOnPlane'*a2fChamber(1:3,2);

% Generate the grid...
strctGridParam = fnDefineGridModel_Standard();
strctGridParam.m_acParam{1}.m_Value = fDesiredTiltDeg;
strctGridParam.m_acParam{2}.m_Value = fDesiredRotationDeg;
strctGridModel = fnBuildGridModel_Standard(strctGridParam);
[fClosestDistanceToGridHoleMM, iHoleIndex]=min( sqrt((strctGridModel.m_afGridHolesX-fHoleDistanceX).^2+(strctGridModel.m_afGridHolesY-fHoleDistanceY).^2));
strctGridModel.m_strctGridParams.m_abSelectedHoles(iHoleIndex) = true;


% Add a grid
iDefaultModel = 1; % Circular
iGridIndex = fnAddGridFromStruct(g_strctModule.m_astrctGrids(iDefaultModel),[]);
% Now, manipulate this grid....
g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber).m_astrctGrids(iGridIndex).m_strctModel = strctGridModel;

fnUpdateGridList();
fnUpdateGridAxes(false);
fnInvalidate(1);


return;