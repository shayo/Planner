function strctGrid = fnAppendGridModelWithAdditionalMembers(strctGrid)
iNumHoles = length(strctGrid.m_afGridHolesX);
strctGrid.m_abSelected = zeros(1, iNumHoles)>0;
strctGrid.m_afGuideTubeLengthMM = 20*ones(1, iNumHoles);
strctGrid.m_afElectrodeLengthMM = 60*ones(1, iNumHoles);
strctGrid.m_fGridThetaDeg = 0; % Rotation relative to chamber. 0 points to the "anterior". positive values represent CCW rotation.
strctGrid.m_fChamberDepthOffset = 0;
strctGrid.m_strName = strctGrid.m_strGridType; % A name the user can change.
return;

