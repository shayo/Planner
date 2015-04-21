function L= fnGetLightSources(hAxes)
% Will generate one if non is present...
C=get(hAxes,'Children');
iNumKids = length(C);
abLight = zeros(1,iNumKids)>0;
for k=1:iNumKids
    abLight(k) = strcmp(get(C(k),'type'), 'light');
end
if sum(abLight) == 0
    L=light(hAxes);
else
    L=C(abLight);
end

return;

