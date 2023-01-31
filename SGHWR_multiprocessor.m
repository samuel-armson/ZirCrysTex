% Master File for running Zirconia_mTeX 

% Select mTeX installation to use and start mTeX
%addpath 'C:/Users/Rhys/My Documents/MATLAB/mtex-5.1.1';
addpath(genpath('C:/Users/Sam A/Documents/GitHub/Zirconia_mTeX'));
addpath 'functions';
addpath 'third_party_packages';
% Define global variables
global phase_of_interest
global cs
global reference_texture_component
global Sample_ID
global pname
%addpath 'C:/Users/Sam A/My Documents/MATLAB/mtex-5.6.1/mtex-5.6.1';
addpath 'C:/Users/Sam A/My Documents/MATLAB/mtex-5.8.0/mtex-5.8.0';
startup_mtex

% Saving figures takes time. Best to only use on final run: 'on' or 'no'. Apply to all functions here.
save_figures = 'no';

% Sample ID: name given to saved output figures. Choose to ensure that other files aren't overwritten    
Sample_ID = "Slice 207";
% Path to files. eg: 'J:/Nature Paper Figures/'
pname = 'D:/Sam/Dropbox (The University of Manchester)/SGHWR/Python_edited/';

% Phase of interest for orientation analysis - select here for global phase of interest.
phase_of_interest = 'HCP Zr';

% Reference texture component. Used for plotting angular deviation of points from. Used for colouring and histogram (if desired).
reference_texture_component = [0,0,0,2];

% UPDATE THIS ACCORDING TO YOUR CTF FILE.
% crystal symmetry

CS = cs_loader({'metal','beta Zr'})
  
% plotting convention
setMTEXpref('xAxisDirection','east');
setMTEXpref('zAxisDirection','outOfPlane');


file_names = ['BQ_offcut_0.ctf','BQ_offcut_1.ctf','BQ_offcut_2.ctf','BQ_offcut_3.ctf','BQ_offcut_4.ctf','BQ_offcut_5.ctf','BQ_offcut_6.ctf','BQ_offcut_7.ctf']
sample_IDs = ['BQ_1','BQ_2','BQ_3','BQ_4','BQ_5','BQ_6','BQ_7','BQ_8']

for ctf_id = 1 : length(file_names)
	disp('looping')

	% File name with pname prefix, eg: [pname 'SPED_Substrate_MARIA.ctf']
	data_1 = [pname file_names(ctf_id)];

	% load EBSD data
	ebsd_1 = loadEBSD(data_1,CS,'interface','ctf','convertSpatial2EulerReferenceFrame');
	ebsd_1 = ebsd_1.gridify;


	% globally define crystal symmetry of phase of interest
	cs = ebsd_1(phase_of_interest).CS

	% Perform cross-section correction
	ebsd_1 = x_section_correction(ebsd_1,'EBSD')
	%ebsd_1 = dataset_rotation(ebsd_1,[0,0,0],'axis')

	%plot_map(ebsd_1,'IPF','phase_name','HCP Zr','crys_sym',ebsd_1('HCP Zr').CS,'ipf_key',ipfHSVKey(cs.Laue))

	%%
	grains_1 = create_grains(ebsd_1,'misorientation',10,'smallest_grain',1,'smoothing',3,'fill_gaps','yes')

	%%
	odf_data= calcODF(ebsd_1(phase_of_interest).orientations,'halfwidth', 10*degree)

	desired_pole_figures = [[0,0,0,2,"plane"];[1,1,-2,0,"plane"];[1,0,-1,0,"plane"];[1,1,-2,1,"plane"]];

	plot_pf(odf_data,desired_pole_figures,'crys_sym',ebsd_1(phase_of_interest).CS,'sample_ID',sample_IDs(ctf_id))

	plot_map(grains_1,'IPF','phase_name','HCP Zr','crys_sym',ebsd_1('HCP Zr').CS,'ref_text_comp',[0,0,0,2],'plot_key','off','ipf_key',ipfHSVKey(cs.Laue),'sample_ID',sample_IDs(ctf_id))

	%%
	grain_dimension_hist_fixed(grains_1('HCP Zr'),'bin_size',10,'max_size',430,'units','um','max_percentage',2,'sample_ID',sample_IDs(ctf_id))
	%grain_dim_1D_hist(grains_1('HCP Zr'),'axis_min_maj','maj_ax','bin_size',5,'max_size',100,'units','um','max_percentage',25,'normalise_by','area')
	%grain_dim_1D_hist(grains_1('HCP Zr'),'axis_min_maj','min_ax','bin_size',5,'max_size',100,'units','um','max_percentage',25,'normalise_by','area')
	grain_dim_1D_hist(grains_1('HCP Zr'),'axis_min_maj','maj_ax','bin_size',5,'max_size',430,'units','um','max_percentage',65,'normalise_by','area','sample_ID',sample_IDs(ctf_id))
	grain_dim_1D_hist(grains_1('HCP Zr'),'axis_min_maj','min_ax','bin_size',5,'max_size',430,'units','um','max_percentage',65,'normalise_by','area','sample_ID',sample_IDs(ctf_id))

	disp('KEARNS')	
	calcKearnsFactor(odf_data,'N',vector3d(0,0,1),'h',define_miller([0,0,0,2],'crys_sym',cs))
	disp('')
	disp(sample_IDs(ctf_id))
	disp('Complete')

	close all

end

%% Sign off
for n=1:1
    load gong
    sound(y,Fs)
    disp('FIN')
 
    figure;
    set(gca,'visible','off')
    text(0.3,0.4,'fin.', 'FontSize',100);
end































