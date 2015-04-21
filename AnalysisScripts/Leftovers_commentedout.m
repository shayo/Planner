 



% 
% function fnAlignToGrid()
%     return;
% global g_strctModule
% iSelectedGrid = get(g_strctModule.m_strctPanel.m_hGridList,'value');
% if isempty(iSelectedGrid) || iSelectedGrid == 0 || isempty(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber).m_astrctGrids)
%     return;
% end;
% strctGrid = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber).m_astrctGrids(iSelectedGrid);
% a2fCRS_To_XYZ = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fReg*g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fM; 
% 
% a2fChamberT = a2fCRS_To_XYZ*g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber).m_a2fM_vox;
% 
% [fDummy,iSelectedHole] = min(strctGrid.m_afGridHolesX.^2+strctGrid.m_afGridHolesY.^2);
% 
% a2fTrans = fnBuildElectrodeTransform(strctGrid.m_afGridHolesX(iSelectedHole), strctGrid.m_afGridHolesY(iSelectedHole), ...
%     strctGrid.m_apt3fGridHolesNormals(iSelectedHole,:), strctGrid.m_fGridThetaDeg, strctGrid.m_fChamberDepthOffset, a2fChamberT);
%      
% 
% g_strctModule.m_strctCrossSectionXY.m_a2fM = a2fTrans;
% 
% g_strctModule.m_strctCrossSectionYZ.m_a2fM(1:3,1:3) = a2fTrans(1:3,[2,3,1]);
% g_strctModule.m_strctCrossSectionYZ.m_a2fM(1:3,4) = a2fTrans(1:3,4);
% g_strctModule.m_strctCrossSectionYZ.m_a2fM(1:3,2)=-g_strctModule.m_strctCrossSectionYZ.m_a2fM(1:3,2);
% g_strctModule.m_strctCrossSectionXZ.m_a2fM(1:3,1:3) = a2fTrans(1:3,[1,3,2]);
% g_strctModule.m_strctCrossSectionXZ.m_a2fM(1:3,4) = a2fTrans(1:3,4);
% g_strctModule.m_strctCrossSectionXZ.m_a2fM(1:3,2)=-g_strctModule.m_strctCrossSectionXZ.m_a2fM(1:3,2);
% 
% fnInvalidate(1);
% return;


%%

% 
% function [fMinDist,fDepthMM,iBestHole,fBestTheta] = fnSearchAllOrientations(strctGrid, a2fChamberM,pt3fTargetPosMM)
% 
% afThetaSearch = -180:180;
% iNumThetas = length(afThetaSearch);
% afMinDist = zeros(1, iNumThetas);
% aiBestHole = zeros(1, iNumThetas); 
% afDepthsMM = zeros(1, iNumThetas);
% hWaitbar = waitbar(0,sprintf('Testing all orientations on grid %s', strctGrid.m_strGridType));
% for iThetaIter = 1:iNumThetas
%     if mod(iThetaIter,5)
%         waitbar(iThetaIter/iNumThetas,hWaitbar);
%     end;
%     strctGrid.m_fGridThetaDeg = afThetaSearch(iThetaIter);
%     [afMinDist(iThetaIter), aiBestHole(iThetaIter),afDepthsMM(iThetaIter)] = ...
%         fnFindNearestHoleToTarget(a2fChamberM,strctGrid,pt3fTargetPosMM);
% end;
% close(hWaitbar);
% [fMinDist, iIndex] = min(afMinDist);
% fDepthMM = afDepthsMM(iIndex);
% iBestHole = aiBestHole(iIndex);
% fBestTheta = afThetaSearch(iIndex);
% 
% return;
% 
% function fnTargetFindHoleWithGridRotation()
% global g_strctModule
% aiCurrTarget = get(g_strctModule.m_strctPanel.m_hTargetList,'value');
% if length(aiCurrTarget) > 1
%     msgbox('This option is available only for one target');
%     return;
% end;
% iCurrTarget = aiCurrTarget(1);
% 
% iSelectedGrid = get(g_strctModule.m_strctPanel.m_hGridList,'value');
% 
% iNumGrids = length(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber).m_astrctGrids);
% if iNumGrids == 0
%     return;
% end;
% 
% 
% a2fCRS_To_XYZ = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fReg*g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fM; 
% pt3fTargetPosMM = a2fCRS_To_XYZ*[g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctTargets(iCurrTarget).m_pt3fPositionVoxel;1];
% 
% strctGrid = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber).m_astrctGrids(iSelectedGrid);
% strctChamber = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber);
% a2fChamberM = a2fCRS_To_XYZ*strctChamber.m_a2fM_vox;
% 
% [fMinDist,fDepthMM,iBestHole,fBestTheta] = fnSearchAllOrientations(strctGrid, a2fChamberM,pt3fTargetPosMM);
% strctGrid.m_abSelected(:) = false;
% 
% fnAddNewGridWithResults(strctGrid, fBestTheta, iBestHole,fDepthMM)
% str1 = sprintf('Minimum distance from electrode tip to target: %.2f mm',fMinDist);
% str2 = sprintf('Grid Orientation: %.2f deg',fBestTheta);
% str3 = sprintf('Depth: %.2f mm',fDepthMM);
% msgbox( {str1,str2,str3},'Result');
% 
% return;


% function fnAddNewGridWithResults(strctGrid, fTheta,iHoleSelected, fDepthMM)
%     return;
% global g_strctModule
% iCurrTarget = get(g_strctModule.m_strctPanel.m_hTargetList,'value');
% 
% % Add a new grid
% strctGrid.m_fGridThetaDeg = fTheta;
% strctGrid.m_strName = [strctGrid.m_strGridType,' Opt for ',g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctTargets(iCurrTarget).m_strName];
% strctGrid.m_abSelected(iHoleSelected) = 1;
% strctGrid.m_afGuideTubeLengthMM(iHoleSelected) = 20;
% strctGrid.m_afElectrodeLengthMM(iHoleSelected) = fDepthMM-strctGrid.m_afGuideTubeLengthMM(iHoleSelected);
% 
% fnAddGridFromStruct(strctGrid);
% fnUpdateGridAxes();
% fnUpdateChamberMIP();
% fnChangePlanarIntersectionToElectrodeTract(strctGrid, iHoleSelected);
% return;
% 
% 


% function fnCalibrateArm()
% global g_strctModule
% g_strctModule.m_iStereoArmSelected = get(g_strctModule.m_strctPanel.m_hStereoArmsList,'value');
% switch g_strctModule.m_astrctStereoTaxticModels(g_strctModule.m_iStereoModelSelected).m_astrctArms(g_strctModule.m_iStereoArmSelected).m_strctRobot.m_strName
%     case 'Kopf 1460 (Left Arm)'
%     case 'Kopf 1460 (Right Arm)'
%     otherwise
%         errordlg('Sorry, I do not know how to calibrate this arm in real time. Please make sure your model is accurate in the config file!','Error');
%         return;
% end
% prompt={'Value of ML when manipulator is at the center of the frame:','Length (in CM) of manipulator when DV is to','is:'};
% name='Arm Calibration';
% numlines=1;
% defaultanswer={'3.38','0','11'};
% answer=inputdlg(prompt,name,numlines,defaultanswer);
% if isempty(answer)
%     return;
% end;
% 
% 
% C1 = 5.43; % Triky to read out...
% INCH_TO_CM = 2.54;
% fDistanceBetweenArms = 7 * INCH_TO_CM;
% fMLReadOutValueWhenManipulatorIsAtCenterOfFrame = str2num(answer{1}); %#ok
% C3 = fDistanceBetweenArms/2 + fMLReadOutValueWhenManipulatorIsAtCenterOfFrame; % Distance of end-effector when everything is set to "zero"
% 
% fDV_Value = str2num(answer{2});
% fHeightOfManipulatorWhenDVx = str2num(answer{3});
% C2 = fHeightOfManipulatorWhenDVx-C1;
%             
% RightArmLinks = [...
% % alpha    A/r       theta	    D      sigma	offset 
%   pi/2       0       pi/2       0       1      0 % First link, prismatic, link  length = AP
%   pi/2       0       0          C1      0     -pi/2 % Second link, rotatory, Z rotation
%   -pi/2      0       0          0       0      0
%   0          0       0          0       0      pi
%   pi/2       0       0         0        1      C2
%   pi/2       0       0          0       1      -C3
%   0          0        0         0       1      C1+C2
%   0          0       0          0       0      pi/2 % Dummy rotational end effector tool 
% ];
% 
%         
 


