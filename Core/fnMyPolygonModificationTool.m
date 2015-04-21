function [afX, afY] = fnMyPolygonModificationTool(hAxes, X,Y)

apt2fArcLength= fnResampleArcLength2D([X(:),Y(:)], 2);
%afCurvature = LineCurvature2D(apt2fArcLength);
%figure;plot(afCurvature)

afX = apt2fArcLength(:,1);
afY = apt2fArcLength(:,2);
bCancelled = false;
hFig = get(hAxes,'parent');
strctSavedMouseHandles.m_hMouseDown = get(hFig,'WindowButtonDownFcn');
strctSavedMouseHandles.m_hMouseMove = get(hFig,'WindowButtonMotionFcn');
strctSavedMouseHandles.m_hMouseUp = get(hFig,'WindowButtonUpFcn');
strctSavedMouseHandles.m_hKeyDown = get(hFig,'WindowKeyPressFcn');
strctSavedMouseHandles.m_hKeyUp = get(hFig,'WindowKeyReleaseFcn');
strctSavedMouseHandles.m_hMouseScroll = get(hFig,'WindowScrollWheelFcn');
setappdata(hFig,'strctSavedMouseHandles',strctSavedMouseHandles);

set(hFig,'WindowButtonDownFcn', @fnMouseDown);
set(hFig,'WindowButtonMotionFcn', @fnMouseMove);
set(hFig,'WindowButtonUpFcn',   @fnMouseUp);
set(hFig,'WindowKeyPressFcn',   @fnKeyDown);
set(hFig,'WindowKeyReleaseFcn', @fnKeyUp);
set(hFig,'WindowScrollWheelFcn',    @fnMouseScroll);
hold(hAxes,'on');

pt2fMousePosition = get(hAxes,'CurrentPoint');
if size(pt2fMousePosition,2) ~= 3
    pt2fMousePosition = [-1 -1];
else
    pt2fMousePosition = [pt2fMousePosition(1,1), pt2fMousePosition(1,2)];
end;

strctBalloon.m_afX = afX;
strctBalloon.m_afY = afY;
strctBalloon.m_hAxes = hAxes;
strctBalloon.m_fRadius = 20;
strctBalloon.m_afAngle = linspace(0,2*pi,20);
strctBalloon.m_pt2fPosition = pt2fMousePosition;
setappdata(hFig,'bMouseDown',false);



afCircle = [strctBalloon.m_pt2fPosition(1)+cos(strctBalloon.m_afAngle)*strctBalloon.m_fRadius;...
                    strctBalloon.m_pt2fPosition(2)+sin(strctBalloon.m_afAngle)*strctBalloon.m_fRadius];
% Create the baloon 
strctBalloon.m_hHandle= plot(hAxes,afCircle(1,:),afCircle(2,:),'m');
strctBalloon.m_hPolygon = plot(hAxes, afX,afY,'c','Linewidth',2);
strctBalloon.m_hClose= plot(hAxes, afX,afY,'b.');
strctBalloon.m_hNotClose= plot(hAxes, afX,afY,'c.');
setappdata(hFig,'strctBalloon',strctBalloon);
uiwait(hFig);
strctBalloon=getappdata(hFig,'strctBalloon');
if strctBalloon.m_bSave
    afX = strctBalloon.m_afX;
    afY = strctBalloon.m_afY;
else
    afX = X;
    afY = Y;
end
return;


function fnQuit(hFig,bSave)
strctSavedMouseHandles = getappdata(hFig,'strctSavedMouseHandles');
strctBalloon = getappdata(hFig,'strctBalloon');

set(hFig,'WindowButtonDownFcn',strctSavedMouseHandles.m_hMouseDown);
set(hFig,'WindowButtonMotionFcn',strctSavedMouseHandles.m_hMouseMove);
set(hFig,'WindowButtonUpFcn',strctSavedMouseHandles.m_hMouseUp);
set(hFig,'WindowKeyPressFcn',strctSavedMouseHandles.m_hKeyDown);
set(hFig,'WindowKeyReleaseFcn',strctSavedMouseHandles.m_hKeyUp);
set(hFig,'WindowScrollWheelFcn',strctSavedMouseHandles.m_hMouseScroll);

delete(strctBalloon.m_hHandle);
delete(strctBalloon.m_hPolygon);
delete(strctBalloon.m_hClose);
delete(strctBalloon.m_hNotClose);
strctBalloon.m_bSave = bSave;
setappdata(hFig,'strctBalloon',strctBalloon);

uiresume(hFig);
return;

function fnMouseUp(hFig,eventdata)
setappdata(hFig,'bMouseDown',false);

function fnMouseDown(hFig,eventdata)
setappdata(hFig,'bMouseDown',true);
fnApplyForce(hFig);

return;

function fnApplyForce(hFig)

strctBalloon = getappdata(hFig,'strctBalloon');
pt2fMousePosition = get(strctBalloon.m_hAxes,'CurrentPoint');
if size(pt2fMousePosition,2) ~= 3
    pt2fMousePosition = [-1 -1];
else
    pt2fMousePosition = [pt2fMousePosition(1,1), pt2fMousePosition(1,2)];
end;

