function pm = plot_map(data_in,map_type,varargin)
	%{
	Plots raw EBSD data or pre-calculated grain data. 

	REQUIRED ARGUMENTS
	data_in = EBSD or GRAINS data type provided by mTeX.
	map_type = Either: 'IPF','Euler','Deviation', 'Phase'

	OPTIONAL ARGUMENTS
	IPF_key = 
	ref_texture_comp = Eg. [0,0,0,2] or [0,0,1]. 
	save_fig = 'yes' or 'no'. Default value is no. This is useful for saving time and storage space when testing scripts before
				commiting to saving them.
	sample_ID = 'Example sample ID', for example. Required when you want to save the figure. It is useful to set a global sample
				name using the figure_name function directly before starting to plot figures. The char string produced by this
				function can then be used as the sample_ID argument.
	extension = 'tif','png','jpg','pdf' etc. Default is pdf.
	resolution = integer value. Default is 1000. (dpi)

	%}

	global cs
	global reference_texture_component
	global phase_of_interest
	global Sample_ID

	if isempty(reference_texture_component) == 1
		reference_texture_component = [0,0,1];
	end
	
	p = inputParser;
	addRequired(p,'data_in');
	addRequired(p,'map_type');
	addOptional(p,'phase_name',phase_of_interest);
	addOptional(p,'crys_sym',cs)
	addOptional(p,'ref_text_comp',reference_texture_component)
	addOptional(p,'save_fig','none');
	addOptional(p,'sample_ID','none');
	addOptional(p,'extension','none');
	addOptional(p,'resolution','none');
	addOptional(p,'IPF_key', ipfHSVKey(cs.Laue));
	addOptional(p,'figure_width',16); %Width of figure in cm. A4 paper is 21cm wide, so 16cm is good for thesis.

	parse(p,data_in,map_type,varargin{:});	





	disp('')
	disp('Plotting map...')
	disp('')

	figure_width = p.Results.figure_width;
	map_type = p.Results.map_type;
	
	if map_type == 'IPF'
		ipf_key_fig = figure('Name','IPF Key');
		newMtexFigure(ipf_key_fig)
		IPF_key = p.Results.IPF_key
		plot(IPF_key)
  		if strcmp(phase_of_interest,'Monoclinic ZrO$$_2$$')
    		hold on 
    		annotate([Miller(1,0,0,cs),Miller(1,1,0,cs),Miller(0,0,1,cs),Miller(0,1,0,cs),Miller(-1,0,0,cs),Miller(-1,1,0,cs),Miller(1,0,-6,cs)],...
      		'all','labeled','BackgroundColor','white');
   		hold off
  		end
	end

	map_figure = figure('Name','Map loading...');
	newMtexFigure(map_figure)

	if isa(data_in,'EBSD') == 1
		disp("ebsd")



	elseif isa(data_in, 'GRAINS') ==1
		disp("grains")

	else
		disp("'data_in' must be of type 'EBSD' or 'GRAINS' ")
	end

end

































































