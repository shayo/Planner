function astrctMesh = fnBuildGridMesh_GenericCircular(strctGridModel, bDrawShort,bHighlight)
clear astrctMesh
if ~exist('bHighlight','var')
    bHighlight = false;
end;

iNumGroups = length(strctGridModel.m_strctGridParams.m_acGroupNames);
astrctMesh = [];

for iGroupIter=1:iNumGroups
    
    iHoleInGroup = find(strctGridModel.m_strctGridParams.m_aiGroupAssignment == iGroupIter,1,'first');
    afNormal = strctGridModel.m_apt3fGridHolesNormals(:,iHoleInGroup);
    afGroupColor = strctGridModel.m_strctGridParams.m_a2fGroupColor(:,iGroupIter);
    
    % Analyze the sub-groups...
    if isfield(strctGridModel,'m_acGroupBoundaries')
        iNumSubGroups = length(strctGridModel.m_acGroupBoundaries{iGroupIter});
        for iSubGroupIter=1:iNumSubGroups
            iNumPts = size(strctGridModel.m_acGroupBoundaries{iGroupIter}{iSubGroupIter},2);
            P0=[strctGridModel.m_acGroupBoundaries{iGroupIter}{iSubGroupIter}; zeros(1,iNumPts)]';
            if bDrawShort
                P1 = P0 + repmat(afNormal',iNumPts,1) *  strctGridModel.m_strctGridParams.m_fGridHeightMM;
            else
                P1 = P0 + repmat(afNormal',iNumPts,1) *  100;
            end
            strctMesh= fnCreateMeshFromTwoPolygons(P0, P1, afGroupColor);
            astrctMesh = [astrctMesh,strctMesh];
        end
    end

end

% Now place electrodes...
if bDrawShort
    fAboveGridMM = 0;
    fElectrodeLengthMM = 2*fGridHeightMM;
else
    fAboveGridMM = 25;
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
    fGridHoleDiameterMM = strctGridModel.m_strctGridParams.m_fGridHoleDiameterMM;
    for iHoleIter=1:iNumActiveHoles
        afNrm = strctGridModel.m_apt3fGridHolesNormals(:, aiActiveHoles(iHoleIter))';
           astrctMeshElectrode(iHoleIter) = fnCreateRotatedCylinderMesh(...
            afNrm,...
           -strctGridModel.m_afGridHolesX(aiActiveHoles(iHoleIter)),...
            strctGridModel.m_afGridHolesY(aiActiveHoles(iHoleIter)),...
            fGridHoleDiameterMM, -(fElectrodeLengthMM), fAboveGridMM, 6,afColor);
    
    end
else
    astrctMeshElectrode = [];
end
astrctMesh = [astrctMesh,astrctMeshElectrode];


return;

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
    
    for iHoleIter=1:iNumActiveHoles
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
