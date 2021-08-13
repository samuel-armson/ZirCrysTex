% Master File for running Zirconia_mTeX 

% Select mTeX installation to use and start mTeX
addpath 'C:/Users/Rhys/My Documents/MATLAB/mtex-5.1.1';
addpath 'functions';
addpath 'third_party_packages';
% Define global variables
global phase_of_interest
global cs
global reference_texture_component
global Sample_ID
global pname
%addpath 'C:/Users/Sam/My Documents/MATLAB/mtex-5.2.8';
startup_mtex

% Saving figures takes time. Best to only use on final run: 'on' or 'no'. Apply to all functions here.
save_figures = 'no';

% Sample ID: name given to saved output figures. Choose to ensure that other files aren't overwritten    
Sample_ID = "2NVa3";
% Path to files. eg: 'J:/Nature Paper Figures/'
pname = 'D:/Sam/Dropbox (The University of Manchester)/Sam Armson shared folder/Experimental/SPED/2NVa3/No_LM';

% File name with pname prefix, eg: [pname 'SPED_Substrate_MARIA.ctf']
data_full = [pname '2NV_no_LM_decent_region_full.ctf'];
%data_mono = [pname '2NVa3_r1.2_ee_0.4_more_phases_fuzz_amb_res_no_hydride_or_SPP_mono.ctf'];
%data_met = [pname '2NVa3_r1.2_ee_0.4_more_phases_fuzz_amb_res_no_hydride_or_SPP_metal.ctf'];

% Phase of interest for orientation analysis - select here for global phase of interest.
phase_of_interest = 'Monoclinic ZrO$$_2$$';

% Reference texture component. Used for plotting angular deviation of points from. Used for colouring and histogram (if desired).
reference_texture_component = [1,0,-3];

% UPDATE THIS ACCORDING TO YOUR CTF FILE.
% crystal symmetry

CS = cs_loader({'mono','metal','suboxide','tet','SPP','Pt'})
  
% plotting convention
setMTEXpref('xAxisDirection','east');
setMTEXpref('zAxisDirection','outOfPlane');

% load EBSD data
ebsd_full = loadEBSD(data_full,CS,'interface','ctf','convertSpatial2EulerReferenceFrame');


% globally define crystal symmetry of phase of interest
cs = ebsd_full(phase_of_interest).CS

% Perform cross-section correction
ebsd_full = x_section_correction(ebsd_full,'SPED','scan_rotation',90)
ebsd_mono = ebsd_full
ebsd_met = ebsd_full

grains_full = create_grains(ebsd_full,'misorientation',15,'smallest_grain',1,'smoothing',1,'fill_gaps','no')
grains_mono = create_grains(ebsd_mono,'misorientation',15,'smallest_grain',1,'smoothing',1,'fill_gaps','no','phase_name','Monoclinic ZrO$$_2$$')
grains_met = create_grains(ebsd_met,'misorientation',15,'smallest_grain',5,'smoothing',5,'fill_gaps','no','phase_name','HCP Zr')


odf = make_ODF(ebsd_mono('Monoclinic ZrO$$_2$$'))
odf_data= calcODF(ebsd_mono('Monoclinic ZrO$$_2$$').orientations,'halfwidth', 3*degree)
desired_pole_figures = [[1,0,-3,"plane"];[1,0,-4,"plane"];[1,0,-5,"plane"];[1,0,-6,"plane"]];
%plot_pf(ebsd_mono,desired_pole_figures,'crys_sym',ebsd_mono('Monoclinic ZrO$$_2$$').CS)
plot_pf(odf_data,desired_pole_figures,'crys_sym',ebsd_mono('Monoclinic ZrO$$_2$$').CS)

%%


%plot_map(ebsd_mono,'BC','gb_overlay',grains_mono,'phase_name','Monoclinic ZrO$$_2$$')
%plot_map(ebsd_mono,'BC','phase_name','Monoclinic ZrO$$_2$$')
%plot_map(grains_mono,'gb_only','phase_name','Monoclinic ZrO$$_2$$')

plot_map(grains_full,'phase')
plot_map(grains_mono,'Deviation','phase_name','Monoclinic ZrO$$_2$$','ref_text_comp',[1,0,-3])
plot_map(grains_met,'Deviation','phase_name','HCP Zr','crys_sym',ebsd_full('HCP Zr').CS,'ref_text_comp',[0,0,0,2],'view_unit_cell','CS')

%plot_substrate_mono(grains_met,grains_mono)

%combine_figures(f2,f3)

grain_dimension_hist_ellipse(grains_mono,'bin_size',5,'max_size',250,'units','nm','max_percentage',20)
orientation_deviation_histogram(ebsd_mono,'phase_name','Monoclinic ZrO$$_2$$')


%% Sign off
for n=1:1
    load gong
    sound(y,Fs)
    disp('FIN')
 
    figure;
    set(gca,'visible','off')
    text(0.3,0.4,'fin.', 'FontSize',100);
end































