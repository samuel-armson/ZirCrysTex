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
Sample_ID = "MIBL EX HIGH DR PFIB EBSD";
% Path to files. eg: 'J:/Nature Paper Figures/'
pname = 'D:/Sam/Dropbox (The University of Manchester)/Sam Armson shared folder/Experimental/MIBL EX HIGH DR PFIB/MIBL EX HIGH/';
% File name with pname prefix, eg: [pname 'SPED_Substrate_MARIA.ctf']
fname_full = [pname 'MIBL EX HIGH.ctf'];

% Phase of interest for orientation analysis - select here for global phase of interest.

phase_of_interest = 'HCP Zr';


% Reference texture component. Used for plotting angular deviation of points from. Used for colouring and histogram (if desired).
reference_texture_component = [0,0,0,2];

% UPDATE THIS ACCORDING TO YOUR CTF FILE.
% crystal symmetry
CS = {...
	'notIndexed',...
	crystalSymmetry('6/mmm', [3.232 3.232 5.147], 'X||a*', 'Y||b', 'Z||c*', 'mineral', 'HCP Zr', 'color', [2, 123, 206]/255)};
  
% plotting convention
setMTEXpref('xAxisDirection','east');
setMTEXpref('zAxisDirection','outOfPlane');

% load EBSD data
ebsd = loadEBSD(fname_full,CS,'interface','ctf','convertSpatial2EulerReferenceFrame');
% globally define crystal symmetry of phase of interest
cs = ebsd(phase_of_interest).CS

% Perform cross-section correction
ebsd = x_section_correction(ebsd,'EBSD')

fibre_comp = define_fibre(reference_texture_component,cs)


desired_pole_figures = [[0,0,0,2,"plane"];[1,-1,0,0,"plane"];[1,1,-2,0,"direction"]];
plot_pf(ebsd,desired_pole_figures,'colouring','black')

plot_map(ebsd,'Euler')


































