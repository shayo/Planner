function astrctMesh = fnChamber_BuildModel(strctChamber, bSelected)
global g_strctModule
if ~g_strctModule.m_strctGUIOptions.m_bLongChamber
    astrctMesh = strctChamber.m_strctModel.m_strctModel.m_astrctMeshShort;
else
    astrctMesh = strctChamber.m_strctModel.m_strctModel.m_astrctMeshLong;
end


% Transform the model from voxel space to mm space
 a2fCRS_To_XYZ = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fReg * g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fM;
for k=1:length(astrctMesh)
    if ~bSelected
        astrctMesh(k).m_afColor = 0.3*astrctMesh(k).m_afColor;
    end
    a2fChamberM = a2fCRS_To_XYZ*strctChamber.m_a2fM_vox;
    a3fVerticesHomo = a2fChamberM*[astrctMesh(k).m_a2fVertices;ones(1,size(astrctMesh(k).m_a2fVertices,2))];
    astrctMesh(k).m_a2fVertices = a3fVerticesHomo(1:3,:);

end
return;