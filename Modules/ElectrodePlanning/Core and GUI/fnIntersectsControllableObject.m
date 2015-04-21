
function [bIntersects, strctObject, strWhat,iObjectIndex] = fnIntersectsControllableObject(strctMouseOp)
global g_strctModule    
bIntersects = false;
strctObject  = [];
strWhat = [];
iObjectIndex = [];
if isfield(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol},'m_acControllableObjects')
    iNumObjects = length(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_acControllableObjects); 
    for iObjectIter=1:iNumObjects
        strctObject = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_acControllableObjects{iObjectIter};
        switch strctObject.m_strType
            case 'Ruler'
                iObjectIndex = iObjectIter;
               [bIntersects, strWhat] = fnIntersectsRuler(strctObject, strctMouseOp);
               if bIntersects
                return;
               end;
        end
    end
end

return;
