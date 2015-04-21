function fnRotateAtlas(hAxes, afDelta)
global g_strctModule
if isempty(g_strctModule.m_acAnatVol)
    return;
end;
a2fM = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fAtlasReg;
strctCrossSection = fnAxesHandleToStrctCrossSection(hAxes);

dxy = -g_strctModule.m_strctCrossSectionXY.m_a2fM(1:3,3)' * g_strctModule.m_strctCrossSectionXY.m_a2fM(1:3,4);
dyz = -g_strctModule.m_strctCrossSectionYZ.m_a2fM(1:3,3)' * g_strctModule.m_strctCrossSectionYZ.m_a2fM(1:3,4);
dxz = -g_strctModule.m_strctCrossSectionXZ.m_a2fM(1:3,3)' * g_strctModule.m_strctCrossSectionXZ.m_a2fM(1:3,4);
Nxy =  g_strctModule.m_strctCrossSectionXY.m_a2fM(1:3,3);
Nyz =  g_strctModule.m_strctCrossSectionYZ.m_a2fM(1:3,3);
Nxz =  g_strctModule.m_strctCrossSectionXZ.m_a2fM(1:3,3);
P=-(dxy* cross(Nyz,Nxz) + dyz * cross(Nxz,Nxy) + dxz * cross(Nxy,Nyz)) ./ dot(Nxy, cross(Nyz,Nxz));

% Find the intersection point of the two other cross sections
if ~isempty(strctCrossSection)
    pt3fCurrPos = P;
    a2fT = [1 0 0 -pt3fCurrPos(1);
        0 1 0 -pt3fCurrPos(2);
        0 0 1 -pt3fCurrPos(3);
        0 0 0 1];
    a2fR = fnRotateVectorAboutAxis(strctCrossSection.m_a2fM(1:3,3),afDelta(1)/200*pi);
    a2fRot = zeros(4,4);
    a2fRot(1:3,1:3) = a2fR;
    a2fRot(4,4) = 1;
    
    g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fAtlasReg = inv(a2fT) * a2fRot * a2fT * a2fM; %#ok
end
fnInvalidate();
return;