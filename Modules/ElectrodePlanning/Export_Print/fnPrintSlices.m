
function fnPrintSlices()
global g_strctModule g_strctWindows

set(g_strctWindows.m_hFigure,'Renderer','zbuffer');
set(g_strctModule.m_strctPanel.hMouseModeText,'visible','off');
set(g_strctModule.m_strctPanel.m_strctXZ.m_ahTextHandles,'visible','off');
set(g_strctModule.m_strctPanel.m_strctXY.m_ahTextHandles,'visible','off');
set(g_strctModule.m_strctPanel.m_strctYZ.m_ahTextHandles,'visible','off');

a2fXY = g_strctModule.m_strctCrossSectionXY.m_a2fM;
a2fXZ = g_strctModule.m_strctCrossSectionXZ.m_a2fM;
a2fYZ = g_strctModule.m_strctCrossSectionYZ.m_a2fM;

aiXZ_rect = get(g_strctModule.m_strctPanel.m_strctXZ.m_hAxes,'position');
aiYZ_rect = get(g_strctModule.m_strctPanel.m_strctYZ.m_hAxes,'position');
aiXY_rect = get(g_strctModule.m_strctPanel.m_strctXY.m_hAxes,'position');

aiXZ_size = aiXZ_rect(3:4)-aiXZ_rect(1:2)+1;
aiYZ_size = aiYZ_rect(3:4)-aiYZ_rect(1:2)+1;
aiXY_size = aiXY_rect(3:4)-aiXY_rect(1:2)+1;

afRange = -45:0.5:45;
iNumSlices = length(afRange);
% Arrange as tiles.
NumTileHoriz = 8;
NumTileVert = ceil(iNumSlices/NumTileHoriz);
a2fTileXY = zeros(NumTileVert *aiXY_size(1),NumTileHoriz *aiXY_size(2),3,'uint8');
a2fTileYZ = zeros(NumTileVert *aiXY_size(1),NumTileHoriz *aiXY_size(2),3,'uint8');
a2fTileXZ = zeros(NumTileVert *aiXY_size(1),NumTileHoriz *aiXY_size(2),3,'uint8');
%a4fXZ = zeros(aiXY_size(1),aiXY_size(2),3,length(afRange));
for iIter=1:length(afRange)
    g_strctModule.m_strctCrossSectionXY.m_a2fM(1:3,4) = a2fXY(1:3,4) + a2fXY(1:3,3)*afRange(iIter);
    g_strctModule.m_strctCrossSectionYZ.m_a2fM(1:3,4) = a2fYZ(1:3,4) + a2fYZ(1:3,3)*afRange(iIter);
    g_strctModule.m_strctCrossSectionXZ.m_a2fM(1:3,4) = a2fXZ(1:3,4) + a2fXZ(1:3,3)*afRange(iIter);
    
    fnInvalidate(1);
    
    XZ=getframe(g_strctModule.m_strctPanel.m_strctXZ.m_hAxes,aiXZ_rect);
    YZ=getframe(g_strctModule.m_strctPanel.m_strctYZ.m_hAxes,aiYZ_rect);
    XY=getframe(g_strctModule.m_strctPanel.m_strctXY.m_hAxes,aiXY_rect);
 %   a4fXZ(:,:,:,iIter)=XZ.cdata;
    iTileX = mod(iIter-1,NumTileHoriz)+1;
    iTileY = 1+floor((iIter-1)/(NumTileHoriz));
    iStartXY_j = (iTileX-1)*aiXY_size(1)+1;
    iStartXY_i = (iTileY-1)*aiXY_size(2)+1;
    a2fTileXY(iStartXY_i:iStartXY_i+aiXY_size(1)-1,...
              iStartXY_j:iStartXY_j+aiXY_size(2)-1,:) = XY.cdata;


    iStartYZ_j = (iTileX-1)*aiYZ_size(1)+1;
    iStartYZ_i = (iTileY-1)*aiYZ_size(2)+1;
    a2fTileYZ(iStartYZ_i:iStartYZ_i+aiYZ_size(1)-1,...
              iStartYZ_j:iStartYZ_j+aiYZ_size(2)-1,:) = YZ.cdata;

    iStartXZ_j = (iTileX-1)*aiXZ_size(1)+1;
    iStartXZ_i = (iTileY-1)*aiXZ_size(2)+1;
    a2fTileXZ(iStartXZ_i:iStartXZ_i+aiXZ_size(1)-1,...
              iStartXZ_j:iStartXZ_j+aiXZ_size(2)-1,:) = XZ.cdata;
end
% for k=1:size(a4fXZ,4)
%     strFileName = sprintf('C:\\Data\\Planner CrossSections\\%04d.jpg',k);
% imwrite(a4fXZ(:,:,:,k)/255,strFileName)
% end

strPath=uigetdir('Enter Ouput folder');
if ~isempty(strPath)
    imwrite(a2fTileXZ,fullfile(strPath,'Coronal.jpg'),'quality',100);
    imwrite(a2fTileXY,fullfile(strPath,'Horizontal.jpg'),'quality',100);
    imwrite(a2fTileYZ,fullfile(strPath,'Saggital.jpg'),'quality',100);
end

if g_strctModule.m_strctGUIOptions.m_bOpenGL
    set(g_strctWindows.m_hFigure,'Renderer','opengl');
end

set(g_strctModule.m_strctPanel.m_strctXZ.m_ahTextHandles,'visible','on');
set(g_strctModule.m_strctPanel.m_strctXY.m_ahTextHandles,'visible','on');
set(g_strctModule.m_strctPanel.m_strctYZ.m_ahTextHandles,'visible','on');
set(g_strctModule.m_strctPanel.hMouseModeText,'visible','on');

g_strctModule.m_strctCrossSectionXY.m_a2fM = a2fXY;
g_strctModule.m_strctCrossSectionXZ.m_a2fM = a2fXZ;
g_strctModule.m_strctCrossSectionYZ.m_a2fM = a2fYZ;
    fnInvalidate(1);

return