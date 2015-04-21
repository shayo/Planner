function a2iOutput=fnMyDilate(a2iInput,fSize)
a2iOutput = bwdist(a2iInput)<fSize;