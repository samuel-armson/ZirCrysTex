function mul_mil = multi_miller(desired_pfs,varargin)
	%{
	Returns  1D array of miller objects for mTeX to use with indices in 1-D cell array format (eg [1,0,-3]). Main benefit over the standard
	is being able to read-in the indices from cell array. Utilises the define_miller function.

	REQUIRED ARGUMENTS
	texture_component = [1,0,-3], or [0,0,0,2], or [1,1,1,"plane"], or [0,0,0,2,"direction"] for example. 
					1-D cell array of positive or negative integers and optionally the type of index. Miller indices.
					If all pole figures are wanted to be planar or directional, this can be included as on optinonal argument separate
					from this one. If you would like to show directional and planar side by side in one figure, add the type as an
					additional item in the array for EACH index.
	
	OPTIONAL ARGUMENTS
	glob_plot_type = 'direction' or 'plane'. Default is plane (or hkl/HKIL in mtex notation)
	crys_sym = crystal_symmetry in phase of interest. Can be accessed via: crys_sym = ebsd(phase_of_interest).CS. Default is the global cs
				value in main script.
	%}
	global cs

	p = inputParser;
	addRequired(p,'desired_pfs');
	addOptional(p,'crys_sym',cs);
	addOptional(p,'glob_plot_type','plane');
	parse(p,desired_pfs,varargin{:});

	input_shape = size(desired_pfs);
	pf_quant = input_shape(1);
	argument_quant = input_shape(2);
    
    mul_mil = [];
	if argument_quant == 3
		for iteration = 1:pf_quant
			mil = define_miller(desired_pfs(iteration,:),'crys_sym',p.Results.crys_sym,'plot_type',p.Results.glob_plot_type);
			mul_mil = [mul_mil,mil];
		end

	elseif argument_quant == 4 && isa(desired_pfs(1,4),'double') == 1
		for iteration = 1:pf_quant
			mil = define_miller(desired_pfs(iteration,:),'crys_sym',p.Results.crys_sym,'plot_type',p.Results.glob_plot_type);
			mul_mil = [mul_mil,mil];
		end
	
    else
		for iteration = 1:pf_quant
			ind_plot_type = desired_pfs(iteration,end);
			mil = define_miller(str2double(desired_pfs(iteration,1:(argument_quant-1))),'crys_sym',p.Results.crys_sym,'plot_type',ind_plot_type);
			mul_mil = [mul_mil,mil];
		end
	end
end


