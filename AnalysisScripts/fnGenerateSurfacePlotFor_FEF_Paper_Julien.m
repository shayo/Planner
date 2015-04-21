function fnGenerateSurfacePlotFor_FEF_Paper_Julien()
% strSessionName = 'D:\Data\Doris\Planner\Julien\Julien_Session_For_Optogenetics_Publication.mat';
% PlannerAPI('StartPlanner');
% bSuccessful = PlannerAPI('LoadSession', strSessionName);

% 1. Load White matter surface
strRH_Root = 'D:\Data\Doris\Planner\Julien\100219Julien - New Reference\RH Surfaces\';
    
strWhiteMatterFile = [strRH_Root,'rh.white'];
strPialFile = [strRH_Root,'rh.pial'];
strInflatedFile = [strRH_Root,'rh.inflated'];
strCurvatureFile = [strRH_Root,'rh.curv'];
strThicknessFile = [strRH_Root,'rh.thickness'];

iAnatomicalVolumeIndex = 1;

iSelectedROI = [];

TestPlannerAPI_FunctionalOverlaySurfacesAux(22,strWhiteMatterFile,strPialFile,strInflatedFile,strCurvatureFile,strThicknessFile,iAnatomicalVolumeIndex,'120503Julien_300uA_E-G',iSelectedROI,-9,-3)
fnGenerateSurfacePlotFor_FEF_Paper_CameraView(0);
fnGenerateSurfacePlotFor_FEF_Paper_CameraView(2);

TestPlannerAPI_FunctionalOverlaySurfacesAux(23,strWhiteMatterFile,strPialFile,strInflatedFile,strCurvatureFile,strThicknessFile,iAnatomicalVolumeIndex,'120503Julien_300uA_O-G',iSelectedROI,-9,-3)
fnGenerateSurfacePlotFor_FEF_Paper_CameraView(0);
fnGenerateSurfacePlotFor_FEF_Paper_CameraView(2);

TestPlannerAPI_FunctionalOverlaySurfacesAux(24,strWhiteMatterFile,strPialFile,strInflatedFile,strCurvatureFile,strThicknessFile,iAnatomicalVolumeIndex,'120503Julien_300uA_OE-G',iSelectedROI,-9,-3)
fnGenerateSurfacePlotFor_FEF_Paper_CameraView(0);
fnGenerateSurfacePlotFor_FEF_Paper_CameraView(2);

TestPlannerAPI_FunctionalOverlaySurfacesAux(25,strWhiteMatterFile,strPialFile,strInflatedFile,strCurvatureFile,strThicknessFile,iAnatomicalVolumeIndex,'120503Julien_300uA_OE-E',iSelectedROI,-9,-3)
fnGenerateSurfacePlotFor_FEF_Paper_CameraView(0);
fnGenerateSurfacePlotFor_FEF_Paper_CameraView(2);

TestPlannerAPI_FunctionalOverlaySurfacesAux(26,strWhiteMatterFile,strPialFile,strInflatedFile,strCurvatureFile,strThicknessFile,iAnatomicalVolumeIndex,'120621_Ocont-G',iSelectedROI,-5,-3)
fnGenerateSurfacePlotFor_FEF_Paper_CameraView(0);
fnGenerateSurfacePlotFor_FEF_Paper_CameraView(2);

strLH_Root = 'D:\Data\Doris\Planner\Julien\100219Julien - New Reference\LH Surfaces\LH\';

strWhiteMatterFile = [strLH_Root,'lh.white'];
strPialFile = [strLH_Root,'lh.pial'];
strInflatedFile = [strLH_Root,'lh.inflated'];
strCurvatureFile = [strLH_Root,'lh.curv'];
strThicknessFile = [strLH_Root,'lh.thickness'];


TestPlannerAPI_FunctionalOverlaySurfacesAux(122,strWhiteMatterFile,strPialFile,strInflatedFile,strCurvatureFile,strThicknessFile,iAnatomicalVolumeIndex,'120613-14_3Cond_E-G',iSelectedROI,-5,-3)
fnGenerateSurfacePlotFor_FEF_Paper_CameraView(1);
fnGenerateSurfacePlotFor_FEF_Paper_CameraView(3);

TestPlannerAPI_FunctionalOverlaySurfacesAux(123,strWhiteMatterFile,strPialFile,strInflatedFile,strCurvatureFile,strThicknessFile,iAnatomicalVolumeIndex,'120613-14_3Cond_O-G',iSelectedROI,-5,-3)
fnGenerateSurfacePlotFor_FEF_Paper_CameraView(1);
fnGenerateSurfacePlotFor_FEF_Paper_CameraView(3);

TestPlannerAPI_FunctionalOverlaySurfacesAux(124,strWhiteMatterFile,strPialFile,strInflatedFile,strCurvatureFile,strThicknessFile,iAnatomicalVolumeIndex,'120613-14_3Cond_OE-G',iSelectedROI,-5,-3)
fnGenerateSurfacePlotFor_FEF_Paper_CameraView(1);
fnGenerateSurfacePlotFor_FEF_Paper_CameraView(3);

