function fnRemoveRuler(iRulerID)    
global g_strctModule
for iIter=1:length(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_acControllableObjects)
    if g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_acControllableObjects{iIter}.m_iUniqueID == iRulerID
        g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_acControllableObjects(iIter) = [];
        break;
    end
end
fnInvalidate(1);
return;