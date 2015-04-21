
function fnUpdateChamberMIP()
    return;
%     
% global g_strctModule
% if g_strctModule.m_iCurrChamber == 0 || isempty(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers)
%     return
% end
% if isempty(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber).m_iGridSelected)
%     return;
% end;
% % Test if we can do this type of projection....
% % This is only OK if all holes are pointing along the same direction.
% % Otherwise, we will need to sample each direction separately....
% strctGrid = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber).m_astrctGrids(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber).m_iGridSelected);
% 
% fNormalX = strctGrid.m_apt3fGridHolesNormals(1,1);
% fNormalY = strctGrid.m_apt3fGridHolesNormals(1,2);
% fNormalZ = strctGrid.m_apt3fGridHolesNormals(1,3);
% 
% iNumSlices = 40;
% afOffsetFromZ = linspace(20,60,iNumSlices); % Skip first 20 mm. That's the grid & Chamber with many FP
% strctZoomCrossSection.m_iResWidth = 64;
% strctZoomCrossSection.m_iResHeight = 64;
% strctZoomCrossSection.m_fHalfWidthMM = 10;
% strctZoomCrossSection.m_fHalfHeightMM = 10;
% 
% a3fMax_Func = zeros(strctZoomCrossSection.m_iResHeight,strctZoomCrossSection.m_iResWidth,3);
% a3fAlphaMax = zeros(strctZoomCrossSection.m_iResHeight,strctZoomCrossSection.m_iResWidth,3);
% a3fMin_Func = zeros(strctZoomCrossSection.m_iResHeight,strctZoomCrossSection.m_iResWidth,3);
% a3fAlphaMin = zeros(strctZoomCrossSection.m_iResHeight,strctZoomCrossSection.m_iResWidth,3);
% a3fMIP_Blood = zeros(strctZoomCrossSection.m_iResHeight,strctZoomCrossSection.m_iResWidth,3);
% a3fBloodAlpha = zeros(strctZoomCrossSection.m_iResHeight,strctZoomCrossSection.m_iResWidth,3);
% 
% if ~isempty(g_strctModule.m_acFuncVol)
%     a2fXYZ_To_CRS_Func = inv(g_strctModule.m_acFuncVol{g_strctModule.m_iCurrFuncVol}.m_a2fM) * inv(g_strctModule.m_acFuncVol{g_strctModule.m_iCurrFuncVol}.m_a2fReg);
%     a2fCRS_To_XYZ = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fReg*g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fM;
%     
%     a2fMIP_Func_Min = zeros(strctZoomCrossSection.m_iResHeight,strctZoomCrossSection.m_iResWidth);
%     a2fMIP_Func_Max = zeros(strctZoomCrossSection.m_iResHeight,strctZoomCrossSection.m_iResWidth);
%     a2fM = a2fCRS_To_XYZ*g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber).m_a2fM_vox;
%     
%       a2fTrans = fnBuildElectrodeTransform(0, 0, [fNormalX,fNormalY,fNormalZ], strctGrid.m_fGridThetaDeg+180, 0, a2fM);
%     a2fTrans = fnRotateAboutSameAxis(a2fTrans, pi);
%      
%     if g_strctModule.m_strctGUIOptions.m_bMIPFuncNeg || g_strctModule.m_strctGUIOptions.m_bMIPFuncPos
%         clear ahHandlesTmp
%         for iSliceIter=1:iNumSlices
%             a2fT = a2fTrans;
%             a2fT(1:3,4) = a2fTrans(1:3,4)+  a2fTrans(1:3,3) * -afOffsetFromZ(iSliceIter);
%             strctZoomCrossSection.m_a2fM = a2fT;
%             [a2fFuncSlice, apt3fPlanePoints,a2fXmm,a2fYmm,a2fXmmT,a2fYmmT,a2fZmmT,apt3fInVolMM] = fnResampleCrossSection(...
%                 g_strctModule.m_acFuncVol{g_strctModule.m_iCurrFuncVol}.m_a3fVol, a2fXYZ_To_CRS_Func,strctZoomCrossSection);
%             a2fMIP_Func_Min = min(a2fMIP_Func_Min, a2fFuncSlice);
%             a2fMIP_Func_Max = max(a2fMIP_Func_Max, a2fFuncSlice);
%          end
%         
%         if g_strctModule.m_strctGUIOptions.m_bMIPFuncNeg
%             [a3fMin_Func, a2fAlphaMin] = fnOverlayContrastTransform(a2fMIP_Func_Min);
%             a3fAlphaMin  = fnDup3(a2fAlphaMin);
%         end
%         if g_strctModule.m_strctGUIOptions.m_bMIPFuncPos
%             [a3fMax_Func, a2fAlphaMax] = fnOverlayContrastTransform(a2fMIP_Func_Max);
%             a3fAlphaMax = fnDup3(a2fAlphaMax);
%          end
%     end
% end
% 
% if g_strctModule.m_strctGUIOptions.m_bMIPBlood && ...
%         ~isempty(g_strctModule.m_acAnatVol) && isfield(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol},'m_a3bBloodVolume') && ~isempty(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a3bBloodVolume)
%     
%     a2fCRS_To_XYZ = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fReg*g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fM;
%     a2fXYZ_To_CRS = inv(a2fCRS_To_XYZ);
%     a2fM = a2fCRS_To_XYZ*g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(g_strctModule.m_iCurrChamber).m_a2fM_vox;
%     
%     a2fTrans = fnBuildElectrodeTransform(0, 0, [fNormalX,fNormalY,fNormalZ], strctGrid.m_fGridThetaDeg+180, 0, a2fM);
%     a2fTrans = fnRotateAboutSameAxis(a2fTrans, pi);
%   
% 
%     a2fMIP_Blood = zeros(64,64);
%     
%     for iSliceIter=1:iNumSlices
%         a2fT = a2fTrans;
%         a2fT(1:3,4) = a2fTrans(1:3,4)+  a2fTrans(1:3,3) * -afOffsetFromZ(iSliceIter);
%         strctZoomCrossSection.m_a2fM = a2fT;
%         a2fBloodSlice =...
%             fnResampleCrossSection(...
%             g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a3bBloodVolume, a2fXYZ_To_CRS,strctZoomCrossSection);
%         a2fMIP_Blood = max(a2fMIP_Blood, a2fBloodSlice);
%     end
%     a3fMIP_Blood = zeros( [size(a2fMIP_Blood),3]);
%     a3fMIP_Blood(:,:,1) = double(a2fMIP_Blood);
%     a3fBloodAlpha = fnDup3(a2fMIP_Blood>0);
% end
% 
% 
% IFuncFinal =  a3fAlphaMin .* a3fMin_Func + a3fAlphaMax .* a3fMax_Func + a3fMIP_Blood .* a3fBloodAlpha;
% IFuncFinal = min(IFuncFinal,1);
% set(g_strctModule.m_strctPanel.m_strctGrid.m_hImage,'cdata',IFuncFinal);
%     
% 
% return;