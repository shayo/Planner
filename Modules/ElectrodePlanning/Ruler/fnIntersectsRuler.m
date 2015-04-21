
function [bIntersects, strWhat] = fnIntersectsRuler(strctObject, strctMouseOp)
global g_strctModule    
bIntersects = false;
strWhat = [];
[strctCrossSection,strName] = fnAxesToCrossSection(strctMouseOp.m_hAxes);
 if ~strcmp(   strName, strctObject.m_strAxes)
     return;
 end;
 % Check whether it is close to the end points first.
 a2fXYZ_To_CRS = inv(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fM) * inv(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fReg); %#ok
a2fCRS_To_XYZ = inv(a2fXYZ_To_CRS);
 %[pt3fPosIn3DSpace,pt3fPosInStereoSpace, pt3fVoxelCoordinate, strctCrossSection,pt3fPosInAtlasSpace]=fnGet3DCoord(strctMouseOp);
  pt2fStart = fnPoint3DToImage(strctCrossSection, a2fCRS_To_XYZ * [strctObject.m_pt3fVoxelCoordinate1;1]); %#ok
  pt2fEnd = fnPoint3DToImage(strctCrossSection, a2fCRS_To_XYZ * [strctObject.m_pt3fVoxelCoordinate2;1]); %#ok
  fDistToStart = norm(strctMouseOp.m_pt2fPos-pt2fStart);
  fDistToEnd = norm(strctMouseOp.m_pt2fPos-pt2fEnd);
  [fDistToLine, pt2fClosestPointOnLine, fDistanceAlongLine,bInInterval] = fnPointLineDist2D(pt2fStart,pt2fEnd, strctMouseOp.m_pt2fPos); %#ok
    if  fDistToStart < 5
        bIntersects = true;
        strWhat = 'Start';
    elseif fDistToEnd < 5
        bIntersects = true;
        strWhat = 'End';
    elseif fDistToLine < 3  && bInInterval
        bIntersects = true;
        strWhat = 'Line';
    end
 
return;
