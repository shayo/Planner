A=load('YFP1');
B=load('PV1');
C=load('CamKII');
D=load('YFP1_PV1_CamKII');
a=A.a3fRGB(157:300,191:335,:);
b=B.a3fRGB(157:300,191:335,:);
c=C.a3fRGB(157:300,191:335,:);
d=D.a3fRGB(157:300,191:335,:);

figure(50);
clf;
imshow([a,b;c,d]);


A=load('YFP2');
B=load('DAPI2');
C=load('NeuN2');
D=load('GFAP2');
E=load('YFP2_NEUN_DAPI_GFAP');
a=A.a3fRGB(127:300,191:355,:);
b=B.a3fRGB(127:300,191:355,:);
c=C.a3fRGB(127:300,191:355,:);
d=D.a3fRGB(127:300,191:355,:);
e=E.a3fRGB(127:300,191:355,:);

figure(50);
clf;
imshow([a,c;d,e]);



A=load('YFP3');
B=load('DAPI3');
C=load('NeuN3');
D=load('GFAP3');
E=load('YFP3_NEUN_GFAP_DAPI');
a=A.a3fRGB(127:300,[191:355] -30,:);
b=B.a3fRGB(127:300,[191:355] -30,:);
c=C.a3fRGB(127:300,[191:355] -30,:);
d=D.a3fRGB(127:300,[191:355] -30,:);
e=E.a3fRGB(127:300,[191:355] -30,:);

figure(50);
clf;
imshow([a,c;d,e]);





A=load('YFP4');
B=load('PV4');
C=load('CamKII4');
D=load('YFP4_PV_CamKII');
a=A.a3fRGB([127:300] - 50,[191:355]-80,:);
b=B.a3fRGB([127:300] - 50,[191:355]-80,:);
c=C.a3fRGB([127:300] - 50,[191:355]-80,:);
d=D.a3fRGB([127:300] - 50,[191:355]-80,:);
figure(50);
clf;
imshow([a,b;c,d]);





A=load('YFP5');
C=load('NeuN5');
D=load('GFAP5');
E=load('YFP5_NeuN_GFAP_DAPI');
a=A.a3fRGB(127:300,191:355,:);
c=C.a3fRGB(127:300,191:355,:);
d=D.a3fRGB(127:300,191:355,:);
e=E.a3fRGB(127:300,191:355,:);

figure(50);
clf;
imshow([a,c;d,e]);


A=load('Layers_DAPI');
B=load('Layers_YFP');
C=load('Layers_YFP&DAPI');

figure(50);
clf;
imshow([A.a3fRGB,B.a3fRGB;C.a3fRGB,zeros(size(A.a3fRGB))]);




A=load('Layers2_DAPI');
B=load('Layers2_YFP');
C=load('Layers2_YFP&DAPI');

figure(50);
clf;
imshow([A.a3fRGB,B.a3fRGB;C.a3fRGB,zeros(size(A.a3fRGB))]);
