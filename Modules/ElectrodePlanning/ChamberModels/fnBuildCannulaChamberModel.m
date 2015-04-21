function [strctModel] = fnBuildCannulaChamberModel()
% A chamber must have only two strctures that describe the 3D geometry
% One is "short" (normal size) and one is "long" to see its projection in
% the volume. 
%
% Future versions may automatically do this projection so only the short
% version will be needed.

% These values are for a Plastic1, part number:  C313GT 
strctParams.m_strManufacterer = 'Plastic1';
strctParams.m_strName = sprintf('Plastic1 C313GT');
strctParams.m_fPedestalHeightMM = 8.0;
strctParams.m_fPedestalDiameterMM = 3.25;
strctParams.m_iQuat = 20;

strctModel.m_astrctMeshShort = fnCreateCylinderMeshWithBottom(strctParams.m_fPedestalDiameterMM, 0,-strctParams.m_fPedestalHeightMM, strctParams.m_iQuat,[1 0 1]);  % Pedestal
strctModel.m_astrctMeshLong  = fnCreateCylinderMeshWithBottom(strctParams.m_fPedestalDiameterMM, 0,-strctParams.m_fPedestalHeightMM-30, strctParams.m_iQuat,[1 0 1]);  % Pedestal
return;
