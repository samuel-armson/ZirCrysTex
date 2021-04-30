function gdh = shape_prefered_orientation(data_in,varargin)
	%{
	Plots 1D histogram of grain areas. Calculated by counting number of pixels per grain. Does not use ellipse fitting.

	REQUIRED ARGUMENTS
	data_in = GRAINS data type provided by mTeX.

	OPTIONAL ARGUMENTS
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

	global Sample_ID
  global phase_of_interest

	p = inputParser;
	addRequired(p,'data_in');
  addOptional(p,'phase_name',phase_of_interest);
	addOptional(p,'bin_quant',50);
  addOptional(p,'titles','No Title')
	addOptional(p,'save_fig','none');
	addOptional(p,'sample_ID','none');
	addOptional(p,'extension','none');
	addOptional(p,'resolution','none');
	addOptional(p,'figure_width',16); %Width of figure in cm. A4 paper is 21cm wide, so 16cm is good for thesis.

	parse(p,data_in,varargin{:});	


	disp('')
	disp('Plotting SPO rose diagram')
	disp('')

  
	[omega,maj_ax,min_ax] = data_in.fitEllipse;

	Fig_2d_hist_as_res= figure('Name','Loading...');
	figure(Fig_2d_hist_as_res);
  subplot(1,1,1)
  weights = data_in(p.Results.phase_name).area .* (data_in(p.Results.phase_name).aspectRatio-1).*10000000;
  %histogram(omega,'nbins',p.Results.bin_quant, 'weights', w)
  histogram(data_in(p.Results.phase_name).longAxis,p.Results.bin_quant, 'weights', weights)
  title(p.Results.titles)
  


%{
	newxlabels = arrayfun(@(x) sprintf('%.0f', scaling * x), xticks, 'un', 0);
	yticks = get(gca,'ytick');
	newylabels = arrayfun(@(y) sprintf('%.0f', scaling * y), yticks, 'un', 0);
	set(gca,'xticklabel',newxlabels);
	set(gca,'yticklabel',newylabels);
	set(gca,'XMinorTick','on','YMinorTick','on');
	set(gca,'TickDir','out');
	xlabel('Minor axis length (nm)');
	ylabel('Major axis length (nm)');
	set(findall(gcf,'-property','FontSize'),'FontSize',8);
	set(groot,'defaultAxesTickLabelInterpreter','latex');
	set(groot,'defaulttextinterpreter','latex');
	set(groot,'defaultLegendInterpreter','latex');
%}



























































end