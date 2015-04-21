function [a2fHoriz, a2fSaggital, a2fCoronal, a3fHoriz, a3fSaggital, a3fCoronal] = fnGetVolumeCrossSections(strctVol)

strctVol.m_strctCrossSectionHoriz.m_a2fM(1:3,4)    = strctVol.m_strctCrossSectionHoriz.m_a2fM(1:3,4) + strctVol.m_strctCrossSectionHoriz.m_a2fM(1:3,3) * strctVol.m_strctCrossSectionHoriz.m_fViewOffsetMM;
strctVol.m_strctCrossSectionSaggital.m_a2fM(1:3,4) = strctVol.m_strctCrossSectionSaggital.m_a2fM(1:3,4) + strctVol.m_strctCrossSectionSaggital.m_a2fM(1:3,3) * strctVol.m_strctCrossSectionSaggital.m_fViewOffsetMM;
strctVol.m_strctCrossSectionCoronal.m_a2fM(1:3,4)  = strctVol.m_strctCrossSectionCoronal.m_a2fM(1:3,4) + strctVol.m_strctCrossSectionCoronal.m_a2fM(1:3,3) * strctVol.m_strctCrossSectionCoronal.m_fViewOffsetMM;

a2fXYZ_To_CRS = inv(strctVol.m_a2fM) * inv(strctVol.m_a2fReg);
a2fHoriz    = fnResampleCrossSection(strctVol.m_a3fVol, a2fXYZ_To_CRS, strctVol.m_strctCrossSectionHoriz);
a2fSaggital = fnResampleCrossSection(strctVol.m_a3fVol, a2fXYZ_To_CRS, strctVol.m_strctCrossSectionSaggital);
a2fCoronal  = fnResampleCrossSection(strctVol.m_a3fVol, a2fXYZ_To_CRS, strctVol.m_strctCrossSectionCoronal);

a3fCoronal = fnDup3(fnContrastTransform(a2fCoronal, strctVol.m_strctContrastTransform));
a3fHoriz = fnDup3(fnContrastTransform(a2fHoriz, strctVol.m_strctContrastTransform));
a3fSaggital = fnDup3(fnContrastTransform(a2fSaggital, strctVol.m_strctContrastTransform));

return;
