function strctGridModel = fnBuildGridModel_DualCircular(strctGridParams)
% This function generates a structure that contains the grid model
% It uses various information in strctGridParams to construct the grid
% The output is a structure that must contain

% Master Grid Controls
fTheta0Rad = fnGetGridParameter(strctGridParams,'Theta0')/180*pi;
fGridInnerDiam0 = fnGetGridParameter(strctGridParams,'GridInnerDiam0');

% 
fShiftX1 = fnGetGridParameter(strctGridParams,'ShiftX1');
fShiftY1 = fnGetGridParameter(strctGridParams,'ShiftY1');
fGridPhiDeg1 = fnGetGridParameter(strctGridParams,'Phi1');
fGridThetaRad1 = fnGetGridParameter(strctGridParams,'Theta1')/180*pi;
fGridHoleDistanceMM1 = fnGetGridParameter(strctGridParams,'HoleDist1');
strHoleDistWhere1 = fnGetGridParameter(strctGridParams,'HoleDistWhere1');
fGridHoleDiameterMM1 = fnGetGridParameter(strctGridParams,'HoleDiam1');
strNumHoles1 = fnGetGridParameter(strctGridParams,'NumHoles1');
fOffsetX1 = fnGetGridParameter(strctGridParams,'OffsetX1');
fOffsetY1 = fnGetGridParameter(strctGridParams,'OffsetY1');
fGridInnerDiameterMM1 = fnGetGridParameter(strctGridParams,'GridInnerDiam1');
% 
fShiftX2 = fnGetGridParameter(strctGridParams,'ShiftX2');
fShiftY2 = fnGetGridParameter(strctGridParams,'ShiftY2');
fGridPhiDeg2 = fnGetGridParameter(strctGridParams,'Phi2');
fGridThetaRad2 = fnGetGridParameter(strctGridParams,'Theta2')/180*pi;
fGridHoleDistanceMM2 = fnGetGridParameter(strctGridParams,'HoleDist2');
strHoleDistWhere2 = fnGetGridParameter(strctGridParams,'HoleDistWhere2');
fGridHoleDiameterMM2 = fnGetGridParameter(strctGridParams,'HoleDiam2');
strNumHoles2 = fnGetGridParameter(strctGridParams,'NumHoles2');
fOffsetX2 = fnGetGridParameter(strctGridParams,'OffsetX2');
fOffsetY2 = fnGetGridParameter(strctGridParams,'OffsetY2');
fGridInnerDiameterMM2 = fnGetGridParameter(strctGridParams,'GridInnerDiam2');
%
bClipInvalid = fnGetGridParameter(strctGridParams,'ClipInvalid');
fGridHeightMM = fnGetGridParameter(strctGridParams,'GridHeight');
bLongGrid = fnGetGridParameter(strctGridParams,'LongGrid');

% Rotate Master Grid 
a2fR = fnRotateVectorAboutAxis([0 0 1], -fTheta0Rad);

[afX_A, afY_A, apt3fNormals_A] = fnBuildSmallGrid(a2fR,fShiftX1, fShiftY1,...
                           fOffsetX1, fOffsetY1,...
                          fGridHoleDiameterMM1, fGridHoleDistanceMM1, ...
                          fGridInnerDiameterMM1, fGridThetaRad1, fGridPhiDeg1,...
                          fGridHeightMM, bClipInvalid, strNumHoles1, strHoleDistWhere1);

[afX_B, afY_B, apt3fNormals_B] = fnBuildSmallGrid(a2fR,fShiftX2, fShiftY2,...
                          fOffsetX2, fOffsetY2,...
                          fGridHoleDiameterMM2, fGridHoleDistanceMM2, ...
                          fGridInnerDiameterMM2, fGridThetaRad2, fGridPhiDeg2,...
                          fGridHeightMM, bClipInvalid, strNumHoles2, strHoleDistWhere2);

N = size(afX_A,2)+size(afX_B,2);
                      
strctGridModel.m_strctGridParams = strctGridParams;
strctGridModel.m_aiSubModelInd = [ones(1,length(afX_A)),2*ones(1,length(afX_B))];

strctGridModel.m_afGridHolesX = [afX_A,afX_B];
strctGridModel.m_afGridHolesY = [afY_A,afY_B];
strctGridModel.m_apt3fGridHolesNormals = [apt3fNormals_A,apt3fNormals_B];
strctGridModel.m_strctGridParams.m_abSelectedHoles = zeros(1, N)>0;

                      

