function gdh = grain_dimension_hist_fixed(data_in,varargin)
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

	p = inputParser;
	addRequired(p,'data_in');

	addOptional(p,'bin_size',0.01);
	addOptional(p,'max_size',0.6);
	addOptional(p,'max_percentage',20);
	addOptional(p,'units','nm')
	addOptional(p,'save_fig','none');
	addOptional(p,'sample_ID','none');
	addOptional(p,'extension','none');
	addOptional(p,'resolution','none');
	addOptional(p,'figure_width',16); %Width of figure in cm. A4 paper is 21cm wide, so 16cm is good for thesis.

	parse(p,data_in,varargin{:});	


	disp('')
	disp('Plotting 2D grain dimension histogram...')
	disp('')

  if strcmp(p.Results.units,'nm') == 1
    scaling_factor = 1000;
  elseif strcmp(p.Results.units,'um') == 1
  	scaling_factor = 1;
 	end

	ax_bin_size = p.Results.bin_size;
	max_axis_val = p.Results.max_size;
	maj_ax = norm(data_in.caliper('longest'))*scaling_factor;
	min_ax = norm(data_in.caliper('shortest'))*scaling_factor;


  total_area = sum(data_in.area)*scaling_factor*scaling_factor

	max_axis_vals = [max(maj_ax),max(min_ax)]
	%max_axis_val = max(max_axis_vals)
	maj_axis_bins = (0:ax_bin_size:max_axis_val);
	min_axis_bins = (0:ax_bin_size:max_axis_val);
	relative_area = ((maj_axis_bins/2).*(min_axis_bins/2)*pi)/total_area;
	axis_bins = {maj_axis_bins min_axis_bins};

	%values = [maj_ax, min_ax].*relative_area*100

	%hist_2d = hist3(values,'Edges',axis_bins);
	hist_2d = hist3([maj_ax, min_ax],'Edges',axis_bins);
	%hist_2d = histogram2(maj_ax,min_ax,maj_axis_bins,min_axis_bins,'DisplayStyle','tile')

	Fig_2d_hist_as_res= figure('Name','Loading...');
	figure(Fig_2d_hist_as_res);

	

	hist_2d_normalised = (hist_2d.*relative_area)*100;

	pcolor(hist_2d_normalised);
	cb_new = mtexColorbar('TickLength',0);
	cb_new.Label.Interpreter = 'latex';
	set(cb_new,'TickLabelInterpreter', 'latex');
	colorTitleHandle = get(cb_new,'Label');
	set(colorTitleHandle ,'String','$\%$ of phase area', 'fontsize', 8);

	set(gcf,'Color','white');
	set(gcf, 'InvertHardcopy', 'off');
	%set(gca,'linewidth',1);

	colormap(white_viridis('white_percentage',2));
	cbarlimits = [0 p.Results.max_percentage]
	caxis(cbarlimits);
	%xticks = get(gca,'xtick');



	scaling  = ax_bin_size;
	newxlabels = linspace(0,max(max_axis_val),length(min_axis_bins))
	%yticks = get(gca,'ytick');
	newylabels = linspace(0,max(max_axis_val),length(min_axis_bins));
	xticks(1:1:max_axis_val)
	yticks(1:1:max_axis_val)
	set(gca,'xticklabel',newxlabels);
	set(gca,'yticklabel',newylabels);
	set(gca,'TickDir','out');
	xlabel('Minor axis length (um)');
	ylabel('Major axis length (um)');
	set(findall(gcf,'-property','FontSize'),'FontSize',8);
	set(groot,'defaultAxesTickLabelInterpreter','latex');
	set(groot,'defaulttextinterpreter','latex');
	set(groot,'defaultLegendInterpreter','latex');

	%xlim([0 max_axis_val/scaling_factor])
	%ylim([0 max_axis_val/scaling_factor])

























































end