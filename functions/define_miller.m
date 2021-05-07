function d_m = define_miller(texture_component,varargin)
	%{
	Returns miller object for mTeX to use with indices in 1-D cell array format (eg [1,0,-3]). Main benefit over the standard
	is being able to read-in the indices from cell array.

	REQUIRED ARGUMENTS
	texture_component = [1,0,-3], or [0,0,0,2], for example. 1-D cell array of positive or negative integers. Miller indices.
	
	OPTIONAL ARGUMENTS
	plot_type = 'direction' or 'plane'. Default is plane (or hkl/HKIL in mtex notation)
	crys_sym = crystal_symmetry in phase of interest. Can be accessed via: crys_sym = ebsd(phase_of_interest).CS
	%}

	global cs

	p = inputParser;
	addRequired(p,'texture_component');
	addOptional(p,'crys_sym',cs);
	addOptional(p,'plot_type','plane');
	parse(p,texture_component,varargin{:});

	index_size = size(texture_component);


	if strcmp(p.Results.plot_type,'plane') == 1
		if index_size(2) == 3
			d_m = Miller(texture_component(1),texture_component(2),texture_component(3),p.Results.crys_sym);
		elseif index_size(2) == 4
			d_m = Miller(texture_component(1),texture_component(2),texture_component(3),texture_component(4),p.Results.crys_sym);
		else
			disp('Texture component must have either 3 or 4 indices')
		end
	elseif strcmp(p.Results.plot_type,'direction') == 1
		if index_size(2) == 3
			d_m = Miller(texture_component(1),texture_component(2),texture_component(3),p.Results.crys_sym,'uvw');
		elseif index_size(2) == 4
			d_m = Miller(texture_component(1),texture_component(2),texture_component(3),texture_component(4),p.Results.crys_sym,'UVTW');
		else
			disp('Texture component must have either 3 or 4 indices')
		end
	else
		disp("plot_type must be 'plane' or 'direction' if argument is given. Plane is used by default")
	end
end