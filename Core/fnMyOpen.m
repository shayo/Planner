function a2iOutput=fnMyOpen(a2iInput,fSize) %#ok
a2iOutput = fnMyDilate(fnMyErode(a2iInput,fSize+0.0001),fSize+0.0001);
