% Master File for running Zirconia_mTeX 
%{
Found that best grain calc params are:
misorientation = 15 (degrees)
smallest_grain = 3 (pixels)
smoothing = 3 (unknown)
%}
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
% plotting convention
setMTEXpref('xAxisDirection','east');
setMTEXpref('zAxisDirection','outOfPlane');
% Phase of interest for orientation analysis - select here for global phase of interest.
phase_of_interest = 'Monoclinic ZrO$$_2$$';
% Reference texture component. Used for plotting angular deviation of points from. Used for colouring and histogram (if desired).
reference_texture_component = [1,0,-3];



% Path to files. eg: 'J:/Nature Paper Figures/'
pname = 'D:/Sam/Dropbox (The University of Manchester)/Sam Armson shared folder/Experimental/SPED/';

data_38NVa1= [pname '38NVa1 thinboy Fuzz mono.ctf'];
data_1TDa1 = [pname '1TDa1/1TDa1_r1.6_ee_0.4_more_phases_Fuzz_mono.ctf'];
data_2NVa3 = [pname '2NVa3/2NVa3_r1.2_ee_0.4_more_phases_fuzz_amb_res_no_hydride_or_SPP_mono.ctf'];
data_LOWDR = [pname 'MIBL LOW DR/Small area/MIBL LOW DR small fuzz amb res mono.ctf'];
data_MEDDR = [pname 'MIBL MED DR Fuzz mono.ctf'];
data_EXHI3 = [pname 'MIBL EX HIGH DR 3/MIBL EX HIGH DR 3 R_1.6_EE_0.4_more_phases_index400_or_1_mono.ctf'];
data_EXHI2= [pname 'MIBL Ex High DR/MIBL_EX_HIGH_DR_2_Fuzz_mono.ctf'];




% UPDATE THIS ACCORDING TO YOUR CTF FILE.
% crystal symmetry

CS_38NVa1 = cs_loader({'metal','Pt','Pt','mono','suboxide','tet'})
CS_1TDa1 = cs_loader({'metal','mono','SPP','tet','suboxide'})
CS_2NVa3 = cs_loader({'mono','suboxide','tet','metal','SPP','hydride'})
CS_LOWDR = cs_loader({'pt','metal','mono','tet','suboxide','SPP'})
CS_MEDDR = cs_loader({'metal','pt','mono','suboxide','tet'})
CS_EXHI3 = cs_loader({'mono','suboxide','tet','metal','hydride','hematite','pt'})
CS_EXHI2 = cs_loader({'pt','metal','mono','tet','suboxide'})
  


% load EBSD data
ebsd_38NVa1 = loadEBSD(data_38NVa1,CS_38NVa1,'interface','ctf','convertSpatial2EulerReferenceFrame');
ebsd_1TDa1 = loadEBSD(data_1TDa1,CS_1TDa1,'interface','ctf','convertSpatial2EulerReferenceFrame');
ebsd_2NVa3 = loadEBSD(data_2NVa3,CS_2NVa3,'interface','ctf','convertSpatial2EulerReferenceFrame');
ebsd_LOWDR = loadEBSD(data_LOWDR,CS_LOWDR,'interface','ctf','convertSpatial2EulerReferenceFrame');
ebsd_MEDDR = loadEBSD(data_MEDDR,CS_MEDDR,'interface','ctf','convertSpatial2EulerReferenceFrame');
ebsd_EXHI3 = loadEBSD(data_EXHI3,CS_EXHI3,'interface','ctf','convertSpatial2EulerReferenceFrame');
ebsd_EXHI2 = loadEBSD(data_EXHI2,CS_EXHI2,'interface','ctf','convertSpatial2EulerReferenceFrame');

