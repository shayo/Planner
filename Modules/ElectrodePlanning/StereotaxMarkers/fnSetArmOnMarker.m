
function fnSetArmOnMarker()
global g_strctModule
iSelectedMarker = get(g_strctModule.m_strctPanel.m_hMarkersList,'value');
if length(iSelectedMarker) > 1 || g_strctModule.m_iCurrAnatVol == 0
    return;
end;
if ~isempty(iSelectedMarker) && iSelectedMarker > 0 && isfield(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol},'m_astrctMarkers')
    if ~isempty(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers)
        strctMarker = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers(iSelectedMarker);
        
    iNewModelIndex = find(ismember({g_strctModule.m_astrctStereoTaxticModels.m_strName},strctMarker.m_strModelName));
   iNumArms= length(g_strctModule.m_astrctStereoTaxticModels(iNewModelIndex).m_astrctArms);
    acArmsName = cell(1,iNumArms);
    for k=1:iNumArms
        acArmsName{k} = g_strctModule.m_astrctStereoTaxticModels(iNewModelIndex).m_astrctArms(k).m_strctRobot.m_strName;
    end
    iNewArmIndex = find(ismember(acArmsName,strctMarker.m_strArmType));
    if isempty(iNewArmIndex)
        return;
    end;
    

iCombinedIndex = find(g_strctModule.m_strctPanel.m_aiModelIndex == iNewModelIndex & g_strctModule.m_strctPanel.m_aiArmIndex == iNewArmIndex);
set(g_strctModule.m_strctPanel.m_hVirtualArmType,'value',iCombinedIndex );
     
% First, delete current controllers.
try
    delete([g_strctModule.m_strctPanel.m_ahLinkEdit,g_strctModule.m_strctPanel.m_ahLinkFixed,g_strctModule.m_strctPanel.m_ahLinkSlider]);
catch %#ok
end

if ~iscell(g_strctModule.m_strctConfig.m_acStereoModels.m_strctModel{iNewModelIndex}.m_strctArm)
    g_strctModule.m_strctVirtualArm = feval(g_strctModule.m_strctConfig.m_acStereoModels.m_strctModel{iNewModelIndex}.m_strctArm.m_strModelFunction);
else
    g_strctModule.m_strctVirtualArm = feval(g_strctModule.m_strctConfig.m_acStereoModels.m_strctModel{iNewModelIndex}.m_strctArm{iNewArmIndex}.m_strModelFunction);
end


%     g_strctModule.m_strctVirtualArm = g_strctModule.m_astrctStereoTaxticModels(iNewModelIndex).m_astrctArms(iNewArmIndex).m_strctRobot;
    fnChangeVirtualArmTypeAux();
    % Update Joints
    iNumJoints = length(g_strctModule.m_astrctStereoTaxticModels(g_strctModule.m_iStereoModelSelected).m_astrctArms(g_strctModule.m_iStereoArmSelected).m_strctRobot.m_astrctJointsDescription);
    for k=1:iNumJoints
            set(g_strctModule.m_strctPanel.m_ahLinkEdit(k),'string',num2str(strctMarker.m_astrctJointDescirptions(k).m_fValue));
            feval(g_strctModule.m_hCallbackFunc,'LinkEditValue',k);
    end
  
    fnInvalidateStereotactic();
    fnInvalidate();
    end
end;

return;
