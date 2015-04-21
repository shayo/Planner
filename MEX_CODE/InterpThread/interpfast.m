function J = interpfast(I,xi,yi,zi,type)
%
%
%  J = interpfast(I,xi,yi,type)
%
% or
%
%  J = interpfast(I,xi,yi,zi,type)
%
%  example 2D,
%
%    I=rand(10,10);
%    xi=rand(5,1)*9+1;
%    yi=rand(5,1)*9+1;
%    J1 = interpfast(I,xi,yi,'linear')
%    J2 = interp2(I',xi,yi,'linear')
%
%  example 3D,
%
%    I=rand(200,200,200);
%    xi=rand(1e4,1)*199+1;
%    yi=rand(1e4,1)*199+1;
%    zi=rand(1e4,1)*199+1;
%    tic; J1 = interpfast(I,xi,yi,zi,'cubic'); toc;
%    tic; J2 = interp3(permute(I,[2 1 3]),xi,yi,zi,'cubic'); toc
%
%
if(ndims(I)==2)
    if(nargin>3), type=zi; else type='l'; end
elseif(ndims(I)==3)
    if(nargin<5), type='l'; end
else
    error('interpfast:input', 'Dimension not supported');
end

classI=class(I);

if((~isa(I,'double'))&&(~isa(I,'single')))
    I=single(I);
end


switch lower(type(1))
    case 'l'
        mode=0;
    case 'c'
        mode=2;
    case 's'
        mode=2;
    case 'n'
        mode=0;
    otherwise
    error('interpfast:input', 'Unknown interpolation type');        
end


if(isa(I,'double'))
    if(ndims(I)==2)
        J = interp2fast_double(double(I),double(xi),double(yi),double(mode));
    else
        J = interp3fast_double(double(I),double(xi),double(yi),double(zi),double(mode));
    end
else
    if(ndims(I)==2)
        J = interp2fast_double(double(I),double(xi),double(yi),double(mode));
    else
        J = interp3fast_single(single(I),single(xi),single(yi),single(zi),single(mode));
    end    
end

J=cast(J,classI);
J=reshape(J,size(xi));
