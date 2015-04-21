% Matlab interface for bioImage formats library
%
%  Input:
%   fname    - string with file name of image to decode 
%   page_num - the number of the page to decode, 0 if ommited
%              in time series pages are time points
%              in the z series pages are depth points
%
%  Output:
%   im       - matrix of the image in the native format with channels in the 3d dimension
%   format   - string with format name used to decode the image
%   pages    - number of pages in the image
%   xyzres   - pixel size on x,y,z dim in microns double[3]
%   metatxt  - string with all meta-data extracted from the image
%
%  ex:
%   [im, format, pages, xyzr, metatxt] = bimread( fname, page_num );
%   
%   [im] = bimread( fname );
%
%  Notes: 
%    Creates 8,16,32,64 bit arrays in float, signed and unsigned
%    If the input is 1 or 4 bit, that will be converted to 8bits
%

[im, format, pages, xyzr, metatxt] = bimread( 'C:\Data\Bert Confocal\0262.oib', 1 );
clear mex;
% show channel 1 of the image
imagesc(im(:,:,1));
