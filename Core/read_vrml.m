%/*********************************************************************************
% FUNCTION NAME : read_vrml
% AUTHOR        : G. Akroyd
% PURPOSE  : reads a VRML or Inventor file and stores data points and connectivity
%             in arrays ready for drawing wireframe images.
%
% VARIABLES/PARAMETERS: 
%  i/p  filename       name of vrml file 
%  o/p  nel            number of geometry parts (elements) in file
%  o/p  w3d            geometry structure ;-
%                       w3d.pts   array of x y z values for each element                      
%                       w3d.knx   array of connection nodes for each element
%                       w3d.color color of each element
%                       w3d.polynum number of polygons for each element
%                       w3d.trans  transparency of each element
%
% Version / Date : 3.0   / 23-9-02
%                  removed triang optn & replaced face array Nan padding
%                   with 1st value padding to correct opengl display prob.
% Version / Date : 2.0   / 17-7-00
%                  changed output to a structure rather than separate arrays
%                   to use less memory.
%                  1.0   / 21-6-99
%                  original version
%**********************************************************************************/

function [nel,w3d,infoline] = read_vrml(filename)

keynames=char('Coordinate3','point','coordIndex');
 
  fp = fopen(filename,'r');
  if fp == -1
      fclose all;
      str = sprintf('Cannot open file %s \n',filename);
      errordlg(str);
      error(str);
  end

