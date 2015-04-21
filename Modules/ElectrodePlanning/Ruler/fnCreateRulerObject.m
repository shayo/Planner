
function strctObject = fnCreateRulerObject()
global g_strctModule 
[strctCrossSection,strName] = fnAxesToCrossSection(g_strctModule.m_strctLastMouseDown.m_hAxes);

if isempty(strctCrossSection)
    return;
end;
strctObject.m_strAxes = strName;

strctObject.m_strctCrossSection = strctCrossSection;
% Default position of ruler, vertical in screen coordinates.
pt2fPos1 = [strctCrossSection.m_iResWidth/2, 2*strctCrossSection.m_iResHeight/5];
pt2fPos2 = [strctCrossSection.m_iResWidth/2, 4*strctCrossSection.m_iResHeight/5];
a2fXYZ_To_CRS = inv(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fM) * inv(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fReg);  %#ok
% Convert this to 3D voxel coordinates....
pt2fPosMM1 = fnCrossSection_Image_To_MM(strctCrossSection, pt2fPos1);
pt2fPosMM2 = fnCrossSection_Image_To_MM(strctCrossSection, pt2fPos2);
pt3fPosIn3DSpace1 =strctCrossSection.m_a2fM*[pt2fPosMM1,0,1]';
pt3fPosIn3DSpace2 = strctCrossSection.m_a2fM*[pt2fPosMM2,0,1]';
pt3fVoxelCoordinate1 = a2fXYZ_To_CRS*pt3fPosIn3DSpace1;
pt3fVoxelCoordinate2 = a2fXYZ_To_CRS*pt3fPosIn3DSpace2;
strctObject.m_strType = 'Ruler';
strctObject.m_pt3fVoxelCoordinate1 = pt3fVoxelCoordinate1(1:3);
strctObject.m_pt3fVoxelCoordinate2 = pt3fVoxelCoordinate2(1:3);
if ~isfield(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol},'m_acControllableObjects') || isfield(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol},'m_acControllableObjects') && isempty(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_acControllableObjects)
    strctObject.m_iUniqueID = 1;
    g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_acControllableObjects{1} = strctObject;
else
    iNumRulers = length(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_acControllableObjects);
    afID = zeros(1,iNumRulers);
    for k=1:iNumRulers
        afID(k) = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_acControllableObjects{k}.m_iUniqueID;
    end
    strctObject.m_iUniqueID = max(afID)+1;
    if isempty(strctObject.m_iUniqueID)
        strctObject.m_iUniqueID = 1;
    end
    g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_acControllableObjects{iNumRulers+1} = strctObject;
end
fnInvalidate();
return;