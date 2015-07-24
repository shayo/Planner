function fnSetStereotaxCrossSections( )
global g_strctModule

% % Project [0,0,0] and aiVolSize and find min and max
% aiVolSize = size(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a3fVol);
% 
% P = [0,0,0,1; 
%      aiVolSize,1];
%  
% Pmm =  g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fReg*g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fM * P';
% 
% fRangeX = abs(Pmm(2,2)-Pmm(2,1));
% fRangeY = abs(Pmm(1,2)-Pmm(1,1));
% fRangeZ = abs(Pmm(3,2)-Pmm(3,1));
% 
% fHalfXYMM  =  max(fRangeX,fRangeY)/2;
% fHalfYZMM  =  max(fRangeZ,fRangeY)/2;
% fHalfXZMM =  max(fRangeX,fRangeZ)/2;
% 
% iResWidth = g_strctModule.m_strctPanel.m_aiImageRes(2);
% iResHeight = g_strctModule.m_strctPanel.m_aiImageRes(1);
% 
% % prepare cross sections
% strctCrossSectionXY.m_a2fM = [1,0,0  0;
%                               0 -1 0  0;
%                               0 0 1  0;
%                               0 0 0  1]; % This gives horizontal slice such that Y = 0 is anterior
% 
% strctCrossSectionXY.m_fHalfWidthMM = fHalfXYMM;
% strctCrossSectionXY.m_fHalfHeightMM = fHalfXYMM; 
% strctCrossSectionXY.m_iResWidth = iResWidth;
% strctCrossSectionXY.m_iResHeight = iResHeight;
% 
% strctCrossSectionXZ.m_a2fM = [1,0,0  0;
%                               0 0 1  0;
%                               0 -1 0  0;
%                               0 0 0  1]; % This gives coronal slice such that Y = 0 is superior
% strctCrossSectionXZ.m_fHalfWidthMM =  fHalfXZMM;
% strctCrossSectionXZ.m_fHalfHeightMM =  fHalfXZMM;
% strctCrossSectionXZ.m_iResWidth = iResWidth;
% strctCrossSectionXZ.m_iResHeight = iResHeight;
% 
% strctCrossSectionYZ.m_a2fM = [0 0 1  0;
%                               1 0 0  0;
%                               0,-1,0  0;
%                               0 0 0  1]; % This gives coronal slice such that Y = 0 is superior
% strctCrossSectionYZ.m_fHalfWidthMM = fHalfYZMM;
% strctCrossSectionYZ.m_fHalfHeightMM = fHalfYZMM;
% strctCrossSectionYZ.m_iResWidth = iResWidth;
% strctCrossSectionYZ.m_iResHeight = iResHeight;
% 




g_strctModule.m_strctCrossSectionXY = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_strctCrossSectionHoriz;
g_strctModule.m_strctCrossSectionXZ = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_strctCrossSectionCoronal;
g_strctModule.m_strctCrossSectionYZ = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_strctCrossSectionSaggital;

return;
