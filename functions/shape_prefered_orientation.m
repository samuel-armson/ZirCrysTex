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
  addOptional(p,'units','nm')
  addOptional(p,'colouring','area')
  addOptional(p,'ar_compensation','off')
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


  %w = data_in(p.Results.phase_name).area .* (data_in(p.Results.phase_name).aspectRatio-1);
  w = data_in(p.Results.phase_name).area;
  %g_sizes = ones(length(omega),1)
  g_sizes = data_in.grainSize;
  g_areas = data_in.area;
  aspect_ratios = (maj_ax./min_ax);
  if strcmp(p.Results.units,'nm') == 1
    g_sizes = g_sizes;
    g_areas = data_in.area*1000000;
  end

  omega_weighted = [];
  g_sizes_weighted = [];
  g_areas_weighted = [];
  ar_weighted =[];

  if strcmp(p.Results.ar_compensation, 'off') == 1
    %Standard, not weighted for aspect ratio
    for omega_i = 1:length(omega)
      for gs = 1:g_sizes(omega_i)
        omega_weighted(end+1) = omega(omega_i);
        g_sizes_weighted(end+1) = g_sizes(omega_i);
        g_areas_weighted(end+1) = g_areas(omega_i);
        ar_weighted(end+1) = aspect_ratios(omega_i);
      end
    end

  else
    %Weighted for aspect ratio
    %aspect_ratio = round((aspect_ratio - 1)*10)
    aspect_ratio = round((aspect_ratio - 1))
    for omega_i = 1:length(omega)
      for gs = 1:(g_sizes(omega_i)*aspect_ratio)
        omega_weighted(end+1) = omega(omega_i);
        g_sizes_weighted(end+1) = g_sizes(omega_i);
        g_areas_weighted(end+1) = g_areas(omega_i);
        ar_weighted(end+1) = aspect_ratios(omega_i);
      end
    end

  end

%{
%Built-in mtex version (not as good)
  figure()
  histogram(data_in(p.Results.phase_name).longAxis,p.Results.bin_quant)

  figure()
  histogram(data_in(p.Results.phase_name).longAxis,p.Results.bin_quant,'weights',w)
%}
  
  if strcmp(p.Results.colouring,'area') == 1
    gsizebins = [0,100,400,900,1600,2500,3600,4900,6400];
  elseif strcmp(p.Results.colouring,'aspect_ratio') == 1
    gsizebins = [1,2,3,4,5];
  end


  Options_1 = {'anglenorth', 90, 'angleeast', 0,'ndirections',72,'labelnorth',...
              ' ','labeleast',' ','labelwest',' ','labelsouth','',...
              'titlestring',p.Results.titles,'lablegend','Grain Size','vwinds',gsizebins};
  
  %WindRose(omega./degree,g_sizes,Options_1)

  Options_2 = {'anglenorth', 90, 'angleeast', 0,'ndirections',360,'labelnorth',...
            ' ','labeleast',' ','labelwest',' ','labelsouth','',...
            'titlestring',p.Results.titles,'lablegend','Grain Size','vwinds',gsizebins};

  if strcmp(p.Results.colouring,'area') == 1
    WindRose(omega_weighted./degree,g_areas_weighted,Options_1)
  elseif strcmp(p.Results.colouring,'aspect_ratio') == 1
    WindRose(omega_weighted./degree,ar_weighted,Options_1)
  end


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