function a2fTrans=fnGetUnconformTransformation()
a2fCRS_To_XYZ = [   -0.5000         0         0   64.0000
         0         0    0.5000  -60.0000 % -64 %
         0   -0.5000         0   64.0000
         0         0         0    1.0000];

a2fCRS_To_XYZ_ConformedA = [     
    -1     0     0   128
     0     0     1  -128
     0    -1     0   128
     0     0     0     1];
 T = [
    -1     0     0     0
     0     0    -1     0
     0     1     0     0
     0     0     0     1];

 a2fTrans = a2fCRS_To_XYZ*inv(a2fCRS_To_XYZ_ConformedA)*T;
 return;
 