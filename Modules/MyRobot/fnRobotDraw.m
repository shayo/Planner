function ahRobotHandles = fnRobotDraw(strctRobot, afConf, hAxes, fMag)
%% Plot the trajectory of the links
hold(hAxes,'on');
iNumLinks = size(strctRobot.m_a2fDH,1);
a2fCurrT = strctRobot.m_a2fBase;

a3fTn = zeros(4,4,iNumLinks);
a3fTn(:,:,1) =a2fCurrT;
a2fPoints = zeros(3,iNumLinks);
a2fPoints(:,1) = a2fCurrT(1:3,4);
for iLinkIter=1:iNumLinks
    a3fTn(:,:,iLinkIter) = a2fCurrT;
    a2fCurrT = a2fCurrT *  fnRobotLinkTransformation(strctRobot.m_a2fDH(iLinkIter,:), afConf(iLinkIter));
    a2fPoints(:,iLinkIter) = a2fCurrT(1:3,4);
end
a2fCurrT = a2fCurrT *strctRobot.m_a2fTool;
hLinksTrajectory = plot3(hAxes,10*a2fPoints(1,:),10*a2fPoints(2,:),10*a2fPoints(3,:),'linewidth',3,'color','k');

%%
ahJointAxis = zeros(1,iNumLinks);
ahJointSurface = zeros(1,iNumLinks);
xyz_line = [0 0; 0 0; -2*fMag 2*fMag; 1 1];
iQuant = 8;
for iLinkIter=1:iNumLinks

    [xc,yc,zc] = cylinder(fMag/4, iQuant);
    zc(zc==0) = -fMag/2;
    zc(zc==1) = fMag/2;
    xyz = [xc(:)'; yc(:)'; zc(:)'; ones(1,2*iQuant+2)];
       
    xyz = a3fTn(:,:,iLinkIter) * xyz;
    ncols = size(xyz,2)/2;
    xc = reshape(xyz(1,:), 2, ncols);
    yc = reshape(xyz(2,:), 2, ncols);
    zc = reshape(xyz(3,:), 2, ncols);
    xyzl = a3fTn(:,:,iLinkIter) * xyz_line;
    
    ahJointSurface(iLinkIter) = surface(10*xc,10*yc,10*zc,'parent',hAxes,'FaceColor', 'blue');
    ahJointAxis(iLinkIter) = plot3(hAxes,10*xyzl(1,:),10*xyzl(2,:),10*xyzl(3,:),'color', 'blue','linestyle','--');
end

xv = a2fCurrT*[fMag;0;0;1];
yv = a2fCurrT*[0;fMag;0;1];
zv = a2fCurrT*[0;0;fMag;1];

hToolAxisX = plot3(10*[a2fCurrT(1,4) xv(1)],10* [a2fCurrT(2,4) xv(2)], 10*[a2fCurrT(3,4) xv(3)],'parent',hAxes,'color','r','LineWidth',3);
hToolAxisY = plot3(10*[a2fCurrT(1,4) yv(1)],10* [a2fCurrT(2,4) yv(2)], 10*[a2fCurrT(3,4) yv(3)],'parent',hAxes,'color','g','LineWidth',3);
hToolAxisZ = plot3(10*[a2fCurrT(1,4) zv(1)],10* [a2fCurrT(2,4) zv(2)], 10*[a2fCurrT(3,4) zv(3)],'parent',hAxes,'color','b','LineWidth',3);

ahRobotHandles = [hLinksTrajectory, ahJointSurface,ahJointAxis,hToolAxisX,hToolAxisY,hToolAxisZ];
return;
