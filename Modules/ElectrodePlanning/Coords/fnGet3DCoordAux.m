function [pt3fPosIn3DSpace, pt3fPosInStereoSpace, pt3fVoxelCoordinate, strctCrossSection]=fnGet3DCoordAux(pt2fPos, hAxes)
strctMouseOp.m_hAxes = hAxes;
strctMouseOp.m_pt2fPos = pt2fPos;
[pt3fPosIn3DSpace, pt3fPosInStereoSpace, pt3fVoxelCoordinate, strctCrossSection]=fnGet3DCoord(strctMouseOp);
return;