
function strctObject = fnModifyRulerPosition(strctObject, strWhat, strctMouseOp)
global g_strctModule 
afDiffPix = strctMouseOp.m_pt2fPos-g_strctModule.m_strctPrevMouseOp.m_pt2fPos;
a2fCRS_To_XYZ = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fReg*g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fM;
strctCrossSection=fnAxesNameToCrossSection(strctObject.m_strAxes);
pt1mm = a2fCRS_To_XYZ*[strctObject.m_pt3fVoxelCoordinate1;1];
pt2mm = a2fCRS_To_XYZ*[strctObject.m_pt3fVoxelCoordinate2;1];
pt1pix=fnPoint3DToImage(strctCrossSection,pt1mm(1:3));
pt2pix=fnPoint3DToImage(strctCrossSection,pt2mm(1:3));
switch strWhat
    case 'Start'
        pt1pix=pt1pix+afDiffPix;
    case 'End'
        pt2pix=pt2pix+afDiffPix;
      case 'Line'
        pt1pix=pt1pix+afDiffPix;
        pt2pix=pt2pix+afDiffPix;
end
pt1vox = inv(a2fCRS_To_XYZ)*[fnCrossSection_Image_To_MM_3D(strctCrossSection,pt1pix);1]; %#ok
pt2vox = inv(a2fCRS_To_XYZ)*[fnCrossSection_Image_To_MM_3D(strctCrossSection,pt2pix);1]; %#ok
strctObject.m_pt3fVoxelCoordinate1 = pt1vox(1:3);
strctObject.m_pt3fVoxelCoordinate2 = pt2vox(1:3);
return;

function fnModifyController(iControllerIndex,strctMouseOp,strWhat)
global g_strctModule
    strctObject = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_acControllableObjects{iControllerIndex};
switch  strctObject.m_strType
    case 'Ruler'
        g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_acControllableObjects{iControllerIndex} = fnModifyRulerPosition(strctObject, strWhat, strctMouseOp);
end

return;

