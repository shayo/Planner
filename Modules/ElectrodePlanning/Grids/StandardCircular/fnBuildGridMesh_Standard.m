function astrctMesh = fnBuildGridMesh_Standard(strctGridModel, bDrawShort,bHighlight)
clear astrctMesh
if ~exist('bHighlight','var')
    bHighlight = false;
end;

fGridHoleDiameterMM = fnGetGridParameter(strctGridModel.m_strctGridParams,'HoleDiam');
fOffsetX = fnGetGridParameter(strctGridModel.m_strctGridParams,'OffsetX');
fOffsetY = fnGetGridParameter(strctGridModel.m_strctGridParams,'OffsetY');
fGridHoleDistanceMM = fnGetGridParameter(strctGridModel.m_strctGridParams,'HoleDist');
fGridInnerDiameterMM = fnGetGridParameter(strctGridModel.m_strctGridParams,'GridInnerDiam');
fGridThetaRad = fnGetGridParameter(strctGridModel.m_strctGridParams,'Theta') /180*pi;
fGridPhiDeg = fnGetGridParameter(strctGridModel.m_strctGridParams,'Phi');
fGridHeightMM = fnGetGridParameter(strctGridModel.m_strctGridParams,'GridHeight');
bLongGrid = fnGetGridParameter(strctGridModel.m_strctGridParams,'LongGrid');

if bDrawShort
    fAboveGridMM = 0;
    bLongGrid = false;
    fElectrodeLengthMM = 2*fGridHeightMM;
else
    fAboveGridMM = 25;
    fLongGridMM = 80;
    fElectrodeLengthMM = 80;
end

iNumActiveHoles = sum(strctGridModel.m_strctGridParams.m_abSelectedHoles);
aiActiveHoles = find(strctGridModel.m_strctGridParams.m_abSelectedHoles);


if iNumActiveHoles > 0
    clear astrctMeshElectrode
    
    if bHighlight
        afColor = [1 0 1];
    else
        afColor = 0.5*[1 0 1];
    end
    
    
    a2fElectrodeColors = [0,0,255;
                          0,162,232;
                          0,255,0;
                          0,255,0;
                          255,140,0];
   
afBlue = [0,176,240]/255;
afGreen = [0,176,80]/255;
afOrange = [255,192,0]/255;
afPurple = [0.54 0.09 1];
afCyan = [64,255,191]/255;
afDarkBlue = [0,0,191]/255;
                   
    for iHoleIter=1:iNumActiveHoles
        if aiActiveHoles(iHoleIter)  == 50
            afColor = afBlue;
        elseif aiActiveHoles(iHoleIter)  == 79
            afColor = afGreen;
        elseif aiActiveHoles(iHoleIter)  == 96
            afColor = afOrange;
        else
            afColor = afPurple;
        end
          astrctMeshElectrode(iHoleIter) = fnCreateRotatedCylinderMesh(...
            strctGridModel.m_apt3fGridHolesNormals(:, aiActiveHoles(iHoleIter))',...
            -strctGridModel.m_afGridHolesX(aiActiveHoles(iHoleIter)),...
            strctGridModel.m_afGridHolesY(aiActiveHoles(iHoleIter)),...
            fGridHoleDiameterMM, -(fElectrodeLengthMM), fAboveGridMM, 6,afColor);
    
    end
else
    astrctMeshElectrode = [];
end

astrctMeshMaster = fnBuildCylinderWithPlane(fGridHeightMM, fGridInnerDiameterMM, [1 0 0],fGridPhiDeg/180*pi, 0, 0, 0,fGridThetaRad,bLongGrid);
astrctMesh=[astrctMeshMaster,astrctMeshElectrode];

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