% function fnMakeMarkersPlanar() %#ok
% global g_strctModule
% iNumMarkers = 8;%length(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers);
% apt3fMarkersVox = ones(4,iNumMarkers);
% a2fCRS_To_XYZ = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fReg*g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fM; 
% for k=1:iNumMarkers
%     apt3fMarkersVox(1:3,k) = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers(k).m_pt3fPosition_vox;
% end
% apt3fMarkersMM = a2fCRS_To_XYZ* apt3fMarkersVox;
% % fit the best plane to the points.
% afBestPlaneD1 = apt3fMarkersMM(1:3,:)' \ -ones(iNumMarkers,1);
% afPlaneNormal=afBestPlaneD1/norm(afBestPlaneD1);
% afDistToPlaneMM = (afBestPlaneD1(1) * apt3fMarkersMM(1,:) + afBestPlaneD1(2) * apt3fMarkersMM(2,:) + afBestPlaneD1(3) * apt3fMarkersMM(3,:) + 1) / norm(afBestPlaneD1);
% 
% apt3fMarkersAdjustedMM = apt3fMarkersMM(1:3,:) - repmat(afDistToPlaneMM,3,1) .* repmat(afPlaneNormal,1,iNumMarkers);
% % Project each marker to the plane...i.e., find the closest point on the
% % plane to each marker.
% %apt3fMarkersAdjustedMM' \ -ones(iNumMarkers,1)
% %afDist = (afBestPlaneD1(1) * apt3fMarkersAdjustedMM(1,:) + afBestPlaneD1(2) * apt3fMarkersAdjustedMM(2,:) + afBestPlaneD1(3) * apt3fMarkersAdjustedMM(3,:) + 1) / norm(afBestPlaneD1)
% 
% for k=1:iNumMarkers
%     pt3fVox = inv(a2fCRS_To_XYZ) *[apt3fMarkersAdjustedMM(:,k);1]; %#ok
%     g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers(k).m_pt3fPosition_vox = pt3fVox(1:3);
% end
% fnInvalidate(1);
% return;





% function fnUpdateElectrodeCrossSection()
% global g_strctModule
% 
% 
% g_strctModule.m_strctCrossSectionEL.m_fHalfHeightMM = 40;
% a2fXYZ_To_CRS = inv(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fM) * inv(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fReg);    
% a2fXYZ_To_CRS_Func = inv(g_strctModule.m_acFuncVol{g_strctModule.m_iCurrFuncVol}.m_a2fM) * inv(g_strctModule.m_acFuncVol{g_strctModule.m_iCurrFuncVol}.m_a2fReg); % HERE
% [a2fCrossSectionEL, apt3fPlanePointsEL] = ...
%         fnResampleCrossSectionMod(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a3fVol, ...
%         a2fXYZ_To_CRS, g_strctModule.m_strctCrossSectionEL);
% a2fCrossSectionEL_Trans = fnContrastTransform(a2fCrossSectionEL, g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_strctContrastTransform);
% 
% a2fCrossSectionEL_Func = fnResampleCrossSectionMod(g_strctModule.m_acFuncVol{g_strctModule.m_iCurrFuncVol}.m_a3fVol, ...
%     a2fXYZ_To_CRS_Func, g_strctModule.m_strctCrossSectionEL);
% 
% [a3fEL_Func, a2fEL_Alpha] = fnOverlayContrastTransform(a2fCrossSectionEL_Func);
% a3fCrossSectionEL = ((1-fnDup3(a2fEL_Alpha)) .* fnDup3(a2fCrossSectionEL_Trans)) + fnDup3(a2fEL_Alpha) .* a3fEL_Func;
% figure(10);
% clf;
% imshow(a3fCrossSectionEL,[]);
% 
% Q(:,:,1) = a3fCrossSectionEL(:,:,1)';
% Q(:,:,2) = a3fCrossSectionEL(:,:,2)';
% Q(:,:,3) = a3fCrossSectionEL(:,:,3)';
% 
% A = zeros(3,3,3);
% A(1,2,1) = 1;
% A(1,3,2) = 1;
% set(g_strctModule.m_strctPanel.m_strctElectrode.m_hImage,'cdata',Q);
% 
% return;
% 




% 
% 
% function fnUpdateChamberAndGridContoursAux(strctChamber,strStrctField, strctCrossSection)
% global g_strctModule
% 
% strctAxes = getfield(g_strctModule.m_strctPanel,strStrctField);
% 
% if ~isfield(strctAxes,'m_ahChamber')
%     strctAxes.m_ahChamber = [];
% else
%     delete(strctAxes.m_ahChamber(ishandle(strctAxes.m_ahChamber)));
%     strctAxes.m_ahChamber = [];
% end;
% if isempty(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers)
%     setfield(g_strctModule.m_strctPanel,strStrctField,strctAxes);
%     return;
% end;
% 
% %  Build Chamber model and draw it
% if ~isfield(strctChamber.m_strctChamberParams,'m_strManufacterer')
%     strctChamber.m_strctChamberParams.m_strManufacterer = 'Crist'; % Backward compatability
% end
% 
% switch strctChamber.m_strctChamberParams.m_strManufacterer
%     case 'Crist'
%         astrctMesh = fnBuildCristChamberModel(strctChamber.m_strctChamberParams);
%     case 'Plastic1'
%         astrctMesh = fnBuildCannulaChamberModel(strctChamber.m_strctChamberParams);
% end
% 
% ahHandles =[];
% for iMeshIter=1:length(astrctMesh)
%     strctMesh = astrctMesh(iMeshIter);
%     if sum(strctMesh.m_ahDoNotDrawAxes == strctAxes.m_hAxes) == 0
%         % First, transform mesh to XYZ reference frame
%         Tmp = strctChamber.m_a2fM*[strctMesh.m_a2fVertices; ones(1,size(strctMesh.m_a2fVertices,2))];
%         strctMesh.m_a2fVertices = Tmp(1:3,:);
%         % Now, intersect with cross-section
%         a2fLinesPix = fnMeshCrossSectionIntersection(strctMesh, strctCrossSection);
%         if ~isempty(a2fLinesPix)
%             ahHandles(end+1) = fnPlotLinesAsSinglePatch(strctAxes.m_hAxes, a2fLinesPix, strctMesh.m_afColor);
%         end;
%     end;
% end;
% 
% % Build Grid Model and draw it...
% if g_strctModule.m_iCurrGrid > 0
%     strctGrid = strctChamber.m_astrctGrids(g_strctModule.m_iCurrGrid);
% 
%     astrctMesh = fnBuildGridModel(strctGrid);
%     for iMeshIter=1:length(astrctMesh)
%         strctMesh = astrctMesh(iMeshIter);
%         if sum(strctMesh.m_ahDoNotDrawAxes == strctAxes.m_hAxes) == 0
%             % First, transform mesh to XYZ reference frame
%             Tmp = strctChamber.m_a2fM*[strctMesh.m_a2fVertices; ones(1,size(strctMesh.m_a2fVertices,2))];
%             strctMesh.m_a2fVertices = Tmp(1:3,:);
%             % Now, intersect with cross-section
%             a2fLinesPix = fnMeshCrossSectionIntersection(strctMesh, strctCrossSection);
%             if ~isempty(a2fLinesPix)
%                 ahHandles(end+1) = fnPlotLinesAsSinglePatch(strctAxes.m_hAxes, a2fLinesPix, strctMesh.m_afColor);
%             end;
%         end;
%     end;
% 
%     
%     
%     % Draw grid DIRECTION in chamber...
%     
%    
% %     
% %     if g_strctModule.m_strctGUIOptions.m_bLongGrid
% % 
% %         
% %         afNormal =[0, sin( strctGrid.m_fGridPhiDeg/180*pi), -cos(strctGrid.m_fGridPhiDeg/180*pi)];
% %         a2fTrans = fnBuildElectrodeTransform(0, 0, afNormal, strctGrid.m_fGridThetaDeg,    strctGrid.m_fChamberDepthOffset,...
% %         strctChamber.m_a2fM,[0 0 -1]);
% %         strctMesh = strctChamber.m_strct3DModel.m_astrctMesh(iMeshIter);
% %         Tmp = a2fTrans*[strctMesh.m_a2fVertices; ones(1,size(strctMesh.m_a2fVertices,2))];
% %         strctMesh.m_a2fVertices = Tmp(1:3,:);
% %         % Now, intersect with cross-section
% %         a2fLinesPix = fnMeshCrossSectionIntersection(strctMesh, strctCrossSection);
% %         if ~isempty(a2fLinesPix)
% %             ahHandles(end+1) = fnPlotLinesAsSinglePatch(strctAxes.m_hAxes, a2fLinesPix, [0 1 0]);
% %         end;
% %     end
%     
%     
%     aiUsedElectrodes = find(strctGrid.m_abSelected);
% 
%     if ~isempty(aiUsedElectrodes)
%         [astrctMesh] = fnBuildElectrodeMesh(strctChamber, g_strctModule.m_iCurrGrid);
%         for iMeshIter=1:length(astrctMesh)
%             a2fLinesPix = fnMeshCrossSectionIntersection(astrctMesh(iMeshIter), strctCrossSection);
%             if ~isempty(a2fLinesPix)
%                 ahHandles(end+1) = fnPlotLinesAsSinglePatch(strctAxes.m_hAxes, a2fLinesPix, astrctMesh(iMeshIter).m_afColor);
%             end;
%             
%         end;
%     end;
% end;
% 
% strctAxes.m_ahChamber = ahHandles;
% eval(['g_strctModule.m_strctPanel.',strStrctField,'.m_ahChamber = ahHandles;']);
% 
% 
% 
% return;



    
% 
% 







