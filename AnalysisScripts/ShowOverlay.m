A=load('D:\Data\Doris\Data For Publications\FEF Opto\Cells\YFP1.mat')
B=load('D:\Data\Doris\Data For Publications\FEF Opto\Cells\PV1.mat')
D=load('D:\Data\Doris\Data For Publications\FEF Opto\Cells\YFP1_PV1_CamKII.mat')
C=load('D:\Data\Doris\Data For Publications\FEF Opto\Cells\CamKII.mat')


figure(10);clf;
h1=tightsubplot(2,2,1);
imagesc(A.a3fRGB)
axis off
h2=tightsubplot(2,2,2);
imagesc(B.a3fRGB)
axis off
h3=tightsubplot(2,2,3);
imagesc(min(1,C.a3fRGB*1.5))
axis off
h4=tightsubplot(2,2,4);
imagesc(D.a3fRGB)
axis off
linkaxes([h1,h2,h3,h4]);
