
function a2iOutput=fnMyErode(a2iInput,fSize)
a2iOutput = bwdist(~a2iInput)>fSize;
