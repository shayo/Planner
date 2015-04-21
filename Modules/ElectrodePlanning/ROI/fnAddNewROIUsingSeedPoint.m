function fnAddNewROIUsingSeedPoint()
global g_strctModule g_strctWindows
fnChangeMouseMode('AddSingleClickObject', 'Select Seed Point')
g_strctModule.m_hClickCallback = @fnAddNewROIAux;
[a2fX,a2fY]=meshgrid(-8:7,-8:7);
a2fD = sqrt(a2fX.^2+a2fY.^2);
a2iPointerShape = NaN*ones(16,16);
a2iPointerShape(a2fD > 6 & a2fD < 7) = 2;
set(g_strctWindows.m_hFigure,'Pointer','custom','PointerShapeHotSpot',[8 8],'PointerShapeCData',a2iPointerShape);

return;

