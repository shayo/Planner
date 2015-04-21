function strctGridModel = fnBuildGridModel_Generic(strctGridParam)
% This function generates a structure that contains the grid model
% It uses various information in strctGridParams to construct the grid
% The output is a structure that must contain
%
%
% strctGridModel.m_strctGridParams  - Parameters used to construct this model
% strctGridModel.m_afGridHolesX    - Holes X Position
% strctGridModel.m_afGridHolesY    - Holes Y Position
% strctGridModel.m_apt3fGridHolesNormals - Holes Normal Direction
%
%

iNumHoles = length(strctGridParam.m_afGridHoleXpos_mm);

afZ=-cos(strctGridParam.m_afGridHoleTiltDeg/180*pi);
afX=-sin(strctGridParam.m_afGridHoleRotationDeg/180*pi).*sin(strctGridParam.m_afGridHoleTiltDeg/180*pi);
afY=cos(strctGridParam.m_afGridHoleRotationDeg/180*pi).*sin(strctGridParam.m_afGridHoleTiltDeg/180*pi);




strctGridModel.m_strctGridParams = strctGridParam;
strctGridModel.m_afGridHolesX = strctGridParam.m_afGridHoleXpos_mm;
strctGridModel.m_afGridHolesY = strctGridParam.m_afGridHoleYpos_mm;
strctGridModel.m_apt3fGridHolesNormals = [afX;afY;afZ];
if ~isfield(strctGridModel.m_strctGridParams,'m_abSelectedHoles')
    strctGridModel.m_strctGridParams.m_abSelectedHoles = zeros(1, iNumHoles)>0;
else
    if length(strctGridModel.m_strctGridParams.m_abSelectedHoles) ~= iNumHoles
     strctGridModel.m_strctGridParams.m_abSelectedHoles = zeros(1, iNumHoles)>0;
    end
end

strctGridModel.m_abIntersect = fnTestHoleIntersection(strctGridModel);
strctGridModel.m_acGroupBoundaries = fnFindGroupBoundaries(strctGridModel);



return;

function acGroupBoundaries = fnFindGroupBoundaries(strctGridModel)
% Found group boundaries....
iNumGroups = length(strctGridModel.m_strctGridParams.m_acGroupNames);
acGroupBoundaries = cell(1,iNumGroups);
for iGroupIter=1:iNumGroups
    aiRelevantHoles = find(strctGridModel.m_strctGridParams.m_aiGroupAssignment == iGroupIter);
 
    if isempty(aiRelevantHoles)
        continue;
    end;
    if length(aiRelevantHoles) == 1
        % Just one region, which is the hole itself
            Xc = strctGridModel.m_strctGridParams.m_afGridHoleXpos_mm(aiRelevantHoles(1));
            Yc = strctGridModel.m_strctGridParams.m_afGridHoleYpos_mm(aiRelevantHoles(1));
            afAngles = linspace(0,2*pi,20);
            afCos = cos(afAngles);
            afSin = sin(afAngles);
            acGroupBoundaries{iGroupIter}{1} = [Xc+afCos*strctGridModel.m_strctGridParams.m_fGridHoleDiameterMM/2;...
                                                                             Yc+afSin*strctGridModel.m_strctGridParams.m_fGridHoleDiameterMM/2];
    else
            
        % pick the first hole and measure everything relative to that
        % one....
        fCurrentDistanceMM = 1 / cos(strctGridModel.m_strctGridParams.m_afGridHoleTiltDeg(aiRelevantHoles(1))/180*pi);
        Xc = strctGridModel.m_strctGridParams.m_afGridHoleXpos_mm(aiRelevantHoles(1));
        Yc = strctGridModel.m_strctGridParams.m_afGridHoleYpos_mm(aiRelevantHoles(1));
        afXDist = round((strctGridModel.m_strctGridParams.m_afGridHoleXpos_mm(aiRelevantHoles) - Xc)/fCurrentDistanceMM);
        afYDist = round((strctGridModel.m_strctGridParams.m_afGridHoleYpos_mm(aiRelevantHoles) - Yc)/fCurrentDistanceMM);
        fMinX = floor(min(afXDist));
        fMaxX = ceil(max(afXDist));
        fMinY = floor(min(afYDist));
        fMaxY = ceil(max(afYDist));
        iXRange = max(1, fMaxX-fMinX+1);
        iYRange = max(1, fMaxY-fMinY+1);
        a2bI = zeros(iYRange,iXRange) > 0;
        aiInd = sub2ind([iYRange,iXRange], afYDist-fMinY+1,afXDist-fMinX+1);
        a2bI(aiInd)=1;
         acBoundaries = bwboundaries(a2bI);
        iNumSubRegions = length(acBoundaries);
        for iSubRegionIter=1:iNumSubRegions
            acGroupBoundaries{iGroupIter}{iSubRegionIter} = [-((acBoundaries{iSubRegionIter}(:,2)+fMinX-1)*fCurrentDistanceMM + Xc), ...
                                                                                                    (acBoundaries{iSubRegionIter}(:,1)+fMinY-1)*fCurrentDistanceMM + Yc]';
        end
     end