% function fnChangePlanarIntersectionToElectrodeTract(strctGrid, iSelectedHole)
%     
% global g_strctModule
% return;
% % Change crosshair to visualize a specified electrode track
% a2fCRS_To_XYZ = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fReg*g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fM; 
% a2fChamberT = a2fCRS_To_XYZ*g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber).m_a2fM_vox;
% 
% a2fTrans = fnBuildElectrodeTransform(...
%     strctGrid.m_strctModel.m_afGridHolesX(iSelectedHole), ...
%     strctGrid.m_strctModel.m_afGridHolesY(iSelectedHole), ...
%     strctGrid.m_strctModel.m_apt3fGridHolesNormals(iSelectedHole,:), ...
%     strctGrid.m_fGridThetaDeg,...
%     strctGrid.m_fChamberDepthOffset,...   
%     a2fChamberT);
% 
% 
% afElectrodeDirection =a2fTrans(1:3,3);
% pt3fNewCenter = a2fTrans(1:3,4);
% 
% 
% %[afV1,afV2] = fnGramSchmidt(afElectrodeDirection);
% afV1 = a2fTrans(1:3,1);
% afV2 = a2fTrans(1:3,2);
% 
% % This will align the blue cross sections (XY) to CHAMBER coordinates
% a2fTrans = eye(4);
% a2fTrans(1:3,4) = a2fChamberT(1:3,4);
% a2fR = fnRotateVectorAboutAxis(a2fChamberT(1:3,3),pi);
% a2fR3D = eye(4);
% a2fR3D(1:3,1:3) = a2fR;
% a2fTrans(1:3,1)=-a2fTrans(1:3,1);
% g_strctModule.m_strctCrossSectionXY.m_a2fM =  a2fTrans* a2fR3D * inv(a2fTrans) * a2fChamberT;
% 
% % This will align the blue cross section (XY) to electrode direction
% 
% g_strctModule.m_strctCrossSectionYZ.m_a2fM(1:3,1:3) = [afV1, afElectrodeDirection, afV2];
% g_strctModule.m_strctCrossSectionYZ.m_a2fM(1:3,4) = pt3fNewCenter;
% g_strctModule.m_strctCrossSectionXZ.m_a2fM(1:3,1:3) = [afV2, afElectrodeDirection, afV1];
% g_strctModule.m_strctCrossSectionXZ.m_a2fM(1:3,4) = pt3fNewCenter;
% 
% 
% % Set the Electrode cross section....
% %g_strctModule.m_strctCrossSectionEL.m_a2fM = g_strctModule.m_strctCrossSectionYZ.m_a2fM;
% 
% fnInvalidate();
% return







% 
% function astrctMesh = fnBuildElectrodeMesh(strctGrid, a2fM)
% % Build a mesh for all selected electrodes
% aiSelectedElectrodes = find(strctGrid.m_abSelected);
% iNumSelected = length(aiSelectedElectrodes);
% if iNumSelected == 0
%     astrctMesh = [];
%     return;
% end;
% for iIter=1:iNumSelected
%     fGuideTubeLengthMM = strctGrid.m_afGuideTubeLengthMM(aiSelectedElectrodes(iIter));
%     fElectrodeLengthMM = strctGrid.m_afElectrodeLengthMM(aiSelectedElectrodes(iIter));
%   
%     strctMeshGT = fnCreateCylinderMesh(strctGrid.m_afGridHolesDiameterMM(aiSelectedElectrodes(iIter)), -fGuideTubeLengthMM,0, 6,[0 1 1]);
%     strctMeshElectrode = fnCreateCylinderMesh(strctGrid.m_afGridHolesDiameterMM(aiSelectedElectrodes(iIter)), -(fGuideTubeLengthMM+fElectrodeLengthMM),...
%         25, 6,[1 0 1]); % Show 25 mm above the chamber ... easier to detect if in contrast...
%     fGridHoleX = strctGrid.m_afGridHolesX(aiSelectedElectrodes(iIter));
%     fGridHoleY = strctGrid.m_afGridHolesY(aiSelectedElectrodes(iIter));
%      afNormal =  strctGrid.m_apt3fGridHolesNormals(aiSelectedElectrodes(iIter),:);
%     strctMeshGT = fnTransformElectrodeMeshToVolume(strctMeshGT, ...
%         fGridHoleX, fGridHoleY, afNormal, strctGrid.m_fGridThetaDeg,strctGrid.m_fChamberDepthOffset,...
%    a2fM);
%     
%     strctMeshElectrode = fnTransformElectrodeMeshToVolume(strctMeshElectrode, ...
%         fGridHoleX,  fGridHoleY, afNormal,strctGrid.m_fGridThetaDeg,strctGrid.m_fChamberDepthOffset,...
%     a2fM);
%         astrctMesh(2*(iIter-1)+1) = strctMeshGT;
%         astrctMesh(2*(iIter-1)+2) = strctMeshElectrode;
%  end;
% 
% return;

%function strctMesh = fnTransformElectrodeMeshToVolume(strctMesh, fX, fY, afNorm, fGridTheta, fDepthOffset, a2fChamberM)
%a2fTrans = fnBuildElectrodeTransform(fX, fY, afNorm, fGridTheta, fDepthOffset, a2fChamberM);
%apt2fVertices = a2fTrans * [strctMesh.m_a2fVertices;ones(1,size(strctMesh.m_a2fVertices,2))];
%strctMesh.m_a2fVertices = apt2fVertices(1:3,:);
%
%return




% function a2fNew = fnRotateAboutSameAxis(a2fM, fAngle) 
% a2fTrans = eye(4);
% a2fTrans(1:3,4) = -a2fM(1:3,4);
% a2fRot = eye(4);
% a2fRot(1:3,1:3) = fnRotateVectorAboutAxis(a2fM(1:3,3),fAngle);
% a2fTrans2 = eye(4);
% a2fTrans2(1:3,4) = a2fM(1:3,4);
% a2fNew =a2fTrans2*a2fRot*a2fTrans*a2fM;
% return;
% 

% function fnSetRes(iResolution) %#ok
% global g_strctModule
% g_strctModule.m_strctCrossSectionXY.m_iResHeight = iResolution;
% g_strctModule.m_strctCrossSectionXY.m_iResWidth = iResolution;
% axis(g_strctModule.m_strctPanel.m_strctXY.m_hAxes,[0.5  iResolution 0.5 iResolution]);
% 
% g_strctModule.m_strctCrossSectionYZ.m_iResHeight = iResolution;
% g_strctModule.m_strctCrossSectionYZ.m_iResWidth = iResolution;
% axis(g_strctModule.m_strctPanel.m_strctYZ.m_hAxes,[0.5  iResolution 0.5 iResolution]);
% 
% g_strctModule.m_strctCrossSectionXZ.m_iResHeight = iResolution;
% g_strctModule.m_strctCrossSectionXZ.m_iResWidth = iResolution;
% axis(g_strctModule.m_strctPanel.m_strctXZ.m_hAxes,[0.5  iResolution 0.5 iResolution]);
% fnInvalidate();
% return;
% 

