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

  for row = 1 : row_count

    disp('Processing parameter set' + num2str(row) + ' of ' + num2str(row_count))
    ebsd_a =data_in(data_in.mad>=(table2array(grain_params(row,2))/100));
    ebsd_a =data_in(ebsd_a.bc>=table2array(grain_params(row,3)));

  end
  %grains_a = create_grains(ebsd_a,'misorientation',table2array(grain_params(row,4)),'smallest_grain',table2array(grain_params(row,5)),'smoothing',table2array(grain_params(row,6)),'filter_type',table2cell(grain_params(row,7)),'filter_value',table2array(grain_params(row,8)),'fill_gaps',table2cell(grain_params(row,9)))


  

  gpv = 1






























































end