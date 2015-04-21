
function fnAddChamberNormalToPlane()
global g_strctModule
fnChangeMouseMode('AddSingleClickObject', 'Add Chamber (normal-to-plane)');
g_strctModule.m_hClickCallback = @fnAddChamberSinglePointAux;
return;

