function fnAddGridUsingDirection()
global g_strctModule
fnChangeMouseMode('AddTwoClickObject', 'Add Grid using direction');
g_strctModule.m_hClickCallback = @fnAddGridUsingTwoPoints;
return;