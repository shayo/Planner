function astrctElectrodeProjectionToTissueBlock=fnProjectElectrodeOnTissueBlock(strctPlanner, iAnatomical, iChamber, iGrid, iTissueBlockSeries)
% Project Electrode trajectory on tissue block.
%global g_strctModule
% Draw chamber, both in 2D and 3D
% if chamber has a grid, draw it as well. 
% if there are electrodes in the grid, draw them as well
strctChamber = strctPlanner.g_strctModule.m_acAnatVol{iAnatomical}.m_astrctChambers(iChamber);

a2fCRS_To_XYZ = strctPlanner.g_strctModule.m_acAnatVol{iAnatomical}.m_a2fReg*strctPlanner.g_strctModule.m_acAnatVol{iAnatomical}.m_a2fM; 
a2fM = a2fCRS_To_XYZ*strctChamber.m_a2fM_vox;

strctGrid = strctChamber.m_astrctGrids(iGrid);

strctGrid.m_strctModel.m_strctGridParams.m_acParam{6}.m_Value = 1;
astrctGridMesh = feval(strctGrid.m_strctGeneral.m_strBuildMesh, strctGrid.m_strctModel,false,true);
% strctGrid.m_strctModel.m_strctGridParams.m_acParam{6}.m_Value = 2;
% astrctGridMesh2 = feval(strctGrid.m_strctGeneral.m_strBuildMesh, strctGrid.m_strctModel,false,true);
% strctGrid.m_strctModel.m_strctGridParams.m_acParam{6}.m_Value = 3;
% astrctGridMesh3 = feval(strctGrid.m_strctGeneral.m_strBuildMesh, strctGrid.m_strctModel,false,true); 
% astrctGridMesh = [astrctGridMesh1,astrctGridMesh2,astrctGridMesh3];


% Drop the first mesh. its the projection of the grid, not electrodes...

a2fGridOffsetTransform = eye(4);
a2fGridOffsetTransform(3,4) = -strctGrid.m_fChamberDepthOffset;
a2fM_WithMeshOffset =a2fM*a2fGridOffsetTransform;
astrctMesh = fnApplyTransformOnMesh(astrctGridMesh,a2fM_WithMeshOffset);


iCounter=1;
clear astrctElectrodeProjectionToTissueBlock;

for iTissueBlockSeries=1:length(strctPlanner.g_strctModule.m_astrctImageSeries)

iNumTissueBlocks = length(strctPlanner.g_strctModule.m_astrctImageSeries(iTissueBlockSeries).m_acImages);
for iTissueBlockIter=1:iNumTissueBlocks
    a2fImagePlaneTo3D = strctPlanner.g_strctModule.m_astrctImageSeries(iTissueBlockSeries).m_a2fImagePlaneTo3D;
    a2fMMtoPix = strctPlanner.g_strctModule.m_astrctImageSeries(iTissueBlockSeries).m_acImages{iTissueBlockIter}.m_a2fMMtoPix;
    a2fResample = strctPlanner.g_strctModule.m_astrctImageSeries(iTissueBlockSeries).m_acImages{iTissueBlockIter}.m_a2fSubSampling;
    
    a2fCrossSection = a2fImagePlaneTo3D;
    a2fCrossSection(1:3,4) = a2fCrossSection(1:3,4) + a2fCrossSection(1:3,3) * strctPlanner.g_strctModule.m_astrctImageSeries(iTissueBlockSeries).m_acImages{iTissueBlockIter}.m_fZOffsetMM;

    afPlane = [a2fCrossSection(1:3,3); -a2fCrossSection(1:3,3)' * a2fCrossSection(1:3,4);];
    iNumMeshes = length(astrctMesh);

    a2fTissueBlockLines = zeros(0,7); % [x1,y1,x2,y2,r,g,b];
    for iMeshIter=1:iNumMeshes
        strctMesh = astrctMesh(iMeshIter);
%         figure(11);clf;hold on; fnDrawMeshIn3D(strctMesh, gca);axis equal
%         
%         [a2fX,a2fY] = meshgrid(-50:50,-50:50);
%         a2fZ = (-afPlane(4)-(a2fX * afPlane(1) + a2fY * afPlane(2)))/afPlane(3);
%         mesh(a2fX,a2fY,a2fZ);
%         
        [a2fLines3D,aiFaces] = fndllMeshPlaneIntersect(afPlane, strctMesh.m_a2fVertices,strctMesh.m_a2iFaces);
        if ~isempty(a2fLines3D)
            % Coordinates 
            iNumLines = size(a2fLines3D,2);
            %strctMesh.m_afColor
            for iLineIter=1:iNumLines
                apt3fLineCoords = [[a2fLines3D(1:3,iLineIter);1],[a2fLines3D(4:6,iLineIter);1]];
                % Project the lines (which should all be on the plane back to
                % tissue block coordinates
                apt2fMMonplane = inv(a2fImagePlaneTo3D) * apt3fLineCoords;
                apt2fMMonPlaneHomo = apt2fMMonplane([1,2,4],:);
                a2fTissueBlockCoordPix= a2fResample * a2fMMtoPix * apt2fMMonPlaneHomo;
                a2fTissueBlockLines(end+1,:) = [a2fTissueBlockCoordPix(1,1),a2fTissueBlockCoordPix(2,1),a2fTissueBlockCoordPix(1,2),a2fTissueBlockCoordPix(2,2), strctMesh.m_afColor];
            end
        end
    end    
    astrctElectrodeProjectionToTissueBlock(iCounter).m_strFileName = strctPlanner.g_strctModule.m_astrctImageSeries(iTissueBlockSeries).m_acImages{iTissueBlockIter}.m_strFileName;
    astrctElectrodeProjectionToTissueBlock(iCounter).m_a2fLines = a2fTissueBlockLines;
    iCounter=iCounter+1;
    % 
end
end