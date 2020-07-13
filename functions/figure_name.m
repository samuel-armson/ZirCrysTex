function f_n = figure_name(sample_ID,varargin)
	%{
	Takes sample_ID and concatenates it with the reference_texture_component and an optional suffix. This is particularly
	useful when exploring different texture components to use for the reference in certain plots. If only the sample_ID is given,
	the return will just be the sample_ID. This seems to be the most flexible way to set up the function. The extension parameter
	will add the file extension after any chosen suffix.

	REQUIRED ARGUMENTS
	sample_ID = 'example sample ID', for example. Just a unique sample / analysis identifier to prevent saving over other figures.
	
	OPTIONAL ARGUMENTS / PARAMETERS (varargin)
	file_path = add suffix for file path eg: 'J:/MIBL SAMPLES/EX HIGH DR/'. Needs trailing /
	reference_texture_component = [1,0,-3], for example. A 1x3 or 1x4 (Miller or Miller-Bravais) cell array of integers.
	suffix = additional string of information to add to the figure name. Particularly useful in figure plotting functions
				eg. 'IPF map'.
	extension = figure format to export. eg. 'pdf','png','tif'.
	%}

	p = inputParser;
	addRequired(p,'sample_ID');
	addOptional(p,'file_path','none');
	addOptional(p,'reference_texture_component',[0,0,0]);
	addOptional(p,'suffix','none');
	addOptional(p,'extension','none');
	parse(p,sample_ID,varargin{:});

	sample_ID_char = char(p.Results.sample_ID);

	if strcmp(p.Results.file_path,'none') == 0
		sample_ID_char = strcat(p.Results.file_path,' ',sample_ID_char);
	end

	if p.Results.reference_texture_component ~= [0,0,0]
		sample_ID_char = strcat(sample_ID_char,{' '})
		index_size = size(p.Results.reference_texture_component);
		iteration = 1;
		for iteration = 1:index_size(2)
			sample_ID_char = strcat(Sample_ID_char, num2str(p.Results.reference_texture_component(iteration)));
		end
	end

	if strcmp(p.Results.suffix,'none') == 0
		sample_ID_char = strcat(sample_ID_char,{' '},char(p.Results.suffix));
	end

	if strcmp(p.Results.extension,'none') == 0
		sample_ID_char = strcat(sample_ID_char,'.',char(p.Results.extension));
	end

	f_n = sample_ID_char;
	
end