
function fnAddChamberSinglePointAux(strctMouseOp)
global g_strctModule
[pt3fPosIn3DSpace, pt3fPosInStereoSpace, pt3fVoxelCoordinate, strctCrossSection]=fnGet3DCoord(strctMouseOp); %#ok

a2fM = eye(4);
a2fM(1:3,1:3) = strctCrossSection.m_a2fM(1:3,1:3);
a2fM(1:3,4) =pt3fPosIn3DSpace(1:3);

switch strctMouseOp.m_hAxes 
    case g_strctModule.m_strctPanel.m_strctXY.m_hAxes % Horizontal
         a2fM(1:3,3)=-a2fM(1:3,3);
    case g_strctModule.m_strctPanel.m_strctYZ.m_hAxes
        % Saggital. Should be oriented Towards ML=0
        fML = pt3fPosInStereoSpace(2);
        if fML < 0
            a2fM(1:3,3) = -a2fM(1:3,3);
        end
    case g_strctModule.m_strctPanel.m_strctXZ.m_hAxes
        % Coronal. If AP < 0
        fAP = pt3fPosInStereoSpace(1);
        if fAP < 0
            a2fM(1:3,3) = -a2fM(1:3,3);
        end
        
end

fnAddChamberAux(a2fM);
return;      

