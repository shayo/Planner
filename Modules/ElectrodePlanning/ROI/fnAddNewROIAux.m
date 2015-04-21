function iNewROIIndex = fnAddNewROIAux(strctMouseOp)
global g_strctModule

if isempty(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctROIs)
iSelectedROI= fnAddNewROI();
else
    iSelectedROI= get(g_strctModule.m_strctPanel.m_hROIList,'value');
    iSelectedROI=iSelectedROI(1);
end


strctCrossSection =fnAxesToCrossSection(strctMouseOp.m_hAxes);
if  isempty(strctCrossSection)
    return;
end;
    
pt3fPosMM = fnCrossSection_Image_To_MM_3D(strctCrossSection, strctMouseOp.m_pt2fPos);

a2fCRS_To_XYZ_Func = g_strctModule.m_acFuncVol{g_strctModule.m_iCurrFuncVol}.m_a2fReg*g_strctModule.m_acFuncVol{g_strctModule.m_iCurrFuncVol}.m_a2fM;
pt3fCenterVoxel = inv(a2fCRS_To_XYZ_Func) * [pt3fPosMM;1];
% Sample the log value...
fLogValue= fndllFastInterp3(g_strctModule.m_acFuncVol{g_strctModule.m_iCurrFuncVol}.m_a3fVol, 1+pt3fCenterVoxel(1),1+pt3fCenterVoxel(2),1+pt3fCenterVoxel(3));
fprintf('Seed point value is : %.2f\n',fLogValue)

% Find all points that are below half....
fThreshold = 0.5
fprintf('Searching for all nearby voxels with value less than %.2f\n',fLogValue*fThreshold);
pt3iCenter=round(pt3fCenterVoxel(1:3));
[a3iL,iNc]= bwlabeln(g_strctModule.m_acFuncVol{g_strctModule.m_iCurrFuncVol}.m_a3fVol < fLogValue*fThreshold);
a3iLocal = a3iL(pt3iCenter(2)-2:pt3iCenter(2)+2,pt3iCenter(1)-2:pt3iCenter(1)+2,pt3iCenter(3)-2:pt3iCenter(3)+2);
iSelectedComponent = mode(a3iLocal(a3iLocal>0));
if iSelectedComponent == 0
    fprintf('Nothing found?!?!?\n');
    return;
end;
a3bVolume = a3iL == iSelectedComponent;
aiInd = find(a3bVolume(:));
fprintf('Found %d voxels\n',length(aiInd));
if length(aiInd) == 0
    return;
end;
 % Now, transform these back to i,j,k
 [aiI,aiJ,aiK]=ind2sub(size(g_strctModule.m_acFuncVol{g_strctModule.m_iCurrFuncVol}.m_a3fVol),aiInd);
 % Back to MM and then back to voxels in anatomical space.
a2fCRS_To_XYZ = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fReg*g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fM;
Tmp = inv(a2fCRS_To_XYZ) *  a2fCRS_To_XYZ_Func * [aiJ, aiI, aiK, ones(size(aiI))]';
g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctROIs(iSelectedROI).m_aiVolumeIndices = sub2ind(size(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a3fVol), round(Tmp(2,:)),round(Tmp(1,:)),round(Tmp(3,:)));
 fnInvalidate(1);
return;

