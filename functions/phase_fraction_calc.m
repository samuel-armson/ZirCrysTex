function pfc = phase_fraction_calc(data_in,varargin)
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

	parse(p,data_in,varargin{:});	

  mono_px = sum(data_in('Monoclinic ZrO$$_2$$').grainSize);
  tet_px = sum(data_in('Tetragonal ZrO$$_2$$').grainSize);

  mono_frac = mono_px/(mono_px+tet_px)*100;
  tet_frac = tet_px/(mono_px+tet_px)*100;

  pfc = mono_frac;






























































end