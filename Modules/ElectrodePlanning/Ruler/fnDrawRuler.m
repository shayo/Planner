
function ahHandles= fnDrawRuler(strctObject)
global g_strctModule g_strctWindows
    ahHandles = []; 

[strctCrossSection,hAxes] = fnAxesNameToCrossSection(strctObject.m_strAxes);
% We should only draw the ruler if the ruler is ON the correct cross
% section plane ....
a2fCRS_To_XYZ = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fReg * g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fM;

pt3fCoord1MM = a2fCRS_To_XYZ*[strctObject.m_pt3fVoxelCoordinate1;1];
pt3fCoord2MM = a2fCRS_To_XYZ*[strctObject.m_pt3fVoxelCoordinate2;1];

afDirection = pt3fCoord2MM(1:3)-pt3fCoord1MM(1:3);
fLength = norm(afDirection);
afDirection = afDirection/fLength;
bOnPlane = abs(dot(strctCrossSection.m_a2fM(1:3,3),afDirection))  < 1e-5;
if ~bOnPlane
    return;
end

% Build a metric distance between  point 1 and 2
afRangeMM = 0:1:fLength ; % 1 mm accuracy

iNumPoints = length(afRangeMM);
apt3fCoordRulerMM = repmat(pt3fCoord1MM(1:3),1,iNumPoints) + [afRangeMM;afRangeMM;afRangeMM ] .* repmat(afDirection, 1,iNumPoints);
% project to screen.
[apt2fPointsImage,abInside] =fnPoint3DToImage(strctCrossSection, apt3fCoordRulerMM);

afOrthDir = apt2fPointsImage(end,:) - apt2fPointsImage(1,:);
a2fR = [cos(pi/2) sin(pi/2);-sin(pi/2),cos(pi/2)];
afOrthDir = a2fR*[afOrthDir/norm(afOrthDir)]'; %#ok

iStart = find(abInside,1,'first');
iEnd = find(abInside,1,'last');
if isempty(iStart) || isempty(iEnd)
    return;
end;
pt2fStart = apt2fPointsImage(iStart,:);
pt2fEnd = apt2fPointsImage(iEnd,:);



hRulerMenu = uicontextmenu('parent',g_strctWindows.m_hFigure);
uimenu(hRulerMenu,'Label','Remove','Callback',{@fnCallback,'RemoveRuler',strctObject.m_iUniqueID});
ahHandles(1) = plot(hAxes,[pt2fStart(1), pt2fEnd(1)],[pt2fStart(2), pt2fEnd(2)],'c','LineWidth',1,'uicontextmenu',hRulerMenu);


aiPlotTicks = iStart:1:iEnd;
abLargeTicks = zeros(1, length(aiPlotTicks)); %#ok
iHandleCounter=2;
for k=1:length(aiPlotTicks)
    pt2fP1 = apt2fPointsImage(aiPlotTicks(k),:);
    if mod(afRangeMM(aiPlotTicks(k)),10)  ==0
        pt2fP2 = apt2fPointsImage(aiPlotTicks(k),:) + afOrthDir' * 7;
        pt2fP3 = apt2fPointsImage(aiPlotTicks(k),:) + afOrthDir' * 10;
        ahHandles(iHandleCounter) = text(pt2fP3(1),pt2fP3(2), num2str(afRangeMM(aiPlotTicks(k))),'parent',hAxes,'color','c','FontName',g_strctWindows.m_strDefaultFontName); %#ok
        iHandleCounter=iHandleCounter+1;
    elseif mod(afRangeMM(aiPlotTicks(k)),5)  ==0
        pt2fP2 = apt2fPointsImage(aiPlotTicks(k),:) + afOrthDir' * 4;
    else
        pt2fP2 = apt2fPointsImage(aiPlotTicks(k),:) + afOrthDir' * 1.5;
    end
    ahHandles(iHandleCounter) = plot(hAxes,[pt2fP1(1), pt2fP2(1)],[pt2fP1(2), pt2fP2(2)],'c','LineWidth',1,'uicontextmenu',hRulerMenu); %#ok
    iHandleCounter=iHandleCounter+1;
end

return;
