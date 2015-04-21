
function fnRotateMarkerAux(hAxes, afDelta)
global g_strctModule
strctCrossSection=fnAxesHandleToStrctCrossSection(hAxes);

if ~isfield(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol},'m_astrctMarkers') || ...
        isempty(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers) || ...
        isempty(strctCrossSection)
    return; 
end;

aiCurrMarkers = get(g_strctModule.m_strctPanel.m_hMarkersList,'value');
a2fCRS_To_XYZ = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fReg*g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fM; 

for iIter=1:length(aiCurrMarkers)
    iMarkerIndex = aiCurrMarkers(iIter);
    
    strctMarker = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers(iMarkerIndex);
    [afV1,afV2]=    fnGramSchmidt(strctMarker.m_afDirection_vox');
    a2fM_vox = eye(4);
    a2fM_vox(1:3,1) = afV1;
    a2fM_vox(1:3,2) = afV2;
    a2fM_vox(1:3,3) = strctMarker.m_afDirection_vox;
    a2fM_vox(1:3,4) = strctMarker.m_pt3fPosition_vox;
    a2fM = a2fCRS_To_XYZ*a2fM_vox;
    
    pt3fCurrPos = a2fM(1:3,4);
        a2fT = [1 0 0 -pt3fCurrPos(1); 
                0 1 0 -pt3fCurrPos(2);
                0 0 1 -pt3fCurrPos(3);
                0 0 0 1];
        a2fR = fnRotateVectorAboutAxis(strctCrossSection.m_a2fM(1:3,3),afDelta(1)/500*pi);
        a2fRot = zeros(4,4);
        a2fRot(1:3,1:3) = a2fR;
        a2fRot(4,4) = 1;
        
        a2fM_vox = inv(a2fCRS_To_XYZ)*inv(a2fT) * a2fRot * a2fT * a2fM; %#ok
        strctMarker.m_afDirection_vox = a2fM_vox(1:3,3);
        strctMarker.m_pt3fPosition_vox = a2fM_vox(1:3,4);
      g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers(iMarkerIndex) = strctMarker;
end

fnInvalidate();
return;

