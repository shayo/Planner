
function fnAddMarkerSmart()
global g_strctModule 
fnChangeMouseMode('AddTwoClickObject', 'Add Marker');
g_strctModule.m_hClickCallback = @fnAddMarkerSmartAux;
return;
