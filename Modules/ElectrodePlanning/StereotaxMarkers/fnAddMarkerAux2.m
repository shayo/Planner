function fnAddMarkerAux2(pt3fPosVoxel,pt3fPosInStereoSpace,pt3fPosInVol, afMarkerDirection_vox)
global g_strctModule
if ~exist('afMarkerDirection_vox','var')
    afMarkerDirection_vox = [NaN,NaN,NaN];
end
if ~isfield(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol},'m_astrctMarkers') 
    iNewMarkerIndex = 1;
else
    iNewMarkerIndex = 1+length(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers);    
end

strctMarker.m_pt3fPosition_vox = pt3fPosVoxel;
strctMarker.m_afDirection_vox = afMarkerDirection_vox;
strctMarker.m_strName = sprintf('Marker %d ',iNewMarkerIndex);
    %pt3fPosInStereoSpace(1),pt3fPosInStereoSpace(2),pt3fPosInStereoSpace(3));

strctMarker.m_strModelName = g_strctModule.m_astrctStereoTaxticModels(g_strctModule.m_iStereoModelSelected).m_strName;


strctMarker.m_strctCrossSectionXY = g_strctModule.m_strctCrossSectionXY;
strctMarker.m_strctCrossSectionYZ = g_strctModule.m_strctCrossSectionYZ;
strctMarker.m_strctCrossSectionXZ = g_strctModule.m_strctCrossSectionXZ;
strctMarker.m_strctCrossSectionXY.m_a2fM(1:3,4) = pt3fPosInVol(1:3);
strctMarker.m_strctCrossSectionYZ.m_a2fM(1:3,4) = pt3fPosInVol(1:3);
strctMarker.m_strctCrossSectionXZ.m_a2fM(1:3,4) = pt3fPosInVol(1:3);

% Add a new marker with this model:
strctMarker.m_astrctJointDescirptions = ...
    g_strctModule.m_astrctStereoTaxticModels(g_strctModule.m_iStereoModelSelected).m_astrctArms(g_strctModule.m_iStereoArmSelected).m_strctRobot.m_astrctJointsDescription;
strctMarker.m_strArmType = g_strctModule.m_astrctStereoTaxticModels(g_strctModule.m_iStereoModelSelected).m_astrctArms(g_strctModule.m_iStereoArmSelected).m_strctRobot.m_strName;                
strctMarker.m_bEnabled = true;
%%

if ~isfield(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol},'m_astrctMarkers') || ...
        isempty(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers)
     g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers = strctMarker;
else
    iNumMarkers = length(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers);    
    g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers(iNumMarkers+1) = strctMarker;
end;
fnUpdateMarkerList();
return;

