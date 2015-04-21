function fnAlignToGridHole(iSelectedHole)
global g_strctModule
iSelectedGrid = get(g_strctModule.m_strctPanel.m_hGridList,'value');
if isempty(iSelectedGrid) || iSelectedGrid == 0 || isempty(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber).m_astrctGrids)
    return;
end;
strctChamber = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber);
strctGrid = strctChamber.m_astrctGrids(iSelectedGrid);
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


afDistance = 0:0.1:80;
iNumSamplePoints = length(afDistance);
a2fDirection = -a2fTrans(1:3,3) * afDistance;
apt3fSamplePointsMM = [repmat(a2fTrans(1:3,4),1,iNumSamplePoints) + a2fDirection; ones(1,iNumSamplePoints)];
apt3fSamplePointsVox = a2fXYZ_To_CRS_Anat * apt3fSamplePointsMM; %#ok

afValuesAnat = fndllFastInterp3(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a3fVol, 1+apt3fSamplePointsVox(1,:),1+apt3fSamplePointsVox(2,:),1+apt3fSamplePointsVox(3,:));
if g_strctModule.m_iCurrFuncVol > 0

    a2fCRS_To_XYZ_Func = g_strctModule.m_acFuncVol{g_strctModule.m_iCurrFuncVol}.m_a2fReg*g_strctModule.m_acFuncVol{g_strctModule.m_iCurrFuncVol}.m_a2fM; 
    a2fXYZ_To_CRS_Func = inv(a2fCRS_To_XYZ_Func);
    apt3fSamplePointsFuncVox = a2fXYZ_To_CRS_Func * apt3fSamplePointsMM; %#ok
    afValuesFunc = fndllFastInterp3(g_strctModule.m_acFuncVol{g_strctModule.m_iCurrFuncVol}.m_a3fVol,...
        1+apt3fSamplePointsFuncVox(1,:),1+apt3fSamplePointsFuncVox(2,:),1+apt3fSamplePointsFuncVox(3,:));
    figure(11);
    clf;
    ax = plotyy(afDistance,afValuesAnat,afDistance,afValuesFunc); 
    set(gca,'xtick',0:2:afDistance(end));
    xlabel('Depth from grid top (mm)');
    set(get(ax(1),'Ylabel'),'String','Intensity') ;
    set(get(ax(2),'Ylabel'),'String','Log_{10}P') ;
    

end

% figure(10);
% clf;
% fnPlotCoordSys(a2fTrans);
% fnPlotCoordSys(a2fM_WithMeshOffset);
% axis equal

 
% This will have some weird in-plane rotation. Let's align it with the
% chamber direction (it makes more sense visually...)
% fAlpha = acos(-dot(a2fM(1:3,2),a2fTrans(1:3,2)));
% a2fSecondRot = fnRotateVectorAboutFixedAxis(a2fM(1:3,3),fAlpha,a2fM(1:3,4));
% a2fTrans=a2fSecondRot*a2fTrans;
g_strctModule.m_strctCrossSectionXY.m_a2fM = a2fTrans;
g_strctModule.m_strctCrossSectionXY=  fnRotateInPlaneCrossSectionAux(g_strctModule.m_strctCrossSectionXY, pi);


g_strctModule.m_strctCrossSectionYZ.m_a2fM(1:3,1:3) = a2fTrans(1:3,[2,3,1]);
g_strctModule.m_strctCrossSectionYZ.m_a2fM(1:3,4) = a2fTrans(1:3,4);
g_strctModule.m_strctCrossSectionYZ=  fnRotateInPlaneCrossSectionAux(g_strctModule.m_strctCrossSectionYZ, pi);


g_strctModule.m_strctCrossSectionXZ.m_a2fM(1:3,1:3) = a2fTrans(1:3,[1,3,2]);
g_strctModule.m_strctCrossSectionXZ.m_a2fM(1:3,4) = a2fTrans(1:3,4);
g_strctModule.m_strctCrossSectionXZ=  fnRotateInPlaneCrossSectionAux(g_strctModule.m_strctCrossSectionXZ, pi);


fnInvalidate(1);
     
return;
