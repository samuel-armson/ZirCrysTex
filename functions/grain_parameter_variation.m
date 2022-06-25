function gpv = grain_parameter_variation(data_in,varargin)
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

	addOptional(p,'units','nm')

	parse(p,data_in,varargin{:});	


	disp('')
	disp('Exploring effects of different parameters on grain calculations...')
	disp('')

  if strcmp(p.Results.units,'nm') == 1
  	area_scaling_factor = 1000000;
    linear_scaling_factor = 1000;
  elseif strcmp(p.Results.units,'um') == 1
  	area_scaling_factor = 1;
    linear_scaling_factor = 1;
 	end

  grain_params = readtable('grain_calc_params.csv');

  row_count = height(grain_params);
  row_count = 3

  mono_grain_quant=[];
  mono_grain_pixels=[];
  mean_mono_grain_area=[];
  median_mono_grain_area=[];
  max_mono_grain_area=[];
  min_mono_grain_area=[];
  mode_mono_grain_area=[];

  maj_largest_grain = [];
  maj_smallest_grain = [];
  maj_mean_grain_size = [];
  maj_median_grain_size = [];
  maj_mode_grain_size = [];

  min_largest_grain = [];
  min_smallest_grain = [];
  min_mean_grain_size = [];
  min_median_grain_size = [];
  min_mode_grain_size = [];



  for row = 1 : row_count

    disp(strcat('Processing parameter set ',num2str(row),' of ',num2str(row_count)))

    ebsd_a =data_in(data_in.mad>=(table2array(grain_params(row,2))/100));
    ebsd_a =ebsd_a(ebsd_a.bc>=table2array(grain_params(row,3)));

    the_grains = create_grains(ebsd_a,'misorientation',table2array(grain_params(row,4)),'smallest_grain',table2array(grain_params(row,5)),'smoothing',table2array(grain_params(row,6)),'filter_type',table2cell(grain_params(row,7)),'filter_value',table2array(grain_params(row,8)),'fill_gaps',table2cell(grain_params(row,9)));

    [omega,maj_ax,min_ax] = the_grains.fitEllipse;
    maj_ax = maj_ax*2*linear_scaling_factor;
    min_ax = min_ax*2*linear_scaling_factor;

    mono_grain_quant(end+1)=size(the_grains.id,1);
    mono_grain_pixels(end+1)=sum(the_grains.grainSize);
    mean_mono_grain_area(end+1)=mean(the_grains.area*area_scaling_factor);
    median_mono_grain_area(end+1)=median(the_grains.area*area_scaling_factor);
    max_mono_grain_area(end+1)=max(the_grains.area*area_scaling_factor);
    min_mono_grain_area(end+1)=min(the_grains.area*area_scaling_factor);
    mode_mono_grain_area(end+1)=mode(the_grains.area*area_scaling_factor);

    maj_largest_grain(end+1) = max(maj_ax);
    maj_smallest_grain(end+1) = min(maj_ax);
    maj_mean_grain_size(end+1) = mean(maj_ax);
    maj_median_grain_size(end+1) = median(maj_ax)
    maj_mode_grain_size(end+1) = mode(maj_ax);

    min_largest_grain(end+1) = max(min_ax);
    min_smallest_grain(end+1) = min(min_ax);
    min_mean_grain_size(end+1) = mean(min_ax);
    min_median_grain_size(end+1) = median(min_ax);
    min_mode_grain_size(end+1) = mode(min_ax);

  end
  
  disp(mono_grain_quant)

  

  gpv = 1






























































end