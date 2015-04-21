
function fnSwitchStereoModel()
global g_strctModule
iNewModel = get(g_strctModule.m_strctPanel.m_hStereoFramesList,'value');
% Warning, this will erase ALL previous information about current marker
% Current marker?

g_strctModule.m_iStereoModelSelected = iNewModel;

% Update the arm list
g_strctModule.m_iStereoArmSelected = 1;
g_strctModule.m_iJointSelected = 1;

iNumArms = length(g_strctModule.m_astrctStereoTaxticModels(g_strctModule.m_iStereoModelSelected).m_astrctArms);
acArmNames = cell(1,iNumArms);
for k=1:iNumArms
    acArmNames{k} = g_strctModule.m_astrctStereoTaxticModels(g_strctModule.m_iStereoModelSelected).m_astrctArms(k).m_strctRobot.m_strName;
end
set(g_strctModule.m_strctPanel.m_hStereoArmsList,'String',char(acArmNames),'value',g_strctModule.m_iStereoArmSelected);


iSelectedMarker = get(g_strctModule.m_strctPanel.m_hMarkersList,'value');

if ~isempty(iSelectedMarker) && iSelectedMarker > 0 && isfield(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol},'m_astrctMarkers') && ...
        ~isempty(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers)
    
    strctMarker = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers(iSelectedMarker);
    if strcmpi(strctMarker.m_strModelName, g_strctModule.m_astrctStereoTaxticModels(g_strctModule.m_iStereoModelSelected).m_strName) == 0
        % Model mismatch
        
        ButtonName = questdlg('Are you sure you want to change the model? It will erase all previous information about joint parameters.', ...
            'Important Question', ...
            'Yes', 'No', 'No');
        if strcmp(ButtonName,'Yes')
            g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers(iSelectedMarker).m_strModelName = ...
                g_strctModule.m_astrctStereoTaxticModels(g_strctModule.m_iStereoModelSelected).m_strName;
            
            g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers(iSelectedMarker).m_strArmType = ...
                g_strctModule.m_astrctStereoTaxticModels(g_strctModule.m_iStereoModelSelected).m_astrctArms(1).m_strctRobot.m_strName;
            
            g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctMarkers(iSelectedMarker).m_astrctJointDescirptions = ...
                g_strctModule.m_astrctStereoTaxticModels(g_strctModule.m_iStereoModelSelected).m_astrctArms(g_strctModule.m_iStereoArmSelected).m_strctRobot.m_astrctJointsDescription;
            
        end
        
    end
end

%g_strctModule.m_iStereoArmSelected = 1;
%g_strctModule.m_iJointSelected = 1;
fnSelectMarker();
return;
