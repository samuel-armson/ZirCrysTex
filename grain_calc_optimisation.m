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
pname = 'D:/Sam/Dropbox (The University of Manchester)/Sam Armson shared folder/Experimental/SPED/1TDa1/';

data_mono = [pname '1TDa1_r1.6_ee_0.4_more_phases_Fuzz_mono.ctf'];

% Phase of interest for orientation analysis - select here for global phase of interest.
phase_of_interest = 'Monoclinic ZrO$$_2$$';

% Reference texture component. Used for plotting angular deviation of points from. Used for colouring and histogram (if desired).
reference_texture_component = [1,0,-3];

% UPDATE THIS ACCORDING TO YOUR CTF FILE.
% crystal symmetry

CS = cs_loader({'metal','mono','SPP','tet','suboxide'})
  
% plotting convention
setMTEXpref('xAxisDirection','east');
setMTEXpref('zAxisDirection','outOfPlane');

% load EBSD data
ebsd_mono = loadEBSD(data_mono,CS,'interface','ctf','convertSpatial2EulerReferenceFrame');

% globally define crystal symmetry of phase of interest
cs = ebsd_mono(phase_of_interest).CS

% Perform cross-section correction
ebsd_mono = x_section_correction(ebsd_mono,'SPED','scan_rotation',90)

%%
%Calculate and plot grains and grain size histograms

grains_mono_1 = create_grains(ebsd_mono,'misorientation',10,'smallest_grain',2,'smoothing',1,'fill_gaps','no','phase_name','Monoclinic ZrO$$_2$$')
grains_mono_2 = create_grains(ebsd_mono,'misorientation',10,'smallest_grain',10,'smoothing',1,'fill_gaps','no','phase_name','Monoclinic ZrO$$_2$$')
grainsets = {grains_mono_1,grains_mono_2}



%plot_map(grains_mono,'Deviation','phase_name','Monoclinic ZrO$$_2$$','ref_text_comp',[1,0,-3])
%grain_dimension_hist_ellipse(grains_mono,'bin_size',5,'max_size',250,'units','nm','max_percentage',20)
grain_area_hist_multi(grainsets,'bin_size',100,'units','nm','max_percentage',20,'plot_type','line')


%% Sign off
for n=1:1
    load gong
    sound(y,Fs)
    disp('FIN')
 
    figure;
    set(gca,'visible','off')
    text(0.3,0.4,'fin.', 'FontSize',100);
end































