% 
% function fnAddAvgTimeCourse()
% global g_strctModule
% 
% if g_strctModule.m_iCurrFuncVol == 0
%     return;
% end;
% 
% [strFuncFile, strPath] = uigetfile([g_strctModule.m_strDefaultFilesFolder,'*.bhdr;*.nii'],'Select 4D Functional Volume');
% if strFuncFile(1) == 0
%     return;
% end;
% strInputVolfile = [strPath,strFuncFile];
% % 
% % [strFile, strPath] = uigetfile([g_strctModule.m_strDefaultFilesFolder,'*.reg;*.dat'],'Select registeration');
% % if strFile(1) == 0
% %     % no registeration available?
%  strInputRegfile = 'Missing';
% a2fRegisteration = [1 0 0 0;
%     0 1 0 0;
%     0 0 1 0;
%     0 0 0 1];
% afVoxelSpacing = [1 1 1]; % unknown...
% % else
% %     strInputRegfile = [strPath,strFile];
% %     [a2fRegisteration, strSubjectName, strVolType,afVoxelSpacing] = fnReadRegisteration(strInputRegfile);    
% % end;
% 
% strctVol = MRIread(strInputVolfile);
% 
% if size(strctVol.vol,4) <= 1
%     msgbox('This is not a 4D volume...','Error');
%     return;
% end;
% 
% g_strctModule.m_acFuncVol{g_strctModule.m_iCurrFuncVol}.m_a4fTimeCourse = strctVol.vol;
% 
% return;







% 
% function [Tmp,afGridXRot,afGridYRot,afCos,afSin,ahHandles] = fnUpdateGridAxesAux(hAxes,strctGrid)
% global g_strctModule
%     afAngle = linspace(0,2*pi,20);
% afCos = cos(afAngle);
% afSin= sin(afAngle);
% 
% % Draw grid inner diameter
% fEffectiveDiameterMM = 2*1.2*(max( sqrt(strctGrid.m_afGridHolesX.^2+strctGrid.m_afGridHolesY.^2)));
% %hold(hAxes,'off');
% ahHandles(1) = plot(hAxes, ...
%     afCos*fEffectiveDiameterMM/2,...
%     afSin*fEffectiveDiameterMM/2,'m','LineWidth',2,'uicontextmenu',g_strctModule.m_strctPanel.m_hGridAxesMenu);
% %hold(hAxes,'on');
% %grid(hAxes,'on');
% 
% ahHandles(2) = plot(hAxes, ...
%     [0 0],[0 fEffectiveDiameterMM/2],'y','LineWidth',2,'uicontextmenu',g_strctModule.m_strctPanel.m_hGridAxesMenu);
% 
% fRotAngle = strctGrid.m_fGridThetaDeg/180*pi;
% a2fR = [cos(fRotAngle) sin(fRotAngle)
%         -sin(fRotAngle) cos(fRotAngle)];
% Tmp = a2fR * [strctGrid.m_afGridHolesX';strctGrid.m_afGridHolesY'];
% 
% afGridXRot = Tmp(1,:);
% afGridYRot = Tmp(2,:);
% 
% 
% Tmp2 = a2fR * [0;fEffectiveDiameterMM/2];
% ahHandles(3) = plot(hAxes, ...
%     [0 Tmp2(1)],[0, Tmp2(2)],'g','LineWidth',2,'uicontextmenu',g_strctModule.m_strctPanel.m_hGridAxesMenu);
% 
% iNumHoles = length(strctGrid.m_afGridHolesX);
% for iHoleIter=1:iNumHoles
%     if strctGrid.m_abSelected(iHoleIter)
%         ahHandles(3+iHoleIter) =  fill(afGridXRot(iHoleIter) + afCos*strctGrid.m_afGridHolesDiameterMM(iHoleIter)/2,...
%             afGridYRot(iHoleIter) + afSin*strctGrid.m_afGridHolesDiameterMM(iHoleIter)/2,...
%             'm','parent',hAxes,'uicontextmenu',g_strctModule.m_strctPanel.m_hGridAxesMenu);
%     else
%     ahHandles(3+iHoleIter) = plot(hAxes, ...
%             afGridXRot(iHoleIter) + afCos*strctGrid.m_afGridHolesDiameterMM(iHoleIter)/2,...
%             afGridYRot(iHoleIter) + afSin*strctGrid.m_afGridHolesDiameterMM(iHoleIter)/2,...
%             'color',[0.5 0.5 0.5],'uicontextmenu',g_strctModule.m_strctPanel.m_hGridAxesMenu);
%          
%     end;    
% end;
% 
% return;


% 
% function a2fTrans = fnBuildElectrodeTransform(fX, fY, afNorm, fGridThetaDeg, fGridOffset, a2fChamberM)
% % T0 rotates the mesh such that it is aligned with the hole normal direction
% [afV1,afV2]=fnGramSchmidt(-afNorm);
% a2fR = [afV1',afV2',-afNorm(:)];
% 
% a2fT0 = eye(4);
% a2fT0(1:3,1:3) = a2fR;
% % T1 Translates the mesh to the correct grid hole
% a2fT1 = eye(4);
% a2fT1(1,4) = -fX;
% a2fT1(2,4) = fY;
% % T2 rotates the mesh to the desired grid orientation (relative to chamber
% a2fT2 = eye(4);
% a2fT2(1:2,1:2) =  [cos(fGridThetaDeg/180*pi), -sin(fGridThetaDeg/180*pi);
%                    sin(fGridThetaDeg/180*pi),cos(fGridThetaDeg/180*pi)];
% % T3 lowers the grid by the given offset              
% a2fT3 = eye(4);               
% a2fT3(3,4) = -fGridOffset;
% 
% a2fTrans = a2fChamberM * a2fT3 * a2fT2 * a2fT1 * a2fT0 ;
% return;























% 
% function fnDrawModel(strctModel)
% for iMeshIter=1:length(strctModel.m_astrctMesh)
%  A.vertices = strctModel.m_astrctMesh(iMeshIter).m_a2fVertices'; A.faces = strctModel.m_astrctMesh(iMeshIter).m_a2iFaces'; 
% patch(A,'facecolor',strctModel.m_astrctMesh(iMeshIter).m_afColor);    
% end;
% return;



% function fnUpdateMarkerAxes()
% global g_strctModule
% cla(g_strctModule.m_strctPanel.hMarkersAxes);
% if isfield(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol},'m_astrctMarkers') 
%     iNumMarkers = length(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers);
%     if  iNumMarkers  > 0
%     
%     apt3fMarkersPosition = zeros(3,iNumMarkers);
%     for k=1:iNumMarkers 
%         apt3fMarkersPosition(:,k) = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers(k).m_pt3fPositionMM;
%     end
%     plot(g_strctModule.m_strctPanel.hMarkersAxes,apt3fMarkersPosition(1,:),apt3fMarkersPosition(2,:),'r.')
%     fMinX = min(apt3fMarkersPosition(1,:));
%     fMaxX = max(apt3fMarkersPosition(1,:));
%     fMinY = min(apt3fMarkersPosition(2,:));
%     fMaxY = max(apt3fMarkersPosition(2,:));
%     iPadding = 10;
%     set(g_strctModule.m_strctPanel.hMarkersAxes,'xlim',[fMinX-iPadding iPadding+fMaxX],...
%         'ylim',[fMinY-iPadding iPadding+fMaxY]);
%     for k=1:iNumMarkers
%         text(apt3fMarkersPosition(1,k),apt3fMarkersPosition(2,k),num2str(k),'parent',g_strctModule.m_strctPanel.hMarkersAxes,'fontweight','bold');
%     end
%     iSelectedMarker = get(g_strctModule.m_strctPanel.m_hMarkersList,'value');
%     plot(g_strctModule.m_strctPanel.hMarkersAxes,apt3fMarkersPosition(1,iSelectedMarker),...
%         apt3fMarkersPosition(2,iSelectedMarker),'go','MarkerSize',15)
%     text(fMinX-iPadding, fMinY-iPadding,'Posterior Left', 'parent',g_strctModule.m_strctPanel.hMarkersAxes,'color','b');
%     text(fMinX-iPadding, fMaxY+iPadding-2,'Anterior Left', 'parent',g_strctModule.m_strctPanel.hMarkersAxes,'color','b');
%     else
%         
%     end
% end
% 
% return













