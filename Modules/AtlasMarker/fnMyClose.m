function a3bOut=fnMyClose(a3bInput,fSize)
a3bOut = fnMyErode(fnMyDilate(a3bInput,fSize-0.0001),fSize-0.0001);

function a3bOutput=fnMyErode(a3bInput,fSize)
a3bOutput = bwdist(~a3bInput)>fSize;

function a3bOutput=fnMyDilate(a3bInput,fSize)
a3bOutput = bwdist(a3bInput)<fSize;


