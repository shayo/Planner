function strctArm = fnKopf1460RightArm_MO()
C1 = 5.39;  % Triky to read out...
C3 =  12.15;%11.6457; 

INCH_TO_CM = 2.54;	%SM this is actuall correct by definition
MM_TO_CM = 1 / 10;	%SM mainly to document units
fDistanceBetweenArms = 7 * INCH_TO_CM;
%fDistanceBetweenArms = 7.0079 * INCH_TO_CM;


fHeightOfManipulatorWhenDV8 = 19;            
UseDV8Calibration = 1;
if UseDV8Calibration
    C2 = fHeightOfManipulatorWhenDV8 - C1;
    C4 = 8;
end
            

% being radians-challenged, make things more obvious by switching to degrees
% Denavit Hartenberg Parameter reminder (http://en.wikipedia.org/wiki/Denavit?Hartenberg_parameters)
% alpha: angle about common normal, from old z axis to new z axis
% A/r: lenght of common normal between the main axis of two consecutive joints
% theta: angle about previous z, from old x to new x
% D: offset along previous z to the common normal
% sigma: 1 denotes prismatic, 0 denotes rotatory links
% offset:	either fixed offset angle for rotatory links or fixed distance offset for prismatic links
%	for prismatic:	table_offset+cur_link_set_value = robot_D		; robot_theta = table_theta
%	for rotatory:	table_offset+cur_link_set_value = robot_theta	; robot_D =	table_D

%SM explain the values to some degree... (Variable names are column name plus link sequence number, plus optional axis labels)
A1 = -((19.15 / sqrt(2)) - (18.72 / sqrt(2))) * MM_TO_CM;	% the base block has an opening 19.15mm, but the bars are only 18.72mm wide, the block is centered over the opening, not the bar, that is shifted medial by a hunch, this could also have been  modelled for link 2
D2z = 15.6 * MM_TO_CM; %	the DV rotation base plane sits 15.6 mm above the top (plane) of the bars
%TODO: how does one model the arm correctly with proper offsets between
%links? Does thast require additional dummy links?
D3z = (57.25 - (37.9 / 2)) * MM_TO_CM;	% The AP axis; the diameter of the circular part of the linkks base is 37.9mm wide, and the distance from the DV rot plane to the top of the circular part at either 90 or -90 degree is 57.25mm
%D3a = -(32.8/2 - 15.07) * MM_TO_CM;	% the center of the rotatory disk is offset from the DV rotation axis, not modelled
D3b = -(32.8/2 - (9.51/2 + 3.2 + 8.3)) * MM_TO_CM;	% offset of discrete rotation axis from DV rotation axis
tmp_gap = 0;	% gap between discrete DV rotation base plane and AP rotation block
D4z = (63.9 - (D3z / MM_TO_CM) + tmp_gap) * MM_TO_CM;	% height of discrete DV rotation plane above AP rotation axis
D5z = (95.4 - (D3z / MM_TO_CM) - (D4z / MM_TO_CM)) * MM_TO_CM;	% height of the DV 0 mark above the previous link height (95.4 height from main DV rotation plane to DV 0 mark)
D6 = 122.5 * MM_TO_CM;	% distance of msanipulator tip at miximal extension of ML drive
A6 = -(30.3 - 3.11 - 9.52/2 - 3.2 - 9.52/2) * MM_TO_CM;	% distance between scaled DV rod center axis and scaled ML rod center axis
A7 = (7.89/2 + 5.08 + 12.8/2) * MM_TO_CM;	% distance between scaled ML rod center and aux translation rod center
D7z = 189.5 * MM_TO_CM;	% length of the aux rod from lower edge of clamp to Z0 (flat top of frame bar)


%ATTENTION A/r and D in CM!!! angles in radians
RightArmLinks = [...
% alpha_rad		A/r_cm	theta_rad		D_cm	sigma_bool	offset_rad_or_cm	% 0: the reference axis: Z or the DV line
degtorad(90)	A1		degtorad(90)	0		1			0					% 1. link: prismatic, link  length = AP
degtorad(90)	0		0				D2z+D3z	0			degtorad(-90)		% 2. link: rotatory, Z rotation, rotation DV?
degtorad(-90)	0		0				D3b		0			0					% 3. link: rotatory, AP
0				0		0				D4z		0			degtorad(180)		% 4. link: rotatory discrete (90 degree steps)
degtorad(90)	0		0				0		1			D5z					% 5. link: prismatic DV. to be modelled along the scaled rods, so this links z-axis is identical to #4 th z-axis
degtorad(90)	A6		0				0		1			-D6					% 6. link: prismatic ML, to be modelled along the scaled rod, (so offset from the DV axis)
0				A7		0				0		1			D7z					% 7. link: prismatic aux translation, to be modelled offset from theML link
0				0		0				0		0			degtorad(90)		% Dummy rotational end effector tool 
];

% real man work in radians
SO_RightArmLinks = [...
% alpha	A/r		theta	D		sigma	offset 
pi/2	0		pi/2	0		1		0		% First link, prismatic, link  length = AP
pi/2	0		0		C1		0		-1.5429	%
-pi/2	0		0		0		0		0		%
0		0.0153	0		0		0		pi		%
pi/2	0		0		0		1		C2-C4	%
pi/2	0		0		0		1		-C3		%
0		0		0		0		1		C1+C2	%
0		0		0		0		0		pi/2	% Dummy rotational end effector tool 
];


% RightArmLinks = [...
% 
%    1.5708         0    1.5708         0    1.0000         0
%     1.5715         0         0    5.3900         0   -1.5708
%    -1.5708         0         0         0         0    0.0000
%          0         0         0         0         0    3.1501
%     1.6002         0         0         0    1.0000    5.7502
%     1.5757         0         0         0    1.0000  -11.5600
%          0         0         0         0    1.0000   19.0000
%          0         0         0         0         0    1.5708
% ];
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
astrctJointDescirptions(3).m_fMin = -90;	% -180
astrctJointDescirptions(3).m_fMax = 90;	% 180
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

a2fBase = eye(4);
a2fBase(2,4) = fDistanceBetweenArms;





a2fRescaleToCm = eye(4);
a2fRescaleToCm(1,1) = 1/10;
a2fRescaleToCm(2,2) = 1/10;
a2fRescaleToCm(3,3) = 1/10;

AP = [0 0 1];
ML = [0 1 0];
DV = [1 0 0];
fAPBarsDistance = 17.8;

a2fRotAP = eye(4);
a2fRotAP(1:3,1:3) = fnRotateVectorAboutAxis(AP,-pi/2);

a2fRotML = eye(4);
a2fRotML(1:3,1:3) = fnRotateVectorAboutAxis(ML,pi/2);
a2fTransML0 = eye(4);
a2fTransML0(2,4) = fAPBarsDistance/2;

a2fTransDV0 = eye(4);
a2fTransDV0(1,4) = -2.34 - sqrt(2) * 0.61 /2;
% User stereotactic plane to align the monkey in the stereotactic frame
a2fEarBarZeroToFrame = a2fTransDV0 * a2fTransML0 * a2fRotML * a2fRotAP * a2fRescaleToCm;


strctArm = fnRobotCreate(RightArmLinks, a2fBase, eye(4),'Kopf 1460 (Right Arm) MO',astrctJointDescirptions);
return;

function Y=degtorad(X)
Y=X/180*pi;
return