% 
% function fnHandleMouseMoveOnGridAxes(strctMouseOp)
% global g_strctModule
% 
% if ~isfield(g_strctModule.m_strctPanel.m_strctGrid,'m_hCurrGridHole') || isempty(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers)
%     return;
% end;
% 
% iSelectedGrid = get(g_strctModule.m_strctPanel.m_hGridList,'value');
% if isempty(iSelectedGrid)
%     return;
% end;
% 
% iNumGrids = length(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber).m_astrctGrids);
% if iNumGrids == 0
%     return;
% end;
% strctGrid = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber).m_astrctGrids(iSelectedGrid);
% % % Find out whether the mouse click is inside a hole
% % 
% 
% fRotAngle = strctGrid.m_fGridThetaDeg/180*pi;
% a2fR = [cos(fRotAngle) sin(fRotAngle)
%         -sin(fRotAngle) cos(fRotAngle)];
% Tmp = a2fR * [strctGrid.m_afGridHolesX';strctGrid.m_afGridHolesY'];
% afGridXRot = Tmp(1,:);
% afGridYRot = Tmp(2,:);
% 
% [fDistance, iNearestHole ] = min(sqrt((afGridXRot - strctMouseOp.m_pt2fPos(1)).^2 + (afGridYRot - strctMouseOp.m_pt2fPos(2)).^2 ));
% if  fDistance< strctGrid.m_afGridHolesDiameterMM(iNearestHole)/2
%     iSelectedHole = iNearestHole;
% else
%     iSelectedHole = [];
% end
% if ~isempty(iSelectedHole )
%     
%     a2fR3D = eye(3);
%     a2fR3D(1:2,1:2)=a2fR;
%     g_strctModule.m_iSelectedHole = iSelectedHole;
%     afNormalRotated = a2fR3D * strctGrid.m_apt3fGridHolesNormals(iSelectedHole,:)';
%     if norm(afNormalRotated(1:2)) > 1e-5
%         fEffectiveRadius = 1.2*max( sqrt(strctGrid.m_afGridHolesX.^2+strctGrid.m_afGridHolesY.^2));
%         afNormalRotated2D = afNormalRotated(1:2) ./ norm(afNormalRotated(1:2));
%         % Solve for intersection direction.
%         % (x0+t*vx)^2+(y0+t*vy)^2=r^2
%         % x0^2 + 2*x0*t*vx + t^2*vx^2 + 
%         % y0^2 + 2*y0*t*yx + t^2*vy^2  = r^2
%         % t^2(vx^2+vy^2) + t*(2*x0*vx+2*y0*vy)+x0^2+y0^2-r^2=0
%         % t^2 + t*2*(x0*vx+y0*vy) + x0^2+y0^2-r^2
%         % a = 1, b = 2*(x0*vx+y0*vy), c= x0^2+y0^2-r^2
%         % t = ( -b += sqrt(b^2-4*a*c)) / (2*a)
%         b = 2* (afNormalRotated2D' * [afGridXRot(iSelectedHole), afGridYRot(iSelectedHole)]');
%         c = afGridXRot(iSelectedHole).^2+ afGridYRot(iSelectedHole).^2 - (fEffectiveRadius)^2;
%         
%         t = max( ( -b + sqrt(b^2-4*c))/2, ( -b - sqrt(b^2-4*c))/2); % We are searching for the positive solution
%         pt2iIntersectionWithCircle = [afGridXRot(iSelectedHole),afGridYRot(iSelectedHole)]+t*afNormalRotated2D';
%         
%         set(g_strctModule.m_strctPanel.m_strctGrid.m_hCurrGridHoleDir,'xdata',...
%             [afGridXRot(iSelectedHole), pt2iIntersectionWithCircle(1)],...
%             'ydata',[afGridYRot(iSelectedHole) pt2iIntersectionWithCircle(2)],'marker','none','visible','on');
% 
%         
%     else
%         g_strctModule.m_iSelectedHole = [];
%         set(g_strctModule.m_strctPanel.m_strctGrid.m_hCurrGridHoleDir,'xdata',afGridXRot(iSelectedHole),...
%             'ydata',afGridYRot(iSelectedHole),'marker','.','visible','on');
%     end;
%     
%     
% %     
% %     iXPos = round(strctGrid.m_afGridHolesX(iSelectedHole) / strctGrid.m_afGridHolesDiameterMM(iSelectedHole));
% %     iYPos = round(strctGrid.m_afGridHolesY(iSelectedHole) / strctGrid.m_fGridHoleDistanceMM);
% %     
% %     if iXPos >= 0
% %         strXPos = ['E ',num2str(iXPos)];
% %     elseif iXPos < 0
% %         strXPos = ['W ',num2str(-iXPos)];
% %     end;
% %     
% %     if iYPos >= 0
% %         strYPos = ['N ',num2str(iYPos)];
% %     elseif iYPos < 0
% %         strYPos = ['S ',num2str(-iYPos)];
% %     end;
%     
% %     iCurrTarget = get(g_strctModule.m_strctPanel.m_hTargetList,'value');
% %     if ~isempty(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctTargets) && ~isempty(iCurrTarget) &&  length(iCurrTarget) == 1 && ...
% %             iCurrTarget <= length(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctTargets) && (g_strctModule.m_iCurrChamber > 0)
% %         
% %         pt3fCurrTarget = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctTargets(iCurrTarget).m_pt3fPositionMM;
% %         a2fChamberT = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber).m_a2fM;
% %         
% %         a2fTrans = fnBuildElectrodeTransform(strctGrid.m_afGridX(iSelectedHole), strctGrid.m_afGridY(iSelectedHole), ...
% %             strctGrid.m_apt3fGridNormals(iSelectedHole,:), strctGrid.m_fGridThetaDeg,   strctGrid.m_fChamberDepthOffset,...
% %         a2fChamberT,[0 0 -1]);
% %         
% %         pt3fStart = a2fTrans(1:3,4);
% %         afDirection = -a2fTrans(1:3,3);
% %         [fDistanceToTarget, pt3fClosestPointOnLine, fDepthToTarget] = fnPointLineDist3D(pt3fStart, afDirection, pt3fCurrTarget);
% %      else
%          fDistanceToTarget = 0;
%         fDepthToTarget = 0;
% %     end;
%     
%     
%     afTheta = linspace(0,2*pi,20);
%    afCos = cos(afTheta);
%    afSin = sin(afTheta);
% 	set(g_strctModule.m_strctPanel.m_strctGrid.m_hCurrGridHole,...
%         'xdata',afGridXRot(iSelectedHole) + afCos*strctGrid.m_afGridHolesDiameterMM(iSelectedHole)/2,...
%         'ydata',afGridYRot(iSelectedHole) + afSin*strctGrid.m_afGridHolesDiameterMM(iSelectedHole)/2,...
%         'visible','on','LineWidth',2);
%     %set(g_strctModule.m_strctPanel.m_strctGrid.m_hCurrGridHoleTextInfo,'string',...
%     %    sprintf('GT %.1f EL %.1f',strctGrid.m_afGuideTubeLengthMM(iSelectedHole),strctGrid.m_afElectrodeLengthMM(iSelectedHole) ));
%     
%     strExactPos = sprintf('(%.2f, %.2f)',strctGrid.m_afGridHolesX(iSelectedHole),strctGrid.m_afGridHolesY(iSelectedHole));
%     set(g_strctModule.m_strctPanel.m_strctGrid.m_hCurrGridHoleTextInfo,'string',...
%         sprintf('Target: %.1f, Depth %.1f', fDistanceToTarget, fDepthToTarget));
%     %set(g_strctModule.m_strctPanel.m_strctGrid.m_hCurrGridHoleTextPos,'string',[strXPos,' ',strYPos,' ',strExactPos]);
%     set(g_strctModule.m_strctPanel.m_strctGrid.m_hCurrGridHole,'visible','on');
%     set(g_strctModule.m_strctPanel.m_strctGrid.m_hCurrGridHoleDir,'visible','on');
%     
% else
%     set(g_strctModule.m_strctPanel.m_strctGrid.m_hCurrGridHole,'visible','off');
%     set(g_strctModule.m_strctPanel.m_strctGrid.m_hCurrGridHoleTextInfo,'string','');
%     set(g_strctModule.m_strctPanel.m_strctGrid.m_hCurrGridHoleTextPos,'string','');
%     set(g_strctModule.m_strctPanel.m_strctGrid.m_hCurrGridHoleDir,'visible','off');
% 
% end
% 
% return





