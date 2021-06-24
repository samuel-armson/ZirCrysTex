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
addpath 'windrose_210420';
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

data_mono_38NVa1= [pname '38NVa1 thinboy Fuzz mono.ctf'];
data_mono_1TDa1 = [pname '1TDa1/1TDa1_r1.6_ee_0.4_more_phases_Fuzz_mono.ctf'];
data_mono_2NVa3 = [pname '2NVa3/2NVa3_r1.2_ee_0.4_more_phases_fuzz_amb_res_no_hydride_or_SPP_mono.ctf'];
data_mono_LOWDR = [pname 'MIBL LOW DR/Small area/MIBL LOW DR small fuzz amb res mono.ctf'];
data_mono_MEDDR = [pname 'MIBL MED DR Fuzz mono.ctf'];
data_mono_HIGH = [pname 'MIBL HIGH DR/MIBL HIGH DR FUZZ NO HEX OR HEMATITE MONO.ctf']
%data_mono_EXHI3 = [pname 'MIBL EX HIGH DR 3/MIBL EX HIGH DR 3 R_1.6_EE_0.4_more_phases_index400_or_1_mono.ctf'];
data_mono_EXHI2= [pname 'MIBL Ex High DR/MIBL_EX_HIGH_DR_2_Fuzz_mono.ctf'];


data_metal_38NVa1= [pname '38NVa1 thinboy Fuzz metal.ctf'];
data_metal_1TDa1 = [pname '1TDa1/1TDa1_r1.6_ee_0.4_more_phases_Fuzz_metal.ctf'];
data_metal_2NVa3 = [pname '2NVa3/2NVa3_r1.2_ee_0.4_more_phases_fuzz_amb_res_no_hydride_or_SPP_metal.ctf'];
data_metal_LOWDR = [pname 'MIBL LOW DR/Small area/MIBL LOW DR small fuzz amb res metal.ctf'];
data_metal_MEDDR = [pname 'MIBL MED DR Fuzz metal.ctf'];
data_metal_HIGH = [pname 'MIBL HIGH DR/MIBL HIGH DR FUZZ NO HEX OR HEMATITE METAL.ctf']
%data_metal_EXHI3 = [pname 'MIBL EX HIGH DR 3/MIBL EX HIGH DR 3 R_1.6_EE_0.4_more_phases_index400_or_1_mono.ctf'];
data_metal_EXHI2= [pname 'MIBL Ex High DR/MIBL_EX_HIGH_DR_2_Fuzz_metal.ctf'];




% UPDATE THIS ACCORDING TO YOUR CTF FILE.
% crystal symmetry

CS_38NVa1 = cs_loader({'metal','Pt','Pt','mono','suboxide','tet'})
CS_1TDa1 = cs_loader({'metal','mono','SPP','tet','suboxide'})
CS_2NVa3 = cs_loader({'mono','suboxide','tet','metal','SPP','hydride'})
CS_LOWDR = cs_loader({'pt','metal','mono','tet','suboxide','SPP'})
CS_MEDDR = cs_loader({'metal','pt','mono','suboxide','tet'})
CS_HIGH = cs_loader({'mono','Pt','metal','tet','suboxide','hematite'})
%CS_EXHI3 = cs_loader({'mono','suboxide','tet','metal','hydride','hematite','pt'})
CS_EXHI2 = cs_loader({'pt','metal','mono','tet','suboxide'})
  


% load EBSD data
ebsd_mono_38NVa1 = loadEBSD(data_mono_38NVa1,CS_38NVa1,'interface','ctf','convertSpatial2EulerReferenceFrame');
ebsd_mono_1TDa1 = loadEBSD(data_mono_1TDa1,CS_1TDa1,'interface','ctf','convertSpatial2EulerReferenceFrame');
ebsd_mono_2NVa3 = loadEBSD(data_mono_2NVa3,CS_2NVa3,'interface','ctf','convertSpatial2EulerReferenceFrame');
ebsd_mono_LOWDR = loadEBSD(data_mono_LOWDR,CS_LOWDR,'interface','ctf','convertSpatial2EulerReferenceFrame');
ebsd_mono_MEDDR = loadEBSD(data_mono_MEDDR,CS_MEDDR,'interface','ctf','convertSpatial2EulerReferenceFrame');
ebsd_mono_HIGH = loadEBSD(data_mono_HIGH,CS_HIGH,'interface','ctf','convertSpatial2EulerReferenceFrame');
%ebsd_mono_EXHI3 = loadEBSD(data_mono_EXHI3,CS_EXHI3,'interface','ctf','convertSpatial2EulerReferenceFrame');
ebsd_mono_EXHI2 = loadEBSD(data_mono_EXHI2,CS_EXHI2,'interface','ctf','convertSpatial2EulerReferenceFrame');

