function write_surf(fname,vertex_coords, faces)
vnum = size(vertex_coords,1);
fnum = size(faces,1);

magic = 16777213 ;
fid = fopen(fname, 'wb', 'b') ;
if (fid < 0)
  str = sprintf('could not open curvature file %s.', fname) ;
  error(str) ;
end
fwrite3(fid, magic);
fwrite3(fid,vnum);
fwrite3(fid,fnum);
vertex_coords = vertex_coords';
fwrite(fid, vertex_coords(:),'float32');

b1 = bitand(bitshift(faces, -16), 255) ;
b2 = bitand(bitshift(faces, -8), 255) ;
b3 = bitand(faces, 255) ; 
tmp = zeros([3,3,fnum]);
tmp(1,:,:) =b1';
tmp(2,:,:) =b2';
tmp(3,:,:) =b3';
fwrite(fid, tmp(:), 'uchar') ;
fclose(fid) ;

