function white_viridis = white_viridis(varargin)
	%{
	Produced viridis colormap with a certain percentage of white before purple.

	Optional:
	'white_percentage'. Self explanatory. default is 10%

	%}

	global Sample_ID

	p = inputParser;
	addOptional(p,'white_percentage',10);
	

  for white_viridis_n=1:1
    white_to_purp = p.Results.white_percentage
    viridis_part = viridis(100-white_to_purp)
    white_viridis = zeros(100,3)
    white_viridis(white_to_purp+1:end,1:end) = viridis_part
    white_viridis(1:white_to_purp,1) = linspace(1,0.2670,white_to_purp)
    white_viridis(1:white_to_purp,2) = linspace(1,0.0049,white_to_purp)
    white_viridis(1:white_to_purp,3) = linspace(1,0.3294,white_to_purp) 
  end
















































end