ebsd_metal_38NVa1 = loadEBSD(data_metal_38NVa1,CS_38NVa1,'interface','ctf','convertSpatial2EulerReferenceFrame');
ebsd_metal_1TDa1 = loadEBSD(data_metal_1TDa1,CS_1TDa1,'interface','ctf','convertSpatial2EulerReferenceFrame');
ebsd_metal_2NVa3 = loadEBSD(data_metal_2NVa3,CS_2NVa3,'interface','ctf','convertSpatial2EulerReferenceFrame');
ebsd_metal_LOWDR = loadEBSD(data_metal_LOWDR,CS_LOWDR,'interface','ctf','convertSpatial2EulerReferenceFrame');
ebsd_metal_MEDDR = loadEBSD(data_metal_MEDDR,CS_MEDDR,'interface','ctf','convertSpatial2EulerReferenceFrame');
ebsd_metal_HIGH = loadEBSD(data_metal_HIGH,CS_HIGH,'interface','ctf','convertSpatial2EulerReferenceFrame');
%ebsd_metal_EXHI3 = loadEBSD(data_metal_EXHI3,CS_EXHI3,'interface','ctf','convertSpatial2EulerReferenceFrame');
ebsd_metal_EXHI2 = loadEBSD(data_metal_EXHI2,CS_EXHI2,'interface','ctf','convertSpatial2EulerReferenceFrame');

% Perform cross-section correction
ebsd_mono_38NVa1 = x_section_correction(ebsd_mono_38NVa1,'SPED','scan_rotation',270)
ebsd_mono_1TDa1 = x_section_correction(ebsd_mono_1TDa1,'SPED','scan_rotation',90)
ebsd_mono_2NVa3 = x_section_correction(ebsd_mono_2NVa3,'SPED','scan_rotation',90)
ebsd_mono_LOWDR = x_section_correction(ebsd_mono_LOWDR,'SPED','scan_rotation',90)
ebsd_mono_MEDDR = x_section_correction(ebsd_mono_MEDDR,'SPED','scan_rotation',90)
ebsd_mono_HIGH = x_section_correction(ebsd_mono_HIGH,'SPED','scan_rotation',90)
%ebsd_mono_EXHI3 = x_section_correction(ebsd_mono_EXHI3,'SPED','scan_rotation',90)
ebsd_mono_EXHI2 = x_section_correction(ebsd_mono_EXHI2,'SPED','scan_rotation',90)

ebsd_metal_38NVa1 = x_section_correction(ebsd_metal_38NVa1,'SPED','scan_rotation',270)
ebsd_metal_1TDa1 = x_section_correction(ebsd_metal_1TDa1,'SPED','scan_rotation',90)
ebsd_metal_2NVa3 = x_section_correction(ebsd_metal_2NVa3,'SPED','scan_rotation',90)
ebsd_metal_LOWDR = x_section_correction(ebsd_metal_LOWDR,'SPED','scan_rotation',90)
ebsd_metal_MEDDR = x_section_correction(ebsd_metal_MEDDR,'SPED','scan_rotation',90)
ebsd_metal_HIGH = x_section_correction(ebsd_metal_HIGH,'SPED','scan_rotation',90)
%ebsd_metal_EXHI3 = x_section_correction(ebsd_metal_EXHI3,'SPED','scan_rotation',90)
ebsd_metal_EXHI2 = x_section_correction(ebsd_metal_EXHI2,'SPED','scan_rotation',90)

