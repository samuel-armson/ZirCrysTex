% Master File for running Zirconia_mTeX 
%{
Found that best grain calc params are:
misorientation = 15 (degrees)
smallest_grain = 3 (pixels)
smoothing = 3 (unknown)
%}
% Select mTeX installation to use and start mTeX
addpath 'C:/Users/Rhys/My Documents/MATLAB/mtex-5.1.1';
addpath 'C:/Users/Sam A/Documents/GitHub/Zirconia_mTeX';
addpath 'functions';
addpath 'windrose_210420';
addpath 'third_party_packages';
% Define global variables
global phase_of_interest
global cs
global reference_texture_component
global pname
addpath 'C:/Users/Sam A/My Documents/MATLAB/mtex-5.6.1/mtex-5.6.1';
startup_mtex
% Saving figures takes time. Best to only use on final run: 'on' or 'no'. Apply to all functions here.
save_figures = 'no';

% plotting convention
setMTEXpref('xAxisDirection','east');
setMTEXpref('zAxisDirection','outOfPlane');

% Phase of interest for orientation analysis - select here for global phase of interest.
phase_of_interest = 'Monoclinic ZrO$$_2$$';
% Reference texture component. Used for plotting angular deviation of points from. Used for colouring and histogram (if desired).
reference_texture_component = [1,0,-3];

%==========================================================GRAIN CALC PARAMS============================================================
%=======================================================================================================================================
rel_filter = 0
icc = 0
misorientation = 15
small_grain = 1

%=======================================================================================================================================
%=======================================================================================================================================

% Path to files. eg: 'J:/Nature Paper Figures/'
pname = 'D:/Sam/Dropbox (The University of Manchester)/Sam Armson shared folder/Experimental/SPED/2022_ctf_comp/';

% Define data
%_______________________________________________________________________________________________________________________________________
% Mono
data_mono_38NVa1= [pname '38NV_mono_stitched_fixed.ctf'];
data_mono_1TDa1 = [pname '1TD_no_LM_re_export_mono_fixed.ctf'];
data_mono_2NVa3 = [pname '2NV_NO_LM_FINAL_full.ctf'];
data_mono_LOWDR = [pname 'LOW DR LARGE_22_mono.ctf'];
data_mono_MEDDR = [pname 'MIBL MED DR_22_mono.ctf'];
data_mono_HIGH = [pname 'MIBL HIGH DR FUZZ_22_mono.ctf']
data_mono_EXHI2= [pname 'MIBL_EX_HIGH_DR_2_22_mono.ctf'];
% Metal
data_met_38NVa1= [pname '38NV_full_stitched_fixed.ctf'];
data_met_1TDa1 = [pname '1TD_no_LM_re_export_full.ctf'];
data_met_2NVa3 = [pname '2NV_NO_LM_FINAL_full.ctf'];
data_met_LOWDR = [pname 'LOW DR LARGE_22_full.ctf'];
data_met_MEDDR = [pname 'MIBL MED DR_22_full.ctf'];
data_met_HIGH = [pname 'MIBL HIGH DR FUZZ_22_full.ctf']
data_met_EXHI2= [pname 'MIBL_EX_HIGH_DR_2_22_full.ctf'];

% crystal symmetry
%_______________________________________________________________________________________________________________________________________
CS_38NVa1 = cs_loader({'metal','Pt','Pt','mono','suboxide','tet'})
CS_1TDa1 = cs_loader({'Pt','mono','metal','tet','suboxide','SPP','Pt','Hematite'})
%CS_2NVa3 = cs_loader({'mono','suboxide','tet','metal','SPP','hydride'})
CS_2NVa3 = cs_loader({'Pt','mono','Pt','metal','tet','suboxide','SPP'})
CS_LOWDR = cs_loader({'mono','metal','Pt','tet'})
CS_MEDDR = cs_loader({'metal','pt','mono','suboxide','tet'})
CS_HIGH = cs_loader({'mono','Pt','metal','tet','suboxide','hematite'})
CS_EXHI2 = cs_loader({'pt','metal','mono','tet','suboxide'})
  
