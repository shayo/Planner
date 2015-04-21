function afConf = fnRobotInverse(strctRobot, a2fTarget, abFixedJoints, afFixedValue, afInitialSolution, iNumIterations)
iNumJoints = size(strctRobot.m_a2fDH,1);
fStopCondition = 1e-6; % Changed from 1e-12
afConf = afInitialSolution;
abFixedJoints = abFixedJoints>0;
afConf(abFixedJoints) = afFixedValue(abFixedJoints);
iIterationCounter = 0;
afNorm = zeros(1,iNumIterations);


% figure(11);
% clf;
% hAxes=gca;
% ahRobotHandles = fnRobotDraw(strctRobot, afInitialSolution, hAxes, 1);
% 

while (1)
    a2fCurrT = fnRobotForward(strctRobot, afConf);
    afError = fnTransDiff(a2fCurrT, a2fTarget) ;
    a2fJacob = fnRobotJacobian(strctRobot, afConf);
    a2fJacob(:, abFixedJoints) = 0;
    afSmallMove = pinv( a2fJacob ) * afError;
    afConf = afConf + afSmallMove';
    fNorm = norm(afSmallMove);
%     delete(ahRobotHandles);
%     ahRobotHandles = fnRobotDraw(strctRobot, afConf, hAxes, 1);
%     drawnow
    
    if fNorm < fStopCondition
        break;
    end;
    iIterationCounter = iIterationCounter + 1;
    afNorm(iIterationCounter) = fNorm;
    if iIterationCounter > iNumIterations % Did not converge!
        afConf = [];
        return;
    end
end

% Fix rotation angles above pi ?
for k=1:iNumJoints
    if strctRobot.m_a2fDH(k, 5) == 0 % i.e., rotatory
        while afConf(k) > pi
            afConf(k) = afConf(k)-pi;
        end;
        while afConf(k) < -pi
            afConf(k) = afConf(k)+pi;
        end;
    end
end

return;



function afError = fnTransDiff(a2fT1, a2fT2)
% Screw error between two transformations
afTranslationError = a2fT2(1:3,4)-a2fT1(1:3,4);
afRotationError = 1/2 * (cross(a2fT1(1:3,1), a2fT2(1:3,1)) + cross(a2fT1(1:3,2), a2fT2(1:3,2)) + cross(a2fT1(1:3,3), a2fT2(1:3,3)));
afError = [afTranslationError;	afRotationError];
return;



function a2fJacob = fnRobotJacobian(strctRobot, afConf)
% Manipulator jacobian.
a2fJn = fnRobotJacobianAux(strctRobot, afConf);	% Jacobian from joint to wrist space
a2fTn = fnRobotForward(strctRobot, afConf);
a2fJacob = [a2fTn(1:3,1:3), zeros(3,3); 
            zeros(3,3),     a2fTn(1:3,1:3)] * a2fJn;
return;



function a2fJ = fnRobotJacobianAux(strctRobot, afConf)
iNumLinks = size(strctRobot.m_a2fDH,1);
a2fU = strctRobot.m_a2fTool;
a2fJ = [];
for iLinkIter=iNumLinks:-1:1
    a2fU = fnRobotLinkTransformation(strctRobot.m_a2fDH(iLinkIter,:), afConf(iLinkIter)) * a2fU;
    if strctRobot.m_a2fDH(iLinkIter,5) == 0 % Rotatory
        afD = [	-a2fU(1,1)*a2fU(2,4)+a2fU(2,1)*a2fU(1,4)
                -a2fU(1,2)*a2fU(2,4)+a2fU(2,2)*a2fU(1,4)
                -a2fU(1,3)*a2fU(2,4)+a2fU(2,3)*a2fU(1,4)];
        afDelta = a2fU(3,1:3)';	% nz oz az
    else
        % prismatic axis
        afD = a2fU(3,1:3)';	% nz oz az
        afDelta = zeros(3,1);	%  0  0  0
    end
    a2fJ = [[afD; afDelta] a2fJ];
end
return;    