TestPlannerAPI_FunctionalOverlaySurfacesAux(125,strWhiteMatterFile,strPialFile,strInflatedFile,strCurvatureFile,strThicknessFile,iAnatomicalVolumeIndex,'120613-14_3Cond_OE-E',iSelectedROI,-5,-3)
fnGenerateSurfacePlotFor_FEF_Paper_CameraView(1);
fnGenerateSurfacePlotFor_FEF_Paper_CameraView(3);

TestPlannerAPI_FunctionalOverlaySurfacesAux(126,strWhiteMatterFile,strPialFile,strInflatedFile,strCurvatureFile,strThicknessFile,iAnatomicalVolumeIndex,'120621_Ocont-G',iSelectedROI,-5,-3)
fnGenerateSurfacePlotFor_FEF_Paper_CameraView(1);
fnGenerateSurfacePlotFor_FEF_Paper_CameraView(3);

return;

function  TestPlannerAPI_FunctionalOverlaySurfacesAux(hFig,strWhiteMatterFile,strPialFile,strInflatedFile,strCurvatureFile,strThicknessFile,iAnatomicalVolumeIndex,strSelectedFunctional,iSelectedROI, fSigThresLow,fSigThresHigh)
%%

strctMeshWhite = fnReadSurfWrapper(strWhiteMatterFile, true);
strctMeshPial = fnReadSurfWrapper(strPialFile, true);
strctMeshInflated = fnReadSurfWrapper(strInflatedFile, true);
% 2. Read Thickness
 afThicknessMM=read_curv(strThicknessFile);
 afCurvature = read_curv(strCurvatureFile);
% 3.  Iterate over triangles. Per triangle, sample between -1mm to
% thickness and find the maximal activation (minimum p-value).
[a2fVerticesNormals, a2fTriangleNormals] = fnGetMeshNormals(strctMeshWhite);
iNumVertices = size(strctMeshWhite.m_a2fVertices,2);
iNumFaces = size(strctMeshWhite.m_a2iFaces,2);
% 3.2 Obtain the transformation from X,Y,Z back to I,J,K for the functional
% volume.
a2fXYZ_To_IJK_Func = PlannerAPI('GetFuncXYZ_To_IJK',strSelectedFunctional);
a3fPValues= PlannerAPI('GetFuncVol',strSelectedFunctional);
if ~isempty(iSelectedROI)
    [a3bROI, a2fCRS_To_XYZ]= PlannerAPI('GetROI_Volume_By_Index',iAnatomicalVolumeIndex,iSelectedROI);
    [abROI_Vertices, abROI_Faces]= fnProjectROIToSurface(strctMeshWhite, afThicknessMM, a3bROI, inv(a2fCRS_To_XYZ));
end
 
 % 3.3 Sample values along a line.
afMinPValue = zeros(1,iNumVertices);
afMaxPValue = zeros(1,iNumVertices);
afMeanPValue = zeros(1,iNumVertices);
for iVertexIter=1:iNumVertices
    if mod(iVertexIter,10000)==0
        fprintf('%.1f%% ',iVertexIter/iNumVertices*1e2);
    end;
    afLine = 0:0.1: afThicknessMM(iVertexIter);
    % Build the coordinates to sample.
    apt3fLineMM = [strctMeshWhite.m_a2fVertices(1,iVertexIter) + a2fVerticesNormals(1,iVertexIter) * afLine;
                                 strctMeshWhite.m_a2fVertices(2,iVertexIter) + a2fVerticesNormals(2,iVertexIter) * afLine;       
                                 strctMeshWhite.m_a2fVertices(3,iVertexIter) + a2fVerticesNormals(3,iVertexIter) * afLine];
    apt3fLineVox = a2fXYZ_To_IJK_Func * [apt3fLineMM;ones(1,size(apt3fLineMM,2))];
    % Resample bilinear interpolation
    afValues = fndllFastInterp3(a3fPValues, 1+apt3fLineVox(1,:),1+apt3fLineVox(2,:),1+apt3fLineVox(3,:));
    afMinPValue(iVertexIter) = min(afValues);
    afMaxPValue(iVertexIter) = min(afValues);
    afMeanPValue(iVertexIter) = mean(afValues);
end
fprintf('Done!\n');
%%
% Map P value to vertices colors using some colormap....
strctOverlay.m_pt2fLeft= [fSigThresLow 1];  % For Negative values.
strctOverlay.m_pt2fRight= [fSigThresHigh 0];
strctOverlay.m_pt2fLeftPos= [-fSigThresHigh 0]; % For positive values...
strctOverlay.m_pt2fRightPos= [-fSigThresLow 1];
[a2fColors,afAlpha]=fnOverlayTransformAux(afMinPValue, strctOverlay);