%Extra scan rotation correction. Will rotate Euler only - not spatially. Can rotate spatially later in external software package.
%Rotating spatially by a multiple <90° leads to glitches in grain calculation.
%{
ebsd_metal_2NVa3 = dataset_rotation(ebsd_metal_2NVa3,[0,0,-5],'axis','keep','keepXY');
ebsd_metal_LOWDR = dataset_rotation(ebsd_metal_LOWDR,[0,0,5],'axis','keep','keepXY');
ebsd_metal_MEDDR = dataset_rotation(ebsd_metal_MEDDR,[0,0,10],'axis','keep','keepXY');
ebsd_metal_EXHI2 = dataset_rotation(ebsd_metal_EXHI2,[0,0,5],'axis','keep','keepXY');
ebsd_mono_2NVa3 = dataset_rotation(ebsd_mono_2NVa3,[0,0,-5],'axis','keep','keepXY');
ebsd_mono_LOWDR = dataset_rotation(ebsd_mono_LOWDR,[0,0,5],'axis','keep','keepXY');
ebsd_mono_MEDDR = dataset_rotation(ebsd_mono_MEDDR,[0,0,10],'axis','keep','keepXY');
ebsd_mono_EXHI2 = dataset_rotation(ebsd_mono_EXHI2,[0,0,5],'axis','keep','keepXY');
%}


cs = ebsd_mono_1TDa1(phase_of_interest).CS
%%
%Calculate grains
name_list = {'Jacobs 38NV','Jacobs 1TD','Jacobs 2NV','MIBL Low DR','MIBL Med DR','MIBL High DR','MIBL Ex High DR 1'}
mono_ebsd_list = {ebsd_mono_38NVa1,ebsd_mono_1TDa1,ebsd_mono_2NVa3,ebsd_mono_LOWDR,ebsd_mono_MEDDR,ebsd_mono_HIGH,ebsd_mono_EXHI2}
metal_ebsd_list = {ebsd_metal_38NVa1,ebsd_metal_1TDa1,ebsd_metal_2NVa3,ebsd_metal_LOWDR,ebsd_metal_MEDDR,ebsd_metal_HIGH,ebsd_metal_EXHI2}

%{
grainsets_mono = {}
grainsets_metal = {}
for sgi = 1:length(mono_ebsd_list)
	%grains_mono = create_grains(mono_ebsd_list{1,sgi},'misorientation',10,'smallest_grain',1,'smoothing',1,'fill_gaps','no','phase_name','Monoclinic ZrO$$_2$$')
  grains_metal = create_grains(metal_ebsd_list{1,sgi},'misorientation',10,'smallest_grain',10,'smoothing',3,'fill_gaps','no','phase_name','HCP Zr')
	%grainsets_mono{end+1} = grains_mono
  grainsets_metal{end+1} = grains_metal
end
%}

%%
%Plot maps and 2d histograms

%name_list = {'Jacobs 38NV'}
%mono_ebsd_list = {ebsd_mono_38NVa1}
%{
cmap = [[67,5,83],
      [57,138,78],
      [61,186,114],
      [33,114,140],
      [114,208,85],
      [149,230,33],
      [253,231,37]]
%}
cmap = [[78,21,96],
      [52,96,139],
      [36,167,127],
      [216,76,62],
      [243,121,24],
      [251,177,20],
      [241,235,108]]

cmap = cmap./252