if 0
    % Draw GridafAlpha
    afAlpha = linspace(0,2*pi,100);
    afCos = cos(afAlpha);
    afSin = sin(afAlpha);
    
    figure(10);
    clf;
    hold on;
    for k=1:length(strctGridModel.m_afGridHolesX)
        
        plot(strctGridModel.m_afGridHolesX(k), strctGridModel.m_afGridHolesY(k),'ro');
        plot3([strctGridModel.m_afGridHolesX(k) strctGridModel.m_afGridHolesX(k) + strctGridModel.m_apt3fGridHolesNormals(1,k)*10],...
            [strctGridModel.m_afGridHolesY(k) strctGridModel.m_afGridHolesY(k) + strctGridModel.m_apt3fGridHolesNormals(2,k)*10],...
            [0                                0 + strctGridModel.m_apt3fGridHolesNormals(3,k)*fGridHeightMM],'b');
    end
    plot(afCos*fGridInnerDiameterMM/2,afSin*fGridInnerDiameterMM/2,'k');
    plot3(afCos*fGridInnerDiameterMM/2,afSin*fGridInnerDiameterMM/2,-fGridHeightMM *ones(size(afAlpha)),'k');
    
    plot3([0 10],[0 0],[0 0],'r','LineWidth',2);
    plot3([0 0],[0 10],[0 0],'g','LineWidth',2);
    plot3([0 0],[0 0],[0 -10],'c','LineWidth',2);
    xlabel('X');
    ylabel('Y');
    box on
    axis equal
    cameratoolbar
end
                      
                      
return;


function[afGridHolesX, afGridHolesY, apt3fGridNormals] = fnBuildSmallGrid(a2fRMaster,fCenterX, fCenterY,...
                          fOffsetX, fOffsetY,...
                          fGridHoleDiameterMM, fGridHoleDistanceMM, ...
                          fGridInnerDiameterMM, fGridThetaRad, fGridPhiDeg,...
                          fGridHeightMM, bClipInvalid, strNumHoles, strHoleDistWhere)


if strcmpi(strHoleDistWhere,'tilted')
    fGridHoleDistanceMM = fGridHoleDistanceMM * cos(fGridPhiDeg/180*pi);
end

if strcmpi(strNumHoles,'auto')
    afXCenters = fOffsetX+[fliplr(-fGridHoleDistanceMM:...
        -fGridHoleDistanceMM:-((fGridInnerDiameterMM/2) - fGridHoleDiameterMM)),...
        0:fGridHoleDistanceMM:(fGridInnerDiameterMM/2) - fGridHoleDiameterMM];
    afYCenters = fOffsetY+[fliplr(-fGridHoleDistanceMM:...
        -fGridHoleDistanceMM:-((fGridInnerDiameterMM/2) - fGridHoleDiameterMM)),...
        0:fGridHoleDistanceMM:(fGridInnerDiameterMM/2) - fGridHoleDiameterMM];
else
    iNumHoles = str2num(strNumHoles);
    afXCenters = [fOffsetX + ([1:iNumHoles-1] * -fGridHoleDistanceMM),  fOffsetX + ([0:iNumHoles-1] * fGridHoleDistanceMM)];
    afYCenters = [fOffsetY + ([1:iNumHoles-1] * -fGridHoleDistanceMM),  fOffsetY + ([0:iNumHoles-1] * fGridHoleDistanceMM)];
end
[a2fXc, a2fYc] = meshgrid(afXCenters, afYCenters);
    

% Build the normals (using Phi angle)
[fNormalX,fNormalY, fNormalZ] = sph2cart(pi/2, (90-fGridPhiDeg)/180*pi, 1); % Look at the X-Z plane
fNormalZ = -fNormalZ;

if bClipInvalid 
    a2bFeasibleTop =  sqrt(a2fXc.^2 + a2fYc.^2) + fGridHoleDiameterMM/2 < fGridInnerDiameterMM/2;
    fHoleLength = fGridHeightMM / cos(fGridPhiDeg/180*pi);
    
    a2bFeasibleBottom = sqrt(    (a2fXc + fNormalX*fHoleLength ).^2 + ...
    (a2fYc + fNormalY*fHoleLength ).^2) + fGridHoleDiameterMM/2< fGridInnerDiameterMM/2;

    a2bFeasible = a2bFeasibleBottom & a2bFeasibleTop;
else
    a2bFeasible = ones(size(a2fXc)) > 0;
end


N=sum(a2bFeasible(:));
afGridX = a2fXc(a2bFeasible);
afGridY = a2fYc(a2bFeasible);

% Now, Rotate the grid by theta
a2fT = [cos(fGridThetaRad) sin(fGridThetaRad) fCenterX;
    -sin(fGridThetaRad) cos(fGridThetaRad)    fCenterY;
            0               0                   1];

Tmp = a2fRMaster*a2fT * [afGridX';afGridY'; ones(size(afGridX'))];

afGridHolesX = Tmp(1,:);
afGridHolesY = Tmp(2,:);



a2fRMaster(1,2)=-a2fRMaster(1,2);
a2fRMaster(2,1)=-a2fRMaster(2,1);
% And, rotate the normals as well....
afRotationDirection = [0 0 1];
a2fTrans = eye(4);
a2fTrans(1:3,1:3) = a2fRMaster*fnRotateVectorAboutAxis(afRotationDirection,fGridThetaRad);
Tmp = a2fTrans * [fNormalX;fNormalY;fNormalZ;1];

% All normals are the same....
apt3fGridNormals = repmat(Tmp,[1, N]);
apt3fGridNormals=apt3fGridNormals(1:3,:);

return;

