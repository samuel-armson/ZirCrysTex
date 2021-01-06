function m_l = miller_latex(indices)
	%{
	Converts Miller/Miller-Bravais indices from 1-D cell array to string which can be interpreted by latex to produce
	nicer figure annotations.

	REQUIRED ARGUMENTS
	indices = [1,0,-3] or [0,0,0,2], for example. Any 1x3 or 1x4 array of positive or negative integers.
	parentheses_type = One of the following:
						'plane_individual'			Displays with () - plane without symmetrical equivalents
						'plane_family'				Displays with {} - plane with symmetrical equivalents
						'plane'						Displays with {} - plane with symmetrical equivalents (assumes family)
						'direction_individual'		Displays with [] - direction without symmetrical equivalents
						'direction_family'			Displays with <> - directions with symmetrical equivalents 
						'direction'					Displays with <> - directions with symmetrical equivalents (assumes family)
	%}

	index_size = size(indices)
	tex_vals = strings(1, index_size(2)-1)
	parentheses_type = indices(length(indices))

	if strcmp(parentheses_type,'plane_individual') == 1
		prefix = "$$\left(";
		suffix = "\right)$$";
	elseif strcmp(parentheses_type,'plane_family') == 1
		prefix = "$$\left\{";
		suffix = "\right\}$$";
	elseif strcmp(parentheses_type,'plane') == 1
		prefix = "$$\left\{";
		suffix = "\right\}$$";
	elseif strcmp(parentheses_type,'direction_individual') == 1
		prefix = "$$\left[";
		suffix = "\right]$$";
	elseif strcmp(parentheses_type,'direction_family') == 1
		prefix = "$$\left<";
		suffix = "\right>$$";
	elseif strcmp(parentheses_type,'direction') == 1
		prefix = "$$\left<";
		suffix = "\right>$$";
	else
		disp("'parentheses_type' must be: 'plane_individual', 'plane_family', 'plane', 'direction_individual', 'direction_family' or 'direction'.")
	end

	m_l = prefix

	for iteration = 1:index_size(2)-1
		if str2num(indices(iteration)) < 0
			tex_val = "\bar{" + num2str(abs(str2num(indices(iteration)))) + "}";
			m_l = strcat(m_l, tex_val);
		else
			m_l = strcat(m_l,num2str(indices(iteration)));
		end
	end

	m_l = strcat(m_l,suffix)

end