% 
% function fnUnconformFuncVol()
% global g_strctModule
% 
% if g_strctModule.m_iCurrFuncVol == 0
%     return;
% end;
% 
% prompt={'New Row voxel spacing',...
%     'New Col voxel spacing', ...
%     'New Slice voxel spacing'};
% name='New Resolution';
% numlines=1;
% defaultanswer={'0.5','0.5','0.5'};
% 
% answer=inputdlg(prompt,name,numlines,defaultanswer);
% if isempty(answer)
%     return;
% end;
% afVoxelSpacing = [str2num(answer{2}), str2num(answer{1}), str2num(answer{3})]; %#ok
% 
% a2fTrans = [afVoxelSpacing(1) 0 0 0;
%             0 afVoxelSpacing(2) 0 0 ;
%             0 0 afVoxelSpacing(3) 0;
%             0 0 0 1];
%         
% g_strctModule.m_acFuncVol{g_strctModule.m_iCurrFuncVol}.m_a2fReg = ...
% a2fTrans * g_strctModule.m_acFuncVol{g_strctModule.m_iCurrFuncVol}.m_a2fReg;
% 
% %g_strctModule.m_strctFuncVol = g_strctModule.m_acFuncVol{g_strctModule.m_iCurrFuncVol};
% 
% fnInvalidate(true);
% 
% 
% return;

% function fnUnconformAnatVol()
% global g_strctModule
% 
% if g_strctModule.m_iCurrAnatVol == 0
%     return;
% end;
% prompt={'New Row voxel spacing',...
%     'New Col voxel spacing', ...
%     'New Slice voxel spacing'};
% name='New Resolution';
% numlines=1;
% defaultanswer={'0.5','0.5','0.5'};
% 
% answer=inputdlg(prompt,name,numlines,defaultanswer);
% if isempty(answer)
%     return;
% end;
% afVoxelSpacing = [str2num(answer{2}), str2num(answer{1}), str2num(answer{3})];
% aiSize = size(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a3fVol);
% 
% g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_afVoxelSpacing = afVoxelSpacing;
% 
% a2fTrans = [afVoxelSpacing(1) 0 0 0;
%             0 afVoxelSpacing(2) 0 0 ;
%             0 0 afVoxelSpacing(3) 0;
%             0 0 0 1];
% 
% g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_strctFreeSurfer.volres =   afVoxelSpacing;      
% g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fReg = ...
%         a2fTrans * g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fReg ;
% 
% g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_strctCrossSectionHoriz.m_fHalfWidthMM = ...
% g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_strctCrossSectionHoriz.m_fHalfWidthMM * afVoxelSpacing(1);
% g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_strctCrossSectionHoriz.m_fHalfHeightMM = ...
% g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_strctCrossSectionHoriz.m_fHalfHeightMM * afVoxelSpacing(2);
% 
% g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_strctCrossSectionSaggital.m_fHalfWidthMM = ...
% g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_strctCrossSectionSaggital.m_fHalfWidthMM * afVoxelSpacing(1);
% g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_strctCrossSectionSaggital.m_fHalfHeightMM = ...
% g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_strctCrossSectionSaggital.m_fHalfHeightMM * afVoxelSpacing(2);
% 
% 
% g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_strctCrossSectionCoronal.m_fHalfWidthMM = ...
% g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_strctCrossSectionCoronal.m_fHalfWidthMM * afVoxelSpacing(1);
% g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_strctCrossSectionCoronal.m_fHalfHeightMM = ...
% g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_strctCrossSectionCoronal.m_fHalfHeightMM * afVoxelSpacing(2);
%     
% % Update iso-surface 
% %g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol} = fnCreateIsoSurface(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol});
%         
% % XYZ = [-dc 0 0   dc*Nc/2 ]   [c]
% %       [0   0 ds -ds*Ns/2 ] * [r]
% %       [0 -dr 0   dr*Nr/2 ]   [s]
% %       [0   0 0       1   ]   [1]
% 
% fnSetCurrAnatVol();
% fnUpdateSurfacePatch();
% fnSetDefaultCrossSections();%g_strctModule.m_strctPanel.m_aiImageRes(2),g_strctModule.m_strctPanel.m_aiImageRes(1));
% fnInvalidate(true);
% return;
% 
%%
% 
% function [iSelectedHole]=fnSelectGridHoleAux(strctGrid,strctMouseOp)
% global g_strctModule
% % Find out whether the mouse click is inside a hole
% 
% fRotAngle = strctGrid.m_fGridThetaDeg/180*pi;
% a2fR = [cos(fRotAngle) sin(fRotAngle)
%         -sin(fRotAngle) cos(fRotAngle)];
% Tmp = a2fR * [strctGrid.m_afGridHolesX';strctGrid.m_afGridHolesY'];
% afGridXRot = Tmp(1,:);
% afGridYRot = Tmp(2,:);
% 
% 
% [fDistance, iNearestHole ] = min(sqrt((afGridXRot - strctMouseOp.m_pt2fPos(1)).^2 + (afGridYRot - strctMouseOp.m_pt2fPos(2)).^2 ));
% if  fDistance< strctGrid.m_afGridHolesDiameterMM(iNearestHole)/2
%     iSelectedHole = iNearestHole;
% else
%     iSelectedHole = [];
% end
% return;

% function fnSelectGridHole(strctMouseOp)
% global g_strctModule
% iSelectedGrid = get(g_strctModule.m_strctPanel.m_hGridList,'value');
% if isempty(iSelectedGrid) || iSelectedGrid == 0 || isempty(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber).m_astrctGrids)
%     return;
% end;
% strctGrid = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber).m_astrctGrids(iSelectedGrid);
% 
%  [iSelectedHole]=fnSelectGridHoleAux(strctGrid,strctMouseOp);
% if ~isempty(iSelectedHole)
%     g_strctModule.m_iLastSelectedGridHole = iSelectedHole;
% 
%     if strcmp(strctMouseOp.m_strButton,'Left')
%         strctGrid.m_abSelected(iSelectedHole) = ~strctGrid.m_abSelected(iSelectedHole);
%         g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber).m_astrctGrids(iSelectedGrid) = strctGrid;
%         fnUpdateGridAxes();
%         fnInvalidate();
%     end;
% end;
% 
% 
% return;


% 
% function fnSetDepth()
% global g_strctModule
% answer=inputdlg({'Current Depth'},'Depth',1,{num2str(0)});
% if ~isempty(answer)
%     g_strctModule.m_fCurrentDepth = str2num(answer{1});
% end;
% fnSetViewtoRecordingDepth();
% return;
% 
% function fnSetViewtoRecordingDepth()
% global g_strctModule
% % Change crosshair to visualize a specified electrode track
% a2fChamberT = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber).m_a2fM;
% iSelectedGrid = get(g_strctModule.m_strctPanel.m_hGridList,'value');
% strctGrid = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber).m_astrctGrids(iSelectedGrid);
% 
% iSelectedHole = g_strctModule.m_iLastSelectedGridHole;
% a2fTrans = fnBuildElectrodeTransform(...
%     strctGrid.m_afGridX(iSelectedHole), ...
%     strctGrid.m_afGridY(iSelectedHole), ...
%     strctGrid.m_apt3fGridNormals(iSelectedHole,:), ...
%    strctGrid.m_fGridThetaDeg,...
%    strctGrid.m_fChamberDepthOffset,...
%     a2fChamberT,[0 0 1]);
% 
% afElectrodeDirection =a2fTrans(1:3,3);
% pt3fNewCenter = a2fTrans(1:3,4) + afElectrodeDirection * g_strctModule.m_fCurrentDepth;
% g_strctModule.m_strctCrossSectionXZ.m_a2fM(1:3,4) = pt3fNewCenter;
% g_strctModule.m_strctCrossSectionYZ.m_a2fM(1:3,4) = pt3fNewCenter;
% g_strctModule.m_strctCrossSectionXY.m_a2fM(1:3,4) = pt3fNewCenter;
% %set(g_strctModule.m_strctPanel.m_strctXY.m_hCurrentDepthText,'String',sprintf('%.3f',g_strctModule.m_fCurrentDepth));
% fnInvalidate(1);
% 
% return;


