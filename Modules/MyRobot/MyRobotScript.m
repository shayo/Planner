
a2fDH = [
% alpha    A/r       theta	    D      sigma	offset 
  pi/2       0       pi/2       0       1       0 % First link, prismatic, link  length = AP
  pi/2       0       0          C1      0     pi/2 % Second link, rotatory, Z rotation
  -pi/2      0       0          0       0       0
  pi/2       0       pi         0      1       C2
  pi/2       0       0          0       1       -C3
  0          0        0         0       1       C1+C2
  0          0       0          0       0      pi/2 % Dummy rotational end effector tool 
];

kopf_right = robot(a2fDH);


afConf = zeros(1,7);
afConf(2) = 0.5;
strctRobot = fnRobotCreate(a2fDH);
a2fT = fnRobotForward(strctRobot, afConf);
abFixed= [0 0 0 1 0 0 1];

afSol = fnRobotInverse(strctRobot, a2fT, abFixed,zeros(1,7),zeros(1,7),100);

a2fT2 = fnRobotForward(strctRobot,afSol);
figure(1);
clf;
hAxes = gca;

ahRobotHandles = fnRobotDraw(strctRobot, afSol, hAxes, 1.5);
