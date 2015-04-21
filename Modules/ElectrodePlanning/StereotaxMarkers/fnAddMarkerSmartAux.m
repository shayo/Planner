
function fnAddMarkerSmartAux(strctMouseOpStart,strctMouseOpEnd)
global g_strctModule

a2fXYZ_To_CRS = inv(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fM) * inv(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fReg);  %#ok
a2fCRS_To_XYZ = inv(a2fXYZ_To_CRS); %#ok
strctCrossSection=fnAxesHandleToStrctCrossSection(strctMouseOpStart.m_hAxes);
if isempty(strctCrossSection)
    return;
end;

pt2fPosMM = fnCrossSection_Image_To_MM(strctCrossSection, strctMouseOpStart.m_pt2fPos);
pt3fPosMMOnPlane = [pt2fPosMM,0,1]';
pt3fPosInVol = strctCrossSection.m_a2fM*pt3fPosMMOnPlane;
pt3fPosVoxelStart = a2fXYZ_To_CRS * pt3fPosInVol;

pt2fPosMM = fnCrossSection_Image_To_MM(strctCrossSection, strctMouseOpEnd.m_pt2fPos);
pt3fPosMMOnPlane = [pt2fPosMM,0,1]';
pt3fPosInVol = strctCrossSection.m_a2fM*pt3fPosMMOnPlane;
pt3fPosVoxelEnd = a2fXYZ_To_CRS * pt3fPosInVol;

afVoxelDirection = (pt3fPosVoxelEnd(1:3)-pt3fPosVoxelStart(1:3)) / norm(pt3fPosVoxelEnd(1:3)-pt3fPosVoxelStart(1:3));

pt3fPosInStereoSpace=fnGetCoordInStereotacticSpace(pt3fPosVoxelEnd(1:3));
fnAddMarkerAux2(pt3fPosVoxelEnd(1:3),pt3fPosInStereoSpace,pt3fPosInVol,afVoxelDirection);

set(g_strctModule.m_strctPanel.m_hMarkersList,'value', ...
    length( g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers));
fnUpdateMarkerList();
fnInvalidate(true);
% 
% pt2fPosMM = fnCrossSection_Image_To_MM(strctCrossSection, strctMouseOp.m_pt2fPos);
% pt3fPosMMOnPlane = [pt2fPosMM,0,1]';
% pt3fPosInVol = strctCrossSection.m_a2fM*pt3fPosMMOnPlane;
% pt3fPosVoxel = a2fXYZ_To_CRS * pt3fPosInVol;
% pt3iPosVoxel = round(pt3fPosVoxel);
% % Find the intensity at the clicked point.
% iIntensity = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a3fVol(pt3iPosVoxel(2),pt3iPosVoxel(1),pt3iPosVoxel(3));
% if iIntensity < 1.5*mean(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a3fVol(:))
%     msgbox('Intensity in marker is not strong enough compared to background');
%     return;
% end;
% %Use half intensity? Terrible heuristic, but this is temporary.
% a3iTemp = bwlabeln(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a3fVol >= 530);
% iSelectedComponent = a3iTemp(pt3iPosVoxel(2),pt3iPosVoxel(1),pt3iPosVoxel(3));
% a3bSelectedCC = a3iTemp == iSelectedComponent;
% % discard very thick regions. those are throwing us off balance...
% % a3fDist = bwdist(~a3bSelectedCC);
% % fMaxDist = max(a3fDist(:));
% % fDistThres = 0.8*fMaxDist;
% % a3bSelectedCC(fMaxDist-a3fDist > fDistThres) = 0;
% % Center of blob?
% [aiY,aiX,aiZ]=ind2sub(size(a3bSelectedCC),find(a3bSelectedCC));
% pt3fCenter_vox = [median(aiX),median(aiY),median(aiZ)];
% D = [aiX-pt3fCenter_vox(1),aiY-pt3fCenter_vox(2),aiZ-pt3fCenter_vox(3)];
% 
% C = D'*D;
% [u,s,v]=svd(C);
% afDir= v(:,1);
% 
% afLineVox = -30:30; % Assuming 0.5, this gives a range of 30 mm. Should be sufficient
% apt3fLine = [pt3fCenter_vox(1) + afLineVox*afDir(1);...
%  pt3fCenter_vox(2) + afLineVox*afDir(2);...
%  pt3fCenter_vox(3) + afLineVox*afDir(3);];
% 
% % Sample line from volume
% afIntensityValues = fndllFastInterp3(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a3fVol, ...
%     1+apt3fLine(1,:),1+apt3fLine(2,:),1+apt3fLine(3,:));
% afIntensityValues = conv2(afIntensityValues,fspecial('gaussian',[1 4]),'same');
% afGradient = [0;diff(afIntensityValues)];
% [fMax,iMaxIndex] = max(afGradient);
% [fMin,iMinIndex] = min(afGradient);
% pt3fMax = apt3fLine(:,iMaxIndex);
% pt3fMin = apt3fLine(:,iMinIndex);
% pt3fMaxMM = a2fCRS_To_XYZ * [pt3fMax;1];
% pt3fMinMM = a2fCRS_To_XYZ * [pt3fMin;1];
% % Which one do we take? 
% % Go for the one with the smaller DV...
% 
% pt3fMaxStereo=fnGetCoordInStereotacticSpace(pt3fMaxMM);
% pt3fMinStereo=fnGetCoordInStereotacticSpace(pt3fMinMM);
% if pt3fMinStereo(3) > pt3fMaxStereo(3)
%     pt3fMarkerPos_vox = pt3fMin;
%     pt3fMarkerPos_MM= pt3fMinMM;
%     afMarkerDirex_vox = afDir;
% else
%     pt3fMarkerPos_vox = pt3fMax;
%     pt3fMarkerPos_MM= pt3fMaxMM;
%     afMarkerDirex_vox = -afDir;
% end
% 
% pt3fPosInStereoSpace=fnGetCoordInStereotacticSpace(pt3fMarkerPos_vox(1:3));
% fnAddMarkerAux2(pt3fMarkerPos_vox(1:3),pt3fPosInStereoSpace,pt3fMarkerPos_MM,afMarkerDirex_vox);
% 
% set(g_strctModule.m_strctPanel.m_hMarkersList,'value', ...
%     length( g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers));
% fnUpdateMarkerList();
% fnInvalidate(true);
% fnChangeMouseMode('Scroll');
return;

