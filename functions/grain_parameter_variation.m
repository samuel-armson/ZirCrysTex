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
    global pname

	p = inputParser;
	addRequired(p,'data_in');

	addOptional(p,'units','nm')
  addOptional(p,'crys_sym', 1)
  addOptional(p,'small_removal_method', 'same_count')


	parse(p,data_in,varargin{:});	

  cs = p.Results.crys_sym


	disp('')
	disp('Exploring effects of different parameters on grain calculations...')
	disp('')
  disp('pname:')
  disp(get_var_name(data_in))

  if strcmp(p.Results.units,'nm') == 1
  	area_scaling_factor = 1000000;
    linear_scaling_factor = 1000;
  elseif strcmp(p.Results.units,'um') == 1
  	area_scaling_factor = 1;
    linear_scaling_factor = 1;
 	end

  if strcmp(p.Results.small_removal_method,'same_count') == 1
    grain_params = readtable('grain_calc_params.csv');
  elseif strcmp(p.Results.small_removal_method,'corr_2_by_2') == 1
    grain_params = readtable('grain_calc_params_2_by_2_corr.csv');
  elseif strcmp(p.Results.small_removal_method,'corr_3_by_3') == 1
    grain_params = readtable('grain_calc_params_3_by_3_corr.csv');
  end
  %grain_params = grain_params(41:42,:)

  row_count = height(grain_params);

  mono_grain_quant=[];
  mono_grain_pixels=[];
  mean_grain_area=[];
  median_grain_area=[];
  max_grain_area=[];
  min_grain_area=[];
  mode_grain_area=[];

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
  mono_phase_frac = [];
  tet_phase_frac = [];
  kearns_factor = [];



  for row = 1 : row_count

    disp(strcat('Processing parameter set ',num2str(row),' of ',num2str(row_count)))
    ebsd_a = data_in
    %ebsd_a =data_in(data_in.mad>=(table2array(grain_params(row,2))/100));
    %ebsd_a =ebsd_a(ebsd_a.bc>=table2array(grain_params(row,3)));
    ebsd_a(ebsd_a.mad<=(table2array(grain_params(row,2))/100)).phaseId = 0
    ebsd_a(ebsd_a.bc<=table2array(grain_params(row,3))).phaseId = 0

    ebsd_shape = size(ebsd_a(ebsd_a.phaseId=='Monoclinic ZrO$$_2$$').id);
    ebsd_point_count = ebsd_shape(1)

    if ebsd_point_count > 1

      all_grains = create_grains(ebsd_a,'misorientation',table2array(grain_params(row,4)),'smallest_grain',table2array(grain_params(row,5)),'smoothing',table2array(grain_params(row,6)),'filter_type',table2cell(grain_params(row,7)),'filter_value',table2array(grain_params(row,8)),'fill_gaps',table2cell(grain_params(row,9)));
      %all_grains = create_grains(ebsd_a,'misorientation',table2array(grain_params(row,4)),'smallest_grain',table2array(grain_params(row,5)),'smoothing',table2array(grain_params(row,6)),'filter_type',table2cell(grain_params(row,7)),'filter_value',table2array(grain_params(row,8)),'fill_gaps','yes');
      the_grains = all_grains('Monoclinic ZrO$$_2$$');
      
      grains_shape = size(the_grains.id);
      grains_count = grains_shape(1)

      if grains_count > 1

          the_odf = make_ODF(the_grains, 'phase_name', 'Monoclinic ZrO$$_2$$');
    
          [omega,maj_ax,min_ax] = the_grains.fitEllipse;
          maj_ax = maj_ax*2*linear_scaling_factor;
          min_ax = min_ax*2*linear_scaling_factor;
    
          mono_grain_quant(end+1)=size(the_grains.id,1);
          mono_grain_pixels(end+1)=sum(the_grains.grainSize);
          mean_grain_area(end+1)=mean(the_grains.area*area_scaling_factor);
          median_grain_area(end+1)=median(the_grains.area*area_scaling_factor);
          max_grain_area(end+1)=max(the_grains.area*area_scaling_factor);
          min_grain_area(end+1)=min(the_grains.area*area_scaling_factor);
          mode_grain_area(end+1)=mode(the_grains.area*area_scaling_factor);
    
          maj_largest_grain(end+1) = max(maj_ax);
          maj_smallest_grain(end+1) = min(maj_ax);
          maj_mean_grain_size(end+1) = mean(maj_ax);
          maj_median_grain_size(end+1) = median(maj_ax);
          maj_mode_grain_size(end+1) = mode(maj_ax);
    
          min_largest_grain(end+1) = max(min_ax);
          min_smallest_grain(end+1) = min(min_ax);
          min_mean_grain_size(end+1) = mean(min_ax);
          min_median_grain_size(end+1) = median(min_ax);
          min_mode_grain_size(end+1) = mode(min_ax);
    
          mono_phase_frac(end+1) = phase_fraction_calc(all_grains);
          tet_phase_frac(end+1) = 100 - phase_fraction_calc(all_grains);
          kearns_factor(end+1) = calcKearnsFactor(the_odf,'h',define_miller([1,0,-3],'crys_sym',cs));

      else
          mono_grain_quant(end+1)=0;
          mono_grain_pixels(end+1)=0;
          mean_grain_area(end+1)=0;
          median_grain_area(end+1)=0;
          max_grain_area(end+1)=0;
          min_grain_area(end+1)=0;
          mode_grain_area(end+1)=0;
    
          maj_largest_grain(end+1) = 0;
          maj_smallest_grain(end+1) = 0;
          maj_mean_grain_size(end+1) = 0;
          maj_median_grain_size(end+1) = 0;
          maj_mode_grain_size(end+1) = 0;
    
          min_largest_grain(end+1) = 0;
          min_smallest_grain(end+1) = 0;
          min_mean_grain_size(end+1) = 0;
          min_median_grain_size(end+1) = 0;
          min_mode_grain_size(end+1) = 0;
    
          mono_phase_frac(end+1) = 0;
          tet_phase_frac(end+1) = 0;
          kearns_factor(end+1) = 0;
      end
    else
    
      mono_grain_quant(end+1)=0;
      mono_grain_pixels(end+1)=0;
      mean_grain_area(end+1)=0;
      median_grain_area(end+1)=0;
      max_grain_area(end+1)=0;
      min_grain_area(end+1)=0;
      mode_grain_area(end+1)=0;

      maj_largest_grain(end+1) = 0;
      maj_smallest_grain(end+1) = 0;
      maj_mean_grain_size(end+1) = 0;
      maj_median_grain_size(end+1) = 0;
      maj_mode_grain_size(end+1) = 0;

      min_largest_grain(end+1) = 0;
      min_smallest_grain(end+1) = 0;
      min_mean_grain_size(end+1) = 0;
      min_median_grain_size(end+1) = 0;
      min_mode_grain_size(end+1) = 0;

      mono_phase_frac(end+1) = 0;
      tet_phase_frac(end+1) = 0;
      kearns_factor(end+1) = 0;

    end
  end
  
  output_table = grain_params;
  output_table.mono_grain_quant = transpose(mono_grain_quant);
  output_table.mono_grain_pixels = transpose(mono_grain_pixels);
  output_table.mean_grain_area = transpose(mean_grain_area);
  output_table.median_grain_area = transpose(median_grain_area);
  output_table.max_grain_area = transpose(max_grain_area);
  output_table.min_grain_area = transpose(min_grain_area);
  output_table.mode_grain_area = transpose(mode_grain_area);

  output_table.maj_largest_grain = transpose(maj_largest_grain);
  output_table.maj_smallest_grain = transpose(maj_smallest_grain);
  output_table.maj_mean_grain_size = transpose(maj_mean_grain_size);
  output_table.maj_median_grain_size = transpose(maj_median_grain_size);
  output_table.maj_mode_grain_size = transpose(maj_mode_grain_size);

  output_table.min_largest_grain = transpose(min_largest_grain);
  output_table.min_smallest_grain = transpose(min_smallest_grain);
  output_table.min_mean_grain_size = transpose(min_mean_grain_size);
  output_table.min_median_grain_size = transpose(min_median_grain_size);
  output_table.min_mode_grain_size = transpose(min_mode_grain_size);

  output_table.mono_phase_frac = transpose(mono_phase_frac);
  output_table.tet_phase_frac = transpose(tet_phase_frac);
  output_table.kearns_factor = transpose(kearns_factor);



  gpv = output_table;






























































end