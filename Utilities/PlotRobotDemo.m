load('Tmp');
figure(11);
clf;
hAxes=gca;
ahRobotHandles = fnRobotDraw(strctRobot, afInitialSolution, hAxes, 1)

afConf = fnRobotInverse(strctRobot, a2fTarget, abFixedJoints, afFixedValue, afInitialSolution, iNumIterations)