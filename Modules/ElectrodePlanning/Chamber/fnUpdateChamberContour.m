function fnUpdateChamberContour()
global g_strctModule
% Delete old contours.

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
                g_strctModule.m_ahChamberHandles=[g_strctModule.m_ahChamberHandles, fnDrawChamberGridAndElectrodes(strctChamber, true)];
            else
                g_strctModule.m_ahChamberHandles=[g_strctModule.m_ahChamberHandles, fnDrawChamberGridAndElectrodes(strctChamber, false)];
            end
        end
    end
end


if g_strctModule.m_bInChamberMode
    % generate the virtual arm with the attached chamber
    T = fnRobotForward(g_strctModule.m_strctVirtualArm,fnRobotGetConfFromRobotStruct(g_strctModule.m_strctVirtualArm));

     % This is the correct transformation to convert stereotax coordinates
     % (in cm) back to MRI space
     a2fManipulatorMM =inv(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fRegToStereoTactic)* T;
      a2fManipulatorMM(1:3,1:3)=10*a2fManipulatorMM(1:3,1:3);
     a2fManipulatorMM(1:3,3)=-a2fManipulatorMM(1:3,3);

    astrctChamberModel = g_strctModule.m_strctVirtualChamber.m_strctModel.m_astrctMeshShort;
     %Add a small cylinder in the middle for better visualization of the
     %trajectory in the center
    astrctChamberModel(end+1) = fnCreateCylinderMesh(0.3, -50,0, 10,[1 1 1]);
    % Change color...
    for k=1:length(astrctChamberModel)
        astrctChamberModel(k).m_afColor = [0 1 1];
    end
    astrctChamberModelTrans = fnApplyTransformOnMesh(astrctChamberModel,a2fManipulatorMM);
    g_strctModule.m_ahChamberHandles = [ g_strctModule.m_ahChamberHandles,fnDrawMesh(astrctChamberModelTrans);];
 
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
    
end