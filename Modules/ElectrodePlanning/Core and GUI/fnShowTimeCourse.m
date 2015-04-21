
function fnShowTimeCourse()
global g_strctModule
if ~isempty(g_strctModule.m_acFuncVol) &&  g_strctModule.m_iCurrFuncVol > 0 && isfield(g_strctModule.m_acFuncVol{g_strctModule.m_iCurrFuncVol},'m_a4fTimeCourse') 
    a2fXYZ_To_CRS_Func = inv(g_strctModule.m_acFuncVol{g_strctModule.m_iCurrFuncVol}.m_a2fM) * inv(g_strctModule.m_acFuncVol{g_strctModule.m_iCurrFuncVol}.m_a2fReg); %#ok

    dxy = g_strctModule.m_strctCrossSectionXY.m_a2fM(1:3,3)' * g_strctModule.m_strctCrossSectionXY.m_a2fM(1:3,4);
    dyz = g_strctModule.m_strctCrossSectionYZ.m_a2fM(1:3,3)' * g_strctModule.m_strctCrossSectionYZ.m_a2fM(1:3,4);
    dxz = g_strctModule.m_strctCrossSectionXZ.m_a2fM(1:3,3)' * g_strctModule.m_strctCrossSectionXZ.m_a2fM(1:3,4);


    pt3fIntersectionPointMM = (dxy * cross(g_strctModule.m_strctCrossSectionYZ.m_a2fM(1:3,3), g_strctModule.m_strctCrossSectionXZ.m_a2fM(1:3,3))+...
        dyz * cross(g_strctModule.m_strctCrossSectionXZ.m_a2fM(1:3,3), g_strctModule.m_strctCrossSectionXY.m_a2fM(1:3,3))+...
        dxz * cross(g_strctModule.m_strctCrossSectionXY.m_a2fM(1:3,3), g_strctModule.m_strctCrossSectionYZ.m_a2fM(1:3,3)))/...
        dot(g_strctModule.m_strctCrossSectionXY.m_a2fM(1:3,3), cross(g_strctModule.m_strctCrossSectionYZ.m_a2fM(1:3,3),g_strctModule.m_strctCrossSectionXZ.m_a2fM(1:3,3)));

    iNumPoints = size(g_strctModule.m_acFuncVol{g_strctModule.m_iCurrFuncVol}.m_a4fTimeCourse,4);
    afValues = zeros(1,iNumPoints);
    pt3fPointCRS = a2fXYZ_To_CRS_Func * [pt3fIntersectionPointMM;1];
    for k=1:iNumPoints
        a3fVol = g_strctModule.m_acFuncVol{g_strctModule.m_iCurrFuncVol}.m_a4fTimeCourse(:,:,:,k);
        afValues(k) = fndllFastInterp3(a3fVol, 1+pt3fPointCRS(1),1+pt3fPointCRS(2),1+pt3fPointCRS(3));
    end
    afValuesZeroMean = afValues-mean(afValues);
    afPolyCoeff = polyfit(1:length(afValuesZeroMean),afValuesZeroMean,2);
    afPolyVals = polyval(afPolyCoeff,1:length(afValuesZeroMean));
    afCorrected = afValuesZeroMean-afPolyVals;
    
    
    NumScansPerBlock = 8;
    FacesBlocks = [2,6,10,14];
    FacesOnSetScans = [1 + NumScansPerBlock*(FacesBlocks-1)]; %#ok
    
    cla(g_strctModule.m_strctPanel.m_strctTimeCourse.m_hAxes);
    for k=1:4
        fStartX = FacesOnSetScans(k);
        fEndX = FacesOnSetScans(k)+NumScansPerBlock-1;
        fMinX = min(afCorrected);
        fMaxX = max(afCorrected);
        fill([fStartX fStartX fEndX fEndX],[fMinX fMaxX fMaxX fMinX],[0.9 0.9 0.9],'parent',g_strctModule.m_strctPanel.m_strctTimeCourse.m_hAxes,'edgeColor','none');
    end

%    plot(g_strctModule.m_strctPanel.m_strctTimeCourse.m_hAxes, afValuesZeroMean,'LineWidth',2); hold on;
    plot(g_strctModule.m_strctPanel.m_strctTimeCourse.m_hAxes, afCorrected,'b','LineWidth',2);

    
end
return