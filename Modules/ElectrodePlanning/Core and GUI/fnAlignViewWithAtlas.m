function fnAlignViewWithAtlas(pt2fAtlasSpecificCoordinate)
global g_strctModule

if ~isfield(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol},'m_a2fAtlasReg')
    g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fAtlasReg = eye(4);
end;
   
afDV = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fAtlasReg(1:3,3) / norm(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fAtlasReg(1:3,3));
afAP = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fAtlasReg(1:3,1) / norm(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fAtlasReg(1:3,1));
afML = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fAtlasReg(1:3,2) / norm(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fAtlasReg(1:3,2));

pt3fZeroPosMM = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fAtlasReg(1:3,4);

g_strctModule.m_strctCrossSectionXZ.m_a2fM = [-afAP,-afML,afDV, pt3fZeroPosMM;0,0,0,1];
g_strctModule.m_strctCrossSectionXZ.m_fViewOffsetMM = 0;

a2fRot = fnRotateVectorAboutAxis([0 0 1],pi/2);
a2fRot(4,4)=1;
g_strctModule.m_strctCrossSectionYZ.m_a2fM = [afML,afDV,afAP, pt3fZeroPosMM;0,0,0,1] * a2fRot;
g_strctModule.m_strctCrossSectionYZ.m_fViewOffsetMM = 0;

g_strctModule.m_strctCrossSectionXY.m_a2fM = [-afAP,-afDV,afML, pt3fZeroPosMM;0,0,0,1] ;

g_strctModule.m_strctCrossSectionXY.m_fViewOffsetMM = 0;

if exist('pt2fAtlasSpecificCoordinate','var')
    % The default view will bring us to ML=0,AP=0,DV=0.
    % Now we want to shift these planes to a new coordinate
    g_strctModule.m_strctCrossSectionXZ.m_a2fM(1:3,4) = g_strctModule.m_strctCrossSectionXZ.m_a2fM(1:3,4) + ...
        g_strctModule.m_strctCrossSectionXZ.m_a2fM(1:3,3) * pt2fAtlasSpecificCoordinate(3);

    g_strctModule.m_strctCrossSectionYZ.m_a2fM(1:3,4) = g_strctModule.m_strctCrossSectionYZ.m_a2fM(1:3,4) + ...
        g_strctModule.m_strctCrossSectionYZ.m_a2fM(1:3,3) * pt2fAtlasSpecificCoordinate(1);

    g_strctModule.m_strctCrossSectionXY.m_a2fM(1:3,4) = g_strctModule.m_strctCrossSectionXY.m_a2fM(1:3,4) + ...
        g_strctModule.m_strctCrossSectionXY.m_a2fM(1:3,3) * pt2fAtlasSpecificCoordinate(2);
    
end

return;
