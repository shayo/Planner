function strctArm = fnKopf900ALeftArmMod()

% 21x 16.5 size of elevated platform
% 13.5cm to center of rotation

% Radius of rotation 1.68
C1 = 4.0; %Height of first rotatory link (roughly?)
C2 = 8;   % Read out of DV when tip is on the "zero plane"
C3 = 12.383; % Distance of end-effector tip along AP, when ML=0, and Discrete Rotation = 90
C4 = 17; % length of last joint

LeftArmLinks = [
    % alpha    A/r       theta	    D      sigma	offset
    pi/2       0        pi/2       0       1       0 % First link, prismatic, link  length = AP
    pi/2       0        0          C1      0      0 % Second link, rotatory, Z rotation
    pi/2       0        0          0       0       pi   % Second Rotation (about AP)
    0          0        0          0       0       pi/2 % Third Rotation (90 discrete)
    pi/2       0        0          0       1       C4-C1-C2
    pi/2       0        0          0       1       -C3
    0          0        0          0       1        C4
    0          0        0          0       0      pi/2 % Dummy rotational end effector tool
    ];

% % cla
% % strctArm = robot(LeftArmLinks);
% % for x=0:0.1:2*pi
% % qt = [4 0 -10/180*pi pi/2 0 0 0 x];
% % plot(strctArm,qt,'nobase','noshadow','noerase');
% % set(gca,'CameraPosition',[116.1073 -110.2090 -178.4641]);
% % axis equal
% % hold on;
% % Reached = fkine(strctArm,qt);
% % acCol = 'rgb';
% % for k=1:3
% % plot3([Reached(1,4) Reached(1,4)+5* Reached(1,k)],...
% %      [Reached(2,4) Reached(2,4)+5* Reached(2,k)],...
% %      [Reached(3,4) Reached(3,4)+5* Reached(3,k)],acCol(k),'LineWidth',2);
% % end
% % end

%%

astrctJointDescirptions(1).m_strName = 'Anterior Posterior (cm)';
astrctJointDescirptions(1).m_bFixed = false;
astrctJointDescirptions(1).m_fValue = 0;
astrctJointDescirptions(1).m_fMin = 0;
astrctJointDescirptions(1).m_fMax = 10;
astrctJointDescirptions(1).m_afDiscreteValues = [];


astrctJointDescirptions(2).m_strName = 'Rotation DV (deg)';
astrctJointDescirptions(2).m_bFixed = false;
astrctJointDescirptions(2).m_fValue = 0;
astrctJointDescirptions(2).m_fMin = -50;
astrctJointDescirptions(2).m_fMax = 50;
astrctJointDescirptions(2).m_afDiscreteValues = [];



astrctJointDescirptions(3).m_strName = 'Rotation AP (deg)'; 
astrctJointDescirptions(3).m_bFixed = false;
astrctJointDescirptions(3).m_fValue = 0;
astrctJointDescirptions(3).m_fMin = -50;
astrctJointDescirptions(3).m_fMax = 50;
astrctJointDescirptions(3).m_afDiscreteValues = [];


astrctJointDescirptions(4).m_strName = 'Rotation Discrete (90 deg)';
astrctJointDescirptions(4).m_bFixed = true;
astrctJointDescirptions(4).m_fValue = 0;
astrctJointDescirptions(4).m_fMin = -180;
astrctJointDescirptions(4).m_fMax = 180;
astrctJointDescirptions(4).m_afDiscreteValues = [-180 90 0 90];

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


a2fRescaleToCm = eye(4);
a2fRescaleToCm(1,1) = 1/10;
a2fRescaleToCm(2,2) = 1/10;
a2fRescaleToCm(3,3) = 1/10;

AP = [0 0 1];
ML = [0 1 0];
DV = [1 0 0];
fAPBarsDistance = 16.5;

a2fRotAP = eye(4);
a2fRotAP(1:3,1:3) = fnRotateVectorAboutAxis(AP,-pi/2);

a2fRotML = eye(4);
a2fRotML(1:3,1:3) = fnRotateVectorAboutAxis(ML,pi/2);
a2fTransML0 = eye(4);
a2fTransML0(2,4) = fAPBarsDistance/2;

a2fTransDV0 = eye(4);
a2fTransDV0(1,4) = -2.34 - sqrt(2) * 0.61 /2;
% User stereotactic plane to align the monkey in the stereotactic frame
a2fEarBarZeroToFrame =a2fTransDV0*a2fTransML0*a2fRotML*a2fRotAP*a2fRescaleToCm;

strctArm = fnRobotCreate(LeftArmLinks, eye(4), eye(4),'Kopf 900A Left Arm',astrctJointDescirptions);

return;