function astrctMesh = fnBuildGridMesh_DualCircular(strctGridModel, bDrawShort,bHighlight)
clear astrctMesh

if ~exist('bHighlight','var')
    bHighlight = false;
end;

iNumActiveHoles = sum(strctGridModel.m_strctGridParams.m_abSelectedHoles);
aiActiveHoles = find(strctGridModel.m_strctGridParams.m_abSelectedHoles);

fShiftX1 = fnGetGridParameter(strctGridModel.m_strctGridParams,'ShiftX1');
fShiftX2 = fnGetGridParameter(strctGridModel.m_strctGridParams,'ShiftX2');
fShiftY1 = fnGetGridParameter(strctGridModel.m_strctGridParams,'ShiftY1');
fShiftY2 = fnGetGridParameter(strctGridModel.m_strctGridParams,'ShiftY2');

fTheta0Rad = fnGetGridParameter(strctGridModel.m_strctGridParams,'Theta0')/180*pi;
fTheta1Rad = fnGetGridParameter(strctGridModel.m_strctGridParams,'Theta1')/180*pi;
fTheta2Rad = fnGetGridParameter(strctGridModel.m_strctGridParams,'Theta2')/180*pi;

fPhi1Rad = fnGetGridParameter(strctGridModel.m_strctGridParams,'Phi1')/180*pi;
fPhi2Rad = fnGetGridParameter(strctGridModel.m_strctGridParams,'Phi2')/180*pi;

fHoleDiam1 = fnGetGridParameter(strctGridModel.m_strctGridParams,'HoleDiam1');
fHoleDiam2 = fnGetGridParameter(strctGridModel.m_strctGridParams,'HoleDiam2');
fGridHeightMM = fnGetGridParameter(strctGridModel.m_strctGridParams,'GridHeight');
fGrid0InnerDiameterMM = fnGetGridParameter(strctGridModel.m_strctGridParams,'GridInnerDiam0');
fGrid1InnerDiameterMM= fnGetGridParameter(strctGridModel.m_strctGridParams,'GridInnerDiam1');
fGrid2InnerDiameterMM= fnGetGridParameter(strctGridModel.m_strctGridParams,'GridInnerDiam2');
bLongGrid = fnGetGridParameter(strctGridModel.m_strctGridParams,'LongGrid');

if bDrawShort
    fAboveGridMM = 0;
    bLongGrid = false;
    fElectrodeLengthMM = 2*fGridHeightMM;
else
    fAboveGridMM = 25;
    fElectrodeLengthMM = 80;
end

if bHighlight
    afColor = [1 0 1];
else
    afColor = 0.5*[1 0 1];
end

if iNumActiveHoles > 0
    clear astrctMeshElectrode
    for iHoleIter=1:iNumActiveHoles
        
    if strctGridModel.m_aiSubModelInd(aiActiveHoles(iHoleIter)) == 1
        fGridHoleDiameterMM = fHoleDiam1;
    else
        fGridHoleDiameterMM = fHoleDiam2;
    end
    
        astrctMeshElectrode(iHoleIter) = fnCreateRotatedCylinderMesh(...
            strctGridModel.m_apt3fGridHolesNormals(:, aiActiveHoles(iHoleIter))',...
            -strctGridModel.m_afGridHolesX(aiActiveHoles(iHoleIter)),...
            strctGridModel.m_afGridHolesY(aiActiveHoles(iHoleIter)),...
            fGridHoleDiameterMM, -(fElectrodeLengthMM), fAboveGridMM, 6, afColor);
    
    end
    
else
    astrctMeshElectrode = [];
end

% This is correct. Do not change!
astrctMeshMaster = fnBuildCylinderWithPlane(fGridHeightMM, fGrid0InnerDiameterMM, [1 0 0],0, 0, 0, 0,fTheta0Rad,false);
astrctMeshBlue = fnBuildCylinderWithPlane(fGridHeightMM, fGrid1InnerDiameterMM, [0 0 1], fPhi1Rad, -fTheta1Rad, -fShiftX1, fShiftY1,fTheta0Rad,bLongGrid);
astrctMeshGreen = fnBuildCylinderWithPlane(fGridHeightMM, fGrid2InnerDiameterMM, [0 1 0], fPhi2Rad, -fTheta2Rad, -fShiftX2, fShiftY2,fTheta0Rad,bLongGrid);
astrctMesh = [astrctMeshMaster,astrctMeshBlue,astrctMeshGreen,astrctMeshElectrode];

% 
% if bLongGrid
%     % The projection of the grid is portrayed by a rotated cylinder that
%     % points to the grid hole direction
%     afRotationDirection = [1 0 0];
%     fRotationAngle = fGridPhiDeg/180*pi;
%     a2fTrans = eye(4);
%     a2fTrans(1:3,1:3) = fnRotateVectorAboutAxis(afRotationDirection,fRotationAngle);
%     astrctMesh(3) = fnApplyTransformOnMesh( fnCreateCylinderMesh(fGridInnerDiameterMM, -fLongGridMM, 0, 20,[ 0 1 0]),a2fTrans);
% end


if 0
    figure(11);
    clf;hold on;
    H=cla;
    fnDrawMeshIn3D(astrctMesh,H);
    %
    box on
    cameratoolbar show
    axis equal
end
return;





