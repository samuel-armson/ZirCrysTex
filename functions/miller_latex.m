function m_l = miller_latex(indices,parentheses_type)
	%{
	Converts Miller/Miller-Bravais indices from 1-D cell array to string which can be interpreted by latex to produce
	nicer figure annotations.

	REQUIRED ARGUMENTS
	indices = [1,0,-3] or [0,0,0,2], for example. Any 1x3 or 1x4 array of positive or negative integers.
	parentheses_type = One of the following:
						'plane_individual'			Displays with () - plane without symmetrical equivalents
						'plane_family'				Displays with {} - plane with symmetrical equivalents
						'direction_individual'		Displays with [] - direction without symmetrical equivalents
						'direction_family'			Displays with <> - directions with symmetrical equivalents
	%}

	index_size = size(indices)
	tex_vals = strings(1, index_size(2))

	if strcmp(parentheses_type,'plane_individual') == 1
		prefix = "$$\left(";
		suffix = "\right)$$";
	elseif strcmp(parentheses_type,'plane_family') == 1
		prefix = "$$\left\{";
		suffix = "\right\}$$";
	elseif strcmp(parentheses_type,'direction_individual') == 1
		prefix = "$$\left[";
		suffix = "\right]$$";
	elseif strcmp(parentheses_type,'direction_family') == 1
		prefix = "$$\left<";
		suffix = "\right>$$";
	else
		disp("'parentheses_type' must be: 'plane_individual', 'plane_family', 'direction_individual', or 'direction_family'.")
	end

	m_l = prefix

	for iteration = 1:index_size(2)
		if indices(iteration) < 0
			tex_val = "\bar{" + num2str(abs(indices(iteration))) + "}";
			m_l = strcat(m_l, tex_val);
		else
			m_l = strcat(m_l,num2str(indices(iteration)));
		end
	end

	m_l = strcat(m_l,suffix)

end