% afDarkGray = [0.6 0.6 0.6];
% afBrightGray = [0.8 0.8 0.8];
a2fGray = ones(size(a2fColors))*0.9;
a2fGray(afCurvature>0,:) = 0.3;
a2fGray(afCurvature<=0,:) = 0.8;
a2fFinalColors = a2fColors .* [afAlpha',afAlpha',afAlpha'] + a2fGray .* 1-[afAlpha',afAlpha',afAlpha'] ;
a2fFinalColors(afAlpha>0.3,:) = a2fColors(afAlpha>0.3,:);




% Now visualize things using inflated volume
% 
% iSelectedGridHole = 1;
% [a2fGridPoints, a2fDirection]=PlannerAPI('GetGridHolesDirectionsMM',2,1,2);
% [aiIntersectingTriangles, apt3fIntersectionPoints,afDistanceFromP0] =fnMeshLineIntersection(strctMeshPial,a2fGridPoints(:,iSelectedGridHole), a2fDirection(:,iSelectedGridHole));

%aiIntersectingTriangles, apt3fIntersectionPoints,afDistanceFromP0

strctMeshOfInterest =strctMeshInflated;%strctMeshPial; % strctMeshInflated

strctIsoXYZ.vertices =strctMeshOfInterest.m_a2fVertices';
strctIsoXYZ.faces = strctMeshOfInterest.m_a2iFaces';
figure(hFig);
clf;
hSurface = patch(strctIsoXYZ);
set(hSurface,'facecolor','interp','FaceVertexCData',a2fFinalColors,'edgecolor','none','facealpha',1);
cameratoolbar('show');
cameratoolbar('setmode','orbit')
cameratoolbar('SetCoordSys','none');
axis equal
LIGHTING flat  %	Position = [1 0 1]

hAxes = gca; 
  axis ij
  hold on;

%   h=light(gca);
% h=light
%   lightangle(h,90,45);
% 
%   h
% [aiUsedVertices,A,aiMapToUnique] = unique(  strctMeshOfInterest.m_a2iFaces(:,aiIntersectingTriangles));
%   
% 
% set(gcf,'color',[1 1 1])
% axis off
% % Morph between pial and inflated?
% iNumMorphSteps = 100;
% a2fDist = strctMeshInflated.m_a2fVertices-strctMeshPial.m_a2fVertices;
% afStep = linspace(0,1,iNumMorphSteps);
% for k=1:iNumMorphSteps
%     a3fNewPoints = strctMeshPial.m_a2fVertices +  a2fDist * afStep(k) ;
%     set(hSurface,'Vertices', a3fNewPoints');
%     drawnow
% end
% 
% strctIsoXYZ_Small.vertices =strctMeshOfInterest.m_a2fVertices';
% strctIsoXYZ_Small.faces = strctMeshOfInterest.m_a2iFaces(:,aiIntersectingTriangles)';
% hSurfaceSmall = patch(strctIsoXYZ_Small);
% set(hSurfaceSmall,'facecolor','g','edgecolor','none');
% 
% strctIsoXYZ_ROI.vertices =strctMeshOfInterest.m_a2fVertices';
% strctIsoXYZ_ROI.faces = strctMeshOfInterest.m_a2iFaces(:,abROI_Faces)';
% hSurfaceSmall = patch(strctIsoXYZ_ROI);
% set(hSurfaceSmall,'facecolor','c','edgecolor','none','facealpha',0.5);
% 
% 
% iNumElectrodes = size(a2fGridPoints,2);
% for k=iSelectedGridHole
%     plot3(a2fGridPoints(1,k),a2fGridPoints(2,k),a2fGridPoints(3,k),'b*');
%     plot3([a2fGridPoints(1,k) a2fGridPoints(1,k)+50*a2fDirection(1,k)],...
%               [a2fGridPoints(2,k) a2fGridPoints(2,k)+50*a2fDirection(2,k)],...
%               [a2fGridPoints(3,k) a2fGridPoints(3,k)+50*a2fDirection(3,k)],'g');
% end

 
  
% 
%  L1=light();
%  L2=light();
%  lightangle(L1, 80, -3.4);
%  lightangle(L2, -70, -54);
%%
hold on;
set(gcf,'color',[1 1 1])
return;

% Overlay electrode position...
% Only make sense if we use the mm space.  otherwise, only projection is
% valid....

%plot3(apt3fIntersectionPoints(1,:),apt3fIntersectionPoints(2,:),apt3fIntersectionPoints(3,:),'g*');




% %%  Draw chamber...
% global g_strctModule
% strctChamber = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(1);
% a2fCRS_To_XYZ = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fReg*g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fM; 
% a2fM = a2fCRS_To_XYZ*strctChamber.m_a2fM_vox;
% % start by drawing the actual chamber
% % 1. Build chamber model
% astrctMesh = fnChamber_BuildModel(strctChamber, true);
% % 3. Draw it in 3D view
% fnDrawMeshIn3D(astrctMesh,hAxes);



