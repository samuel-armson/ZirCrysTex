function pm = paper_plots(mono_EBSD,full_EBSD,varargin)
	%{


	%}

	global cs
	global reference_texture_component
	global phase_of_interest
	global Sample_ID

	if isempty(reference_texture_component) == 1
		reference_texture_component = [1,0,-3];
	end
	
	p = inputParser;
	addRequired(p,'mono_EBSD');
	addRequired(p,'full_EBSD');
	addOptional(p,'misorientation',15);
	addOptional(p,'smallest_grain',1);
	addOptional(p,'smoothing',0)
	addOptional(p,'ref_text_comp',reference_texture_component)
	addOptional(p,'MAD',0);
	addOptional(p,'BC',0);
	addOptional(p,'fill_gaps','no');
	addOptional(p,'sample_ID','none');
	addOptional(p,'view_unit_cell','yes')
	addOptional(p,'figure_width',16); %Width of figure in cm. A4 paper is 21cm wide, so 16cm is good for thesis.

	parse(p,data_in,map_type,varargin{:});	

	grains_full = create_grains(p.Results.full_EBSD,'misorientation',p.Results.misorientation,'smallest_grain',p.Results.smallest_grain,'smoothing',p.Results.smoothing,'fill_gaps',p.Results.fill_gaps)
	grains_mono = create_grains(p.Results.mono_EBSD,'misorientation',p.Results.misorientation,'smallest_grain',p.Results.smallest_grain,'smoothing',p.Results.smoothing,'fill_gaps',p.Results.fill_gaps,'phase_name','Monoclinic ZrO$$_2$$')

	odf_mono= calcODF(ebsd_mono('Monoclinic ZrO$$_2$$').orientations,'halfwidth', 3*degree)
	odf_met= calcODF(ebsd_full('HCP Zr').orientations,'halfwidth', 3*degree)

	desired_pole_figures_mono = [[1,0,-3,"plane"];[1,0,-6,"plane"];[1,1,-2,"plane"]];
	desired_pole_figures_met = [[0,0,0,2,"plane"]];

	plot_pf(odf_mono,desired_pole_figures_mono,'crys_sym',p.Results.mono_EBSD('Monoclinic ZrO$$_2$$').CS)
	plot_pf(odf_metal,desired_pole_figures_met,'crys_sym',p.Results.full_EBSD('HCP Zr').CS)

	plot_map(grains_mono,'Deviation','phase_name','Monoclinic ZrO$$_2$$','ref_text_comp',[1,0,-3],'crys_sym',p.Results.full_EBSD('Monoclinic ZrO$$_2$$').CS)
	plot_map(grains_full,'Deviation','phase_name','HCP Zr','crys_sym',p.Results.full_EBSD('HCP Zr').CS,'ref_text_comp',[0,0,0,2],'view_unit_cell','CS')

	grain_dimension_hist_ellipse(grains_mono,'bin_size',5,'max_size',500,'units','nm','max_percentage',10)
	orientation_deviation_histogram_osc(p.Results.ebsd_mono,'bin_size',1,'max_y',15)


end

































































