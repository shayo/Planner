function strctMesh = fnBuildImageSeriesBoundingBox()
global g_strctModule


iActiveSeries = get(g_strctModule.m_strctPanel.m_hImageSeriesList,'value');
if isempty(g_strctModule.m_astrctImageSeries(iActiveSeries).m_acImages)
    strctMesh = [];
    return;
end;

aiFirstImageSize = size(g_strctModule.m_astrctImageSeries(iActiveSeries).m_acImages{1}.m_Data);
fZShift = g_strctModule.m_astrctImageSeries(iActiveSeries).m_fImageThickness;

pt3fPointInSpace1 = fnBackProjectAux(iActiveSeries,1, 0,0,-fZShift);
pt3fPointInSpace2 = fnBackProjectAux(iActiveSeries,1, aiFirstImageSize(2),0,-fZShift);
pt3fPointInSpace3 = fnBackProjectAux(iActiveSeries,1, 0, aiFirstImageSize(1),-fZShift);
pt3fPointInSpace4 = fnBackProjectAux(iActiveSeries,1, aiFirstImageSize(2), aiFirstImageSize(1),-fZShift);

iLastImage = length(g_strctModule.m_astrctImageSeries(iActiveSeries).m_acImages);
aiLastImageSize = size(g_strctModule.m_astrctImageSeries(iActiveSeries).m_acImages{iLastImage}.m_Data);
pt3fPointInSpace5 = fnBackProjectAux(iActiveSeries,iLastImage, 0,0,fZShift);
pt3fPointInSpace6 = fnBackProjectAux(iActiveSeries,iLastImage, aiLastImageSize(2),0,fZShift);
pt3fPointInSpace7 = fnBackProjectAux(iActiveSeries,iLastImage, 0, aiLastImageSize(1),fZShift);
pt3fPointInSpace8 = fnBackProjectAux(iActiveSeries,iLastImage, aiLastImageSize(2), aiLastImageSize(1),fZShift);


strctMesh.m_a2fVertices = [pt3fPointInSpace1;
                           pt3fPointInSpace5;
                           pt3fPointInSpace3;
                           pt3fPointInSpace7;
                           pt3fPointInSpace2;
                           pt3fPointInSpace6;
                           pt3fPointInSpace4;
                           pt3fPointInSpace8];
                           
    
strctMesh.m_a2iFaces = [...
 1,2,5;
 2,6,5;
 4,3,7;
 7,8,4;
 6,8,7;
 7,5,6;
 1,3,2;
 3,4,2;
 1,5,7;
 7,3,1;
 4,8,6;
 6,2,4 ]';
afColor=[1 0 0];
strctMesh.m_afColor = afColor;        
strctMesh.m_fOpacity = 0.6;

return

function pt3fPointInSpace = fnBackProjectAux(iActiveSeries,iIndex, fX,fY, fZShift)
global g_strctModule
pt2fMM = inv(g_strctModule.m_astrctImageSeries(iActiveSeries).m_acImages{iIndex}.m_a2fMMtoPix)*inv(g_strctModule.m_astrctImageSeries(iActiveSeries).m_acImages{iIndex}.m_a2fSubSampling) * [fX;fY;1];
pt3fPointOnPlaneMM = [pt2fMM(1:2); g_strctModule.m_astrctImageSeries(iActiveSeries).m_acImages{iIndex}.m_fZOffsetMM+fZShift;1];
pt3fPointInSpace = inv(g_strctModule.m_astrctImageSeries(iActiveSeries).m_a2fImagePlaneTo3D)*pt3fPointOnPlaneMM;
return;