function fnUpdateTargetContours()
global g_strctModule
if g_strctModule.m_iCurrAnatVol == 0 || ~isfield(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol},'m_astrctTargets')
    return;
end;
if isfield(g_strctModule.m_strctPanel,'m_ahTargets')
    delete(g_strctModule.m_strctPanel.m_ahTargets);
    g_strctModule.m_strctPanel.m_ahTargets = [];
end;
iNumTargets = length(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctTargets);
ahHandles = [];
ahAxes = [g_strctModule.m_strctPanel.m_strctXY.m_hAxes,...
    g_strctModule.m_strctPanel.m_strctYZ.m_hAxes,...
    g_strctModule.m_strctPanel.m_strctXZ.m_hAxes];
astrctCrossSection = [g_strctModule.m_strctCrossSectionXY,...
    g_strctModule.m_strctCrossSectionYZ,...
    g_strctModule.m_strctCrossSectionXZ];

iSelectedTarget = get(g_strctModule.m_strctPanel.m_hTargetList,'value');
a2fCRS_To_XYZ = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fReg*g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fM; 
aiCurrTarget = get(g_strctModule.m_strctPanel.m_hTargetList,'value');
    
for iTargetIter=1:iNumTargets
    strctTarget = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctTargets(iTargetIter);
    if iSelectedTarget == iTargetIter
        astrctMesh = fnBuildTargetMesh(strctTarget,1);
    else
        astrctMesh = fnBuildTargetMesh(strctTarget,0);
    end
    
    for iAxesIter=1:3
        for iMeshIter=1:length(astrctMesh)
            a2fLinesPix = fnMeshCrossSectionIntersection(astrctMesh(iMeshIter), astrctCrossSection(iAxesIter) );
            if ~isempty(a2fLinesPix)
                ahHandles(end+1) = fnPlotLinesAsSinglePatch(ahAxes(iAxesIter), a2fLinesPix, astrctMesh(iMeshIter).m_afColor); %#ok
            end;
        end;
        
    end;
    pt3fTarget3D = inv(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_strctCrossSectionHoriz.m_a2fM) *a2fCRS_To_XYZ*[strctTarget.m_pt3fPositionVoxel;1];
    
    % Draw target in 3D
    if sum(iTargetIter == aiCurrTarget) > 0
        iSize = 21;
    else
        iSize = 11;
    end;
    
    hTargetin3D = plot3(pt3fTarget3D(1),pt3fTarget3D(2),pt3fTarget3D(3),'b.','MarkerSize',iSize,'parent',...
        g_strctModule.m_strctPanel.m_strct3D.m_hAxes);
    ahHandles = [ahHandles,hTargetin3D]; %#ok
end;

g_strctModule.m_strctPanel.m_ahTargets = ahHandles;
return;