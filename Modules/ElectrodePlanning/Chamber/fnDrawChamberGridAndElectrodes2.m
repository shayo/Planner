function ahHandles = fnDrawChamberGridAndElectrodes2(strctChamber, bSelected)
global g_strctModule
% Draw chamber, both in 2D and 3D
% if chamber has a grid, draw it as well. 
% if there are electrodes in the grid, draw them as well

% start by drawing the actual chamber
% 1. Build chamber model (in transformed XYZ space)
astrctMesh = fnChamber_BuildModel(strctChamber, bSelected);
% 2. Draw it in cross sections
ahHandles = fnDrawMesh(astrctMesh);
% 3. Draw it in 3D view
Tmp = 10*g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fRegToStereoTactic;
astrctMeshTransformed= fnApplyTransformOnMesh(astrctMesh, Tmp);
ahHandles = [ahHandles,fnDrawMeshIn3D(astrctMeshTransformed,g_strctModule.m_strctPanel.m_strctStereoTactic.m_hAxes)];


return;