% function fnTrack()
% global g_strctModule
% return;
% 




%%

% 
% 
% 
% function fnSetMarkerRightArm()
% global g_strctModule
% iSelectedMarker = get(g_strctModule.m_strctPanel.m_hMarkersList,'value');
% if length(iSelectedMarker) > 1
%     return;
% end;
% if ~isempty(iSelectedMarker) && iSelectedMarker > 0 && isfield(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol},'m_astrctMarkers')
%     if g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers(iSelectedMarker).m_bLeftArm == true
%          g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers(iSelectedMarker).m_bLeftArm = false;
%          set(g_strctModule.m_strctPanel.m_hLeftArmMarkerSelect,'value',0);
%     else
%          g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers(iSelectedMarker).m_bLeftArm = false;
%          set(g_strctModule.m_strctPanel.m_hRightArmMarkerSelect,'value',1);
%     end
% end
% fnSelectMarker();
% return;
% 
% function fnSetMarkerLeftArm()
% global g_strctModule
% iSelectedMarker = get(g_strctModule.m_strctPanel.m_hMarkersList,'value');
% if length(iSelectedMarker) > 1
%     return;
% end;
% if ~isempty(iSelectedMarker) && iSelectedMarker > 0 && isfield(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol},'m_astrctMarkers')
%     if g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers(iSelectedMarker).m_bLeftArm  == false
%          g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers(iSelectedMarker).m_bLeftArm = true;
%          set(g_strctModule.m_strctPanel.m_hRightArmMarkerSelect,'value',0);
%     else
%          g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers(iSelectedMarker).m_bLeftArm = true;
%          set(g_strctModule.m_strctPanel.m_hLeftArmMarkerSelect,'value',1);
%     end
% end
% fnSelectMarker();
% return;
% 
% function fnRotMidlineEdit()
% global g_strctModule
% iSelectedMarker = get(g_strctModule.m_strctPanel.m_hMarkersList,'value');
% if length(iSelectedMarker) > 1
%     return;
% end;
% if ~isempty(iSelectedMarker) && iSelectedMarker > 0 && isfield(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol},'m_astrctMarkers')
%  g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers(iSelectedMarker).m_fMidlineRotation_Value = ...
%      str2num(get(g_strctModule.m_strctPanel.m_hRotMidlineEdit,'string'));
% end
% fnSelectMarker();
% return;
% 
% 
% function fnSetMarkerRot3()
% global g_strctModule
% iSelectedMarker = get(g_strctModule.m_strctPanel.m_hMarkersList,'value');
% if length(iSelectedMarker) > 1
%     return;
% end;
% if ~isempty(iSelectedMarker) && iSelectedMarker > 0 && isfield(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol},'m_astrctMarkers')
%     X = str2num(get(g_strctModule.m_strctPanel.m_hRot3Edit,'string'));
%     if (X ~= 0 && X ~= 90 && X ~= -90 && X ~= 180)
%         set(g_strctModule.m_strctPanel.m_hRot3Edit,'string',0);
%         errordlg('Values can only be [0,90,-90,180]');
%         g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers(iSelectedMarker).m_fRot3_Value = 0;
%         return;
%     end;
% 
%  g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers(iSelectedMarker).m_fRot3_Value = X;
% end
% fnSelectMarker();
% return;
% 
% function fnRotHeightEdit()
% global g_strctModule
% iSelectedMarker = get(g_strctModule.m_strctPanel.m_hMarkersList,'value');
% if length(iSelectedMarker) > 1
%     return;
% end;
% if ~isempty(iSelectedMarker) && iSelectedMarker > 0 && isfield(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol},'m_astrctMarkers')
%  g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers(iSelectedMarker).m_fHeightRotation_Value = ...
%      str2num(get(g_strctModule.m_strctPanel.m_hRotHeightEdit,'string'));
% end
% fnSelectMarker();
% return;
% 
% 
% 
% 
% 
% function fnEditMarkerAP()
% global g_strctModule
% iSelectedMarker = get(g_strctModule.m_strctPanel.m_hMarkersList,'value');
% if length(iSelectedMarker) > 1
%     return;
% end;
% if ~isempty(iSelectedMarker) && iSelectedMarker > 0 && isfield(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol},'m_astrctMarkers')
%  g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers(iSelectedMarker).m_fAP_Value = ...
%      str2num(get(g_strctModule.m_strctPanel.m_hAPEdit,'string'));
% end
% fnSelectMarker();
% return;
% 
% function fnEditMarkerMidLine()
% global g_strctModule
% iSelectedMarker = get(g_strctModule.m_strctPanel.m_hMarkersList,'value');
% if length(iSelectedMarker) > 1
%     return;
% end;
% if ~isempty(iSelectedMarker) && iSelectedMarker > 0 && isfield(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol},'m_astrctMarkers')
%  g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers(iSelectedMarker).m_fMidline_Value = ...
%      str2num(get(g_strctModule.m_strctPanel.m_hMidLineEdit,'string'));
% end
% fnSelectMarker();
% return;
% 
% function fnEditMarkerZ()
% global g_strctModule
% iSelectedMarker = get(g_strctModule.m_strctPanel.m_hMarkersList,'value');
% if length(iSelectedMarker) > 1
%     return;
% end;
% if ~isempty(iSelectedMarker) && iSelectedMarker > 0 && isfield(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol},'m_astrctMarkers')
%  g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers(iSelectedMarker).m_fZ_Value = ...
%      str2num(get(g_strctModule.m_strctPanel.m_hZEdit,'string'));
% end
% fnSelectMarker();
% return;
% 

% 
% 
% 
% function abValidArmConf = fnIsValidArmConf(Arm, afCong)
% 
% g_strctModule.m_astrctStereoTaxticModels(iModelSelected).m_astrctArms(iArmSelected)
% 
% abValidArmConf =  q(:,1) >= -10 & q(:,1) <= 10 & q(:,5) >= -0.1 & q(:,5) <= 8 & q(:,6) >= -0.1 & q(:,6) <= 8;
% return;
% 


