function pm = combine_figures(fig_1,fig_2,varargin)
	%{
	Plots raw EBSD data or pre-calculated grain data. 

	REQUIRED ARGUMENTS
	data_in = EBSD or GRAINS data type provided by mTeX.
	map_type = Either: 'IPF','Euler','Deviation', 'Phase', 'BC'

	OPTIONAL ARGUMENTS
	IPF_key = 
	plot_key = 'off' or 'on'. On is defualt.
	ref_texture_comp = Eg. [0,0,0,2] or [0,0,1]. 
	view_unit_cell = 'CS' for cross-section corrected data, 'PV' or 'yes' for plan-view data. Default is 'no'.
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
	addRequired(p,'fig_1');
	addRequired(p,'fig_2');
	addOptional(p,'plot_key','on');
	addOptional(p,'crys_sym',cs)
	addOptional(p,'ref_text_comp',reference_texture_component)
	addOptional(p,'save_fig','none');
	addOptional(p,'sample_ID','none');
	addOptional(p,'extension','none');
	addOptional(p,'resolution','none');
	addOptional(p,'view_unit_cell','no')
	addOptional(p,'IPF_key', ipfHSVKey(cs.Laue));
	addOptional(p,'figure_width',16); %Width of figure in cm. A4 paper is 21cm wide, so 16cm is good for thesis.

	parse(p,fig_1,fig_2,varargin{:});	

	f1 = p.Results.fig_1;
	old_ax = gca;
	hold on;

	f2 = p.Results.fig_2;
	new_ax = gca;
	copyobj(get(old_ax, 'children'), new_ax);

	fig1Position = get(f1, 'Position');
	set(f2, 'Position', fig1Position');

	% Copy most of the properties
	oldProperties = get(old_ax);
	figureFieldNames = fieldnames(oldProperties)
	for k = 1:length(figureFieldNames)
	  thisProperty = figureFieldNames{k};
	  if ~isempty(strfind(thisProperty, 'Fcn'))
	    continue;
	  end
	  if strcmpi(thisProperty, 'Tag') || strcmpi(thisProperty, 'Parent') || strcmpi(thisProperty, 'Children')
	    continue; % Skip the tag, parent, and children properties
	  end
	  fprintf('About to try to set %s\n', thisProperty);
	  try
	    new_ax.(thisProperty) = old_ax.(thisProperty);
	  catch
	    % Some properties are readonly so this will skip them
	  end
	end
	% Copy over the colormap too
	%colormap(new_ax, oldColorMap);

	
	









































end