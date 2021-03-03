function gah = grain_area_hist(data_in,varargin)
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

	global cs
	global reference_texture_component
	global phase_of_interest
	global Sample_ID

	if isempty(reference_texture_component) == 1
		reference_texture_component = [0,0,1];
	end
	
	p = inputParser;
	addRequired(p,'data_in');

	addOptional(p,'phase_name',phase_of_interest);
	addOptional(p,'bin_size',0.0001);
	addOptional(p,'max_size',0.01);
	addOptional(p,'max_percentage',50);
	addOptional(p,'save_fig','none');
	addOptional(p,'sample_ID','none');
	addOptional(p,'extension','none');
	addOptional(p,'resolution','none');
	addOptional(p,'figure_width',16); %Width of figure in cm. A4 paper is 21cm wide, so 16cm is good for thesis.

	parse(p,data_in,varargin{:});	


	disp('')
	disp('Plotting 1D grain area histogram...')
	disp('')


	grain_areas = data_in.area;
  	aspect_ratios = data_in.aspectRatio;
  	largest_grain = max(grain_areas);
  	total_area = sum(grain_areas,'double');
  	bin_size = p.Results.bin_size;
  	max_size = p.Results.max_size;
  	max_percentage = p.Results.max_percentage;

  	grain_size_hist = figure('Name','Loading...');
  	figure(grain_size_hist);

  	bin_quant = largest_grain/bin_size;
  	numberOfBars = bin_quant;
   
  for b = 1 : numberOfBars
      % Plot one single bar as a separate bar series.
      counts(b)=0
      upper_bound(b) = b*largest_grain/bin_quant;
      lower_bound(b) = upper_bound(b) - largest_grain/bin_quant;
      mid_point(b) = upper_bound(b) - (largest_grain/bin_quant)/2;
      for grain_id = 1 : length(grain_areas)
        if grain_areas(grain_id)>lower_bound(b) & grain_areas(grain_id)<upper_bound(b)
          counts(b) = counts(b) + grain_areas(grain_id);
        end
 
      end
      %counts(b) = sum(grain_areas>lower_bound(b) & grain_areas<upper_bound(b),'double')/total_area;
      handleToThisBarSeries(b) = bar(mid_point(b), (counts(b)/total_area)*100, 'BarWidth', largest_grain/bin_quant);
      % Apply the color to this bar series.
      hold on;
  end
   
  hold off;
  set(grain_size_hist,'Name','1D Grain Area Histogram');
   
  xlabel(['Grain area (nm$^2$)'],'Interpreter','latex');
  ylabel(['$\%$ Total area of phase']);
  set(gca, 'YTickMode', 'Auto');
  set(gca, 'XTickMode', 'Auto');
  xlim([0 max_size]);
  ylim([0 max_percentage]);
  set(gcf, 'color','white');
  set(gcf, 'InvertHardcopy', 'off');
  xticks = get(gca,'xtick');
  scaling  = 1000000;
  newlabels = arrayfun(@(x) sprintf('%.0f', scaling * x), xticks, 'un', 0);
  set(gca,'xticklabel',newlabels);
  set(gca,'XMinorTick','on','YMinorTick','on');
  set(gca,'TickDir','out');
  























































