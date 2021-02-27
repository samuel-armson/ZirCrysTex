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
	addOptional(p,'phase_name','indexed');
	addOptional(p,'misorientation', 10)
	addOptional(p,'smallest_grain', 1)
	addOptional(p,'smoothing', 3)

	parse(p,data_in,varargin{:});

	disp('')
	disp('Calculating grains...')
	disp('')

	ebsd_full = p.Results.data_in
	phase_of_interest = p.Results.phase_name
	Grain_mis_param = p.Results.misorientation ./ degree
	Small_grain_param = p.Results.smallest_grain
	Grain_smooth_param = p.Results.smoothing

	%{
  	[grains_dirty,data_in(phase_name).grainId] = calcGrains(data_in(phase_name),'angle',Grain_mis_param,'unitCell')
  	data_in(grains_dirty(grains_dirty.grainSize <= Small_grain_param)) = [];
  	data_in= fill(data_in(phase_name),grains_dirty);
  	[grains_clean,data_in(phase_name).grainId] = calcGrains(data_in(phase_name),'angle',Grain_mis_param,'unitCell');
  	%ebsd_phase_smoothed = smooth(ebsd_full(phase_of_interest),grains_dirty,splineFilter,'fill');
  	grains_clean = smooth(grains_clean,Grain_smooth_param)
	%}

	disp(class(ebsd_full))

	[grains_dirty,ebsd_full(phase_of_interest).grainId] = calcGrains(ebsd_full(phase_of_interest),'angle',Grain_mis_param,'unitCell')
  	ebsd_full(grains_dirty(grains_dirty.grainSize <= Small_grain_param)) = [];
  	ebsd_full= fill(ebsd_full(phase_of_interest),grains_dirty);
  	[grains_clean,ebsd_full(phase_of_interest).grainId] = calcGrains(ebsd_full(phase_of_interest),'angle',Grain_mis_param,'unitCell');
  	%ebsd_phase_smoothed = smooth(ebsd_full(phase_of_interest),grains_dirty,splineFilter,'fill');
  	grains_clean = smooth(grains_clean,Grain_smooth_param)




  	gr = grains_clean
 









































