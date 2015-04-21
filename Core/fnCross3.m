function C = fnCross3(A,B)
% Last Update: 17 Mar 2008, (SO)
%
% General Description:
% This is a fast cross computation for vectors of length 3.
% For A,B of size Nx3, the result is a cross of each row
%
C = [A(:,2).*B(:,3) - A(:,3).*B(:,2),  A(:,3).*B(:,1)-A(:,1).*B(:,3),...
    A(:,1).*B(:,2)-A(:,2).*B(:,1)];
return;
