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
pname = 'D:/Sam/Dropbox (The University of Manchester)/Sam Armson shared folder/Experimental/SPED/';

% File name with pname prefix, eg: [pname 'SPED_Substrate_MARIA.ctf']
MIBL_3_full = [pname 'MIBL EX HIGH DR 3/MIBL EX HIGH DR 3 R_1.6_EE_0.4_more_phases_index400_or_1.ctf'];
MIBL_3_mono = [pname 'MIBL EX HIGH DR 3/MIBL EX HIGH DR 3 R_1.6_EE_0.4_more_phases_index400_or_1_mono.ctf'];
MIBL_3_met = [pname 'MIBL EX HIGH DR 3/MIBL EX HIGH DR 3 R_1.6_EE_0.4_more_phases_index400_or_1_metal.ctf'];

j_1TDa1_full = [pname '1TDa1/1TDa1_r1.6_ee_0.4_more_phases_Fuzz.ctf']
j_1TDa1_mono = [pname '1TDa1/1TDa1_r1.6_ee_0.4_more_phases_Fuzz_mono.ctf']
j_1TDa1_met = [pname '1TDa1/1TDa1_r1.6_ee_0.4_more_phases_Fuzz_metal.ctf']


% Phase of interest for orientation analysis - select here for global phase of interest.
phase_of_interest = 'Monoclinic ZrO$$_2$$';

% Reference texture component. Used for plotting angular deviation of points from. Used for colouring and histogram (if desired).
reference_texture_component = [1,0,-3];

% UPDATE THIS ACCORDING TO YOUR CTF FILE.
% crystal symmetry
CS_MIBL_3 = {... 
  'notIndexed',...
  crystalSymmetry('12/m1', [5.169 5.232 5.341], [90,99,90]*degree, 'X||a*', 'Y||b*', 'Z||c', 'mineral', 'Monoclinic ZrO$$_2$$', 'color', [27 81 45]/255),...
  crystalSymmetry('6/mmm', [5.312 5.312 3.197], 'X||a*', 'Y||b', 'Z||c*', 'mineral', 'Hexagonal ZrO', 'color', [239 202 8]/255),...
  crystalSymmetry('4/mmm', [3.596 3.596 5.184], 'mineral', 'Tetragonal ZrO$$_2$$', 'color', [208 37 48]/255),...
  crystalSymmetry('6/mmm', [3.232 3.232 5.147], 'X||a*', 'Y||b', 'Z||c*', 'mineral', 'HCP Zr', 'color', [75 154 170]/255),...
  crystalSymmetry('4/mmm', [3.52 3.52 4.45], 'mineral', 'Zr Hydride', 'color', [240 135 0]/255),...
  crystalSymmetry('-3m1', [5.038 5.038 13.772], 'X||a*', 'Y||b', 'Z||c*', 'mineral', 'Hematite', 'color',[99 38 74]/255),...
  crystalSymmetry('m-3m', [4.086 4.086 4.086], 'mineral', 'Amorphous Pt', 'color', [100 100 100]/255)};

CS_j_1TDa1 = {... 
  'notIndexed',...
  crystalSymmetry('6/mmm', [3.232 3.232 5.147], 'X||a*', 'Y||b', 'Z||c*', 'mineral', 'HCP Zr', 'color', [75 154 170]/255),...
  crystalSymmetry('12/m1', [5.169 5.232 5.341], [90,99,90]*degree, 'X||a*', 'Y||b*', 'Z||c', 'mineral', 'Monoclinic ZrO$$_2$$', 'color', [27 81 45]/255),...
  crystalSymmetry('6/mmm', [5.028 5.028 8.248], 'X||a*', 'Y||b', 'Z||c*', 'mineral', 'Zr Fe Cr SPP', 'color', 'light red'),...
  crystalSymmetry('4/mmm', [3.596 3.596 5.184], 'mineral', 'Tetragonal ZrO$$_2$$', 'color', [208 37 48]/255),...
  crystalSymmetry('6/mmm', [5.312 5.312 3.197], 'X||a*', 'Y||b', 'Z||c*', 'mineral', 'Hexagonal ZrO', 'color', [239 202 8]/255)};
  
% plotting convention
setMTEXpref('xAxisDirection','east');
setMTEXpref('zAxisDirection','outOfPlane');

% load EBSD data
ebsd_MIBL_3_full = loadEBSD(MIBL_3_full,CS_MIBL_3,'interface','ctf','convertSpatial2EulerReferenceFrame');
ebsd_MIBL_3_mono = loadEBSD(MIBL_3_mono,CS_MIBL_3,'interface','ctf','convertSpatial2EulerReferenceFrame');
ebsd_MIBL_3_met = loadEBSD(MIBL_3_met,CS_MIBL_3,'interface','ctf','convertSpatial2EulerReferenceFrame');