for sgi = 1:length(mono_ebsd_list)
  %odf = make_ODF(mono_ebsd_list{1,sgi}('Monoclinic ZrO$$_2$$'))
  %odf_data= calcODF(mono_ebsd_list{1,sgi}('Monoclinic ZrO$$_2$$').orientations,'halfwidth', 3*degree)
  %desired_pole_figures = [[1,0,-3,"plane"];[1,0,-4,"plane"];[1,0,-5,"plane"];[1,0,-6,"plane"];[1,1,-2,"plane"];[0,0,1,"plane"]];
  %plot_pf(odf_data,desired_pole_figures,'crys_sym',mono_ebsd_list{1,sgi}('Monoclinic ZrO$$_2$$').CS,'titles',name_list{1,sgi})

  %odf = make_ODF(metal_ebsd_list{1,sgi}('HCP Zr'))
  %odf_data= calcODF(metal_ebsd_list{1,sgi}('HCP Zr').orientations,'halfwidth', 3*degree)
  %desired_pole_figures = [[0,0,0,2,"plane"];[1,1,-2,0,"plane"]];
  %plot_pf(odf_data,desired_pole_figures,'crys_sym',metal_ebsd_list{1,sgi}('HCP Zr').CS,'titles',name_list{1,sgi})

	%plot_map(grainsets_mono{1,sgi},'Deviation','phase_name','Monoclinic ZrO$$_2$$','ref_text_comp',[1,0,-3])
  %plot_map(grainsets_metal{1,sgi},'Deviation','phase_name','HCP Zr','ref_text_comp',[0,0,0,1],'view_unit_cell','CS')
	%grain_dimension_hist_ellipse(grainsets_mono{1,sgi},'bin_size',5,'max_size',1000,'units','nm','max_percentage',10)
	%plot_map(mono_ebsd_list{1,sgi},'BC','gb_overlay',grainsets_mono{1,sgi},'ellipse_overlay','on','phase_name','Monoclinic ZrO$$_2$$')
  %plot_map(grainsets_mono{1,sgi},'ellipse_only','phase_name','Monoclinic ZrO$$_2$$')
  %plot_map(mono_ebsd_list{1,sgi},'BC','gb_overlay',grainsets_mono{1,sgi},'phase_name','Monoclinic ZrO$$_2$$')
	%plot_map(mono_ebsd_list{1,sgi},'BC','phase_name','Monoclinic ZrO$$_2$$')
	%plot_map(grainsets_mono{1,sgi},'gb_only','phase_name','Monoclinic ZrO$$_2$$')
  %shape_prefered_orientation(grainsets_mono{1,sgi},'titles',name_list{1,sgi},'colouring','aspect_ratio','ar_compensation','on')
  orientation_deviation_histogram(mono_ebsd_list{1,sgi},'bin_size',3,'max_y',35,'titles',name_list{1,sgi})
  orientation_deviation_histogram_osc(mono_ebsd_list{1,sgi},'bin_size',3,'max_y',35,'titles',name_list{1,sgi})
end



%Plot Combined 1D histograms

%orientation_deviation_histogram_multi(mono_ebsd_list,'phase_name','Monoclinic ZrO$$_2$$','plot_type','hist_line','alt_cmap',cmap,'legend_labels',name_list)

%grain_area_hist_multi(grainsets_mono,'bin_size',5000,'units','nm','max_percentage',100,'max_size',400000,'plot_type','hist_line','legend_labels',name_list,'freq','normalised','alt_cmap',cmap)
%grain_area_hist_multi(grainsets_mono,'bin_size',2500,'units','nm','max_percentage',100,'max_size',400000,'plot_type','hist_line','legend_labels',name_list,'freq','normalised','alt_cmap',cmap)
%grain_area_hist_multi(grainsets_mono,'bin_size',1000,'units','nm','max_percentage',85,'max_size',100000,'plot_type','hist_line','legend_labels',name_list,'freq','normalised','alt_cmap',cmap)
%grain_area_hist_multi(grainsets_mono,'bin_size',400,'units','nm','max_percentage',50,'max_size',100000,'plot_type','hist_line','legend_labels',name_list,'freq','normalised','alt_cmap',cmap)
%grain_area_hist_multi(grainsets_mono,'bin_size',200,'units','nm','max_percentage',38,'max_size',100000,'plot_type','hist_line','legend_labels',name_list,'freq','normalised','alt_cmap',cmap)
%grain_area_hist_multi(grainsets_mono,'bin_size',50,'units','nm','max_percentage',38,'max_size',5000,'plot_type','hist_line','legend_labels',name_list,'freq','normalised','alt_cmap',cmap)


%%


%% Sign off
for n=1:1
    load gong
    sound(y,Fs)
    disp('FIN')
 
    figure;
    set(gca,'visible','off')
    text(0.3,0.4,'fin.', 'FontSize',100);
end































