end
return;


function abIntersect = fnTestHoleIntersection(strctGridModel)
% Hole intersection?
% given, [x1,x2], [x3,x4], the distance between the lines is given by:
% D = | dot(c, A x B) |  / |A x B|
% where:
% A = x2-x1
% B = x4-x3
% C = x3-x1

% Use the fast dll implementation...
iNumHoles = length(strctGridModel.m_afGridHolesX);

P1 = [strctGridModel.m_afGridHolesX;strctGridModel.m_afGridHolesY;zeros(1,iNumHoles)];
afNrm = strctGridModel.m_apt3fGridHolesNormals;
afNrm(1,:)=-afNrm(1,:);
P2 = P1+10*afNrm;
[afDist,aiInd] = fndllLineLineDist(P1,P2);
%afDist = fndllLineLineDist(P1,P2);

fTolerance = 0.001;
abIntersectEachOther = sqrt(afDist(:)') < strctGridModel.m_strctGridParams.m_fMinimumDistanceBetweenHolesMM-fTolerance;

% Check intersection with outer wall...
% Top ?
    abIntersectTop = sqrt(strctGridModel.m_afGridHolesX.^2+strctGridModel.m_afGridHolesY.^2) + strctGridModel.m_strctGridParams.m_fGridHoleDiameterMM/2 > strctGridModel.m_strctGridParams.m_fGridInnerDiameterMM/2;
afHolesLength = strctGridModel.m_strctGridParams.m_fGridHeightMM ./ cos(strctGridModel.m_strctGridParams.m_afGridHoleTiltDeg/180*pi);
apt3fBottom= P1 +  afNrm .* [afHolesLength;afHolesLength;afHolesLength];

afHolesLengthAbove = strctGridModel.m_strctGridParams.m_fGridHeightAboveMM ./ cos(strctGridModel.m_strctGridParams.m_afGridHoleTiltDeg/180*pi);
apt3fAbove= P1 -  afNrm .* [afHolesLengthAbove;afHolesLengthAbove;afHolesLengthAbove];

abIntersectBottom = sqrt(apt3fBottom(1,:).^2+apt3fBottom(2,:).^2) + strctGridModel.m_strctGridParams.m_fGridHoleDiameterMM/2 > strctGridModel.m_strctGridParams.m_fGridInnerDiameterMM/2;
abIntersectAbove= sqrt(apt3fAbove(1,:).^2+apt3fAbove(2,:).^2) + strctGridModel.m_strctGridParams.m_fGridHoleDiameterMM/2 > strctGridModel.m_strctGridParams.m_fGridInnerDiameterMM/2;

abIntersect = abIntersectEachOther | abIntersectTop | abIntersectBottom | abIntersectAbove;



return;



if 0
iNumHoles = length(strctGridModel.m_afGridHolesX);

abIntersect = zeros(1,iNumHoles) > 0;
for iHoleIter1=1:iNumHoles
    bIntersect = false;
    for iHoleIter2=iHoleIter1+1:iNumHoles
        
        A = strctGridModel.m_apt3fGridHolesNormals(:,iHoleIter1);
        B = strctGridModel.m_apt3fGridHolesNormals(:,iHoleIter2);
        C = [strctGridModel.m_afGridHolesX(iHoleIter1)-strctGridModel.m_afGridHolesX(iHoleIter2),strctGridModel.m_afGridHolesY(iHoleIter1)-strctGridModel.m_afGridHolesY(iHoleIter2),0];
        Cn = sqrt(sum(C.^2));
        
        AxB = [A(2)*B(3)-A(3)*B(2), A(3)*B(1)-A(1)*B(3), A(1)*B(2)-A(2)*B(1);];      
        AxBn = sqrt(sum(AxB.^2));
        
        fDistance = abs(sum(AxB.*C)) / AxBn;
        
        bIntersect =  (AxBn == 0&& Cn < strctGridModel.m_strctGridParams.m_fMinimumDistanceBetweenHolesMM) || ... (% parallel)
                                (AxBn > 0 && fDistance < strctGridModel.m_strctGridParams.m_fMinimumDistanceBetweenHolesMM); % (non-parallel)
        if bIntersect
                break;
        end
    end
    
    abIntersect(iHoleIter1) = bIntersect;
end

end