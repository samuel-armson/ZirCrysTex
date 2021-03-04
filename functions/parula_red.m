function parula_red = parula_red(varargin)
	%{
	Produced viridis colormap with a certain percentage of white before purple.

	Optional:
	'white_percentage'. Self explanatory. default is 10%

	%}

	p = inputParser;
	addOptional(p,'parula_limit',70);
	addOptional(p,'increment',90);
	parse(p,varargin{:});

	parula_limit = p.Results.parula_limit
	increment = p.Results.increment
	
	parula_limit = parula_limit; %Change this value for point where colormap changes from parula to maroon
      
    Maroon_angular_range = ((90 - parula_limit)/increment)-1;
    Dark_maroon = [132 60 56]/255;
    Light_maroon = [231 149 155]/255;
    new_maroon = Light_maroon;
    RGB_change_per_degree = (Light_maroon - Dark_maroon)/Maroon_angular_range;
    parula_red = [parula(parula_limit/increment);Light_maroon];
    for iter_num = 1:Maroon_angular_range;
    	new_maroon = new_maroon - RGB_change_per_degree;
    	parula_red = [parula_red;new_maroon];
    end

end


















































end