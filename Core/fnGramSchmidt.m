function [afDirection1,afDirection2] = fnGramSchmidt(afDirection)
afDirection = afDirection./norm(afDirection); 
afBase1 = zeros(size(afDirection));
[fDummy,iMinIndex] = min(abs(afDirection));
afBase1(iMinIndex) = 1;
% Make sure the afDirection1 is orthogonal to afDirection
afDirection1 = afBase1 - fnProjVOntoU(afDirection,afBase1);
afDirection1 = afDirection1 ./ norm(afDirection1);

%afDirection2 = cross(afDirection,afDirection1);
%afDirection2 = cross(afDirection,afDirection1);

afDirection2 = [afDirection(2)*afDirection1(3)-afDirection(3)*afDirection1(2),...
afDirection(3)*afDirection1(1)-afDirection(1)*afDirection1(3),...
afDirection(1)*afDirection1(2)-afDirection(2)*afDirection1(1)];

afDirection2 = afDirection2 ./ norm(afDirection2);
return;


function [afVU]= fnProjVOntoU(afU,afV)
afVU = (sum(afU.*afV) / sum(afU.*afU)) * afU;
return;

