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
pname = 'D:/Sam/Dropbox (The University of Manchester)/Sam Armson shared folder/Experimental/SPED/MIBL EX HIGH DR 3/';

% File name with pname prefix, eg: [pname 'SPED_Substrate_MARIA.ctf']
fname_1 = [pname 'MIBL EX HIGH DR 3 R_1.6_EE_0.4_more_phases_index400_or_1.ctf'];
fname_2 = [pname 'MIBL EX HIGH DR 3 R_1.6_EE_0.4_more_phases_index400_or_1_mono.ctf'];
fname_3 = [pname 'MIBL EX HIGH DR 3 R_1.6_EE_0.4_more_phases_index400_or_1_metal.ctf'];

% Phase of interest for orientation analysis - select here for global phase of interest.

phase_of_interest = 'Monoclinic ZrO$$_2$$';


% Reference texture component. Used for plotting angular deviation of points from. Used for colouring and histogram (if desired).
reference_texture_component = [1,0,-3];

% UPDATE THIS ACCORDING TO YOUR CTF FILE.
% crystal symmetry
CS = {... 
  'notIndexed',...
  crystalSymmetry('12/m1', [5.169 5.232 5.341], [90,99,90]*degree, 'X||a*', 'Y||b*', 'Z||c', 'mineral', 'Monoclinic ZrO$$_2$$', 'color', [27 81 45]/255),...
  crystalSymmetry('6/mmm', [5.312 5.312 3.197], 'X||a*', 'Y||b', 'Z||c*', 'mineral', 'Hexagonal ZrO', 'color', [239 202 8]/255),...
  crystalSymmetry('4/mmm', [3.596 3.596 5.184], 'mineral', 'Tetragonal ZrO$$_2$$', 'color', [208 37 48]/255),...
  crystalSymmetry('6/mmm', [3.232 3.232 5.147], 'X||a*', 'Y||b', 'Z||c*', 'mineral', 'HCP Zr', 'color', [75 154 170]/255),...
  crystalSymmetry('4/mmm', [3.52 3.52 4.45], 'mineral', 'Zr Hydride', 'color', [240 135 0]/255),...
  crystalSymmetry('-3m1', [5.038 5.038 13.772], 'X||a*', 'Y||b', 'Z||c*', 'mineral', 'Hematite', 'color',[99 38 74]/255),...
  crystalSymmetry('m-3m', [4.086 4.086 4.086], 'mineral', 'Amorphous Pt', 'color', [100 100 100]/255)};
  
% plotting convention
setMTEXpref('xAxisDirection','east');
setMTEXpref('zAxisDirection','outOfPlane');

% load EBSD data
%ebsd_1 = loadEBSD(fname_1,CS,'interface','ctf','convertSpatial2EulerReferenceFrame');
ebsd_2 = loadEBSD(fname_2,CS,'interface','ctf','convertSpatial2EulerReferenceFrame');
%ebsd_3 = loadEBSD(fname_3,CS,'interface','ctf','convertSpatial2EulerReferenceFrame');
% globally define crystal symmetry of phase of interest
cs = ebsd_2(phase_of_interest).CS

% Perform cross-section correction
%ebsd_1 = x_section_correction(ebsd_1,'SPED','scan_rotation',90)
ebsd_2 = x_section_correction(ebsd_2,'SPED','scan_rotation',90)
%ebsd_3 = x_section_correction(ebsd_3,'SPED','scan_rotation',90)
%ebsd = dataset_rotation(ebsd,[0,0,90],'axis');

%fibre_comp = define_fibre(reference_texture_component,cs)

%grains_1 = create_grains(ebsd_1,'misorientation',10,'smallest_grain',2,'smoothing',1,'fill_gaps','no')
grains_2 = create_grains(ebsd_2,'misorientation',10,'smallest_grain',2,'smoothing',1,'fill_gaps','no','phase_name','Monoclinic ZrO$$_2$$')
%grains_3 = create_grains(ebsd_3,'misorientation',10,'smallest_grain',5,'smoothing',5,'fill_gaps','no','phase_name','HCP Zr')
%odf = make_ODF(ebsd)
%odf_data= calcODF(ebsd(phase_of_interest).orientations,'halfwidth', 3*degree)

%desired_pole_figures = [[1,0,-3,"plane"];[1,0,-4,"plane"];[1,0,-5,"plane"];[1,0,-6,"plane"]];

%plot_pf(ebsd,desired_pole_figures)
%plot_pf(odf_data,desired_pole_figures)

%plot_map(ebsd_1,'BC')
%plot_map(ebsd,'IPF','plot_key','off')
%plot_map(grains_1,'Deviation')
%plot_map(ebsd,'Deviation','plot_key','off')
%plot_map(ebsd_1,'phase')
%plot_map(grains_1,'phase')
plot_map(grains_2,'Deviation','phase_name','Monoclinic ZrO$$_2$$','ref_text_comp',[1,0,-3])
%plot_map(grains_3,'Deviation','phase_name','HCP Zr','crys_sym',ebsd_1('HCP Zr').CS,'ref_text_comp',[0,0,0,2],'view_unit_cell','CS')
%combine_figures(f2,f3)

%grain_area_hist(grains1,'bin_size',1,'max_size',50,'units','nm')
grain_dimension_hist(grains_2,'bin_size',5,'max_size',250,'units','nm','max_percentage',20)

orientation_deviation_histogram(ebsd_2,'phase_name','Monoclinic ZrO$$_2$$')


%% Sign off
for n=1:1
    load gong
    sound(y,Fs)
    disp('FIN')
 
    figure;
    set(gca,'visible','off')
    text(0.3,0.4,'fin.', 'FontSize',100);
end































