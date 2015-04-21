function R=RotationAngleToRotationMatrix(r)
% convert rotation angle to rotation matrix
% angles are given in radians in the form of [angle_x, angle_y, angle_z]
% r can be a matrix of angles Nx3, in this case, the output will be 3x3xN
% the matrix which is produces is R = Rx * Ry * Rz
%
NumInputs = size(r,1);

A       = cos(r(:,1));
B       = sin(r(:,1));
C       = cos(r(:,2));
D       = sin(r(:,2));
E       = cos(r(:,3));
F       = sin(r(:,3));
AD      =   A .* D;
BD      =   B .* D;

R = zeros(3,3,NumInputs);

R(1,1,:) = C.*E;
R(1,2,:) = -C.*F;
R(1,3,:) = D;

R(2,1,:) =BD.*E + A.*F;
R(2,2,:) = -BD.*F+A.*E;
R(2,3,:) = -B.*C;

R(3,1,:) =-AD.*E + B.*F;
R(3,2,:) = AD.*F+B.*E;
R(3,3,:) = A.*C;

% 
% Rx = [1,0,0;
%           0,A,-B;
%           0,B,A];
%       
% Ry = [C,0,D;
%            0,1,0;
%            -D,0,C];
% Rz = [E,-F,0;
%           F,E,0;
%           0,0,1];
%       
% 
% |  CE      -CF       D   0 |
% |  BDE+AF  -BDF+AE  -BC  0 |
% | -ADE+BF   ADF+BE   AC  0 |
% |  0        0        0   1 |
% 
% The individual values of A,B,C,D,E and F are evaluated first. Also, the
% values of BD and AD are also evaluated since they occur more than once.
% Thus, the final algorithm is as follows:
% 
% mat[0]  =   C * E;
% mat[1]  =  -C * F;
% mat[2]  =   D;
% mat[4]  =  BD * E + A * F;
% mat[5]  = -BD * F + A * E;
% mat[6]  =  -B * C;
% mat[8]  = -AD * E + B * F;
% mat[9]  =  AD * F + B * E;
% mat[10] =   A * C;
% mat[3]  =  mat[7] = mat[11] = mat[12] = mat[13] = mat[14] = 0;
% mat[15] =  1;