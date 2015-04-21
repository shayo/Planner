function [R]=QuaternionToRotationMatrix(Q)
% Quaternion is given by [x,y,z,w] where
% x,y,z = rotation axis * sin(angle), w = cos(angle)
% Input can be Nx4 (must be normalized), output is 3x3xN
NumInputs = size(Q,1);
R = zeros(3,3,NumInputs);

xx      = Q(:,1) .* Q(:,1);
xy      = Q(:,1) .* Q(:,2);
xz      = Q(:,1) .* Q(:,3);
xw      = Q(:,1) .* Q(:,4);
yy      = Q(:,2) .* Q(:,2);
yz      = Q(:,2) .* Q(:,3);
yw      = Q(:,2) .* Q(:,4);
zz      = Q(:,3) .* Q(:,3);
zw      = Q(:,3) .* Q(:,4);
                  
R(1,1,:) = 1-2*(yy+zz);
R(1,2,:) = 2*(xy+zw);
R(1,3,:) = 2*(xz - yw);

R(2,1,:) = 2*(xy-zw);
R(2,2,:) = 1-2*(xx+zz);
R(2,3,:) = 2*(yz+xw);

R(3,1,:) = 2*(xz+yw);
R(3,2,:) = 2*(yz-xw);
R(3,3,:) = 1-2*(xx+yy);

% Q = |X Y Z W|
%
%          ¦            2     2                                      ¦
%          ¦ 1 - (2Y  + 2Z )   2XY + 2ZW         2XZ - 2YW       ¦
%          ¦                                                                                 ¦
%                                      ¦                          2     2                    ¦
%      M = ¦ 2XY - 2ZW         1 - (2X  + 2Z )   2YZ + 2XW       ¦
%          ¦                                                     ¦
%          ¦                                            2     2  ¦
%          ¦ 2XZ + 2YW         2YZ - 2XW         1 - (2X  + 2Y ) ¦
%          ¦                                                     ¦
%
%   If a 4x4 matrix is required, then the bottom row and right-most column
%   may be added.
%   The matrix may be generated using the following expression:
%
%     xx      = X * X;
%     xy      = X * Y;
%     xz      = X * Z;
%     xw      = X * W;
%     yy      = Y * Y;
%     yz      = Y * Z;
%     yw      = Y * W;
%     zz      = Z * Z;
%     zw      = Z * W;
%     mat[0]  = 1 - 2 * ( yy + zz );
%     mat[1]  =     2 * ( xy - zw );
%     mat[2]  =     2 * ( xz + yw );
%     mat[4]  =     2 * ( xy + zw );
%     mat[5]  = 1 - 2 * ( xx + zz );
%     mat[6]  =     2 * ( yz - xw );
%     mat[8]  =     2 * ( xz - yw );
%     mat[9]  =     2 * ( yz + xw );
%     mat[10] = 1 - 2 * ( xx + yy );
%     mat[3]  = mat[7] = mat[11] = mat[12] = mat[13] = mat[14] = 0;
%     mat[15] = 1;