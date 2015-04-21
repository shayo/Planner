

function fnCorrectOrientation()
global g_strctModule
if g_strctModule.m_iCurrAnatVol == 0
    return;
end;
X = OrientationWizard(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol});
if ~isempty(X)
    g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol} = X;
    fnSetDefaultCrossSections();
    fnInvalidate();
end
return;
