
function  fnDrawControlableObject()
global g_strctModule
% Delete old contours.

if isfield(g_strctModule,'m_ahControllableObjects')
    delete(g_strctModule.m_ahControllableObjects(ishandle(g_strctModule.m_ahControllableObjects)));
end;

ahRulerHandles = [];
if isfield(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol},'m_acControllableObjects')
    iNumObjects = length(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_acControllableObjects); 
    for iObjectIter=1:iNumObjects
        strctObject = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_acControllableObjects{iObjectIter};
        switch strctObject.m_strType
            case 'Ruler'
                ahRulerHandles = [ahRulerHandles,fnDrawRuler(strctObject)]; %#ok
        end
    end
end

g_strctModule.m_ahControllableObjects = ahRulerHandles;
return;