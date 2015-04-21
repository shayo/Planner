function strctFrangiParam = fnGetDefaultFrangiParamters()
strctFrangiParam.GrayScaleValue = 600;
strctFrangiParam.iCCSize = 100;
strctFrangiParam.fVesselnessThreshold = 10;
strctFrangiParam.BlackWhite=false;
strctFrangiParam.FrangiScaleRatio = 2;
strctFrangiParam.FrangiScaleRange=[0.7 0.7];
strctFrangiParam.FrangiC = strctFrangiParam.GrayScaleValue/4;
strctFrangiParam.FrangiAlpha = 1;
strctFrangiParam.verbose = 0;
strctFrangiParam.NumberOfFaces = 20000;
strctFrangiParam.m_fSurfaceOpacity = 0.6;
strctFrangiParam.m_afSurfaceColor = [1 0 0];
strctFrangiParam.m_bDisplay = true;
return;