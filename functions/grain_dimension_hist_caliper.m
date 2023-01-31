function gdh = grain_dimension_hist_caliper(data_in,varargin)
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

	%[omega,maj_ax,min_ax] = data_in.fitEllipse;
    maj_ax = norm(caliper(data_in,'longest'))
    min_ax = norm(caliper(data_in,'shortest'))
  	ax_bin_size = p.Results.bin_size;
  	max_axis_val = p.Results.max_size;
  	maj_ax = maj_ax*scaling_factor;
  	min_ax = min_ax*scaling_factor;

  
  	for ax_val = 1 : length(maj_ax)
      	ellipse_areas(ax_val) = (maj_ax(ax_val)/2)*(min_ax(ax_val)/2)*pi;
  	end
  
  	max_axis_vals = [max(maj_ax),max(min_ax)];
  	%max_axis_val = max(max_axis_vals);
  	%maj_axis_bins = ((ax_bin_size/2):ax_bin_size:(max_axis_val-ax_bin_size/2));
  	%min_axis_bins = ((ax_bin_size/2):ax_bin_size:(max_axis_val-ax_bin_size/2));
    maj_axis_bins = (0:ax_bin_size:(max_axis_val));
    min_axis_bins = maj_axis_bins;
  	%min_axis_bins = ((ax_bin_size):ax_bin_size:(max_axis_val-ax_bin_size));
  	relative_area = ((maj_axis_bins/2).*(min_axis_bins/2)*pi)/sum(ellipse_areas);
  	axis_bins = {maj_axis_bins min_axis_bins};
 
  	hist_2d = hist3([maj_ax, min_ax],'Edges',axis_bins);
  
  	Fig_2d_hist_as_res= figure('Name','Loading...');
  	figure(Fig_2d_hist_as_res);

  	%xlim([0 max_axis_val/ax_bin_size])
  	%ylim([0 max_axis_val/ax_bin_size])
    %axis([0 max_axis_val 0 max_axis_val])
 
  	hist_2d_normalised = (hist_2d.*relative_area)*100;
    %hist_2d_normalised = hist_2d
    
    hist_size = size(hist_2d_normalised,1)
    zero_mat = zeros(max_axis_val/ax_bin_size);
    zero_mat(2:hist_size+1,2:hist_size+1)=hist_2d_normalised;

  	%pcolor(zero_mat);
    pcolor(hist_2d_normalised)
  	cb_new = mtexColorbar('TickLength',0);
  	cb_new.Label.Interpreter = 'latex';
  	set(cb_new,'TickLabelInterpreter', 'latex');
  	colorTitleHandle = get(cb_new,'Label');
  	set(colorTitleHandle ,'String','$\%$ of phase area', 'fontsize', 8);
 
  	set(gcf,'Color','white');
  	set(gcf, 'InvertHardcopy', 'off');
  	set(gca,'linewidth',0.1);
 
  	colormap(white_viridis('white_percentage',2));
  	cbarlimits = [0 p.Results.max_percentage];
  	caxis(cbarlimits);

  	scaling  = ax_bin_size;
    if scaling == 5
        original_spacing = 25;
    elseif scaling == 10
        original_spacing = 6.25;
    end
    original_x_labels = linspace(original_spacing,max_axis_val,max_axis_val/original_spacing);
    newxlabels = scaling.*original_x_labels;
    %newxlabels = {100,200,300,400,500,600,700,800,900,1000};
    newxlabels = {200,400,600,800,1000,1200};
    newylabels = newxlabels;
    
  	
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

  maj_largest_grain = max(maj_ax);
  maj_mean_grain_size = mean(maj_ax);
  maj_std_dev_grain_size = std(maj_ax);
  maj_median_grain_size = median(maj_ax);
  maj_mode_grain_size = mode(maj_ax);

  min_largest_grain = max(min_ax);
  min_mean_grain_size = mean(min_ax);
  min_std_dev_grain_size = std(min_ax);
  min_median_grain_size = median(min_ax);
  min_mode_grain_size = mode(min_ax);
%{
  disp('Major Axis Max :')
  disp(maj_largest_grain)
  disp('Major Axis Mean :')
  disp(maj_mean_grain_size)
  disp('Major Axis STD:')
  disp(maj_std_dev_grain_size)
  disp('Major Axis Median:')
  disp(maj_median_grain_size)
  disp('Major Axis Mode:')
  disp(maj_mode_grain_size)
  disp('')
  disp('Minor Axis Max :')
  disp(min_largest_grain)
  disp('Minor Axis Mean :')
  disp(min_mean_grain_size)
  disp('Minor Axis STD:')
  disp(min_std_dev_grain_size)
  disp('Minor Axis Median:')
  disp(min_median_grain_size)
  disp('Minor Axis Mode:')
  disp(min_mode_grain_size)
%}

























































end