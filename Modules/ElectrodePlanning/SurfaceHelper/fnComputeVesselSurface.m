function strctBloodSurface = fnComputeVesselSurface(a3fVol, strctFrangiParam)
Vfiltered=1e4*FrangiFilter3D(a3fVol,strctFrangiParam); % Single scale Frangi Filter
% [afHist,afCent] = hist(Vfiltered(:),1000);
% find(cumsum(afHist)/sum(afHist) > 0.05,1,'first')
% for k=1:length(afCent)
%     find(Vfiltered > 
% end

strctFrangiParam.fVesselnessThreshold = Tmp(i5Perc)
a3bBinary = Vfiltered>strctFrangiParam.fVesselnessThreshold;
L=bwlabeln(a3bBinary);
aiHist=histc(L(:),0:max(L(:)));
aiLargeCCs=  find(aiHist(2:end)>strctFrangiParam.iCCSize);
T=fndllSelectLabels(uint16(L),uint16(aiLargeCCs))>0;
strctBloodSurface=isosurface(T,0.5);

return;