% load EBSD data
%_______________________________________________________________________________________________________________________________________
% Mono
ebsd_mono_38NVa1 = loadEBSD(data_mono_38NVa1,CS_38NVa1,'interface','ctf','convertSpatial2EulerReferenceFrame');
ebsd_mono_1TDa1 = loadEBSD(data_mono_1TDa1,CS_1TDa1,'interface','ctf','convertSpatial2EulerReferenceFrame');
ebsd_mono_2NVa3 = loadEBSD(data_mono_2NVa3,CS_2NVa3,'interface','ctf','convertSpatial2EulerReferenceFrame');
ebsd_mono_LOWDR = loadEBSD(data_mono_LOWDR,CS_LOWDR,'interface','ctf','convertSpatial2EulerReferenceFrame');
ebsd_mono_MEDDR = loadEBSD(data_mono_MEDDR,CS_MEDDR,'interface','ctf','convertSpatial2EulerReferenceFrame');
ebsd_mono_HIGH = loadEBSD(data_mono_HIGH,CS_HIGH,'interface','ctf','convertSpatial2EulerReferenceFrame');
ebsd_mono_EXHI2 = loadEBSD(data_mono_EXHI2,CS_EXHI2,'interface','ctf','convertSpatial2EulerReferenceFrame');
% Metal
ebsd_met_38NVa1 = loadEBSD(data_met_38NVa1,CS_38NVa1,'interface','ctf','convertSpatial2EulerReferenceFrame');
ebsd_met_1TDa1 = loadEBSD(data_met_1TDa1,CS_1TDa1,'interface','ctf','convertSpatial2EulerReferenceFrame');
ebsd_met_2NVa3 = loadEBSD(data_met_2NVa3,CS_2NVa3,'interface','ctf','convertSpatial2EulerReferenceFrame');
ebsd_met_LOWDR = loadEBSD(data_met_LOWDR,CS_LOWDR,'interface','ctf','convertSpatial2EulerReferenceFrame');
ebsd_met_MEDDR = loadEBSD(data_met_MEDDR,CS_MEDDR,'interface','ctf','convertSpatial2EulerReferenceFrame');
ebsd_met_HIGH = loadEBSD(data_met_HIGH,CS_HIGH,'interface','ctf','convertSpatial2EulerReferenceFrame');
ebsd_met_EXHI2 = loadEBSD(data_met_EXHI2,CS_EXHI2,'interface','ctf','convertSpatial2EulerReferenceFrame');

ebsd_mono_38NVa1 = ebsd_mono_38NVa1.gridify
ebsd_met_38NVa1 = ebsd_met_38NVa1.gridify

ebsd_mono_2NVa3 = ebsd_mono_2NVa3.gridify
ebsd_met_2NVa3 = ebsd_met_2NVa3.gridify

ebsd_mono_LOWDR = ebsd_mono_LOWDR.gridify
ebsd_met_LOWDR = ebsd_met_LOWDR.gridify



% Perform cross-section correction
%_______________________________________________________________________________________________________________________________________
% Mono scan rotations
ebsd_mono_38NVa1 = x_section_correction(ebsd_mono_38NVa1,'SPED','scan_rotation',270);
ebsd_mono_1TDa1 = x_section_correction(ebsd_mono_1TDa1,'SPED','scan_rotation',90);
ebsd_mono_2NVa3 = x_section_correction(ebsd_mono_2NVa3,'SPED','scan_rotation',90);
ebsd_mono_LOWDR = x_section_correction(ebsd_mono_LOWDR,'SPED','scan_rotation',90);
ebsd_mono_MEDDR = x_section_correction(ebsd_mono_MEDDR,'SPED','scan_rotation',90);
ebsd_mono_HIGH = x_section_correction(ebsd_mono_HIGH,'SPED','scan_rotation',90);
ebsd_mono_EXHI2 = x_section_correction(ebsd_mono_EXHI2,'SPED','scan_rotation',90);
% Mono orienation adjustments
%ebsd_mono_2NVa3 = dataset_rotation(ebsd_mono_2NVa3,[0,0,-5],'axis','keep','keepXY');
ebsd_mono_LOWDR = dataset_rotation(ebsd_mono_LOWDR,[0,20,0],'axis','keep','keepXY');
ebsd_mono_MEDDR = dataset_rotation(ebsd_mono_MEDDR,[0,25,0],'axis','keep','keepXY');

