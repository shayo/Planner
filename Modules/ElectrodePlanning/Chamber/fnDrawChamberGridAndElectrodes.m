function ahHandles = fnDrawChamberGridAndElectrodes(strctChamber, bSelected)
global g_strctModule
% Draw chamber, both in 2D and 3D
% if chamber has a grid, draw it as well. 
% if there are electrodes in the grid, draw them as well

a2fCRS_To_XYZ = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fReg*g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fM; 
a2fM = a2fCRS_To_XYZ*strctChamber.m_a2fM_vox;

% start by drawing the actual chamber
% 1. Build chamber model
astrctMesh = fnChamber_BuildModel(strctChamber, bSelected);
% 2. Draw it in cross sections
% for k=1:length(astrctMesh)
%     astrctMesh(k).m_afColor = [1 1 1];
% end
ahHandles = fnDrawMesh(astrctMesh);

% 3. Draw it in 3D view
astrctMeshTrans = fnApplyTransformOnMesh(astrctMesh,inv(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_strctCrossSectionHoriz.m_a2fM));

ahHandles = [ahHandles,fnDrawMeshIn3D(astrctMeshTrans,g_strctModule.m_strctPanel.m_strct3D.m_hAxes)];


% 4. Draw electrodes
if strctChamber.m_iGridSelected > 0
   strctGrid = strctChamber.m_astrctGrids(strctChamber.m_iGridSelected);
   try

   astrctGridMesh = feval(strctGrid.m_strctGeneral.m_strBuildMesh, strctGrid.m_strctModel,g_strctModule.m_strctGUIOptions.m_bLongGrid,bSelected);
   
%    astrctGridMesh(2).m_afColor = [1 1 1];
%    

%   astrctGridMesh=astrctGridMesh(3:end);
 
   a2fGridOffsetTransform = eye(4);
   a2fGridOffsetTransform(3,4) = -strctGrid.m_fChamberDepthOffset;
   a2fM_WithMeshOffset =a2fM*a2fGridOffsetTransform;
   astrctGridMesh = fnApplyTransformOnMesh(astrctGridMesh,a2fM_WithMeshOffset);
   
  ahHandles = [ahHandles,fnDrawMesh(astrctGridMesh)];
  astrctGridTransformed = fnApplyTransformOnMesh(astrctGridMesh,inv(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_strctCrossSectionHoriz.m_a2fM));
  ahHandles = [ahHandles,fnDrawMeshIn3D(astrctGridTransformed,g_strctModule.m_strctPanel.m_strct3D.m_hAxes)];
   catch
   end
end


return;