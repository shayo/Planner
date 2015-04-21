function [ML,DV] = fnConvertCroppedImageCoordsToAtlasCoords(afX,afY)
% Atlas coords are measured as [ML, DV]

% X to ML:
ML = afX * 0.0431 +  -5.6134;
DV = afY * -0.0425  + 68.1806;
return;

X=[428, 664,1370,1606,1841,899];
Y=[50,  40, 10,  0,  -10,30];
robustfit(X,Y)
%    
% y=428 -> DV: 50
% y=664->DV:40
% y=1370-> DV: 10 
% y=1606 -> Dv 0
% y=1841 -> DV: -10

X=[128,176,224,270,316,826,871,779];
Y=[0,2,4,6,8,30,32,28];
% 
% x=127-9 -> ML = 0
% x=176 -> ML = 2
% x=224 -> ML =4
% x=270 -> ML = 6
% x=316 -> ML = 8
