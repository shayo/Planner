function fnModifyController(iControllerIndex,strctMouseOp,strWhat)
global g_strctModule
    strctObject = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_acControllableObjects{iControllerIndex};
switch  strctObject.m_strType
    case 'Ruler'
        g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_acControllableObjects{iControllerIndex} = fnModifyRulerPosition(strctObject, strWhat, strctMouseOp);
end

return;