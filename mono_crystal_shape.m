% Master File for running Zirconia_mTeX 
%{
Found that best grain calc params are:
misorientation = 15 (degrees)
smallest_grain = 3 (pixels)
smoothing = 3 (unknown)
%}
% Select mTeX installation to use and start mTeX
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
% plotting convention
setMTEXpref('xAxisDirection','east');
setMTEXpref('zAxisDirection','outOfPlane');
% Phase of interest for orientation analysis - select here for global phase of interest.
phase_of_interest = 'Monoclinic ZrO$$_2$$';
% Reference texture component. Used for plotting angular deviation of points from. Used for colouring and histogram (if desired).
reference_texture_component = [1,0,-3];



% Path to files. eg: 'J:/Nature Paper Figures/'
pname = 'D:/Sam/Dropbox (The University of Manchester)/Sam Armson shared folder/Experimental/SPED/';
data_1TDa1 = [pname '1TDa1/1TDa1_r1.6_ee_0.4_more_phases_Fuzz_mono.ctf'];

% UPDATE THIS ACCORDING TO YOUR CTF FILE.
% crystal symmetry
CS_1TDa1 = cs_loader({'metal','mono','SPP','tet','suboxide'})
% load EBSD data
ebsd_1TDa1 = loadEBSD(data_1TDa1,CS_1TDa1,'interface','ctf','convertSpatial2EulerReferenceFrame');
% Perform cross-section correction
ebsd_1TDa1 = x_section_correction(ebsd_1TDa1,'SPED','scan_rotation',90)
cs = ebsd_1TDa1(phase_of_interest).CS

%%
N = Miller({1,0,0},{0,1,0},{0,0,1},{1,0,-3},cs)
d = [1, 1.009, 1.031, 3.85];

% this defines the crystal shape in MTEX
cS = crystalShape( N ./ d)

% plot the crystal shape
figure()
plot(cS,'colored','facealpha',0.8)
hold on
arrow3d(0.5*[xvector,yvector,zvector],'labeled')
hold off
legend

param_list = {ebsd_1TDa1}
orientation_deviation_histogram_multi(param_list,'phase_name','Monoclinic ZrO$$_2$$','plot_type','hist_line','alt_cmap',cmap,'legend_labels',name_list)

%% Sign off
for n=1:1
    load gong
    sound(y,Fs)
    disp('FIN')
 
    figure;
    set(gca,'visible','off')
    text(0.3,0.4,'fin.', 'FontSize',100);
end































