% Perform cross-section correction
ebsd_38NVa1 = x_section_correction(ebsd_38NVa1,'SPED','scan_rotation',270)
ebsd_1TDa1 = x_section_correction(ebsd_1TDa1,'SPED','scan_rotation',90)
ebsd_2NVa3 = x_section_correction(ebsd_2NVa3,'SPED','scan_rotation',90)
ebsd_LOWDR = x_section_correction(ebsd_LOWDR,'SPED','scan_rotation',90)
ebsd_MEDDR = x_section_correction(ebsd_MEDDR,'SPED','scan_rotation',90)
ebsd_EXHI3 = x_section_correction(ebsd_EXHI3,'SPED','scan_rotation',90)
ebsd_EXHI2 = x_section_correction(ebsd_EXHI2,'SPED','scan_rotation',90)

cs = ebsd_1TDa1(phase_of_interest).CS
%%
%Calculate grains
name_list = {'Jacobs 38NV','Jacobs 1TD','Jacobs 2NV','MIBL Low DR','MIBL Med DR','MIBL Ex High DR 1','MIBL Ex High DR 2'}
param_list = {ebsd_38NVa1,ebsd_1TDa1,ebsd_2NVa3,ebsd_LOWDR,ebsd_MEDDR,ebsd_EXHI3,ebsd_EXHI2}

grainsets = {}
for sgi = 1:length(param_list)
	grains_mono = create_grains(param_list{1,sgi},'misorientation',15,'smallest_grain',1,'smoothing',1,'fill_gaps','no','phase_name','Monoclinic ZrO$$_2$$')
	grainsets{end+1} = grains_mono
end

%%
%Plot maps and 2d histograms

for sgi = 1:length(param_list)
	%plot_map(grainsets{1,sgi},'Deviation','phase_name','Monoclinic ZrO$$_2$$','ref_text_comp',[1,0,-3])
	%grain_dimension_hist_ellipse(grainsets{1,sgi},'bin_size',5,'max_size',1000,'units','nm','max_percentage',10)
	plot_map(param_list{1,sgi},'BC','gb_overlay',grainsets{1,sgi},'phase_name','Monoclinic ZrO$$_2$$')
	plot_map(grainsets{1,sgi},'BC','phase_name','Monoclinic ZrO$$_2$$')
	plot_map(grainsets{1,sgi},'gb_only','phase_name','Monoclinic ZrO$$_2$$')
end

%%
%Plot Combined 1D histograms

cmap = [[67,5,83],
      [57,138,78],
      [61,186,114],
      [33,114,140],
      [114,208,85],
      [149,230,33],
      [253,231,37]]
cmap = cmap./255

%{
grain_area_hist_multi(grainsets,'bin_size',5000,'units','nm','max_percentage',100,'max_size',400000,'plot_type','hist_line','legend_labels',name_list,'freq','normalised','alt_cmap',cmap)
grain_area_hist_multi(grainsets,'bin_size',2500,'units','nm','max_percentage',100,'max_size',400000,'plot_type','hist_line','legend_labels',name_list,'freq','normalised','alt_cmap',cmap)
grain_area_hist_multi(grainsets,'bin_size',1000,'units','nm','max_percentage',85,'max_size',100000,'plot_type','hist_line','legend_labels',name_list,'freq','normalised','alt_cmap',cmap)
grain_area_hist_multi(grainsets,'bin_size',400,'units','nm','max_percentage',50,'max_size',100000,'plot_type','hist_line','legend_labels',name_list,'freq','normalised','alt_cmap',cmap)
grain_area_hist_multi(grainsets,'bin_size',200,'units','nm','max_percentage',38,'max_size',100000,'plot_type','hist_line','legend_labels',name_list,'freq','normalised','alt_cmap',cmap)
grain_area_hist_multi(grainsets,'bin_size',50,'units','nm','max_percentage',38,'max_size',5000,'plot_type','hist_line','legend_labels',name_list,'freq','normalised','alt_cmap',cmap)
%}

%% Sign off
for n=1:1
    load gong
    sound(y,Fs)
    disp('FIN')
 
    figure;
    set(gca,'visible','off')
    text(0.3,0.4,'fin.', 'FontSize',100);
end































































