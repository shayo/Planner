%function fnConvertDataBasetoMesh()
load('D:\Dropbox\My Dropbox\AtlasMarker\Backups\Atlas_Aug_31.mat');

iNumSlices = length(strctAtlas.m_astrctSlices);
iNumRegions = length(strctAtlas.m_acRegions);
% Sort slices....
[afSortedValues, aiInd]=sort(cat(1,strctAtlas.m_astrctSlices.m_fPositionMM));
astrctSortedSlices = strctAtlas.m_astrctSlices(aiInd);

clear astrctMesh
%% Build Meshs
for k=1:length(strctAtlas.m_acRegions)
    fprintf('%d out of %d\n',k,length(strctAtlas.m_acRegions));
    strctTmp = fnMeshRegionOfInterest(astrctSortedSlices,{strctAtlas.m_acRegions{k}},true,0.2, 0,1);
    if ~isempty(strctTmp)
            astrctMesh(k) = strctTmp;
    end
end
strctMeshAll= fnMeshRegionOfInterest(astrctSortedSlices,strctAtlas.m_acRegions,true,0.2, 0,0.01);

%%
figure(2);
clf;
colordef(2,'black');
 camlight right
hold on;
a2fLines = lines(length(strctAtlas.m_acRegions));
 set(gca,'visible','off')
axis equal
lighting('gouraud');


hMeshAll=patch(strctMeshAll);
set(hMeshAll,'visible','off');

% set(hMeshAll,'FaceColor','none','EdgeColor','w');
 
 %%
 for k=1:length(strctAtlas.m_acRegions)
    fprintf('%d out of %d\n',k,length(strctAtlas.m_acRegions));
    if ~isempty(astrctMesh(k).vertices)
        ahMesh(k)=patch(astrctMesh(k));
        set(ahMesh(k),'FaceColor',a2fLines(k,:),'EdgeColor','none','FaceAlpha',0.3);
    end
end
%%
 for k=1:length(ahMesh)
    if ahMesh(k) > 0
        set( ahMesh(k),'visible','off')
    end
 end
 %%
objw = VideoWriter('D:\Presentations\Planner\RotatingBrain9.avi','Motion JPEG AVI');
objw.FrameRate = 20;
open(objw);

for k=1:length(ahMesh)
    fprintf('%d out of %d\n',k,length(ahMesh));
    if ahMesh(k) > 0
        set( ahMesh(k),'visible','on')
    end
    if k>20 && k < 120
        Q=2;
    elseif k>= 120
        Q = 5;
    else
        Q = 10;
    end
    for j=1:Q
        camorbit(4,0,'none');
        drawnow
        X=getframe(2);
        writeVideo(objw,X);
    end
end

    for j=1:360/4
        camorbit(4,0,'none');
        drawnow
        X=getframe(2);
        writeVideo(objw,X);
    end
set(hMeshAll,'visible','on');


    for j=1:360/4
        camorbit(4,0,'none');
        drawnow
        X=getframe(2);
        writeVideo(objw,X);
    end
 close(objw);


		
%%
