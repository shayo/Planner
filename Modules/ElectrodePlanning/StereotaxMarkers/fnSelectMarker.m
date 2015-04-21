
function fnSelectMarker()
global g_strctModule
iSelectedMarker = get(g_strctModule.m_strctPanel.m_hMarkersList,'value');
if length(iSelectedMarker) > 1 || g_strctModule.m_iCurrAnatVol == 0
    return;
end;
if ~isempty(iSelectedMarker) && iSelectedMarker > 0 && isfield(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol},'m_astrctMarkers')
    if ~isempty(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers)
        strctMarker = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers(iSelectedMarker);
         if ~isfield(strctMarker,'m_astrctJointDescirptions')
            % Old version. Add as default the Kopf 1460 arm
            if strctMarker.m_bLeftArm
                [strctArm, astrctJointDescirptions] = fnKopf1460LeftArm();
            else
                [strctArm, astrctJointDescirptions] = fnKopf1460RightArm();
            end
            
            for iMarkerIter=1:length(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers)
                strctMarker = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers(iMarkerIter);
                
                strctNewMarker.m_pt3fPositionMM = strctMarker.m_pt3fPositionMM;
                strctNewMarker.m_strName = strctMarker.m_strName;
                strctNewMarker.m_strModelName = 'Kopf 1430';
                strctNewMarker.m_strctCrossSectionXY = strctMarker.m_strctCrossSectionXY; 
                strctNewMarker.m_strctCrossSectionYZ = strctMarker.m_strctCrossSectionYZ; 
                strctNewMarker.m_strctCrossSectionXZ = strctMarker.m_strctCrossSectionXZ; 
                
                astrctJointDescirptions(1).m_fValue = strctMarker.m_fAP_Value;
                astrctJointDescirptions(2).m_fValue = strctMarker.m_fHeightRotation_Value;
                astrctJointDescirptions(3).m_fValue = strctMarker.m_fMidlineRotation_Value;
                astrctJointDescirptions(4).m_fValue = strctMarker.m_fRot3_Value;
                astrctJointDescirptions(5).m_fValue = strctMarker.m_fZ_Value;
                astrctJointDescirptions(6).m_fValue = strctMarker.m_fMidline_Value;
                astrctJointDescirptions(7).m_fValue = 0;
                astrctJointDescirptions(8).m_fValue = 0;
                
                strctNewMarker.m_astrctJointDescirptions = astrctJointDescirptions;
                strctNewMarker.m_strArmType = strctArm.name;
                astrctNewMarkers(iMarkerIter) = strctNewMarker; %#ok
            end
            
             g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers = astrctNewMarkers;
             strctMarker = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers(iSelectedMarker);
         end

         a2fCRS_To_XYZ = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fReg*g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fM; 

          afMarkerMM = a2fCRS_To_XYZ*[strctMarker.m_pt3fPosition_vox;1];
      g_strctModule.m_strctCrossSectionXY.m_a2fM(1:3,4) =   afMarkerMM(1:3);
      g_strctModule.m_strctCrossSectionYZ.m_a2fM(1:3,4) =   afMarkerMM(1:3);
      g_strctModule.m_strctCrossSectionXZ.m_a2fM(1:3,4) =   afMarkerMM(1:3);
      
%       g_strctModule.m_strctCrossSectionXY = ...
%         strctMarker.m_strctCrossSectionXY;
% 
%     g_strctModule.m_strctCrossSectionYZ = ...
%         strctMarker.m_strctCrossSectionYZ;
% 
%     g_strctModule.m_strctCrossSectionXZ = ...
%         strctMarker.m_strctCrossSectionXZ;

    % Update Model box
    g_strctModule.m_iStereoModelSelected = find(ismember({g_strctModule.m_astrctStereoTaxticModels.m_strName},strctMarker.m_strModelName));
    set(g_strctModule.m_strctPanel.m_hStereoFramesList,'value',g_strctModule.m_iStereoModelSelected);
    % Update Arms according to selected model
    
    iNumArms = length(g_strctModule.m_astrctStereoTaxticModels(g_strctModule.m_iStereoModelSelected).m_astrctArms);
    acArmNames = cell(1,iNumArms);
    for k=1:iNumArms
        acArmNames{k} = g_strctModule.m_astrctStereoTaxticModels(g_strctModule.m_iStereoModelSelected).m_astrctArms(k).m_strctRobot.m_strName;
    end
    
    g_strctModule.m_iStereoArmSelected = find(ismember(acArmNames,strctMarker.m_strArmType ));
    set(g_strctModule.m_strctPanel.m_hStereoArmsList,'String',char(acArmNames),'value',g_strctModule.m_iStereoArmSelected);
    % Update Joints
    
    iNumJoints = length(g_strctModule.m_astrctStereoTaxticModels(g_strctModule.m_iStereoModelSelected).m_astrctArms(g_strctModule.m_iStereoArmSelected).m_strctRobot.m_astrctJointsDescription);
    acJointsNamesAndValues = cell(1,iNumJoints);% {.m_strName};
    for k=1:iNumJoints
        acJointsNamesAndValues{k} = sprintf('%-10.3f %s',...
            strctMarker.m_astrctJointDescirptions(k).m_fValue,...
            strctMarker.m_astrctJointDescirptions(k).m_strName);
    end;
    set(g_strctModule.m_strctPanel.m_hStereoJointsList,'String',acJointsNamesAndValues,'value',g_strctModule.m_iJointSelected);
    
    set(g_strctModule.m_strctPanel.m_hJointEdit,'String',...
        sprintf('%.3f',strctMarker.m_astrctJointDescirptions(g_strctModule.m_iJointSelected).m_fValue));
 
     fnSetArmOnMarker();
    %fnUpdateMarkerAxes();
    fnInvalidateStereotactic();
    fnInvalidate();
    end
end;

return;