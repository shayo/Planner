function fnClearStereoTactic()
global g_strctModule
if isfield(g_strctModule,'m_ahRobotHandles')
    fnSafeDelete(g_strctModule.m_ahRobotHandles);
end
fDistanceBetweenArmsMM = 177.5;
fAPBarWidthMM = 17.82;
fBarsOffsetMM = sqrt(2)/2*fAPBarWidthMM;

fPlaneOffsetMM =  -23.4 - sqrt(2) * 6.1 /2;

fDistanceToPoleMM = 233.17;
fPoleDiameterMM = 25.52;
fPoleHeightMM = 140;
fAPBarWidthMM = 17.82;

axes(g_strctModule.m_strctPanel.m_strctStereoTactic.m_hAxes); %#ok
set(g_strctModule.m_strctPanel.m_strctStereoTactic.m_hAxes,'visible','on');
cla(g_strctModule.m_strctPanel.m_strctStereoTactic.m_hAxes);
hold on;

[a2fX,a2fY]=meshgrid([-100,100],[-100,250]);
a2fZ=ones(size(a2fX))*-fPlaneOffsetMM+fBarsOffsetMM;
s=surf(a2fX,a2fY,a2fZ);
set(s,'facecolor',[0.5 0.5 0.5],'facealpha',0.1);


[a2fX,a2fY]=meshgrid([-50,50],[-50,50]);
a2fZ=zeros(size(a2fX));
s=surf(a2fX,a2fY,a2fZ);
set(s,'facecolor',[0.5 0.5 0.5],'facealpha',0.5);

a2fRotAP = fnRotateVectorAboutAxis4D([1 0 0],pi/2)* fnRotateVectorAboutAxis4D([0 0 1],pi/4);
a2fRotAP(1,4) = fDistanceBetweenArmsMM/2;
a2fRotAP(3,4) = -fPlaneOffsetMM;
%-1/sqrt(2)*fAPBarWidthMM;
astrctMesh = fnApplyTransformOnMesh(fnBuildCubeMesh(0,0,0,fAPBarWidthMM/2,fAPBarWidthMM/2,100, [0.8 0 0]),a2fRotAP);
fnDrawMeshIn3D(astrctMesh,g_strctModule.m_strctPanel.m_strctStereoTactic.m_hAxes);

a2fRotAP = fnRotateVectorAboutAxis4D([1 0 0],pi/2)* fnRotateVectorAboutAxis4D([0 0 1],pi/4);
a2fRotAP(1,4) = -fDistanceBetweenArmsMM/2;
a2fRotAP(3,4) = -fPlaneOffsetMM;
%-1/sqrt(2)*fAPBarWidthMM;
astrctMesh = fnApplyTransformOnMesh(fnBuildCubeMesh(0,0,0,fAPBarWidthMM/2,fAPBarWidthMM/2,100, [0.8 0 0]),a2fRotAP);
fnDrawMeshIn3D(astrctMesh,g_strctModule.m_strctPanel.m_strctStereoTactic.m_hAxes);


plot3([fDistanceBetweenArmsMM/2 fDistanceBetweenArmsMM/2],[-100 100],-fPlaneOffsetMM*ones(1,2),'r','linewidth',3); % left arm
plot3(-[fDistanceBetweenArmsMM/2 fDistanceBetweenArmsMM/2],[-100 100],-fPlaneOffsetMM*ones(1,2),'r','linewidth',3); % left arm

[X,Y,Z]=cylinder2P(fPoleDiameterMM/2,20,...
[ 0 fDistanceToPoleMM -fPlaneOffsetMM+fBarsOffsetMM],...
[ 0 fDistanceToPoleMM -fPlaneOffsetMM+fPoleHeightMM+fBarsOffsetMM ]);

s=surf(X,Y,Z,'facecolor','r'); %#ok


set(g_strctModule.m_strctPanel.m_strctStereoTactic.m_hAxes,...%'xlim',[-1 20],'ylim',[-5 25],'zlim',[-10 25],...
	'CameraPosition',[1559.86 2024.11 946.485],...
	'CameraTarget',[3.77468 -75 60.2002],...
	'CameraUpVector' , [-0.132993 -0.30022 0.944553],...
	'CameraViewAngle', 6.60861);

return;

