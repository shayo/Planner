strmode = 'l';
switch strmode
case 'l'
        mode=0;
    case 'c'
        mode=2;
    case 's'
        mode=2;
    case 'n'
        mode=0;
end
I=single(rand(100,100,100));
N=256*256;
X=single(rand(1,N)*100);
Y=single(rand(1,N)*100);
Z=single(rand(1,N)*100);

Xd=double(X);
Yd=double(Y);
Zd=double(Z);

T=1000;
afTimeA=zeros(1,T);
afTimeB=zeros(1,T);
for k=1:T
    tic
    J1 = interp3fast_single((I),(X),(Y),(Z),single(mode)); % Coordinates are from 1..N
    afTimeA(k)=toc;

   tic
   J2 = fndllFastInterp3((I),(Xd)-1,(Yd)-1,(Zd)-1);
   afTimeB(k)=toc;
   
   figure(11);
   clf;
   plot(J1,'b.');
   hold on;
   plot(J2,'ro');
   
    
end
mean(afTimeA)*1e3
median(afTimeA)*1e3

%mean(afTimeB)*1e3
%median(afTimeB)*1e3
