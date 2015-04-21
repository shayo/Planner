function fnProjectBloodPattern()
global g_strctModule


if isempty(g_strctModule.m_acAnatVol) || g_strctModule.m_iCurrChamber == 0
    return;
end;
aiCurrTarget = get(g_strctModule.m_strctPanel.m_hTargetList,'value');
a2fCRS_To_XYZ = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fReg * g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fM;

% Cast rays from target to all possible directions 

iNumTargets = length(aiCurrTarget);
iSphereQuant = 100;
fRayLengthMM = 60;
fSamplingQuantizerMM = 0.5;
afSamplingAlongLine = 0:fSamplingQuantizerMM:fRayLengthMM;
iNumSamplesAlongLine = length(afSamplingAlongLine);
[X,Y,Z]=sphere(iSphereQuant);
iNumRays = length(X(:));
DirSphere = [X(:),Y(:),Z(:)];
iNumVertices = size(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_strctSurface.vertices,1);
a2fXYZ_To_CRS = inv(a2fCRS_To_XYZ);
a2fDataMax = zeros( iNumRays,iNumTargets);
a2iMatchingInd = zeros( iNumVertices,iNumTargets);
for iTargetIter=1:iNumTargets
    pt3fTarget_mm= a2fCRS_To_XYZ*[g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctTargets(aiCurrTarget(iTargetIter)).m_pt3fPositionVoxel;1];
    % Convert surface to mm.
    % for each direction, generate a line that we will sample things on...
    a2fX = pt3fTarget_mm(1) + repmat(afSamplingAlongLine, iNumRays,1) .* repmat(X(:),1,iNumSamplesAlongLine);
    a2fY = pt3fTarget_mm(2) + repmat(afSamplingAlongLine, iNumRays,1) .* repmat(Y(:),1,iNumSamplesAlongLine);
    a2fZ = pt3fTarget_mm(3) +  repmat(afSamplingAlongLine, iNumRays,1) .* repmat(Z(:),1,iNumSamplesAlongLine);
    % Now, resample these values from the blood vessel volume.
    apt2fPoints = a2fXYZ_To_CRS * [a2fX(:)'; a2fY(:)'; a2fZ(:)';ones(1,size(a2fX(:)))]; %#ok
    a2fDataSampled = reshape(fndllFastInterp3(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a3bBloodVolume, 1+apt2fPoints(1,:),1+apt2fPoints(2,:),1+apt2fPoints(3,:)), size(a2fX));
    a2fDataMax(:,iTargetIter) =  max(a2fDataSampled,[],2);
    % Match surface vertices with nearet neighbor point on sphere ?
    Xs= g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_strctSurface.vertices(:,1);
    Ys= g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_strctSurface.vertices(:,2);
    Zs= g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_strctSurface.vertices(:,3);
    Pmm=(a2fCRS_To_XYZ * [Xs(:),Ys(:),Zs(:),ones(size(Xs(:)),1)]')';
    
    Dirx = Pmm(:,1) -  pt3fTarget_mm(1) ;
    Diry = Pmm(:,2) -  pt3fTarget_mm(2) ;
    Dirz = Pmm(:,3) -  pt3fTarget_mm(3) ;
    Nrm = sqrt(Dirx.^2+Diry.^2+Dirz.^2);
    Dirxn = Dirx ./ Nrm ;
    Diryn = Diry ./ Nrm ;
    Dirzn = Dirz ./ Nrm ;
    Pnrm = [Dirxn,Diryn,Dirzn];
    [afMinDist, a2iMatchingInd(:,iTargetIter)] = fndllPointPointDist(Pnrm', DirSphere'); %#ok
end
%
     
%     figure(11);
%     clf;
strctIsoCRS = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_strctSurface;
    iNumVertices = size(strctIsoCRS.vertices,1);
        VerticesXYZ = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fReg*g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fM*[strctIsoCRS.vertices,ones(iNumVertices,1)]'; %#ok
%        strctIsoXYZ.vertices = VerticesXYZ(1:3,:)'; %#ok
%         strctIsoXYZ.faces = strctIsoCRS.faces;
%         g_strctModule.m_strctPanel.m_hMainVolSurface = patch(strctIsoXYZ, ...
%             'visible','on');
abVertexIntersectRay = zeros(iNumVertices,1)>0;
for iTargetIter=1:iNumTargets
    afDataMax = a2fDataMax(:,iTargetIter);
    aiMatchingInd = a2iMatchingInd(:,iTargetIter);
    abVertexIntersectRay = abVertexIntersectRay | (afDataMax(aiMatchingInd)>0);
end
        a2fColors = [double(abVertexIntersectRay), zeros(iNumVertices,2)];
        a2fColors(abVertexIntersectRay == 0,1) = 1;
        a2fColors(abVertexIntersectRay == 0,2) = 1;
        
        set(g_strctModule.m_strctPanel.m_hMainVolSurface,'EdgeColor','none', 'FaceVertexCData',a2fColors,'FaceColor','interp','facealpha',0.9);
%     axis equal
%     colormap hot
%      hold on;
%     plot3(pt3fTarget_mm(1),pt3fTarget_mm(2),pt3fTarget_mm(3),'r.','MarkerSize',16);




% % % % Code to add a chamber passing between two targets.
% % % a2fCRS_To_XYZ = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fReg * g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fM;
% % % afPt1 = a2fCRS_To_XYZ*[g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctTargets(aiCurrTarget(1)).m_pt3fPositionVoxel;1];
% % % afPt2 = a2fCRS_To_XYZ*[g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctTargets(aiCurrTarget(2)).m_pt3fPositionVoxel;1];
% % % afDirection = afPt1(1:3)-afPt2(1:3);
% % % afDirection = afDirection/norm(afDirection);
% % % [afDirection1,afDirection2] = fnGramSchmidt(afDirection');
% % % a2fM = eye(4);
% % % a2fM(1:3,3) = afDirection;
% % % a2fM(1:3,1) = afDirection1;
% % % a2fM(1:3,2) = afDirection2;
% % % a2fM(1:3,4) = afPt1(1:3)-afDirection*10;
% % % fnAddChamberAux(a2fM);
fnInvalidate();    
return;