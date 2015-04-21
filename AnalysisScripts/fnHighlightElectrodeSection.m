global g_strctModule
% Bert:
% Zoom Sagittal: 48.5344
% Zoom Coronal: 35.6641, high: 12.458

% Bert
% Hole 50: ChR2, 28.5-32
% Hole 79: Arch, 27.5-31.5
% Hole 96: eNpHR3.0: 29.5-33.5

% Anakin:
% Hole 145: ChR2, 24:0.5:27.5
% Hole 148: ChR2, 24:0.5:27.5

% Julien
% Hole 88: Arch, 29:0.5:33
% Hole 147: ChR2, 29:0.5:33
% Hole 117: Halo, 29:0.5:33

afColorChR2 = [0,176,240]/255;
afColorArchT = [0,176,80]/255;
afColorCheta1 = [140,25,255]/255;
afColorCheta2 = [64,255,191]/255;
afColorHalo = [255,192,0]/255;

iSelectedGrid = 3;
iSelectedHole = 88;
fLineWidth = 4;
afHighlightRange = 29:0.5:33;

afColor = afColorArchT;
fMarkerSize = 18;
strctChamber = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber);
strctGrid = strctChamber.m_astrctGrids(iSelectedGrid);

%find(strctGrid.m_strctModel.m_strctGridParams.m_abSelectedHoles)

a2fCRS_To_XYZ = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fReg*g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fM; 
a2fXYZ_To_CRS_Anat = inv(a2fCRS_To_XYZ);
a2fM = a2fCRS_To_XYZ*strctChamber.m_a2fM_vox;
a2fGridOffsetTransform = eye(4);
a2fGridOffsetTransform(3,4) = -strctGrid.m_fChamberDepthOffset;
a2fM_WithMeshOffset =a2fM*a2fGridOffsetTransform;

% First, shift.
a2fTransformShift = eye(4);
a2fTransformShift(1,4) = -strctGrid.m_strctModel.m_afGridHolesX(iSelectedHole);
a2fTransformShift(2,4) = strctGrid.m_strctModel.m_afGridHolesY(iSelectedHole);

afNrm = strctGrid.m_strctModel.m_apt3fGridHolesNormals(:,iSelectedHole);
afRotationAxis = cross([0 0 -1], afNrm);
fRotationAngle = acos(dot([0 0 -1]',afNrm));
if abs(fRotationAngle) > 0
    a2fRotation = fnRotateVectorAboutAxis4D(afRotationAxis,fRotationAngle);
    a2fTrans=a2fM_WithMeshOffset * a2fRotation*a2fTransformShift;
else
    a2fTrans=a2fM_WithMeshOffset * a2fTransformShift;
end

iNumSamplePoints = length(afHighlightRange);
a2fDirection = -a2fTrans(1:3,3) * afHighlightRange;
apt3fSamplePointsMM = [repmat(a2fTrans(1:3,4),1,iNumSamplePoints) + a2fDirection; ones(1,iNumSamplePoints)];
%%
% Draw on screen Coronal
apt2fImageCoordinates = zeros(iNumSamplePoints,2);
for k=1:iNumSamplePoints
    [pt3fNearestPointOnPlane, pt2fImageMM,Dist]  = fnProjectPointOnCrossSection(g_strctModule.m_strctCrossSectionXZ,apt3fSamplePointsMM(1:3,k));
    apt2fImageCoordinates(k,:) = fnCrossSection_MM_To_Image(g_strctModule.m_strctCrossSectionXZ,pt2fImageMM');
end
hLineCoronal = plot(g_strctModule.m_strctPanel.m_strctXZ.m_hAxes, apt2fImageCoordinates([1,end],1),apt2fImageCoordinates([1,end],2),'LineWidth',fLineWidth,'color',afColor);
ahMarkerCoronal = zeros(1,iNumSamplePoints);
for k=1:iNumSamplePoints
    ahMarkerCoronal(k) = plot(g_strctModule.m_strctPanel.m_strctXZ.m_hAxes,apt2fImageCoordinates(k,1),apt2fImageCoordinates(k,2),'.','color',afColor,'markersize',fMarkerSize);
end

% Draw on screen Sagittal
apt2fImageCoordinates = zeros(iNumSamplePoints,2);
for k=1:iNumSamplePoints
    [pt3fNearestPointOnPlane, pt2fImageMM,Dist]  = fnProjectPointOnCrossSection(g_strctModule.m_strctCrossSectionYZ,apt3fSamplePointsMM(1:3,k));
    apt2fImageCoordinates(k,:) = fnCrossSection_MM_To_Image(g_strctModule.m_strctCrossSectionYZ,pt2fImageMM');
end
hLineSagittal = plot(g_strctModule.m_strctPanel.m_strctYZ.m_hAxes, apt2fImageCoordinates([1,end],1),apt2fImageCoordinates([1,end],2),'LineWidth',fLineWidth,'color', afColor);
ahMarkerSagittal = zeros(1,iNumSamplePoints);
for k=1:iNumSamplePoints
    ahMarkerSagittal(k) = plot(g_strctModule.m_strctPanel.m_strctYZ.m_hAxes,apt2fImageCoordinates(k,1),apt2fImageCoordinates(k,2),'.','color',afColor,'MarkerSize',fMarkerSize);
end

%ahMarkerSagittal2=ahMarkerSagittal



% 
% 

delete(hLineCoronal)
delete(ahMarkerCoronal)
delete(ahMarkerSagittal)
delete(hLineSagittal)

