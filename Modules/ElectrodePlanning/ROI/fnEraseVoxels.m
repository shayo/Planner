function fnEraseVoxels(strctMouseOp, b2D)
global g_strctModule

strctCrossSection =fnAxesToCrossSection(strctMouseOp.m_hAxes);
if  isempty(strctCrossSection)
    return;
end;

if b2D
    fnEraseVoxels2D(strctCrossSection,strctMouseOp);
else
    fnEraseVoxels3D(strctCrossSection,strctMouseOp);
end

fnInvalidate(1);

return

function  fnEraseVoxels2D(strctCrossSection,strctMouseOp)
global g_strctModule

pt3fPosMM = fnCrossSection_Image_To_MM_3D(strctCrossSection, strctMouseOp.m_pt2fPos);

a2fT = strctCrossSection.m_a2fM;
a2fT(1:3,4) = pt3fPosMM;
a2fCRS_To_XYZ = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fReg*g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fM;

[a2fX,a2fY]=meshgrid(-g_strctModule.m_strctGUIOptions.m_fSelectRadiusMM:0.1:g_strctModule.m_strctGUIOptions.m_fSelectRadiusMM,...
                 -g_strctModule.m_strctGUIOptions.m_fSelectRadiusMM:0.1:g_strctModule.m_strctGUIOptions.m_fSelectRadiusMM);
a2bValid = a2fX.^2+a2fY.^2<g_strctModule.m_strctGUIOptions.m_fSelectRadiusMM.^2;
P = [a2fX(a2bValid)';a2fY(a2bValid)';zeros(1,sum(a2bValid(:)));ones(1,sum(a2bValid(:)))];
apt3fVoxelsToErase = inv(a2fCRS_To_XYZ)*a2fT * P;

aiVolSize = size( g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a3fVol);

aiX=round(min(aiVolSize(2), max(1,1+apt3fVoxelsToErase(1,:))));
aiY=round(min(aiVolSize(1), max(1,1+apt3fVoxelsToErase(2,:))));
aiZ=round(min(aiVolSize(3), max(1,1+apt3fVoxelsToErase(3,:))));
aiInd = sub2ind(aiVolSize,aiY,aiX,aiZ);
g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a3fVol(aiInd) = 0;

return;


function  fnEraseVoxels3D(strctCrossSection,strctMouseOp)
global g_strctModule

% Use quantization of 0.05 mm...should be sufficient ?
pt3fPosMM = fnCrossSection_Image_To_MM_3D(strctCrossSection, strctMouseOp.m_pt2fPos);

a2fCRS_To_XYZ = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fReg*g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fM;
pt3fCenterVoxel = inv(a2fCRS_To_XYZ) * [pt3fPosMM;1];
afMM_To_Vox = 1./g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_afVoxelSpacing;

afVox_To_MM = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_afVoxelSpacing;

aiVolSize = size( g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a3fVol);
aiVoxRange = ceil(2*g_strctModule.m_strctGUIOptions.m_fSelectRadiusMM  * afMM_To_Vox);

[a3fX,a3fY,a3fZ]=meshgrid(-aiVoxRange(1)/2:aiVoxRange(1)/2,-aiVoxRange(2)/2:aiVoxRange(2)/2,-aiVoxRange(3)/2:aiVoxRange(3)/2);
a3bInsideSphere = (a3fX*afVox_To_MM(1)./g_strctModule.m_strctGUIOptions.m_fSelectRadiusMM).^2 + ...
                                  (a3fY*afVox_To_MM(2)./g_strctModule.m_strctGUIOptions.m_fSelectRadiusMM).^2 + ...
                                  (a3fZ*afVox_To_MM(3)./g_strctModule.m_strctGUIOptions.m_fSelectRadiusMM).^2 <= 1;
aiX=floor(min(aiVolSize(2), max(1,pt3fCenterVoxel(1)+a3fX(a3bInsideSphere))));
aiY=floor(min(aiVolSize(1),max(1,pt3fCenterVoxel(2)+a3fY(a3bInsideSphere))));
aiZ = floor(min(aiVolSize(3),max(1,pt3fCenterVoxel(3)+a3fZ(a3bInsideSphere))));
aiInd = sub2ind(aiVolSize,aiY,aiX,aiZ);
g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a3fVol(aiInd) = 0;


return;    