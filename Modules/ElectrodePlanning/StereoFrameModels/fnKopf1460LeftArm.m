function strctArm = fnKopf1460LeftArm()
% From Kopf website:
%
% Model 1460 Electrode Manipulator
% Manipulator X, Z adjustment - 80 mm travel calibrated 0.1 mm vernier scale (100 micron increments), 3.0 mm advance per revolution.
% Manipulator Y adjustment - Manual adjustment 100 mm each side of zero (A/P bar) 0.1 mm vernier scale.
% Angle adjustment - Fully universal joint calibrated on two planes for access from any angle. 
% Vertical alignment pin can be removed for angled settings from 0° - 90° either side of vertical, 2° increments.
% Rotation adjustment - Manipulator swivel base can be rotated up to 360°. 
% Manipulator X/Z axis can be repositioned at 90° increments.

C1 = 5.39; % Triky to read out...Height to first rotatory joint
C3 =  12.15; 
INCH_TO_CM = 2.54;
fDistanceBetweenArmsCM = 7 * INCH_TO_CM;

fHeightOfManipulatorWhenDV8 = 19;            
UseDV8Calibration = 1;
if UseDV8Calibration
    C2 = fHeightOfManipulatorWhenDV8-C1;
    C4 = 8;
end

% This is my DH description of the arm manipulator            
LeftArmLinks = [
% alpha    A/r       theta	    D      sigma	offset 
  -pi/2       0        pi/2       0       1       0 % First link, prismatic, link  length = AP
  pi/2       0        0          C1      0     pi/2+1.59/180*pi % Second link, rotatory, Z rotation
  -pi/2      0        0          0       0       0
  0          0.0153        0          0       0      0
  pi/2       0        0          0       1       C2-C4
  pi/2       0        0          0       1       -C3
  0          0        0          0       1       C1+C2
  0          0        0          0       0      pi/2 % Dummy rotational end effector tool 
];

astrctJointDescirptions(1).m_strName = 'Anterior Posterior (cm)';
astrctJointDescirptions(1).m_bFixed = false;
astrctJointDescirptions(1).m_fValue = 0;
astrctJointDescirptions(1).m_fMin = -10;
astrctJointDescirptions(1).m_fMax = 10;
astrctJointDescirptions(1).m_afDiscreteValues = [];


astrctJointDescirptions(2).m_strName = 'Rotation DV (deg)';
astrctJointDescirptions(2).m_bFixed = false;
astrctJointDescirptions(2).m_fValue = 0;
astrctJointDescirptions(2).m_fMin = -180;
astrctJointDescirptions(2).m_fMax = 180;
astrctJointDescirptions(2).m_afDiscreteValues = [];

astrctJointDescirptions(3).m_strName = 'Rotation AP (deg)'; 
astrctJointDescirptions(3).m_bFixed = false;
astrctJointDescirptions(3).m_fValue = 0;
astrctJointDescirptions(3).m_fMin = -180;
astrctJointDescirptions(3).m_fMax = 180;
astrctJointDescirptions(3).m_afDiscreteValues = [];


astrctJointDescirptions(4).m_strName = 'Rotation Discrete (90 deg)';
astrctJointDescirptions(4).m_bFixed = true;
astrctJointDescirptions(4).m_fValue = 0;
astrctJointDescirptions(4).m_fMin = -180;
astrctJointDescirptions(4).m_fMax = 180;
astrctJointDescirptions(4).m_afDiscreteValues = [-180 -90 0 90];


astrctJointDescirptions(5).m_strName = 'Dorsal Ventral (cm)';
astrctJointDescirptions(5).m_bFixed = false;
astrctJointDescirptions(5).m_fValue = 0;
astrctJointDescirptions(5).m_fMin = 0;
astrctJointDescirptions(5).m_fMax = 8;
astrctJointDescirptions(5).m_afDiscreteValues = [];


astrctJointDescirptions(6).m_strName = 'Medial Lateral (cm)';
astrctJointDescirptions(6).m_bFixed = false;
astrctJointDescirptions(6).m_fValue = 0;
astrctJointDescirptions(6).m_fMin = 0;
astrctJointDescirptions(6).m_fMax = 8;
astrctJointDescirptions(6).m_afDiscreteValues = [];


astrctJointDescirptions(7).m_strName = 'Auxillary Translation';
astrctJointDescirptions(7).m_bFixed = true;
astrctJointDescirptions(7).m_fValue = 0;
astrctJointDescirptions(7).m_fMin = -20;
astrctJointDescirptions(7).m_fMax = 20;
astrctJointDescirptions(7).m_afDiscreteValues = [];

astrctJointDescirptions(8).m_strName = 'End Effector Rotation';
astrctJointDescirptions(8).m_bFixed = false;
astrctJointDescirptions(8).m_fValue = 0;
astrctJointDescirptions(8).m_fMin = -180;
astrctJointDescirptions(8).m_fMax = 180;
astrctJointDescirptions(8).m_afDiscreteValues = [];




fPlaneOffsetMM =  -23.4 - sqrt(2) * 6.1 /2;
fAPBarWidthMM = 17.82;
fBarsOffsetMM = sqrt(2)/2*fAPBarWidthMM;
a2fBase = fnRotateVectorAboutAxis4D([0 0 1],pi/2)*fnRotateVectorAboutAxis4D([0 1 0],pi/2);
a2fBase(3,4) = -fPlaneOffsetMM/10+fBarsOffsetMM/10;
a2fBase(1,4) = -fDistanceBetweenArmsCM/2;


strctArm = fnRobotCreate(LeftArmLinks, a2fBase,eye(4), 'Kopf 1460 (Left Arm)',astrctJointDescirptions);

return;