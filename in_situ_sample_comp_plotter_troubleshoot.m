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
rel_filter = 5
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
data_mono_38NVa1= [pname '2NV_ASTAR_RECALC.ctf'];

% Metal
data_met_38NVa1= [pname '2NV_ASTAR_RECALC.ctf'];

% crystal symmetry
%_______________________________________________________________________________________________________________________________________
CS_38NVa1 = cs_loader({'mono','tet','metal','suboxide','SPP'})

  
% load EBSD data
%_______________________________________________________________________________________________________________________________________
% Mono
ebsd_mono_38NVa1 = EBSD.load(data_mono_38NVa1,CS_38NVa1,'interface','ctf','convertSpatial2EulerReferenceFrame');

% Metal
ebsd_met_38NVa1 = EBSD.load(data_met_38NVa1,CS_38NVa1,'interface','ctf','convertSpatial2EulerReferenceFrame');


% Perform cross-section correction
%_______________________________________________________________________________________________________________________________________
% Mono scan rotations
ebsd_mono_38NVa1 = x_section_correction(ebsd_mono_38NVa1,'SPED','scan_rotation',90);

% Metal scan rotations
ebsd_met_38NVa1 = x_section_correction(ebsd_met_38NVa1,'SPED','scan_rotation',90);
%_______________________________________________________________________________________________________________________________________

cs = ebsd_mono_38NVa1(phase_of_interest).CS
%%
%Calculate grains
name_list = {'AC 350'}
mono_ebsd_list = {ebsd_mono_38NVa1}
met_ebsd_list = {ebsd_met_38NVa1}

grainsets_mono = {}
grainsets_met = {}
for sgi = 1:length(mono_ebsd_list)
  % Reliability filter
  mono_ebsd_list{1,sgi} = mono_ebsd_list{1,sgi}(mono_ebsd_list{1,sgi}.mad>=rel_filter/100)
  met_ebsd_list{1,sgi} = met_ebsd_list{1,sgi}(met_ebsd_list{1,sgi}.mad>=rel_filter/100)
  %met_ebsd_list{1,sgi}.unitCell = met_ebsd_list{1,sgi}.unitCell * 1.00001
  % Index correlation Coefficient filter
  mono_ebsd_list{1,sgi} = mono_ebsd_list{1,sgi}(mono_ebsd_list{1,sgi}.bc>=rel_filter/100)
  met_ebsd_list{1,sgi} = met_ebsd_list{1,sgi}(met_ebsd_list{1,sgi}.bc>=rel_filter/100)

  grains_mono = create_grains(mono_ebsd_list{1,sgi},'misorientation',misorientation,'smallest_grain',small_grain,'smoothing',1,'fill_gaps','yes','phase_name','Monoclinic ZrO$$_2$$')
  grains_met = create_grains(met_ebsd_list{1,sgi},'misorientation',misorientation,'smallest_grain',small_grain,'smoothing',1,'fill_gaps','yes','phase_name','HCP Zr')
  %grains_met = calcGrains(met_ebsd_list{1,sgi}('indexed'),'angle',misorientation,'boundary','tight','unitCell')
  %grains_met = calcGrains(met_ebsd_list{1,sgi}('indexed'),'angle',misorientation,'boundary','tight')
  grainsets_met{end+1} = grains_met
  grainsets_mono{end+1} = grains_mono
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

  plot_map(grainsets_mono{1,sgi},'Deviation','phase_name','Monoclinic ZrO$$_2$$','ref_text_comp',[1,0,-3])
  plot_map(grainsets_met{1,sgi},'Deviation','phase_name','HCP Zr','ref_text_comp',[0,0,0,1],'view_unit_cell','CS')
  %grain_dimension_hist_ellipse(grainsets_mono{1,sgi},'bin_size',5,'max_size',1000,'units','nm','max_percentage',10)
  %plot_map(mono_ebsd_list{1,sgi},'BC','gb_overlay',grainsets_mono{1,sgi},'ellipse_overlay','on','phase_name','Monoclinic ZrO$$_2$$')
  %plot_map(grainsets_mono{1,sgi},'ellipse_only','phase_name','Monoclinic ZrO$$_2$$')
  %plot_map(mono_ebsd_list{1,sgi},'BC','gb_overlay',grainsets_mono{1,sgi},'phase_name','Monoclinic ZrO$$_2$$')
  %plot_map(mono_ebsd_list{1,sgi},'BC','phase_name','Monoclinic ZrO$$_2$$')
  %plot_map(grainsets_mono{1,sgi},'gb_only','phase_name','Monoclinic ZrO$$_2$$')
  plot_map(grainsets_met{1,sgi},'phase')
  plot_map(met_ebsd_list{1,sgi},'phase')
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































































