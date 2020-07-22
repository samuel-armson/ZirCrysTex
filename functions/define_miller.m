function d_m = define_miller(texture_component,cs,varargin)
	%{
	Returns miller object for mTeX to use with indices in 1-D cell array format (eg [1,0,-3]). Main benefit over the standard
	is being able to read-in the indices from cell array.

	REQUIRED ARGUMENTS
	texture_component = [1,0,-3], or [0,0,0,2], for example. 1-D cell array of positive or negative integers. Miller indices.
	cs = crystal_symmetry in phase of interest. Can be accessed via: cs = ebsd(phase_of_interest).CS

	OPTIONAL ARGUMENTS
	plot_type = 'direction' or 'plane'. Default is plane (or hkl/HKIL in mtex notation)
	%}

	p = inputParser;
	addRequired(p,'texture_component');
	addRequired(p,'cs');
	addOptional(p,'plot_type','plane');
	parse(p,texture_component,cs,varargin{:});

	index_size = size(texture_component)

	if strcmp(p.Results.plot_type,'plane') == 1
		if index_size(2) == 3
			d_m = Miller(texture_component(1),texture_component(2),texture_component(3),cs);
		elseif index_size(2) == 3
			d_m = Miller(texture_component(1),texture_component(2),texture_component(3),texture_component(4),cs);
		else
			disp('Texture component must have either 3 or 4 indices')
		end
	elseif strcmp(p.Results.plot_type,'direction') == 1
		if index_size(2) == 3
			d_m = Miller(texture_component(1),texture_component(2),texture_component(3),cs,'uvw');
		elseif index_size(2) == 3
			d_m = Miller(texture_component(1),texture_component(2),texture_component(3),texture_component(4),cs,'UVTW');
		else
			disp('Texture component must have either 3 or 4 indices')
		end
	else
		disp("plot_type must be 'plane' or 'direction' if argument is given. Plane is used by default")
	end
end