% Metal scan rotations
ebsd_met_38NVa1 = x_section_correction(ebsd_met_38NVa1,'SPED','scan_rotation',270);
ebsd_met_1TDa1 = x_section_correction(ebsd_met_1TDa1,'SPED','scan_rotation',90);
ebsd_met_2NVa3 = x_section_correction(ebsd_met_2NVa3,'SPED','scan_rotation',90);
ebsd_met_LOWDR = x_section_correction(ebsd_met_LOWDR,'SPED','scan_rotation',90);
ebsd_met_MEDDR = x_section_correction(ebsd_met_MEDDR,'SPED','scan_rotation',90);
ebsd_met_HIGH = x_section_correction(ebsd_met_HIGH,'SPED','scan_rotation',90);
ebsd_met_EXHI2 = x_section_correction(ebsd_met_EXHI2,'SPED','scan_rotation',90);
% Metal orienation adjustments
%ebsd_met_2NVa3 = dataset_rotation(ebsd_met_2NVa3,[0,0,-5],'axis','keep','keepXY');
ebsd_met_LOWDR = dataset_rotation(ebsd_met_LOWDR,[0,20,0],'axis','keep','keepXY');
ebsd_met_MEDDR = dataset_rotation(ebsd_met_MEDDR,[0,25,0],'axis','keep','keepXY');
ebsd_met_MEDDR = dataset_rotation(ebsd_met_MEDDR,[0,0,30],'axis','keep','keepXY');

%_______________________________________________________________________________________________________________________________________

cs = ebsd_mono_1TDa1(phase_of_interest).CS
%%
%Calculate grains
name_list = {'AC 350','AC 400','AC 450','MIBL Low DR','MIBL Med DR','MIBL High DR','MIBL Ex High DR'}
mono_ebsd_list = {ebsd_mono_38NVa1,ebsd_mono_1TDa1,ebsd_mono_2NVa3,ebsd_mono_LOWDR,ebsd_mono_MEDDR,ebsd_mono_HIGH,ebsd_mono_EXHI2}
met_ebsd_list = {ebsd_met_38NVa1,ebsd_met_1TDa1,ebsd_met_2NVa3,ebsd_met_LOWDR,ebsd_met_MEDDR,ebsd_met_HIGH,ebsd_met_EXHI2}

grainsets_mono = {}
grainsets_met = {}
for sgi = 1:length(mono_ebsd_list)
  % Reliability filter
  mono_ebsd_list{1,sgi} = mono_ebsd_list{1,sgi}(mono_ebsd_list{1,sgi}.mad>=rel_filter/100)
  met_ebsd_list{1,sgi} = met_ebsd_list{1,sgi}(met_ebsd_list{1,sgi}.mad>=rel_filter/100)
  % Index correlation Coefficient filter
  mono_ebsd_list{1,sgi} = mono_ebsd_list{1,sgi}(mono_ebsd_list{1,sgi}.bc>=rel_filter/100)
  met_ebsd_list{1,sgi} = met_ebsd_list{1,sgi}(met_ebsd_list{1,sgi}.bc>=rel_filter/100)

  grains_mono = create_grains(mono_ebsd_list{1,sgi},'misorientation',misorientation,'smallest_grain',small_grain,'smoothing',1,'fill_gaps','no','phase_name','Monoclinic ZrO$$_2$$')
  grains_met = create_grains(met_ebsd_list{1,sgi},'misorientation',misorientation,'smallest_grain',small_grain,'smoothing',3,'fill_gaps','no','phase_name','HCP Zr')
  grainsets_met{end+1} = grains_met
