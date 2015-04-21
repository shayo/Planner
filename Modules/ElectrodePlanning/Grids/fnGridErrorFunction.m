function [fError, afMinDistToTargets, aiBestHole, afDistanceFromHoleMM]=fnGridErrorFunction(strctModel,apt3fTargetsPosMM, a2fM_WithMeshOffset)
% Finds the closest hole...
iNumHoles = length(strctModel.m_afGridHolesX);
iNumTargets = size(apt3fTargetsPosMM,2);
a2fMinDistToTarget = zeros(iNumTargets,iNumHoles);
afDistanceFromHoleMM = zeros(1,iNumTargets);
a2fEuclidDistanceFromHoleToTarget= zeros(iNumTargets,iNumHoles);

for iHoleIter=1:iNumHoles
    % First, shift.
    a2fTransformShift = eye(4);
    a2fTransformShift(1,4) = -strctModel.m_afGridHolesX(iHoleIter);
    a2fTransformShift(2,4) = strctModel.m_afGridHolesY(iHoleIter);
    
    afRotationAxis = cross([0 0 -1], strctModel.m_apt3fGridHolesNormals(:,iHoleIter));
    fRotationAngle = acos(dot([0 0 -1]',strctModel.m_apt3fGridHolesNormals(:,iHoleIter)));
    a2fRotation = fnRotateVectorAboutAxis4D(afRotationAxis,fRotationAngle);
    a2fTrans=a2fM_WithMeshOffset * a2fRotation*a2fTransformShift;
    
    pt3fStart = a2fTrans(1:3,4);
    afDirection = -a2fTrans(1:3,3);
    for iTargetIter=1:iNumTargets
        a2fMinDistToTarget(iTargetIter,iHoleIter) = fnPointLineDist3D(pt3fStart, afDirection, apt3fTargetsPosMM(1:3,iTargetIter));
        a2fEuclidDistanceFromHoleToTarget(iTargetIter,iHoleIter) =  norm(pt3fStart-apt3fTargetsPosMM(1:3,iTargetIter));
    end
end
[afMinDistToTargets,aiBestHole] = min(a2fMinDistToTarget,[],2);
for iTargetIter=1:length(aiBestHole)
   afDistanceFromHoleMM(iTargetIter) = a2fEuclidDistanceFromHoleToTarget(iTargetIter,aiBestHole(iTargetIter));
end
fError=sum(afMinDistToTargets);

return;
