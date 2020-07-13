function d_m = define_miller(texture_component,cs)
	%{
	Returns miller object for mTeX to use with indices in 1-D cell array format (eg [1,0,-3]). Main benefit over the standard
	is being able to read-in the indices from cell array.

	REQUIRED ARGUMENTS
	texture_component = [1,0,-3], or [0,0,0,2], for example. 1-D cell array of positive or negative integers. Miller indices.
	cs = crystal_symmetry in phase of interest. Can be accessed via: cs = ebsd(phase_of_interest).CS
	%}

	index_size = size(texture_component)

	if index_size(2) == 3
		d_m = Miller(texture_component(1),texture_component(2),texture_component(3),cs);
	elseif index_size(2) == 3
		d_m = Miller(texture_component(1),texture_component(2),texture_component(3),texture_component(4),cs);
	else
		disp('Texture component must have either 3 or 4 indices')
	end
end