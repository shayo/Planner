
iHoleIter1=1;
iHoleIter2 = 23;

P1 = [strctGridModel.m_afGridHolesX;strctGridModel.m_afGridHolesY;zeros(1,iNumHoles)];
P2 = P1+10*strctGridModel.m_apt3fGridHolesNormals;


afRange = linspace(0,1,100);
for t=1:length(afRange)
    for q=1:length(afRange);
    pt3fQuery1 = P1(:,iHoleIter2) + strctGridModel.m_apt3fGridHolesNormals(:,iHoleIter2)*10*afRange(t);
    pt3fQuery2 = P1(:,iHoleIter1) + strctGridModel.m_apt3fGridHolesNormals(:,iHoleIter1)*10*afRange(q);
    a2fDist(t,q) = sqrt(sum((pt3fQuery2-pt3fQuery1).^2));
    end
end

figure;imagesc(a2fDist)
min(a2fDist(:))
contour(a2fDist)

P = [-7 -5
        -3 -2
         0 0];
N = [    0.0594         0
    0.1632    0.1736
   -0.9848   -0.9848];

P1 = [strctGridModel.m_afGridHolesX;strctGridModel.m_afGridHolesY;zeros(1,iNumHoles)];
P2 = P1+10*strctGridModel.m_apt3fGridHolesNormals;
[afDist,aiInd] = fndllLineLineDist(P1,P2);