end

%_______________________________________________________________________________________________________________________________________

cmap = [[78,21,96],
      [52,96,139],
      [36,167,127],
      [216,76,62],
      [243,121,24],
      [251,177,20],
      [241,235,108]]

cmap = cmap./252
%%
for sgi = 1:length(mono_ebsd_list)
  %odf = make_ODF(mono_ebsd_list{1,sgi}('Monoclinic ZrO$$_2$$'))
  %odf_data= calcODF(mono_ebsd_list{1,sgi}('Monoclinic ZrO$$_2$$').orientations,'halfwidth', 3*degree)
  %desired_pole_figures = [[1,0,-3,"plane"];[1,0,-4,"plane"];[1,0,-5,"plane"];[1,0,-6,"plane"];[1,1,-2,"plane"];[0,0,1,"plane"]];
  %plot_pf(odf_data,desired_pole_figures,'crys_sym',mono_ebsd_list{1,sgi}('Monoclinic ZrO$$_2$$').CS,'titles',name_list{1,sgi})

  %odf = make_ODF(met_ebsd_list{1,sgi}('HCP Zr'))
  %odf_data= calcODF(met_ebsd_list{1,sgi}('HCP Zr').orientations,'halfwidth', 3*degree)
  %desired_pole_figures = [[0,0,0,2,"plane"];[1,1,-2,0,"plane"]];
  %plot_pf(odf_data,desired_pole_figures,'crys_sym',met_ebsd_list{1,sgi}('HCP Zr').CS,'titles',name_list{1,sgi})

  %plot_map(grainsets_mono{1,sgi},'Deviation','phase_name','Monoclinic ZrO$$_2$$','ref_text_comp',[1,0,-3])
  %plot_map(grainsets_met{1,sgi},'Deviation','phase_name','HCP Zr','ref_text_comp',[0,0,0,1],'view_unit_cell','CS')
  %grain_dimension_hist_ellipse(grainsets_mono{1,sgi},'bin_size',5,'max_size',1000,'units','nm','max_percentage',10)
  %plot_map(mono_ebsd_list{1,sgi},'BC','gb_overlay',grainsets_mono{1,sgi},'ellipse_overlay','on','phase_name','Monoclinic ZrO$$_2$$')
  %plot_map(grainsets_mono{1,sgi},'ellipse_only','phase_name','Monoclinic ZrO$$_2$$')
  %plot_map(mono_ebsd_list{1,sgi},'BC','gb_overlay',grainsets_mono{1,sgi},'phase_name','Monoclinic ZrO$$_2$$')
  %plot_map(mono_ebsd_list{1,sgi},'BC','phase_name','Monoclinic ZrO$$_2$$')
  %plot_map(grainsets_mono{1,sgi},'gb_only','phase_name','Monoclinic ZrO$$_2$$')
  plot_map(grainsets_met{1,sgi},'phase')
  %plot_map(met_ebsd_list{1,sgi},'phase')
  %shape_prefered_orientation(grainsets_mono{1,sgi},'titles',name_list{1,sgi},'colouring','aspect_ratio','ar_compensation','on')
  %orientation_deviation_histogram(mono_ebsd_list{1,sgi},'bin_size',3,'max_y',32,'titles',name_list{1,sgi})
  %orientation_deviation_histogram_osc(mono_ebsd_list{1,sgi},'bin_size',3,'max_y',32,'titles',name_list{1,sgi})
end




%_______________________________________________________________________________________________________________________________________


for n=1:1
    load gong
    sound(y,Fs)
    disp('FIN')
 
    figure;
    set(gca,'visible','off')
    text(0.3,0.4,'fin.', 'FontSize',100);
end































































