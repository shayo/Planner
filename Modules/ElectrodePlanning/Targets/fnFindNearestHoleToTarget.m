

function [fMinDist, iBestHole,fDepthMM,afMinDistToTarget] = fnFindNearestHoleToTarget(a2fChamberM,strctGrid,pt3fTargetPosMM)
iNumHoles = length(strctGrid.m_strctModel.m_afGridHolesX);
afMinDistToTarget = ones(1,iNumHoles)*inf;
afDepth = zeros(1,iNumHoles);
%iNumBloodVessels = size(apt3fBloodVesselsMM,2);
for iHoleIter=1:iNumHoles
    
    % First, shift.
    a2fTransformShift = eye(4);
    a2fTransformShift(1,4) = -strctGrid.m_strctModel.m_afGridHolesX(iHoleIter);
    a2fTransformShift(2,4) = strctGrid.m_strctModel.m_afGridHolesY(iHoleIter);
    
    afRotationAxis = cross([0 0 -1], strctGrid.m_strctModel.m_apt3fGridHolesNormals(:,iHoleIter));
    if norm(afRotationAxis) > 0
        
        fRotationAngle = acos(dot([0 0 -1]',strctGrid.m_strctModel.m_apt3fGridHolesNormals(:,iHoleIter)));
      a2fRotation = fnRotateVectorAboutAxis4D(afRotationAxis,fRotationAngle);
     a2fTrans=a2fChamberM * a2fRotation*a2fTransformShift;
    else
     a2fTrans=a2fChamberM * a2fTransformShift;
        
    end
    
    
    pt3fStart = a2fTrans(1:3,4);
    afDirection = -a2fTrans(1:3,3);
    [afMinDistToTarget(iHoleIter), pt3fClosestPointOnLine, afDepth(iHoleIter)] = fnPointLineDist3D(pt3fStart, afDirection, pt3fTargetPosMM(1:3)); %#ok
   
end;

%
% figure(2);
% clf;
% 
% subplot(2,1,1);
% 
% hold on;
% plot(afMinDistToTarget,'b');
% plot(afMinDistToBloodVessel,'r');
% subplot(2,1,2);
% plot(afWeightedDistance,'c');

[fDummy, iBestHole] = min(afMinDistToTarget); %#ok
fMinDist = afMinDistToTarget(iBestHole);
fDepthMM = afDepth(iBestHole);
% 
% pt3fReached = pt3fStart+afDirection*fDepthMM;
% norm(pt3fReached-pt3fTargetPosMM(1:3))
% clf;
% hold on;
% plot3(pt3fTargetPosMM(1),pt3fTargetPosMM(2),pt3fTargetPosMM(3),'b.');
% plot3(pt3fStart(1),pt3fStart(2),pt3fStart(3),'r.');
% plot3([pt3fStart(1) pt3fStart(1)+fDepthMM*afDirection(1)],...
%       [pt3fStart(2) pt3fStart(2)+fDepthMM*afDirection(2)],...   
%       [pt3fStart(3) pt3fStart(3)+fDepthMM*afDirection(3)],'g');
% axis equal 
return;

