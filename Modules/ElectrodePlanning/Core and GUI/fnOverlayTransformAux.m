function [a3fHeat, a2fAlpha] = fnOverlayTransformAux(a2fI, strctOverlay)

fWidth = strctOverlay.m_pt2fRight(1)-strctOverlay.m_pt2fLeft(1);
fHeight = abs(strctOverlay.m_pt2fRight(2)-strctOverlay.m_pt2fLeft(2));

a2fTmp = (a2fI - strctOverlay.m_pt2fLeft(1)) / fWidth;
a2fTmp(a2fI < strctOverlay.m_pt2fLeft(1)) = 0;
a2fTmp(a2fI > strctOverlay.m_pt2fRight(1)) = 1;

fWidth2 = strctOverlay.m_pt2fRightPos(1)-strctOverlay.m_pt2fLeftPos(1);
fHeight2 = abs(strctOverlay.m_pt2fRightPos(2)-strctOverlay.m_pt2fLeftPos(2));

a2fTmp2 = (a2fI - strctOverlay.m_pt2fLeftPos(1)) / fWidth2;
a2fTmp2(a2fI < strctOverlay.m_pt2fLeftPos(1)) = 0;
a2fTmp2(a2fI > strctOverlay.m_pt2fRightPos(1)) = 1;


% a2fTmp is now between [0,1]. It will be used to determine the heap map.
% Where 0 means anything left to m_pt2fLeft and 1 means anything right to
% m_pt2fRight

% figure(10);
% clf;
% fMin = strctOverlay.m_pt2fLeft(1);
% fHigh = strctOverlay.m_pt2fRight(1);
% X=repmat(100:-1:0,40,1)';
% hi=imagesc(1:40,linspace(fMin, fHigh, 100),X);
% set(gca,'xticklabel','');
% colormap autumn
% 

iNumColorQuant = 64;
a2fNegValues = autumn(iNumColorQuant);
a2iNegIndices = round( (1-a2fTmp) * (iNumColorQuant-1)) + 1;

a2fPosValues = winter(iNumColorQuant);
a2iPosIndices = round( (1-a2fTmp2) * (iNumColorQuant-1)) + 1;

a2bNegative = a2fI <= 0;

a3fHeat = zeros([size(a2fTmp),3]);
T1 = zeros(size(a2fTmp));
T1(a2bNegative) = a2fNegValues(a2iNegIndices(a2bNegative),1);
T1(~a2bNegative) = a2fPosValues(a2iPosIndices(~a2bNegative),1);
T2 = zeros(size(a2fTmp));
T2(a2bNegative) = a2fNegValues(a2iNegIndices(a2bNegative),2);
T2(~a2bNegative) = a2fPosValues(a2iPosIndices(~a2bNegative),2);
T3 = zeros(size(a2fTmp));
T3(a2bNegative) = a2fNegValues(a2iNegIndices(a2bNegative),3);
T3(~a2bNegative) = a2fPosValues(a2iPosIndices(~a2bNegative),3);


a3fHeat(:,:,1) = T1;
a3fHeat(:,:,2) = T2;
a3fHeat(:,:,3) = T3;

% 
% 
% iNumColorQuant = 64;
% a2fJetValues = autumn(iNumColorQuant);
% a2iJetIndices = round( (1-a2fTmp) * (iNumColorQuant-1)) + 1;
% 
% 
% a3fHeat = zeros([size(a2fTmp),3]);
% a3fHeat(:,:,1) = reshape(a2fJetValues(a2iJetIndices,1),size(a2fTmp));
% a3fHeat(:,:,2) = reshape(a2fJetValues(a2iJetIndices,2),size(a2fTmp));
% a3fHeat(:,:,3) = reshape(a2fJetValues(a2iJetIndices,3),size(a2fTmp));
% 

 a2fAlphaNeg = (1-a2fTmp) * fHeight + strctOverlay.m_pt2fRight(2);
 a2fAlphaPos = (a2fTmp2) * fHeight2 + strctOverlay.m_pt2fLeftPos(2);
 a2fAlpha = a2fAlphaPos;
 a2fAlpha(a2bNegative) = a2fAlphaNeg(a2bNegative);

 if size(a2fI,1) == 1
     a3fHeat = squeeze(a3fHeat);
     a2fAlpha = squeeze(a2fAlpha);
 end;
return;
