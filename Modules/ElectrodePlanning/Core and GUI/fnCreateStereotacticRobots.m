function fnCreateStereotacticRobots()
global g_strctModule
C1 = 5.395; %fHeightToFirstRotation
C2 = 5.786; % Height from first rotation to "zero" position of the z bar
C3 = 12.3; % Distance of end-effector when everything is set to "zero"
            % Measured by rotating z bar by 90 deg...
            % basically, "zero" along the midline, measured relative 
%C4 = 16.5; % C3 with extention 

fDistanceBetweenArms = 17.75;
% fDistanceToPole = 23.317;
% fPoleDiameter = 2.552;
% fPoleHeight = 14;

% Links represented in standard DH convension

% LeftArmLinks = [
% % alpha    A/r       theta	    D      sigma	offset 
%   pi/2       0       pi/2       0       1       0 % First link, prismatic, link  length = AP
%   pi/2       0       0          C1      0     pi/2 % Second link, rotatory, Z rotation
%   -pi/2      0       0          0       0       0
%   pi/2       0       pi         0      1       C2
%   pi/2       0       0          0       1       -C3
%   0          0        0         0       1       C1+C2
%   0          0       0          0       0      pi/2 % Dummy rotational end effector tool 
% ];

% RightArmLinks = [
% % alpha    A/r       theta	    D      sigma	offset 
%   pi/2       0       pi/2       0       1       0 % First link, prismatic, link  length = AP
%   pi/2       0       0          C1      0     -pi/2 % Second link, rotatory, Z rotation
%   -pi/2      0       0          0       0       0
%   pi/2       0       pi         0      1       C2
%   pi/2       0       0          0       1       -C3
%   0          0        0         0       1       C1+C2
%   0          0       0          0       0      pi/2 % Dummy rotational end effector tool 
% ];


LeftArmLinks = [
% alpha    A/r       theta	    D      sigma	offset 
  pi/2       0       pi/2       0       1       0 % First link, prismatic, link  length = AP
  pi/2       0       0          C1      0     pi/2 % Second link, rotatory, Z rotation
  -pi/2      0       0          0       0       0
 0           0       0         0      0 pi
  pi/2       0       0         0      1       C2
  pi/2       0       0          0       1       -C3
  0          0        0         0       1       C1+C2
  0          0       0          0       0      pi/2 % Dummy rotational end effector tool 
];

RightArmLinks = [...
% alpha    A/r       theta	    D      sigma	offset 
  pi/2       0       pi/2       0       1       0 % First link, prismatic, link  length = AP
  pi/2       0       0          C1      0     -pi/2 % Second link, rotatory, Z rotation
  -pi/2      0       0          0       0       0
  0          0       0          0       0      pi
  pi/2       0       0         0        1       C2
  pi/2       0       0          0       1       -C3
  0          0        0         0       1       C1+C2
  0          0       0          0       0      pi/2 % Dummy rotational end effector tool 
];


kopf_left = robot(LeftArmLinks);
kopf_left.name = 'Kopf 1430 Left Arm';

kopf_right = robot(RightArmLinks);
kopf_right.name = 'Kopf 1430 Right Arm';
Base = eye(4);
Base(2,4) = fDistanceBetweenArms;
kopf_right.base = Base;

g_strctModule.m_strctKopfLeftArm = kopf_left;
g_strctModule.m_strctKopfRightArm = kopf_right;
g_strctModule.m_afLeftArmConf = zeros(1,8);
g_strctModule.m_afRightArmConf = zeros(1,8);
return;