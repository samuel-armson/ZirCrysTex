function gr = create_grains(data_in,desired_pfs,varargin)
	%{
	Creates grains in one line instead of several.

	REQUIRED ARGUMENTS
	data_in = EBSD data type provided by mTeX.

	OPTIONAL ARGUMENTS
	phase_name = If only grains of a certain phase are to be calculated. By default all grains are calculated.
	misorientation = Misorientation required to define neighbouring grains. 10 degrees by default.
	smallest_grain = Removes grains below this critical size, as they are considered to be noise. 1 is default
	smoothing = Degree of smoothing applied to grain boudaries. Default is 3.

	%}

	p = inputParser;
	addRequired(p,'data_in');
	addOptional(p,'misorientation', 10)
	addOptional(p,'smallest_grain', 3)
	addOptional(p,'smoothing', 3)
	addOptional(p,'fill_gaps','no')
	addOptional(p,'fill_nonindexed','no')
	addOptional(p,'phase_name','indexed')

	parse(p,data_in,varargin{:});

	disp('')
	disp('Calculating grains...')
	disp('')

	ebsd_full = p.Results.data_in;
	phase_of_interest = p.Results.phase_name;
	Grain_mis_param = p.Results.misorientation * degree;
	Small_grain_param = p.Results.smallest_grain;
	Grain_smooth_param = p.Results.smoothing;

	ebsd_full.unitCell = ebsd_full.unitCell * 0.5
             
	if strcmp(p.Results.fill_gaps,'no') == 1
		[grains_dirty,ebsd_full.grainId] = calcGrains(ebsd_full,'angle',Grain_mis_param,'unitCell','boundary','tight');
	else
		[grains_dirty,ebsd_full(phase_of_interest).grainId] = calcGrains(ebsd_full(phase_of_interest),'angle',Grain_mis_param);
	end
	disp('Removing small grains...')
  	
  	%ebsd_clean = ebsd_full(grains_dirty(grains_dirty.grainSize > Small_grain_param))
  	%ebsd_clean = ebsd_full
  	%ebsd_clean(grains_dirty(grains_dirty.grainSize <= Small_grain_param)) = [];
  	grains_clean = grains_dirty(grains_dirty.grainSize > Small_grain_param)

  	%ebsd_full= fill(ebsd_full(phase_of_interest),grains_dirty);


  	disp('Cleaning grains...')
  	%[grains_clean,ebsd_clean(phase_of_interest).grainId] = calcGrains(ebsd_clean(phase_of_interest),'angle',Grain_mis_param,'unitCell','boundary','tight');
  	%ebsd_phase_smoothed = smooth(ebsd_full(phase_of_interest),grains_dirty,splineFilter,'fill');
  	%grains_clean=grains_dirty

  	disp('Smooting grains...')
	%grains_clean = smooth(grains_clean,Grain_smooth_param);


  	gr = grains_clean
  	disp('')
	disp('Grains calculated.')
	disp('')








































