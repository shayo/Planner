function rotHV = fnGetRotationMatrixFromAxes(ax,dt,dp)
a  = get(ax, 'cameraposition' );
b = get(ax, 'cameratarget'   );
dar  = get(ax, 'dataaspectratio');
up   = get(ax, 'cameraupvector' );


v = (b-a)./dar;
r = crossSimple(v, up./dar);
u = crossSimple(r, v);

dis = norm(v);
v = v/dis;
r = r/norm(r);
u = u/norm(u);
haxis = u;

vaxis = r;

deg2rad = pi/180;

alph = dt*deg2rad;
cosa = cos(alph);
sina = sin(alph);
vera = 1 - cosa;
x = haxis(1);
y = haxis(2);
z = haxis(3);
rotH = [cosa+x^2*vera x*y*vera-z*sina x*z*vera+y*sina; ...
  x*y*vera+z*sina cosa+y^2*vera y*z*vera-x*sina; ...
  x*z*vera-y*sina y*z*vera+x*sina cosa+z^2*vera]';

alph =-dp*deg2rad;
cosa = cos(alph);
sina = sin(alph);
vera = 1 - cosa;
x = vaxis(1);
y = vaxis(2);
z = vaxis(3);
rotV = [cosa+x^2*vera x*y*vera-z*sina x*z*vera+y*sina; ...
  x*y*vera+z*sina cosa+y^2*vera y*z*vera-x*sina; ...
  x*z*vera-y*sina y*z*vera+x*sina cosa+z^2*vera]';

rotHV = rotV*rotH;

return


% simple cross product
function c=crossSimple(a,b)
c(1) = b(3)*a(2) - b(2)*a(3);
c(2) = b(1)*a(3) - b(3)*a(1);
c(3) = b(2)*a(1) - b(1)*a(2);
return
