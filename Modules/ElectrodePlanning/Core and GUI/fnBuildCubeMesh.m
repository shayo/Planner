function strctMesh = fnBuildCubeMesh(X0,Y0,Z0,fHalfWidth,fHalfHeight,fHalfDepth, afColor)
strctMesh.m_a2fVertices = [...
    X0-fHalfWidth,Y0-fHalfHeight,Z0-fHalfDepth;
    X0-fHalfWidth,Y0-fHalfHeight,Z0+fHalfDepth;
    X0-fHalfWidth,Y0+fHalfHeight,Z0-fHalfDepth;
    X0-fHalfWidth,Y0+fHalfHeight,Z0+fHalfDepth;
    X0+fHalfWidth,Y0-fHalfHeight,Z0-fHalfDepth;
    X0+fHalfWidth,Y0-fHalfHeight,Z0+fHalfDepth;
    X0+fHalfWidth,Y0+fHalfHeight,Z0-fHalfDepth;
    X0+fHalfWidth,Y0+fHalfHeight,Z0+fHalfDepth]';
    
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
strctMesh.m_afColor = afColor;        
strctMesh.m_fOpacity = 0.6;
return;
