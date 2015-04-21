strFile = ['C:\Users\shayo\Downloads\Funnel for 1mm ball'];
[v, f, n, c, stltitle] = stlread([strFile,'.stl']);
Tmp.faces = f;
Tmp.vertices = v * 2.54 * 10;


stlwrite([strFile,'_mm.stl'],Tmp,'mode','binary','title',stltitle,'facecolor',c)
  
% 
%   [v2, f2, n, c, stltitle] = stlread('C:\Users\shayo\Downloads\titanium adapter_mm.stl');
% Tmp2.faces = f2;
% Tmp2.vertices = v2;
% figure;
% patch(Tmp2,'facecolor','r','facealpha',0.5)
% lighting GOURAUD
% axis equal