strctBalloon.m_pt2fPosition = pt2fMousePosition;
afCircle = [strctBalloon.m_pt2fPosition(1)+cos(strctBalloon.m_afAngle)*strctBalloon.m_fRadius;...
                    strctBalloon.m_pt2fPosition(2)+sin(strctBalloon.m_afAngle)*strctBalloon.m_fRadius];
set(strctBalloon.m_hHandle,'xdata',afCircle(1,:),'ydata',afCircle(2,:));

% Apply force.
% Compute the vector & distance for each of the points.
afVx = strctBalloon.m_afX - strctBalloon.m_pt2fPosition(1);
afVy = strctBalloon.m_afY - strctBalloon.m_pt2fPosition(2);
afDist = sqrt(afVx.^2+afVy.^2);
afVx = afVx ./ afDist;
afVy = afVy ./ afDist;
abClose = afDist < strctBalloon.m_fRadius;

set(strctBalloon.m_hClose,'xdata',  strctBalloon.m_afX(abClose),'ydata',strctBalloon.m_afY(abClose));
set(strctBalloon.m_hNotClose,'xdata',  strctBalloon.m_afX(~abClose),'ydata',strctBalloon.m_afY(~abClose));

strctBalloon.m_afX(abClose) = strctBalloon.m_afX(abClose) + afVx(abClose)*1./afDist(abClose)*strctBalloon.m_fRadius ;
strctBalloon.m_afY(abClose) = strctBalloon.m_afY(abClose) + afVy(abClose)*1./afDist(abClose)*strctBalloon.m_fRadius;

apt2fArcLength= fnResampleArcLength2D([strctBalloon.m_afX(:),strctBalloon.m_afY(:)], 2);
strctBalloon.m_afX = apt2fArcLength(:,1);
strctBalloon.m_afY= apt2fArcLength(:,2);

set(strctBalloon.m_hPolygon,'xdata',strctBalloon.m_afX,'ydata',strctBalloon.m_afY);
setappdata(hFig,'strctBalloon',strctBalloon);

function fnMouseScroll(hFig,eventdata)
strctBalloon = getappdata(hFig,'strctBalloon');
strctBalloon.m_fRadius = max(1,strctBalloon.m_fRadius + eventdata.VerticalScrollCount);
% afCircle = [strctBalloon.m_pt2fPosition(1)+cos(strctBalloon.m_afAngle)*strctBalloon.m_fRadius;...
%                     strctBalloon.m_pt2fPosition(2)+sin(strctBalloon.m_afAngle)*strctBalloon.m_fRadius];
% set(strctBalloon.m_hHandle,'xdata',afCircle(1,:),'ydata',afCircle(2,:));
fnMouseMove(hFig,[]);
setappdata(hFig,'strctBalloon',strctBalloon);

function fnMouseMove(hFig,eventdata)
strctBalloon = getappdata(hFig,'strctBalloon');
pt2fMousePosition = get(strctBalloon.m_hAxes,'CurrentPoint');
if size(pt2fMousePosition,2) ~= 3
    pt2fMousePosition = [-1 -1];
else
    pt2fMousePosition = [pt2fMousePosition(1,1), pt2fMousePosition(1,2)];
end;

strctBalloon.m_pt2fPosition = pt2fMousePosition;
afCircle = [strctBalloon.m_pt2fPosition(1)+cos(strctBalloon.m_afAngle)*strctBalloon.m_fRadius;...
                    strctBalloon.m_pt2fPosition(2)+sin(strctBalloon.m_afAngle)*strctBalloon.m_fRadius];
set(strctBalloon.m_hHandle,'xdata',afCircle(1,:),'ydata',afCircle(2,:));



% Apply force.
% Compute the vector & distance for each of the points.
afVx = strctBalloon.m_afX - strctBalloon.m_pt2fPosition(1);
afVy = strctBalloon.m_afY - strctBalloon.m_pt2fPosition(2);
afDist = sqrt(afVx.^2+afVy.^2);
abClose = afDist < strctBalloon.m_fRadius;

set(strctBalloon.m_hClose,'xdata',  strctBalloon.m_afX(abClose),'ydata',strctBalloon.m_afY(abClose));
set(strctBalloon.m_hNotClose,'xdata',  strctBalloon.m_afX(~abClose),'ydata',strctBalloon.m_afY(~abClose));



setappdata(hFig,'strctBalloon',strctBalloon);


bMouseDown=getappdata(hFig,'bMouseDown');
if bMouseDown
        fnApplyForce(hFig);
end

return;



function fnKeyDown(hFig,eventdata)
if strcmp(eventdata.Key,'escape')
    fnQuit(hFig,false);
elseif strcmp(eventdata.Key,'return')
    fnQuit(hFig,true);
elseif strcmp(eventdata.Key,'hyphen')
strctBalloon = getappdata(hFig,'strctBalloon');
strctBalloon.m_fRadius = max(1,strctBalloon.m_fRadius - 1);
fnMouseMove(hFig,[]);
setappdata(hFig,'strctBalloon',strctBalloon);
    
    elseif strcmp(eventdata.Key,'equal')
strctBalloon = getappdata(hFig,'strctBalloon');
strctBalloon.m_fRadius = max(1,strctBalloon.m_fRadius + 1);
fnMouseMove(hFig,[]);
setappdata(hFig,'strctBalloon',strctBalloon);

end

function fnKeyUp(a,b)
