function ahHolesHandles = fnDraw2DGridModel_DualCircular(strctGridModel, hAxes, hContextMenu)
cla(hAxes);
hold(hAxes,'on');
set(hAxes,'uicontextmenu',hContextMenu);

afAngle = linspace(0,2*pi,20);
afCos = cos(afAngle);
afSin= sin(afAngle);

iNumHoles = length(strctGridModel.m_afGridHolesX);

ahHolesHandles = zeros(1,iNumHoles);
fHoleDiam1 = fnGetGridParameter(strctGridModel.m_strctGridParams,'HoleDiam1');
fHoleDiam2 = fnGetGridParameter(strctGridModel.m_strctGridParams,'HoleDiam2');
for iHoleIter=1:iNumHoles
    
    if strctGridModel.m_aiSubModelInd(iHoleIter) == 1
        fHoleDiameterMM = fHoleDiam1;
    else
        fHoleDiameterMM = fHoleDiam2;
    end
    
    if strctGridModel.m_strctGridParams.m_abSelectedHoles(iHoleIter)
        ahHolesHandles(iHoleIter) =  fill( (strctGridModel.m_afGridHolesX(iHoleIter) + afCos*fHoleDiameterMM/2),...
            strctGridModel.m_afGridHolesY(iHoleIter) + afSin*fHoleDiameterMM/2,...
            'm','parent',hAxes,'uicontextmenu',hContextMenu);
    else
    ahHolesHandles(iHoleIter) = plot(hAxes, ...
            (strctGridModel.m_afGridHolesX(iHoleIter) + afCos*fHoleDiameterMM/2),...
            strctGridModel.m_afGridHolesY(iHoleIter) + afSin*fHoleDiameterMM/2,...
            'color',[0.5 0.5 0.5],'uicontextmenu',hContextMenu);
         
    end;    
end;

% Plot inner diameters...
fInnerDiameterMM0 = fnGetGridParameter(strctGridModel.m_strctGridParams,'GridInnerDiam0');
fInnerDiameterMM1 = fnGetGridParameter(strctGridModel.m_strctGridParams,'GridInnerDiam1');
fInnerDiameterMM2 = fnGetGridParameter(strctGridModel.m_strctGridParams,'GridInnerDiam2');


fCenterX1= fnGetGridParameter(strctGridModel.m_strctGridParams,'ShiftX1');
fCenterY1= fnGetGridParameter(strctGridModel.m_strctGridParams,'ShiftY1');

fCenterX2= fnGetGridParameter(strctGridModel.m_strctGridParams,'ShiftX2');
fCenterY2= fnGetGridParameter(strctGridModel.m_strctGridParams,'ShiftY2');


fTheta0Rad = fnGetGridParameter(strctGridModel.m_strctGridParams,'Theta0')/180*pi;
fTheta1Rad = fnGetGridParameter(strctGridModel.m_strctGridParams,'Theta1')/180*pi;
fTheta2Rad = fnGetGridParameter(strctGridModel.m_strctGridParams,'Theta2')/180*pi;

fnPlotRotatedCircle(hAxes,fCenterX1,fCenterY1, fInnerDiameterMM1, fTheta0Rad,'b',hContextMenu);
fnPlotRotatedCircle(hAxes,fCenterX2,fCenterY2, fInnerDiameterMM2, fTheta0Rad,'g',hContextMenu);
fnPlotRotatedCircle(hAxes,0,0, fInnerDiameterMM0, 0,'m',hContextMenu);

fnPlotRotatedLine(hAxes,0,0, fInnerDiameterMM0/2, fTheta0Rad, 0, 'm',hContextMenu);
fnPlotRotatedLine(hAxes,fCenterX1,fCenterY1, fInnerDiameterMM1/2, fTheta0Rad, fTheta1Rad, 'b',hContextMenu);
fnPlotRotatedLine(hAxes,fCenterX2,fCenterY2, fInnerDiameterMM2/2, fTheta0Rad, fTheta2Rad, 'g',hContextMenu);


set(hAxes,'xlim',[-fInnerDiameterMM0/2 fInnerDiameterMM0/2],'ylim',[-fInnerDiameterMM0/2 fInnerDiameterMM0/2]);
axis(hAxes,'equal')
box on
return;


function fnPlotRotatedLine(hAxes,fCenterX,fCenterY, fInnerDiameterMM, fTheta0Rad, fTheta1Rad, strColor, hContextMenu)
% First Rotate
Line = [0 0
        0 fInnerDiameterMM;
        1  1];
    
a2fR1 = [cos(fTheta1Rad) sin(fTheta1Rad) ,fCenterX;
         -sin(fTheta1Rad) cos(fTheta1Rad),fCenterY;
         0                0              , 1];
     
a2fR0 = [cos(fTheta0Rad) sin(fTheta0Rad) ,0;
         -sin(fTheta0Rad) cos(fTheta0Rad),0;
           0,0,1];

Tmp = a2fR0 * a2fR1 *  Line;
plot(hAxes, ...
    Tmp(1,:),Tmp(2,:),strColor,'LineWidth',2,'uicontextmenu',hContextMenu);
return;


function fnPlotRotatedCircle(hAxes,fCenterX,fCenterY, fDiameter, fRotation,strColor,hContextMenu)
afAngle = linspace(0,2*pi,20);
afCos = cos(afAngle);
afSin= sin(afAngle);

afX = fCenterX+afCos*fDiameter/2;
afY = fCenterY+afSin*fDiameter/2;
a2fR = [cos(fRotation) sin(fRotation)
-sin(fRotation) cos(fRotation)];

Tmp = a2fR*[afX;afY];

plot(hAxes, Tmp(1,:),Tmp(2,:), strColor,'LineWidth',2,'uicontextmenu',hContextMenu);

Line = a2fR*[fCenterX fCenterX ;
        fCenterY fCenterY+fDiameter/2];
plot(hAxes, Line(1,:),Line(2,:),'y','LineWidth',2,'uicontextmenu',hContextMenu);


return;