% 
% function fnComputeStereoTaticRegisterationAux2()
% global g_strctModule
% 
% % Aggregate values
% if ~isfield(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol},'m_astrctMarkers') 
%     return;
% end;
% iNumMarkers = length(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers);
% if iNumMarkers < 4
%     return;
% end;
% 
% %% Forward Kinematics. Compute coordinates from read out values
% 
% apt3fMarkersStereoTaticCoord = zeros(3,iNumMarkers);
% apt3fMarkersMRIMetricCoord = zeros(3,iNumMarkers);
% 
% % The convension says: [X,Y,Z] = [MidLine, AP, Z]
% for k=1:iNumMarkers
%     strctMarker = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers(k);
%     
%     % Build the configuration from readout values...
%     q = [strctMarker.m_fAP_Value, ...
%          strctMarker.m_fHeightRotation_Value/180*pi,...
%          strctMarker.m_fMidlineRotation_Value/180*pi,...
%          strctMarker.m_fZ_Value,...
%          strctMarker.m_fMidline_Value,...
%          0,0];
%     
%      if strctMarker.m_bLeftArm
%          T = fkine(g_strctModule.m_strctKopfLeftArm,q);
%      else
%          T = fkine(g_strctModule.m_strctKopfRightArm,q);
%      end
%      
%     apt3fMarkersStereoTaticCoord(:,k) = T(1:3,4);
%     
%     apt3fMarkersMRIMetricCoord(:,k) = strctMarker.m_pt3fPositionMM;
% end
% 
% %% Absolute Orienation Problem
% % Find the mapping FROM MRI coordinate system TO Stereotatic
% [s, R, T, err] = fnAbsoluteOrientation( apt3fMarkersMRIMetricCoord, apt3fMarkersStereoTaticCoord, 0, 0.1);
% %  apt3fMarkersStereoTaticCoord = s * R* apt3fMarkersMRIMetricCoord + T
% % We assume s = 0.1, since measurements are in cm... 
% 
% a2fTrans = [s*R, T;0,0,0,1];
% g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fRegToStereoTactic = a2fTrans;
% %fprintf('Average Residual Error %.3f mm\n',10*err);
% 
% %% Compute Chamber Center and Direction in Stereotactic coordinates
% % Now, compute the position of the chamber in stereotatic coordinate
% iSelectedChamber = get(g_strctModule.m_strctPanel.m_hChambersList,'value');
% if isempty(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers)
%     return;
% end;
% pt3fChamberPosInMRICoord = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(iSelectedChamber).m_a2fM(1:3,4);
% pt3fChamberPosInStereoTactic = a2fTrans * [pt3fChamberPosInMRICoord;1];
% 
% a2fChamberInMRI = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(iSelectedChamber).m_a2fM;
% a2fChamberInMRI(1:3,3) = -a2fChamberInMRI(1:3,3);
% a2fChamberInStereoTacticCoord =  a2fTrans * a2fChamberInMRI;
% 
% a2fChamberInStereoTacticCoord(1:3,1:3) = a2fChamberInStereoTacticCoord(1:3,1:3) * 10;
% 
% %% Solve the inverse Kinematic problem
% q_right = ikine_mod(g_strctModule.m_strctKopfRightArm, a2fChamberInStereoTacticCoord, [0 0 0 0 0 1 0]);
% q_left = ikine_mod(g_strctModule.m_strctKopfLeftArm, a2fChamberInStereoTacticCoord, [0 0 0 0 0 1 0]);
% 
% % Test whether the solution is correct...
% abReachableRight = zeros(1,3);
% if q_right(1) >= -10 && q_right(1) <= 10
%     abReachableRight(1) = 1;
% end
% if q_right(4) >= 0 && q_right(4) <= 8
%     abReachableRight(3) = 1; % z
% end
% if q_right(5) >= 0 && q_right(5) <= 8
%     abReachableRight(2) = 1; % z
% end 
% 
% abReachableLeft = zeros(1,3);
% if q_left(1) >= -10 && q_left(1) <= 10
%     abReachableLeft(1) = 1;
% end
% if q_left(4) >= 0 && q_left(4) <= 8
%     abReachableLeft(3) = 1; % z
% end
% if q_left(5) >= 0 && q_left(5) <= 8
%     abReachableLeft(2) = 1; % z
% end 
% fprintf('RIGHT: Error: %.3f mm, [%d %d %d], [%.2f %.2f %.2f]\n',10*err,...
%     abReachableRight(1),abReachableRight(2),abReachableRight(3),q_right(1),q_right(4),q_right(5));
% 
% fprintf('LEFT : Error: %.3f mm, [%d %d %d], [%.2f %.2f %.2f]\n',10*err,...
%     abReachableLeft(1),abReachableLeft(2),abReachableLeft(3), q_left(1),q_left(4),q_left(5));
% 
% return;
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% %%
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 



% function fnAutomaticChamberAxes()
% global g_strctModule
% % Automatic direction alignment ?
% switch g_strctModule.m_strctMouseOpMenu.m_hAxes 
%     case g_strctModule.m_strctPanel.m_strctXY.m_hAxes
%         % Transform the clicked point to 3D coordinates
%         % Set default chamber pose (position = click, rotation from plane)
%        
%         a2fXYZ_To_CRS = inv(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fM) * inv(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fReg); 
%         % Create a local region
%         
%         pt3fCenterVolume = fnCrossSection_Image_To_MM_3D(g_strctModule.m_strctCrossSectionXY, g_strctModule.m_strctMouseOpMenu.m_pt2fPos);
%         iHeightZmm = 4;
%         iNumSlices = ceil(iHeightZmm/min(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_afVoxelSpacing ));
%         if mod(iNumSlices,2) == 0
%             iNumSlices = iNumSlices + 1;
%         end
%         
%         afOffsetFromZ = linspace(-iHeightZmm/2,iHeightZmm/2,iNumSlices);
%         
%         a3fLocalVolume = zeros(128,128,iNumSlices);
% 
%        strctZoomCrossSection.m_iResWidth = 128;
%        strctZoomCrossSection.m_iResHeight = 128;
%        strctZoomCrossSection.m_fHalfWidthMM = 1.5;
%        strctZoomCrossSection.m_fHalfHeightMM = 1.5;
%         
%        a2fXmm = zeros(128,128,iNumSlices); 
%        a2fYmm = zeros(128,128,iNumSlices);
%        a2fZmm = zeros(128,128,iNumSlices);
%        
%         for iSliceIter=1:iNumSlices
%             a2fM = eye(4);
%             a2fM(1:3,1:3) = g_strctModule.m_strctCrossSectionXY.m_a2fM(1:3,1:3);
%             a2fM(1:3,4) = pt3fCenterVolume+  g_strctModule.m_strctCrossSectionXY.m_a2fM(1:3,3) * afOffsetFromZ(iSliceIter);
%             strctZoomCrossSection.m_a2fM = a2fM;
%             [a3fLocalVolume(:,:,iSliceIter),fDummy,a2fXmm(:,:,iSliceIter),a2fYmm(:,:,iSliceIter),a2fZmm(:,:,iSliceIter)] =...
%                 fnResampleCrossSection(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a3fVol, a2fXYZ_To_CRS,strctZoomCrossSection); %#ok
%         end
%         
%         iMiddleSlice = (iNumSlices+1)/2;
%         fMeanIntensity = a3fLocalVolume(64-2:64+2,64-2:64+2, iMiddleSlice);
%         fThreshold = mean(fMeanIntensity(:)) - 4*std(fMeanIntensity(:));
%         a3bLocalVolume = fnMyClose(a3fLocalVolume>fThreshold,3);
%         a3iLocalVolume = bwlabeln(a3bLocalVolume);
%         Tmp = a3iLocalVolume(64-2:64+2,64-2:64+2, iMiddleSlice-2:iMiddleSlice+2);
%         aiCount=histc(Tmp(Tmp>0),1:max(Tmp(:)));
%         [fDummy,iSelectedComponent]=max(aiCount); %#ok
%         a3bInside = a3iLocalVolume==iSelectedComponent; 
%      
%         afX = a2fXmm(a3bInside);
%         afY = a2fYmm(a3bInside);
%         afZ = a2fZmm(a3bInside);
%         
%         afDirections = [afX-mean(afX),afY-mean(afY),afZ-mean(afZ)];
%         a2fTmp = afDirections'*afDirections;
%         [U,V]=eig(a2fTmp); %#ok
%         afOptDirection = U(:,3);
%         [afDir2,afDir3]=fnGramSchmidt(afOptDirection);
%         a2fNewPos = eye(4);
%         a2fNewPos(1:3,4) = [mean(afX),mean(afY),mean(afZ)];
%         a2fNewPos(1:3,1:3) = [afDir2,afDir3,afOptDirection];
%         fnAddChamberAux(a2fNewPos);
% 
%          
%        
%     case g_strctModule.m_strctPanel.m_strctYZ.m_hAxes
%         a2fM(1:3,1:3) = g_strctModule.m_strctCrossSectionYZ.m_a2fM(1:3,1:3);
%         a2fM(1:3,4) = fnCrossSection_Image_To_MM_3D(g_strctModule.m_strctCrossSectionYZ, g_strctModule.m_strctMouseOpMenu.m_pt2fPos);
%     case g_strctModule.m_strctPanel.m_strctXZ.m_hAxes        
%         a2fM(1:3,1:3) = g_strctModule.m_strctCrossSectionXZ.m_a2fM(1:3,1:3);
%         a2fM(1:3,4) = fnCrossSection_Image_To_MM_3D(g_strctModule.m_strctCrossSectionXZ, g_strctModule.m_strctMouseOpMenu.m_pt2fPos);
% end;
% 
% return;