%* initialise arrays & counters */
  fv = zeros(1,3);
  foundkey=zeros(1,3); %* flags to determine if keywords found */
  endpts=0; %/* flag set when end of co-ord pts reached for an element */
  npt=0; %/* counter for num pts or conections */
  npol=1; % counter for number of polygons in an element
  nel=1; %/* counter for num of elements */
  color(1,1:3) = [0.5 0.55 0.5]; % default color
  maxnp = 0;
  tempstr = ' ';
  lastel = 1;
  lnum = 1;
  w3d(1).name = 'patch1';
  infoline = '#';
  trnsp(1) = 1; % transparency array - one val per element

  %/* start of main loop for reading file line by line */
  while ( tempstr ~= -1)
     tempstr = fgets(fp); % -1 if eof 
     if tempstr(1) == '#' & lnum == 2,
        infoline = tempstr;
     end 
     lnum = lnum +1; % line counter
     if ~isempty(findstr(tempstr,'DEF')) & ~endpts,
        w3d(nel).name = sscanf(tempstr,'%*s %s %*s %*s');
     end
     
     if ~isempty(findstr(tempstr,'rgb')) | ~isempty(findstr(tempstr,'diffuseColor')) % get color data 
         sp = findstr(tempstr,'[');
         if isempty(sp), sp = 12 + findstr(tempstr,'diffuseColor'); end
         nc = 0;
         if ~isempty(sp)
            sp = sp +1;                          
            [cvals,nc]=sscanf(tempstr(sp:length(tempstr)),'%f %f %f,');
         end
         if nc >= 3
            if nel > lastel+1 
               for m = lastel+1:nel-1
                  color(m,1:3) = color(1,1:3); % if color not set then make equal to 1st 
               end 
            end 
            % if multi colors set then populate color matrix, this is an inventor feature
            for s = 1:fix(nc/3) 
                  color(s+nel-1,1:3) = cvals(3*s-2:3*s)'; 
               lastel = s+nel-1;
            end    
         end 
     end 
     if ~isempty(findstr(tempstr,'transparency')), % get transparency level
         sp = findstr(tempstr,'trans');
         [tvals,nc]=sscanf(tempstr(sp+12:length(tempstr)),'%f');
         if nc > 0, trnsp(nel) = tvals(1); end
     end 

     for i=1:3  %/* check for each keyword in line */
        key = deblank(keynames(i,:));
        if ~isempty(findstr(tempstr,key)) & isempty(findstr(tempstr,'#')) 
           %/* if key found again before all found there is a problem
           %  so reset flag for that key */
           if ~foundkey(i), foundkey(i)=1;else foundkey(i)=0; end
           if(i>1 & ~foundkey(i-1)) foundkey(i)=0; end %/* previous key must exist first ! */
        end
     end
     if(foundkey(1) & foundkey(2)) %/* start of if A  first 2 keys found */
         if foundkey(3) %/* scan for connectivity data */
            tempstr = [tempstr,' #']; %/* last word marker for end of line */
            skip = '';
            %/* loop puts integer values in a line into connection array */
            word = ' ';
            while(word(1) ~= '#')
               format = sprintf('%s %%s#',skip);
               [word,nw] = sscanf(tempstr,format);
               skip = [skip,'%*s'];
               [node,nred] = sscanf(word,'%d,');
               if nred>0 
                  for p = 1:nred
                     if node(p) ~= -1 
                        npt = npt +1; 
                        % increment node value as matlab counts from 1, vrml 0
                        w3d(nel).knx(npol,npt) = node(p)+1;
                     else
                        if npt > maxnp(nel), maxnp(nel) = npt; end 
                        npt = 0;
                        npol = npol + 1; 
                     end
                  end
               end              
            end

            if ~isempty(findstr(tempstr,']')) %/* End of data block marker */
               polynum(nel)=npol-1; %/* store num of polygons in this element */
               endpts=0; %/* reset flag ready for next element search */
               npt=0;
               npol=1;
               foundkey = zeros(1,4); %/* reset keyword flags for next search */
               nel = nel+1; %/* now looking for next element so increment counter 
               maxnp(nel) = 0;
               w3d(nel).name = sprintf('patch%d',nel); % name next block
            end
         end %/* end of scan for connectivity */

         %/* got 1st 2 keys but not 3rd and not end of co-ords data */
         if(foundkey(2) & ~foundkey(3) & ~endpts) %/* scan for pts data */
            sp = findstr(tempstr,'[');
            if isempty(sp)
               %/* points data in x y z columns */
               [fv,nv]=sscanf(tempstr,'%f %f %f,');
            else
               %/* if block start marker [ in line - need to skip over it to data 
               %   hence pointer to marker incremented */
               sp = sp +1;
               [fv,nv]=sscanf(tempstr(sp:length(tempstr)),'%f %f %f,');
            end
            if(nv>0)
               if mod(nv,3) ~= 0
                  fclose(fp);
                  error('Error reading 3d wire co-ordinates: should be x y z, on each line');
               end 
               nov = fix(nv/3);
               for p = 1:nov
                  npt = npt+1;
                  w3d(nel).pts(npt,1:3)=fv(3*p-2:3*p); 
               end
            end                  
            if ~isempty(findstr(tempstr,']')) %/* end of pts data block */
               endpts=1; %/* flag to stop entry to pts scan while reading connections */
               npt=0;
            end
         end %/* end of scan for data pts */
     end %/* end of if A */     
  end %/* end of main loop */

 if nel == 0
        fclose(fp);
        error('Error reading 3d file: no data found');
 end
 nel = nel -1; 
 
 % if not same number of verticies in each polygon we need to fill
 % out rest of row in array with 1st value
 nc = size(color); 
 ts = size(trnsp);

 for i = 1:nel 
   facs = w3d(i).knx;
   ind1 = find(facs==0); [rown,coln] = ind2sub(size(facs),ind1);
   facs(ind1) = facs(rown);
   w3d(i).knx = facs;
   if i > 1 & i > nc(1), color(i,1:3) = color(1,1:3); end % extend color array to cover all elements 
   w3d(i).color = color(i,1:3);
   w3d(i).polynum = polynum(i);
   if i > ts(2) | trnsp(i)==0, 
       trnsp(i) = 1; 
   end % extend transparency array to cover all elements 
   w3d(i).trans = trnsp(i);
 end
  
 fclose(fp);
  
%  END OF FUNCTION read_vrml

%=====================================================================================
