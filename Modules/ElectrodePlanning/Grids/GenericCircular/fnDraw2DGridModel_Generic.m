function ahHolesHandles = fnDraw2DGridModel_Generic(strctGridModel, hAxes, strctDisplayParam)
cla(hAxes);
hold(hAxes,'on');

afAngle = linspace(0,2*pi,20);
afCos = cos(afAngle);
afSin= sin(afAngle);

iNumHoles = length(strctGridModel.m_afGridHolesX);

fHoleDiameterMM = strctGridModel.m_strctGridParams.m_fGridHoleDiameterMM;

if ~isfield(strctDisplayParam,'m_bDisplayHoleDirection')
    strctDisplayParam.m_bDisplayHoleDirection = false;
end;

bShowBottomHoles = false;
bShowTopHoles = true;
bShowInvalid = true;
bShowNumber = false;
ahHolesHandles = zeros(1,iNumHoles);
ahSelectedHoleHandles = zeros(1,iNumHoles);
if ~isfield(strctDisplayParam,'m_aiHighlightedGroups')
    strctDisplayParam.m_aiHighlightedGroups  = [];
end

for iHoleIter=1:iNumHoles
    afGroupColor = strctGridModel.m_strctGridParams.m_a2fGroupColor(:, strctGridModel.m_strctGridParams.m_aiGroupAssignment(iHoleIter));
    
    if bShowNumber
        text(strctGridModel.m_afGridHolesX(iHoleIter),strctGridModel.m_afGridHolesY(iHoleIter),num2str(iHoleIter),'parent',hAxes,'horizontalalignment','center');
    end
    
    if bShowBottomHoles
    ahHolesHandles(iHoleIter) = plot(hAxes, ...
        (strctGridModel.m_afGridHolesX(iHoleIter)+strctGridModel.m_strctGridParams.m_fGridHeightMM*strctGridModel.m_apt3fGridHolesNormals(1,iHoleIter)+afCos*fHoleDiameterMM/2),...
        strctGridModel.m_afGridHolesY(iHoleIter)+strctGridModel.m_strctGridParams.m_fGridHeightMM*strctGridModel.m_apt3fGridHolesNormals(2,iHoleIter)+afSin*fHoleDiameterMM/2,...
        'color',afGroupColor*0.5,'linestyle','--');
    end
    
    if bShowTopHoles
        
        if  sum(strctDisplayParam.m_aiHighlightedGroups ==  strctGridModel.m_strctGridParams.m_aiGroupAssignment(iHoleIter)) > 0
            iLineWidth = 2;
        else
            iLineWidth = 1;
        end
        
    ahHolesHandles(iHoleIter) = plot(hAxes, ...
        (strctGridModel.m_afGridHolesX(iHoleIter)+ + afCos*fHoleDiameterMM/2),...
        strctGridModel.m_afGridHolesY(iHoleIter) + afSin*fHoleDiameterMM/2,...
        'color',afGroupColor,'LineWidth',iLineWidth);
            
    end
    
    if  bShowInvalid && strctGridModel.m_abIntersect(iHoleIter)
        
        plot([strctGridModel.m_afGridHolesX(iHoleIter)-fHoleDiameterMM/2  strctGridModel.m_afGridHolesX(iHoleIter)+fHoleDiameterMM/2],...
            [strctGridModel.m_afGridHolesY(iHoleIter)+fHoleDiameterMM/2  strctGridModel.m_afGridHolesY(iHoleIter)-fHoleDiameterMM/2],'r','LineWidth',2);
        plot([strctGridModel.m_afGridHolesX(iHoleIter)-fHoleDiameterMM/2  strctGridModel.m_afGridHolesX(iHoleIter)+fHoleDiameterMM/2],...
            [strctGridModel.m_afGridHolesY(iHoleIter)-fHoleDiameterMM/2  strctGridModel.m_afGridHolesY(iHoleIter)+fHoleDiameterMM/2],'r','LineWidth',2);
        
    end
    
    if strctGridModel.m_strctGridParams.m_abSelectedHoles(iHoleIter) % holes with electrodes....
        
        ahHolesHandles(iHoleIter) =  fill( (strctGridModel.m_afGridHolesX(iHoleIter) + afCos*fHoleDiameterMM/2),...
            strctGridModel.m_afGridHolesY(iHoleIter) + afSin*fHoleDiameterMM/2,...
            'm','parent',hAxes);
    end;
    
    if ~isempty(strctDisplayParam.m_aiSelectedHoles) && sum(strctDisplayParam.m_aiSelectedHoles == iHoleIter)>0
         fill( (strctGridModel.m_afGridHolesX(iHoleIter) + afCos*fHoleDiameterMM/4),...
            strctGridModel.m_afGridHolesY(iHoleIter) + afSin*fHoleDiameterMM/4,...
            'r','parent',hAxes);
    end
    
    
    if strctDisplayParam.m_bDisplayHoleDirection
        plot([strctGridModel.m_afGridHolesX(iHoleIter),strctGridModel.m_afGridHolesX(iHoleIter)-strctGridModel.m_strctGridParams.m_fGridHeightMM*strctGridModel.m_apt3fGridHolesNormals(1,iHoleIter)],...
                [strctGridModel.m_afGridHolesY(iHoleIter),strctGridModel.m_afGridHolesY(iHoleIter)+strctGridModel.m_strctGridParams.m_fGridHeightMM*strctGridModel.m_apt3fGridHolesNormals(2,iHoleIter)],'color',afGroupColor,'LineWidth',2);
    end
