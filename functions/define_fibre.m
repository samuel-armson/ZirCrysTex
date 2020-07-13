function d_f = define_fibre(texture_component,cs,varargin)
	%{
	Returns fibre component which can be used by mTeX. Mainly to reduce the number of inputs required - only needs a texture
	component in 1-D cell array format (eg [1,0,-3], [0,0,0,2], etc) and crystal symmetry of phase. By defualt, 
	the fibre will be plotted relative to the sample z-axis (zvector)

	REQUIRED ARGUMENTS
	texture_component = [1,0,-3], or [0,0,0,2], for example. 1-D cell array of positive or negative integers. Miller indices.
	cs = crystal_symmetry in phase of interest. Can be accessed via: cs = ebsd(phase_of_interest).CS

	OPTIONAL ARGUMENTS
	relative_axis = 'xvector', 'yvector', or 'zvector'. 'zvector' is default. See mTeX help for other options (under fibre function).

	%}
	p = inputParser;
	addRequired(p,'texture_component');
	addRequired(p,'cs');
	addOptional(p,'relative_axis','none');
	parse(p,texture_component,cs,varargin{:});

	if strcmp(p.Results.relative_axis, 'none') == 1
		d_f = fibre(define_miller(p.Results.texture_component,p.Results.cs),zvector);
	else
		d_f = fibre(define_miller(p.Results.texture_component,p.Results.cs),p.Results.relative_axis);
end
