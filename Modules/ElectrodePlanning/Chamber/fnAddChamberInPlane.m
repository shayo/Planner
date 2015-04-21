    
function fnAddChamberInPlane()
global g_strctModule
fnChangeMouseMode('AddTwoClickObject', 'Add Chamber (in-plane)');
g_strctModule.m_hClickCallback = @fnAddChamberUsingTwoPoints;
return;