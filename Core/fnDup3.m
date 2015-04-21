function Y=fnDup3(X)
Y=reshape([X,X,X], [size(X),3]);
%Y(:,:,1) = X;
%Y(:,:,2) = X;
%Y(:,:,3) = X;
return;