end;


% 
% fOuterDiameterMM = fnGetGridParameter(strctGridModel.m_strctGridParams,'GridOuterDiam');
% fInnerDiameterMM = fnGetGridParameter(strctGridModel.m_strctGridParams,'GridInnerDiam');
% 

plot(hAxes, ...
    afCos*strctGridModel.m_strctGridParams.m_fGridInnerDiameterMM/2,...
    afSin*strctGridModel.m_strctGridParams.m_fGridInnerDiameterMM/2,'m','LineWidth',2);

% plot(hAxes, ...
%     [0 0],[0 fInnerDiameterMM/2],'y','LineWidth',2);

% fThetaRad = fnGetGridParameter(strctGridModel.m_strctGridParams,'Theta')/180*pi;
% 
% fGridOriX  = cos(-fThetaRad+pi/2)*fInnerDiameterMM/2;
% fGridOriY = sin(-fThetaRad+pi/2)*fInnerDiameterMM/2;
% plot(hAxes, ...
%     [0 fGridOriX],[0 fGridOriY],'g','LineWidth',2);
% set(hAxes,'xlim',[-fOuterDiameterMM/2 fOuterDiameterMM/2],'ylim',[-fOuterDiameterMM/2 fOuterDiameterMM/2]);
% 
% 
% box on
set(hAxes,'xlim',[-10 10],'ylim',[-10 10]);


% 
% 
% 
% 
% 
% % Found group boundaries....
% iNumGroups = length(strctGridModel.m_strctGridParams.m_acGroupNames);
% for iGroupIter=1:iNumGroups
%     aiRelevantHoles = find(strctGridModel.m_strctGridParams.m_aiGroupAssignment == iGroupIter);
%     
%     
%   
% afGroupColor = strctGridModel.m_strctGridParams.m_a2fGroupColor(:, strctGridModel.m_strctGridParams.m_aiGroupAssignment(aiRelevantHoles(1)));
% 
%     if length(aiRelevantHoles) == 1
%         % Just one region, which is the hole itself
%       for iSubRegionIter=1:iNumSubRegions
%             Xc = strctGridModel.m_strctGridParams.m_afGridHoleXpos_mm(aiRelevantHoles(1));
%             Yc = strctGridModel.m_strctGridParams.m_afGridHoleYpos_mm(aiRelevantHoles(1));
%             plot(hAxes, Xc+afCos*strctGridModel.m_strctGridParams.m_fGridHoleDiameterMM/2,  Yc+afSin*strctGridModel.m_strctGridParams.m_fGridHoleDiameterMM/2, 'color',afGroupColor,'linewidth',2);
%       end
%         
%     else
%             
%         % pick the first hole and measure everything relative to that
%         % one....
%         fCurrentDistanceMM = 1 / cos(strctGridModel.m_strctGridParams.m_afGridHoleTiltDeg(aiRelevantHoles(1))/180*pi);
%         Xc = strctGridModel.m_strctGridParams.m_afGridHoleXpos_mm(aiRelevantHoles(1));
%         Yc = strctGridModel.m_strctGridParams.m_afGridHoleYpos_mm(aiRelevantHoles(1));
%         afXDist = round((strctGridModel.m_strctGridParams.m_afGridHoleXpos_mm(aiRelevantHoles) - Xc)/fCurrentDistanceMM);
%         afYDist = round((strctGridModel.m_strctGridParams.m_afGridHoleYpos_mm(aiRelevantHoles) - Yc)/fCurrentDistanceMM);
%         fMinX = floor(min(afXDist));
%         fMaxX = ceil(max(afXDist));
%         fMinY = floor(min(afYDist));
%         fMaxY = ceil(max(afYDist));
%         iXRange = max(1, fMaxX-fMinX+1);
%         iYRange = max(1, fMaxY-fMinY+1);
%         a2bI = zeros(iYRange,iXRange) > 0;
%         aiInd = sub2ind([iYRange,iXRange], afYDist-fMinY+1,afXDist-fMinX+1);
%         a2bI(aiInd)=1;
%          acBoundaries = bwboundaries(a2bI);
%         iNumSubRegions = length(acBoundaries);
%         for iSubRegionIter=1:iNumSubRegions
%             plot(hAxes,(acBoundaries{iSubRegionIter}(:,2)+fMinX-1)*fCurrentDistanceMM + Xc, (acBoundaries{iSubRegionIter}(:,1)+fMinY-1)*fCurrentDistanceMM + Yc, 'color',afGroupColor,'linewidth',2);
%         end
%         
%         
%         
%      end
%     
% end





return;
