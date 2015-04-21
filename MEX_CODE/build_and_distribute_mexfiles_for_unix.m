function [ output_args ] = build_and_distribute_mexfiles_for_unix( input_args )
%SYMLINK_MEXFILES_FOR_UNIX build, copy and rename the mex files planner
%requires, so it is easy to use from unix
%   Detailed explanation goes here


all_start = tic;
disp(['Starting: ', mfilename]);

% make sure this is called from where it wants to be called
base_path = fileparts(mfilename('fullpath'));
cd(base_path);

% should only be used under unix
if (ispc)
	disp('Under windows, please use the MSVC compiler and the solution file MexSolution.sln.');
	return
end

% account for the fancy architecture sub directory names under MEX
switch computer('arch')
	case 'maci64'
		SO_architecture_name = 'Mac_x64';
	case 'glnxa64'
		SO_architecture_name = 'Linux_x64';
	case 'win64'
		SO_architecture_name = 'Win_x64';
	case 'win32'
		SO_architecture_name = 'Win_x32';
	otherwise
		error(['Architecture: ', computer('arch'), ' not handled yet... (exiting, prematurely)']);
end

% where to store the compiled mex files
mex_targ_dir = fullfile(pwd, '..', 'MEX', SO_architecture_name);


% the names of the files to be compiled...
mex_code_file_list = {'CohenSutherland.cpp', 'ba_interp3.cpp', 'FastInterp3.cpp', 'FastInterp3Vol.cpp', ...
					'eig3volume.cpp', ...
					'fnGenComb.cpp', 'MeshPlaneIntersect.cpp', 'SelectLabels.cpp','PointPointDist.cpp'};
% the sub directory for each source file (if multiple files from a sub directory are to be compiled included this sub directory multiple times)
mex_code_dir_list = {'CohenSutherland', 'ba_interp3', 'FastInterp3', 'FastInterp3Vol',...
					'eig3volume', ...
					'GenComb', 'MeshPlaneIntersect', 'SelectLabels','PointPointDist'};
% the name stems to use for the mex files (to account for Shay's prefixes)				
mex_file_stem_list = {'fndllCohenSutherland', 'ba_interp3', 'fndllFastInterp3', 'fndllFastInterp3Vol', ...
					'eig3volume', ...
					'fnGenComb', 'fndllMeshPlaneIntersect', 'fndllSelectLabels','fndllPointPointDist'};

% TODO check all three list for equal length...



if (isunix)
	for i_mexfile = 1 : length(mex_code_dir_list)
		cur_src_dir = mex_code_dir_list{i_mexfile};
		disp(['source_sub-directory: ', cur_src_dir]);
		cur_src_file = mex_code_file_list{i_mexfile};
		[~, cur_src_file_stem] = fileparts(cur_src_file);
		disp(['source file: ', cur_src_file]);
		cur_mex_file_stem = mex_file_stem_list{i_mexfile};
		disp(['output name: ', cur_mex_file_stem, '.', mexext]);
		
		
		cur_fq_src_file = fullfile(pwd, cur_src_dir, cur_src_file);
		% now build the mex file
		eval(['mex ', cur_fq_src_file]);
		
		% now copy the just created mex file to the target directory with
		% the target prefix
		[status, message, messageid] = copyfile(fullfile(pwd, [cur_src_file_stem, '.', mexext]), ...
											fullfile(mex_targ_dir, [cur_mex_file_stem, '.', mexext]));
		
		% delete the intermediate
		delete(fullfile(pwd, [cur_src_file_stem, '.', mexext]));
	end
end

disp(['Done... (', mfilename,')']);
toc(all_start);

return
end

