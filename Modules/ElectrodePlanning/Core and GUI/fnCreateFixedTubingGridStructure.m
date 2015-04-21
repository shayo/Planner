function strctGridParam = fnCreateFixedTubingGridStructure(fLengthBelowMM)
strctGridParam.m_strGridName = sprintf('One Hole %d mm',fLengthBelowMM);


fTubingInnerDiameterMM = 0.380;
fTubingOuterDiameterMM = 0.686;
fTubingLengthBelowPedestalMM = 2;
fTubingLengthAbovePedestalMM = 5;
fPedestalHeightMM = 8;

strctGridParam.m_fGuideTubeDiameterMM = fTubingInnerDiameterMM;

strctGridParam.m_fGridPhiDeg = 0;
strctGridParam.m_fGridInnerDiameterMM = fTubingInnerDiameterMM;
strctGridParam.m_fGridOuterDiameterMM = fTubingOuterDiameterMM;
strctGridParam.m_fGridHoleDiameterMM = fTubingInnerDiameterMM;
strctGridParam.m_fGridHoleDistanceMM = fTubingOuterDiameterMM;
strctGridParam.m_fGridHeightMM = fTubingLengthBelowPedestalMM+fPedestalHeightMM;
strctGridParam.m_afGridX = 0;
strctGridParam.m_afGridY = 0;
strctGridParam.m_apt3fGridNormals = [0,0,-1];
strctGridParam.m_fGridThetaDeg = 0; % not very relevant here
strctGridParam.m_abSelected = false;
strctGridParam.m_afGuideTubeLengthMM = fPedestalHeightMM;
strctGridParam.m_afElectrodeLengthMM = 10;
strctGridParam.m_fChamberDepthOffset = 0;
return;