function a2iOut=fnMyClose(a2iInput,fSize) %#ok
a2iOut = fnMyErode(fnMyDilate(a2iInput,fSize-0.0001),fSize-0.0001);

