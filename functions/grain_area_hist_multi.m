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

	global Sample_ID
	
	p = inputParser;
	addRequired(p,'data_in');

	addOptional(p,'bin_size',1);
	addOptional(p,'max_size',500);
	addOptional(p,'max_percentage',50);
	addOptional(p,'units','nm')
  addOptional(p,'legend_labels','none')
  addOptional(p,'plot_type','bar')
  addOptional(p,'freq','normalised')
	addOptional(p,'save_fig','none');
	addOptional(p,'sample_ID','none');
	addOptional(p,'extension','none');
	addOptional(p,'resolution','none');
	addOptional(p,'figure_width',16); %Width of figure in cm. A4 paper is 21cm wide, so 16cm is good for thesis.

	parse(p,data_in,varargin{:});	


	disp('')
	disp('Plotting 1D grain area histogram...')
	disp('')

  grain_size_hist = figure('Name','Loading...');
  figure(grain_size_hist);

  if strcmp(p.Results.units,'nm') == 1
    scaling_factor = 1000000;
  elseif strcmp(p.Results.units,'um') == 1
    scaling_factor = 1;
  end

  cmap = parula(100);
  % Find the middle row, which corresponds to an image value of 0.5
  row_number = round(size(cmap, 1) / 2)
  % Print the color there out to the command window:

  for grainset = 1:length(data_in)
    
    row_number = round(size(cmap, 1)*grainset / length(data_in))
    
    subdata = data_in{1,grainset}
  	grain_areas = subdata.area*scaling_factor;
    aspect_ratios = subdata.aspectRatio;
    largest_grain = max(grain_areas);
    total_area = sum(grain_areas,'double');
    bin_size = p.Results.bin_size;
    max_size = p.Results.max_size;
    max_percentage = p.Results.max_percentage;

    bin_quant = largest_grain/bin_size;
    numberOfBars = bin_quant
    
    x_vals = []
    y_vals = []

    for b = 1 : numberOfBars
      % Plot one single bar as a separate bar series.
      counts(b)=0;
      upper_bound(b) = b*largest_grain/bin_quant;
      lower_bound(b) = upper_bound(b) - largest_grain/bin_quant;
      mid_point(b) = upper_bound(b) - (largest_grain/bin_quant)/2;
      for grain_id = 1 : length(grain_areas)
        if grain_areas(grain_id)>lower_bound(b) & grain_areas(grain_id)<upper_bound(b)
          counts(b) = counts(b) + grain_areas(grain_id);
        end
      end
      if strcmp(p.Results.freq,'raw') == 1
        y_value = counts(b)
      else
        y_value = (counts(b)/total_area)*100
      end
      %counts(b) = sum(grain_areas>lower_bound(b) & grain_areas<upper_bound(b),'double')/total_area;
      if strcmp(p.Results.plot_type, 'bar') == 1
        handleToThisBarSeries(b) = bar(mid_point(b), y_value, 'BarWidth', largest_grain/bin_quant);
      elseif strcmp(p.Results.plot_type, 'hist_line') == 1
        x_vals(end+1) = lower_bound(b)
        y_vals(end+1) = y_value
        x_vals(end+1) = upper_bound(b)
        y_vals(end+1) = y_value

      else
        x_vals(end+1) = mid_point(b)
        y_vals(end+1) = y_value
      end


      hold on;
    end
    
    if strcmp(p.Results.plot_type,'hist_line') == 1
      if strcmp(p.Results.legend_labels,'none') == 1
        plot1 = plot(x_vals,y_vals,'DisplayName',num2str(grainset),'LineWidth',0.5,'Color',cmap(row_number, :))
      else
        plot1 = plot(x_vals,y_vals,'DisplayName',num2str(p.Results.legend_labels(grainset)),'LineWidth',0.5,'Color',cmap(row_number, :))
        plot1.Color(4) = 0.5;
      end
      elseif strcmp(p.Results.plot_type,'line') == 1
        if strcmp(p.Results.legend_labels,'none') == 1
          plot(x_vals,y_vals,'DisplayName',num2str(grainset),'LineWidth',0.5,'Color',cmap(row_number, :))
        else
          plot(x_vals,y_vals,'DisplayName',num2str(p.Results.legend_labels(grainset)),'LineWidth',0.5,'Color',cmap(row_number, :))
          plot1.Color(4) = 0.5;
        end
      elseif strcmp(p.Results.plot_type,'scatter') == 1
        if strcmp(p.Results.legend_labels,'none') == 1
          scatter(x_vals,y_vals,'mkr','-','DisplayName',num2str(grainset),'Color',cmap(row_number, :))
        else
          scatter(x_vals,y_vals,'mkr','-','DisplayName',num2str(p.Results.legend_labels(grainset)),'Color',cmap(row_number, :))
        end
    end	 

	hold off;
	set(grain_size_hist,'Name','1D Grain Area Histogram');
  legend
  if strcmp(p.Results.freq,'raw') == 1
    ylabel(['Number of grains'],'Interpreter','latex');
  else
    ylabel(['$\%$ Total area of phase'],'Interpreter','latex');
  end
	
	set(gca, 'YTickMode', 'Auto');
	set(gca, 'XTickMode', 'Auto');
	%xlim([0 max_size]);
	%ylim([0 max_percentage]);
	set(gcf, 'color','white');
	set(gcf, 'InvertHardcopy', 'off');
	xticks = get(gca,'xtick');
	if strcmp(p.Results.units,'nm') == 1 
		xlabel(['Grain area (nm$^2$)'],'Interpreter','latex');
	elseif strcmp(p.Results.units,'um') == 1
		xlabel(['Grain area (um$^2$)'],'Interpreter','latex');
	end

	newlabels = arrayfun(@(x) sprintf('%.0f', x), xticks, 'un', 0);
	set(gca,'xticklabel',newlabels);
	set(gca,'XMinorTick','on','YMinorTick','on');
	set(gca,'TickDir','out');
	set(findall(gcf,'-property','FontSize'),'FontSize',8)
	set(groot,'defaultAxesTickLabelInterpreter','latex');
	set(groot,'defaulttextinterpreter','latex');
	set(groot,'defaultLegendInterpreter','latex');

  disp('')
	disp('1D grain area histogram plotted.')
	disp('')
  
%gah = plot1
end






















































