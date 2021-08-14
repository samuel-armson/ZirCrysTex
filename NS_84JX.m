% Master File for running Zirconia_mTeX 

% Select mTeX installation to use and start mTeX
addpath 'C:/Users/Rhys/My Documents/MATLAB/mtex-5.1.1';
addpath 'C:/Users/Sam/Documents/GitHub/Zirconia_mTeX'
addpath 'functions';
addpath 'third_party_packages';
% Define global variables
global phase_of_interest
global cs
global reference_texture_component
global Sample_ID
global pname
%addpath 'C:/Users/Sam/My Documents/MATLAB/mtex-5.6.1/mtex-5.6.1';
startup_mtex

% Saving figures takes time. Best to only use on final run: 'on' or 'no'. Apply to all functions here.
save_figures = 'no';

% Sample ID: name given to saved output figures. Choose to ensure that other files aren't overwritten    
Sample_ID = "2NVa3";
% Path to files. eg: 'J:/Nature Paper Figures/'
pname = 'D:/Sam/Dropbox (The University of Manchester)/NanoSIMS data for collab/EBSD/84JX/2020_10_14/';

% File name with pname prefix, eg: [pname 'SPED_Substrate_MARIA.ctf']
data_1 = [pname '2020_10_14 84JX below long left Site 1 Map Data 1.ctf'];
data_2 = [pname '2020_10_14 84JX below long left Site 2 Map Data 2.ctf'];


% Phase of interest for orientation analysis - select here for global phase of interest.
phase_of_interest = 'HCP Zr';

% Reference texture component. Used for plotting angular deviation of points from. Used for colouring and histogram (if desired).
reference_texture_component = [0,0,0,1];

% UPDATE THIS ACCORDING TO YOUR CTF FILE.
% crystal symmetry

CS = cs_loader({'metal','tet','mono'})
  
% plotting convention
setMTEXpref('xAxisDirection','east');
setMTEXpref('zAxisDirection','outOfPlane');

% load EBSD data
ebsd_1 = loadEBSD(data_1,CS,'interface','ctf','convertSpatial2EulerReferenceFrame');
ebsd_2 = loadEBSD(data_2,CS,'interface','ctf','convertSpatial2EulerReferenceFrame');


% globally define crystal symmetry of phase of interest
cs = ebsd_1(phase_of_interest).CS

% Perform cross-section correction
ebsd_1 = x_section_correction(ebsd_1,'EBSD','scan_rotation',0)
ebsd_2 = x_section_correction(ebsd_2,'EBSD','scan_rotation',0)



grains_1 = create_grains(ebsd_1,'misorientation',15,'smallest_grain',5,'smoothing',5,'fill_gaps','no')
grains_2 = create_grains(ebsd_2,'misorientation',15,'smallest_grain',5,'smoothing',5,'fill_gaps','no')

grains_1_fill = create_grains(ebsd_1,'misorientation',15,'smallest_grain',5,'smoothing',5,'fill_gaps','yes')
grains_2_fill = create_grains(ebsd_2,'misorientation',15,'smallest_grain',5,'smoothing',5,'fill_gaps','yes')

%odf = make_ODF(ebsd_1(phase_of_interest))
%odf_data= calcODF(ebsd_1(phase_of_interest).orientations,'halfwidth', 3*degree)
%desired_pole_figures = [[0,0,0,2,"plane"];[1,1,-2,0,"plane"]];
%plot_pf(ebsd_1,desired_pole_figures,'crys_sym',ebsd_1(phase_of_interest).CS)
%plot_pf(odf_data,desired_pole_figures,'crys_sym',ebsd_1(phase_of_interest).CS)

%plot_map(ebsd_mono,'BC','gb_overlay',grains_mono,'phase_name','Monoclinic ZrO$$_2$$')
%plot_map(ebsd_mono,'BC','phase_name','Monoclinic ZrO$$_2$$')
%plot_map(grains_mono,'gb_only','phase_name','Monoclinic ZrO$$_2$$')

plot_map(ebsd_1,'IPF','phase_name','HCP Zr','crys_sym',ebsd_1('HCP Zr').CS,'ref_text_comp',[0,0,0,2])
plot_map(ebsd_2,'IPF','phase_name','HCP Zr','crys_sym',ebsd_1('HCP Zr').CS,'ref_text_comp',[0,0,0,2])

plot_map(ebsd_1,'Euler','phase_name','HCP Zr','crys_sym',ebsd_1('HCP Zr').CS,'ref_text_comp',[0,0,0,2])
plot_map(ebsd_2,'Euler','phase_name','HCP Zr','crys_sym',ebsd_1('HCP Zr').CS,'ref_text_comp',[0,0,0,2])

plot_map(ebsd_1,'Deviation','phase_name','HCP Zr','crys_sym',ebsd_1('HCP Zr').CS,'ref_text_comp',[0,0,0,2])
plot_map(ebsd_2,'Deviation','phase_name','HCP Zr','crys_sym',ebsd_1('HCP Zr').CS,'ref_text_comp',[0,0,0,2])

plot_map(grains_1,'Deviation','phase_name','HCP Zr','crys_sym',ebsd_1('HCP Zr').CS,'ref_text_comp',[0,0,0,2],'view_unit_cell','CS')
plot_map(grains_2,'Deviation','phase_name','HCP Zr','crys_sym',ebsd_1('HCP Zr').CS,'ref_text_comp',[0,0,0,2],'view_unit_cell','CS')

plot_map(grains_1_fill,'Deviation','phase_name','HCP Zr','crys_sym',ebsd_1('HCP Zr').CS,'ref_text_comp',[0,0,0,2],'view_unit_cell','CS')
plot_map(grains_2_fill,'Deviation','phase_name','HCP Zr','crys_sym',ebsd_1('HCP Zr').CS,'ref_text_comp',[0,0,0,2],'view_unit_cell','CS')

plot_map(grains_1_fill,'IPF','phase_name','HCP Zr','crys_sym',ebsd_1('HCP Zr').CS,'ref_text_comp',[0,0,0,2],'view_unit_cell','CS')
plot_map(grains_2_fill,'IPF','phase_name','HCP Zr','crys_sym',ebsd_1('HCP Zr').CS,'ref_text_comp',[0,0,0,2],'view_unit_cell','CS')

%combine_figures(f2,f3)

%grain_dimension_hist_ellipse(grains_mono,'bin_size',5,'max_size',250,'units','nm','max_percentage',20)
%orientation_deviation_histogram(ebsd_mono,'phase_name','Monoclinic ZrO$$_2$$')



%% Sign off
for n=1:1
    load gong
    sound(y,Fs)
    disp('FIN')
 
    figure;
    set(gca,'visible','off')
    text(0.3,0.4,'fin.', 'FontSize',100);
end































