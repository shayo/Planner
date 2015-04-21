function strctModel = fnBuildCristChamberModel(fChamberAngle)
% A chamber must have only two strctures that describe the 3D geometry
% One is "short" (normal size) and one is "long" to see its projection in
% the volume. 
%
% Future versions may automatically do this projection so only the short
% version will be needed.
strctModel.m_astrctMeshShort = fnBuildShortModel( fnGetStandardCristChamberParams(fChamberAngle));
strctModel.m_astrctMeshLong = fnBuildLongModel( fnGetStandardCristChamberParams(fChamberAngle));
return;


function strctParams = fnGetStandardCristChamberParams(fChamberAngle)
% Builds a 3D wire-frame model of a chamber
fOuterDiameterMM = 24.0; % mm
fInnerDiameterMM = 19.00;

% fOuterDiameterMM = 22.0; % mm
% fInnerDiameterMM = 16.00;


fChamberH1 = 20.25;
if (fChamberAngle == 0)
    fChamberH2  = 20.25;
else
    % These values are for a "30" deg chamber
    fChamberH2 = 33;
end
strctParams.m_strManufacterer = 'Crist';
strctParams.m_strName = sprintf('Crist %d Deg',fChamberAngle);
strctParams.m_fOuterDiameterMM = fOuterDiameterMM;
strctParams.m_fInnerDiameterMM = fInnerDiameterMM;
strctParams.m_fChamberH1 = fChamberH1;
strctParams.m_fChamberH2 = fChamberH2;
strctParams.m_fChamberAngleDeg = fChamberAngle;
strctParams.m_iQuat = 20;
return;

function astrctMeshShort = fnBuildShortModel(strctChamberParams)
astrctMeshShort(1)= fnCreateChamberMesh(strctChamberParams.m_fInnerDiameterMM, -strctChamberParams.m_fChamberH1,...
    -strctChamberParams.m_fChamberH2, 0,strctChamberParams.m_iQuat, [1 0 1]);

astrctMeshShort(2)= fnCreateChamberMesh(strctChamberParams.m_fOuterDiameterMM, -strctChamberParams.m_fChamberH1,...
    -strctChamberParams.m_fChamberH2, 0,strctChamberParams.m_iQuat, [1 0 1]);

astrctMeshShort(3)= fnCreateChamberMesh(strctChamberParams.m_fOuterDiameterMM, -80,...
    -80, 0,strctChamberParams.m_iQuat, [1 0 1]);

astrctMeshShort(4)= fnCreateChamberMesh(strctChamberParams.m_fOuterDiameterMM, -80,...
    -80, 0,strctChamberParams.m_iQuat, [1 0 1]);

strctMesh.m_a2fVertices = [ 0                                      0            0                           0; ...
                          strctChamberParams.m_fInnerDiameterMM/2  0 strctChamberParams.m_fInnerDiameterMM/2 0;...
                           -strctChamberParams.m_fChamberH1 -strctChamberParams.m_fChamberH1 0  0];
strctMesh.m_a2iFaces = [1,2,3; 2 3 4]';       
strctMesh.m_afColor = [1 1 0];
strctMesh.m_fOpacity = 0.4;

astrctMeshShort(5) = strctMesh;

return;

function astrctMesh = fnBuildLongModel(strctChamberParams)

astrctMesh(1)= fnCreateChamberMesh(strctChamberParams.m_fInnerDiameterMM, -strctChamberParams.m_fChamberH1,...
    -strctChamberParams.m_fChamberH2, 0,strctChamberParams.m_iQuat, [1 0 1]);

astrctMesh(2)= fnCreateChamberMesh(strctChamberParams.m_fOuterDiameterMM, -strctChamberParams.m_fChamberH1,...
    -strctChamberParams.m_fChamberH2, 0,strctChamberParams.m_iQuat, [1 0 1]);

strctMesh.m_a2fVertices = [ 0                                      0            0                           0; ...
                          strctChamberParams.m_fInnerDiameterMM/2  0 strctChamberParams.m_fInnerDiameterMM/2 0;...
                           -strctChamberParams.m_fChamberH1 -strctChamberParams.m_fChamberH1 0  0];
strctMesh.m_a2iFaces = [1,2,3; 2 3 4]';       
strctMesh.m_afColor = [1 1 0];
strctMesh.m_fOpacity = 0.4;
astrctMesh(3) = strctMesh;

return;