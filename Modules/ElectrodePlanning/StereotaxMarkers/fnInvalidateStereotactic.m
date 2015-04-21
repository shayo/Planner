function fnInvalidateStereotactic()
global g_strctModule
%%5
fnClearStereoTactic();


% g_strctModule.m_strctVirtualArm = fnKopf1460LeftArm();% 
g_strctModule.m_ahRobotHandles = fnRobotDraw(g_strctModule.m_strctVirtualArm,fnRobotGetConfFromRobotStruct(g_strctModule.m_strctVirtualArm),...
     g_strctModule.m_strctPanel.m_strctStereoTactic.m_hAxes,1);
% 
% if isfield(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol},'m_astrctMarkers')
%     % Draw features using the foward model
%     apt3fMarkersStereoTaticCoord=fnSolveRegistrationAux();
%     
%     plot3(g_strctModule.m_strctPanel.m_strctStereoTactic.m_hAxes,...
%         apt3fMarkersStereoTaticCoord(1,:),...
%         apt3fMarkersStereoTaticCoord(2,:),...
%         apt3fMarkersStereoTaticCoord(3,:),'c.','Markersize',11);
% end
% 


strctIsoCRS = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_strctSurface;
if ~isempty(strctIsoCRS)
    iNumVertices = size(strctIsoCRS.vertices,1);
    if iNumVertices > 0
        
        a2fCRS_To_XYZ = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fReg*g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fM; 
        VerticesXYZmmMRI =  a2fCRS_To_XYZ*[strctIsoCRS.vertices,ones(iNumVertices,1)]';

        a2fSurfTrans = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fRegToStereoTactic;%*g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fReg*g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fM;
        
        VerticesXYZcmStereotax = a2fSurfTrans*10*VerticesXYZmmMRI;
% % FIXED! 18 Apr 2014.
% a2fChamberInStereoTacticCoord =   * a2fChamberInMRI;
% a2fChamberInStereoTacticCoord(1:3,4)=1/10*a2fChamberInStereoTacticCoord(1:3,4);
        
        %g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fRegToStereoTactic*VerticesXYZmmMRI
        
        
        strctIsoXYZ.vertices = VerticesXYZcmStereotax(1:3,:)';
        strctIsoXYZ.faces = strctIsoCRS.faces;
        g_strctModule.hSurfaceInStereoTaxtic = patch(strctIsoXYZ, ...
            'parent',g_strctModule.m_strctPanel.m_strctStereoTactic.m_hAxes,'visible','on');
        set(g_strctModule.hSurfaceInStereoTaxtic,'FaceColor','b','EdgeColor','none','facealpha',0.2 );
        %  plot3([0 0],[0 0],[0 10],'parent',g_strctModule.m_strctPanel.m_strctStereoTactic.m_hAxes,'color','g','LineWidth',10);
        
        % plot ear bars
       % plot3([fEarBarOffsetCM fEarBarOffsetCM],[0 fAPBarsDistance],[0 0],'LineWidth',3,'color','m');
        %camlight('right')
        axis(g_strctModule.m_strctPanel.m_strctStereoTactic.m_hAxes,'equal');
        lighting('gouraud');
    end
end

% Draw chambers
if isfield(g_strctModule,'m_ahChamberHandles')
    delete(g_strctModule.m_ahChamberHandles(ishandle(g_strctModule.m_ahChamberHandles)));
end;

g_strctModule.m_ahChamberHandles = [];
if ~isempty(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers) && g_strctModule.m_iCurrChamber ~= 0
    iNumChambers = length(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers);
    for iChamberIter=1:iNumChambers
        strctChamber = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctChambers(iChamberIter);
        if strctChamber.m_bVisible
            if iChamberIter == g_strctModule.m_iCurrChamber
                g_strctModule.m_ahChamberHandles=[g_strctModule.m_ahChamberHandles, fnDrawChamberGridAndElectrodes2(strctChamber, true)];
            else
                g_strctModule.m_ahChamberHandles=[g_strctModule.m_ahChamberHandles, fnDrawChamberGridAndElectrodes2(strctChamber, false)];
            end
        end
    end
end