ebsd_j_1TDa1_full = loadEBSD(j_1TDa1_full,CS_j_1TDa1,'interface','ctf','convertSpatial2EulerReferenceFrame');
ebsd_j_1TDa1_mono = loadEBSD(j_1TDa1_mono,CS_j_1TDa1,'interface','ctf','convertSpatial2EulerReferenceFrame');
ebsd_j_1TDa1_met = loadEBSD(j_1TDa1_met,CS_j_1TDa1,'interface','ctf','convertSpatial2EulerReferenceFrame');
% globally define crystal symmetry of phase of interest
cs = ebsd_MIBL_3_full(phase_of_interest).CS

% Perform cross-section correction
ebsd_MIBL_3_full = x_section_correction(ebsd_MIBL_3_full,'SPED','scan_rotation',90)
ebsd_MIBL_3_mono = x_section_correction(ebsd_MIBL_3_mono,'SPED','scan_rotation',90)
ebsd_MIBL_3_met = x_section_correction(ebsd_MIBL_3_met,'SPED','scan_rotation',90)

ebsd_j_1TDa1_full = x_section_correction(ebsd_j_1TDa1_full,'SPED','scan_rotation',90)
ebsd_j_1TDa1_mono = x_section_correction(ebsd_j_1TDa1_mono,'SPED','scan_rotation',90)
ebsd_j_1TDa1_met = x_section_correction(ebsd_j_1TDa1_met,'SPED','scan_rotation',90)


grains_MIBL_3_full = create_grains(ebsd_MIBL_3_full,'misorientation',10,'smallest_grain',2,'smoothing',1,'fill_gaps','no')
grains_MIBL_3_mono = create_grains(ebsd_MIBL_3_mono,'misorientation',10,'smallest_grain',2,'smoothing',1,'fill_gaps','no','phase_name','Monoclinic ZrO$$_2$$')
grains_MIBL_3_met = create_grains(ebsd_MIBL_3_met,'misorientation',10,'smallest_grain',5,'smoothing',5,'fill_gaps','no','phase_name','HCP Zr')

grains_j_1TDa1_full = create_grains(ebsd_j_1TDa1_full,'misorientation',10,'smallest_grain',2,'smoothing',1,'fill_gaps','no')
grains_j_1TDa1_mono = create_grains(ebsd_j_1TDa1_mono,'misorientation',10,'smallest_grain',2,'smoothing',1,'fill_gaps','no','phase_name','Monoclinic ZrO$$_2$$')
grains_j_1TDa1_met = create_grains(ebsd_j_1TDa1_met,'misorientation',10,'smallest_grain',5,'smoothing',5,'fill_gaps','no','phase_name','HCP Zr')

%odf = make_ODF(ebsd)
%odf_data= calcODF(ebsd(phase_of_interest).orientations,'halfwidth', 3*degree)
%desired_pole_figures = [[1,0,-3,"plane"];[1,0,-4,"plane"];[1,0,-5,"plane"];[1,0,-6,"plane"]];
%plot_pf(ebsd,desired_pole_figures)
%plot_pf(odf_data,desired_pole_figures)


plot_map(ebsd_MIBL_3_full,'phase')
plot_map(grains_MIBL_3_full,'phase')
plot_map(grains_MIBL_3_mono,'Deviation','phase_name','Monoclinic ZrO$$_2$$','ref_text_comp',[1,0,-3])
plot_map(grains_MIBL_3_met,'Deviation','phase_name','HCP Zr','crys_sym',ebsd_MIBL_3_full('HCP Zr').CS,'ref_text_comp',[0,0,0,2],'view_unit_cell','CS')
%combine_figures(f2,f3)
plot_map(ebsd_j_1TDa1_full,'phase')
plot_map(grains_j_1TDa1_full,'phase')
plot_map(grains_j_1TDa1_mono,'Deviation','phase_name','Monoclinic ZrO$$_2$$','ref_text_comp',[1,0,-3])
plot_map(grains_j_1TDa1_met,'Deviation','phase_name','HCP Zr','crys_sym',ebsd_MIBL_3_full('HCP Zr').CS,'ref_text_comp',[0,0,0,2],'view_unit_cell','CS')

grain_dimension_hist_ellipse(grains_MIBL_3_mono,'bin_size',5,'max_size',250,'units','nm','max_percentage',20)
orientation_deviation_histogram(ebsd_MIBL_3_mono,'phase_name','Monoclinic ZrO$$_2$$')

grain_dimension_hist_ellipse(grains_j_1TDa1_mono,'bin_size',5,'max_size',250,'units','nm','max_percentage',20)
orientation_deviation_histogram(ebsd_j_1TDa1_mono,'phase_name','Monoclinic ZrO$$_2$$')


%% Sign off
for n=1:1
    load gong
    sound(y,Fs)
    disp('FIN')
 
    figure;
    set(gca,'visible','off')
    text(0.3,0.4,'fin.', 'FontSize',100);
end































