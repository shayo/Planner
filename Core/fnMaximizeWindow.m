function fnMaximizeWindow(hFigure)

iNumTitle = get(hFigure,'NumberTitle');
strFigureName= get(hFigure,'Name');

if isnumeric(hFigure)
    figString = num2str(hFigure);
else
    figString = num2str(hFigure.Number);
end

strWindowName = ['maximize_', figString];
set(hFigure,'Name',strWindowName,'NumberTitle','off');
drawnow; % Make sure this takes effect
if ~isunix
	fnMaximizeWind(strWindowName,get(hFigure),'Resize');
else
	% to make maximize work on unices
	maximize_old(hFigure);
end

set(hFigure,'Name',strFigureName,'NumberTitle',iNumTitle);

return;
