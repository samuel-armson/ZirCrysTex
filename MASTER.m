% Master File for running Zirconia_mTeX 

% Select mTeX installation to use and start mTeX
addpath 'C:/Users/Rhys/My Documents/MATLAB/mtex-5.1.1';
addpath 'functions';
addpath 'third_party_packages';
%addpath 'C:/Users/Sam/My Documents/MATLAB/mtex-5.2.8';
startup_mtex

% Saving figures takes time. Best to only use on final run: 'on' or 'no'. Apply to all functions here.
save_figures = 'no';

% Sample ID: name given to saved output figures. Choose to ensure that other files aren't overwritten    
Sample_ID = "MIBL EX HIGH DR 0.8 EE FUZZY MASK TESTING FILTERS";
% Path to files. eg: 'J:/Nature Paper Figures/'
pname = 'J:/MIBL SAMPLES/EX HIGH DR/';
% Full area file name, eg: [pname 'SPED_Substrate_MARIA.ctf']
fname_full = [pname 'EX HIGH DR 2 EE_0.8 FUZZY MASK.ctf'];

% Phase of interest for orientation analysis - select here for global phase of interest.
phase_of_interest = 'Monoclinic ZrO$$_2$$';

% Reference texture component. Used for plotting angular deviation of points from. Used for colouring and histogram (if desired).
reference_texture_component = [1,0,-3];

% UPDATE THIS ACCORDING TO YOUR CTF FILE.
% crystal symmetry
CS = {...
	'notIndexed',...
	crystalSymmetry('m-3m', [4.086 4.086 4.086], 'mineral', 'Amorphous', 'color', 'cyan'),...
	crystalSymmetry('12/m1', [5.169 5.232 5.341], [90,99,90]*degree, 'X||a*', 'Y||b*', 'Z||c', 'mineral', 'Monoclinic ZrO$$_2$$', 'color', [34, 111, 84]/255),...
	crystalSymmetry('4/mmm', [3.596 3.596 5.184], 'mineral', 'Tetragonal ZrO$$_2$$', 'color', [160, 35, 41]/255),...
	crystalSymmetry('6/mmm', [3.232 3.232 5.147], 'X||a*', 'Y||b', 'Z||c*', 'mineral', 'HCP Zr', 'color', [2, 123, 206]/255),...
	crystalSymmetry('6/mmm', [5.312 5.312 3.197], 'X||a*', 'Y||b', 'Z||c*', 'mineral', 'H-Suboxide', 'color', [227, 181, 5]/255)};
  
% plotting convention
setMTEXpref('xAxisDirection','east');
setMTEXpref('zAxisDirection','outOfPlane');

% load EBSD data
ebsd = loadEBSD(fname_full,CS,'interface','ctf','convertSpatial2EulerReferenceFrame');

% Perform cross-section correction
ebsd = x_section_correction(ebsd,'SPED','scan_rotation',92)

disp(figure_name(Sample_ID,'file_path',pname,'reference_texture_component',reference_texture_component,...
    'suffix','IPF','extension','png'))

plot(ebsd)