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
Sample_ID = "REGION_1_PRIME";
% Path to files. eg: 'J:/Nature Paper Figures/'
pname = 'D:/Sam/Dropbox (The University of Manchester)/Externally shared/Nature Paper MTEX figs/DATA AND SCRIPTS/';

% File name with pname prefix, eg: [pname 'SPED_Substrate_MARIA.ctf']
data_full = [pname 'Region_1_prime.ctf'];
data_met = [pname 'Metal_Region_1_prime.ctf'];

% Phase of interest for orientation analysis - select here for global phase of interest.
phase_of_interest = 'Monoclinic ZrO$$_2$$';

% Reference texture component. Used for plotting angular deviation of points from. Used for colouring and histogram (if desired).
reference_texture_component = [1,0,-3];

% UPDATE THIS ACCORDING TO YOUR CTF FILE.
% crystal symmetry

CS = cs_loader({'tet','metal','mono'})
CS_met = cs_loader({'tet','metal','mono','SPP','SPP','SPP'})
  
% plotting convention
setMTEXpref('xAxisDirection','east');
setMTEXpref('zAxisDirection','outOfPlane');

% load EBSD data
ebsd_full = loadEBSD(data_full,CS,'interface','ctf','convertSpatial2EulerReferenceFrame');
ebsd_met = loadEBSD(data_met,CS_met,'interface','ctf','convertSpatial2EulerReferenceFrame');

% globally define crystal symmetry of phase of interest
cs = ebsd_full(phase_of_interest).CS

mono_odf = make_ODF(ebsd_full('Monoclinic ZrO$$_2$$'))
mono_odf_data= calcODF(ebsd_full('Monoclinic ZrO$$_2$$').orientations,'halfwidth', 3*degree)
mono_desired_pole_figures = [[0,0,1,"direction"]];

tet_odf = make_ODF(ebsd_full('Tetragonal ZrO$$_2$$'))
tet_odf_data= calcODF(ebsd_full('Tetragonal ZrO$$_2$$').orientations,'halfwidth', 3*degree)
tet_desired_pole_figures = [[0,0,1,"direction"]];

met_odf = make_ODF(ebsd_met('HCP Zr'))
met_odf_data= calcODF(ebsd_met('HCP Zr').orientations,'halfwidth', 3*degree)
met_desired_pole_figures = [[0,0,0,2,"direction"]];

plot_pf(mono_odf_data,mono_desired_pole_figures)
plot_pf(tet_odf_data,tet_desired_pole_figures)
plot_pf(met_odf_data,met_desired_pole_figures)


%% Sign off
for n=1:1
    load gong
    sound(y,Fs)
    disp('FIN')
 
    figure;
    set(gca,'visible','off')
    text(0.3,0.4,'fin.', 'FontSize',100);
end































