function hPatch = fnPlotLinesAsSinglePatch(hAxes, a2fLines, afColor)
%a2fLines = [%x0 %y0 %x1 %y1]

%a2fLines = [xdata(1,:)', ydata(1,:)', xdata(2,:)',ydata(2,:)'];
% 
% a2fLineColors = [0 0 1 0 0.8 0 0 1 0 0.8;
%                  0 1 0 0 0.8 0 0 1 0 0.8;
%                  1 0 1 0 0.8 0 0 1 0 0.8]';

iNumLines = size(a2fLines,1);

vertices = reshape(a2fLines',2,size(a2fLines,1)*2)';
faces = reshape(1:iNumLines*2,2,iNumLines)';

if size(afColor,1) > 1
    [a2iUniqueColors,~,aiMapping] = unique(afColor,'rows');
    for k=1:size(a2iUniqueColors,1)
        hPatch(k) = patch('parent',hAxes,'Faces',faces(aiMapping==k,:),'Vertices',vertices,'edgecolor',a2iUniqueColors(k,:));%'FaceVertexCData',afColor,'edgecolor','flat');
    end
else
    hPatch = patch('parent',hAxes,'Faces',faces,'Vertices',vertices,'edgecolor',afColor);%'FaceVertexCData',a2fLineColors,'edgecolor','flat');
end
return;

