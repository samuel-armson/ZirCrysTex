function gah = grain_dim_1D_hist(data_in,varargin)
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
	addOptional(p,'axis_min_maj','maj_ax')
	addOptional(p,'bin_size',1);
	addOptional(p,'max_size',500);
	addOptional(p,'max_percentage',50);
	addOptional(p,'units','nm')
  addOptional(p,'plot_type','bar')
	addOptional(p,'save_fig','none');
	addOptional(p,'sample_ID','none');
	addOptional(p,'extension','none');
	addOptional(p,'resolution','none');
	addOptional(p,'figure_width',16); %Width of figure in cm. A4 paper is 21cm wide, so 16cm is good for thesis.

	parse(p,data_in,varargin{:});	


	disp('')
	disp('Plotting 1D grain area histogram...')
	disp('')


  if strcmp(p.Results.units,'nm') == 1
    scaling_factor = 1000;
  elseif strcmp(p.Results.units,'um') == 1
    scaling_factor = 1;
  end

  if strcmp(p.Results.axis_min_maj,'maj_ax') == 1
  	grain_size = norm(data_in.caliper('longest'))*scaling_factor;
  else
	grain_size = norm(data_in.caliper('shortest'))*scaling_factor;
  end

  aspect_ratios = data_in.aspectRatio;
  largest_grain = max(grain_size);
  mean_grain_size = mean(grain_size);
  std_dev_grain_size = std(grain_size);
  median_grain_size = median(grain_size);
  mode_grain_size = mode(grain_size);
  total_area = sum(grain_size,'double');
  bin_size = p.Results.bin_size;
  max_size = p.Results.max_size;
  max_percentage = p.Results.max_percentage;

  grain_size_hist = figure('Name','Loading...');
  figure(grain_size_hist);

  %bin_quant = largest_grain/bin_size
  bin_quant = max_size/bin_size;
  numberOfBars = bin_quant
  
  x_vals = []
  y_vals = []

  disp(numberOfBars)

  for b = 1 : numberOfBars
    % Plot one single bar as a separate bar series.
    disp(b)

    counts(b)=0;
    upper_bound(b) = b*max_size/bin_quant;
    lower_bound(b) = upper_bound(b) - max_size/bin_quant;
    mid_point(b) = upper_bound(b) - (max_size/bin_quant)/2;
    for grain_id = 1 : length(grain_size)
      if grain_size(grain_id)>lower_bound(b) & grain_size(grain_id)<upper_bound(b)
        counts(b) = counts(b) + grain_size(grain_id);
      end
    end
    %counts(b) = sum(grain_size>lower_bound(b) & grain_size<upper_bound(b),'double')/total_area;
    if strcmp(p.Results.plot_type, 'bar') == 1
      handleToThisBarSeries(b) = bar(mid_point(b), (counts(b)/total_area)*100, 'BarWidth', max_size/bin_quant);
    else
      x_vals(end+1) = mid_point(b)
      y_vals(end+1) = (counts(b)/total_area)*100
    end


    hold on;
  end
  
  if strcmp(p.Results.plot_type,'bar') == 0
    plot(x_vals,y_vals)
  end	 

	hold off;
	set(grain_size_hist,'Name','1D Grain Area Histogram');
  	if strcmp(p.Results.axis_min_maj,'maj_ax') == 1
		xlabel(['Major axis length $[\mu m]$ '],'Interpreter','latex');
	else
		xlabel(['Minor axis length $[\mu m]$ '],'Interpreter','latex');
	end
	ylabel(['$\%$ Total area of phase'],'Interpreter','latex');
	set(gca, 'YTickMode', 'Auto');
	set(gca, 'XTickMode', 'Auto');
	set(gcf, 'color','white');
	set(gcf, 'InvertHardcopy', 'off');
	%xticks = get(gca,'xtick');
	%newlabels = arrayfun(@(x) sprintf('%.0f', x), xticks, 'un', 0);
	%set(gca,'xticklabel',newlabels);
	set(gca,'XMinorTick','on','YMinorTick','on');
	set(gca,'TickDir','out');
	set(findall(gcf,'-property','FontSize'),'FontSize',8)
	set(groot,'defaultAxesTickLabelInterpreter','latex');
	set(groot,'defaulttextinterpreter','latex');
	set(groot,'defaultLegendInterpreter','latex');
	xlim([0 max_size]);
	ylim([0 max_percentage]);

  disp('')
	disp('1D grain dimension histogram plotted.')
	disp('')

  disp('Mean:')
  disp(mean_grain_size)
  disp('STD:')
  disp(std_dev_grain_size)
  disp('Median:')
  disp(median_grain_size)
  disp('Mode:')
  disp(mode_grain_size)

end






















































