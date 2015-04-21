function ahHolesHandles = fnDraw2DGridModel_Standard(strctGridModel, hAxes, hContextMenu)
cla(hAxes);
hold(hAxes,'on');
try
set(hAxes,'uicontextmenu',hContextMenu);
catch
    fprintf('Problem setting context menu?!?!\n');
end
afAngle = linspace(0,2*pi,20);
afCos = cos(afAngle);
afSin= sin(afAngle);

iNumHoles = length(strctGridModel.m_afGridHolesX);

fHoleDiameterMM = fnGetGridParameter(strctGridModel.m_strctGridParams,'HoleDiam');
ahHolesHandles = zeros(1,iNumHoles);
for iHoleIter=1:iNumHoles
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

fOuterDiameterMM = fnGetGridParameter(strctGridModel.m_strctGridParams,'GridOuterDiam');
fInnerDiameterMM = fnGetGridParameter(strctGridModel.m_strctGridParams,'GridInnerDiam');


plot(hAxes, ...
    afCos*fInnerDiameterMM/2,...
    afSin*fInnerDiameterMM/2,'m','LineWidth',2,'uicontextmenu',hContextMenu);

plot(hAxes, ...
    [0 0],[0 fInnerDiameterMM/2],'y','LineWidth',2,'uicontextmenu',hContextMenu);

fThetaRad = fnGetGridParameter(strctGridModel.m_strctGridParams,'Theta')/180*pi;

fGridOriX  = cos(-fThetaRad+pi/2)*fInnerDiameterMM/2;
fGridOriY = sin(-fThetaRad+pi/2)*fInnerDiameterMM/2;
plot(hAxes, ...
    [0 fGridOriX],[0 fGridOriY],'g','LineWidth',2,'uicontextmenu',hContextMenu);
set(hAxes,'xlim',[-fOuterDiameterMM/2 fOuterDiameterMM/2],'ylim',[-fOuterDiameterMM/2 fOuterDiameterMM/2]);


box on

return;
