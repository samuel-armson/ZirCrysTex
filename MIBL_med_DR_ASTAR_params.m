% Master File for running Zirconia_mTeX 

% Select mTeX installation to use and start mTeX
%addpath 'C:/Users/Rhys/My Documents/MATLAB/mtex-5.1.1';
addpath(genpath('C:/Users/Sam A/Documents/GitHub/Zirconia_mTeX'));
addpath 'functions';
addpath 'third_party_packages';
% Define global variables
global phase_of_interest
global cs
global reference_texture_component
global Sample_ID
global pname
addpath 'C:/Users/Sam A/My Documents/MATLAB/mtex-5.6.1/mtex-5.6.1';
startup_mtex


% Saving figures takes time. Best to only use on final run: 'on' or 'no'. Apply to all functions here.
save_figures = 'no';

% Sample ID: name given to saved output figures. Choose to ensure that other files aren't overwritten    
Sample_ID = "MIBL_MED_DR";
% Path to files. eg: 'J:/Nature Paper Figures/'
pname = 'D:/Sam/Dropbox (The University of Manchester)/Sam Armson shared folder/Experimental/SPED/';

% File name with pname prefix, eg: [pname 'SPED_Substrate_MARIA.ctf']

data_mono = [pname 'MIBL MED DR_22_mono.ctf'];

% Phase of interest for orientation analysis - select here for global phase of interest.
phase_of_interest = 'Monoclinic ZrO$$_2$$';

% Reference texture component. Used for plotting angular deviation of points from. Used for colouring and histogram (if desired).
reference_texture_component = [1,0,-3];

% UPDATE THIS ACCORDING TO YOUR CTF FILE.
% crystal symmetry

%CS = cs_loader({'Pt','mono','metal','tet','suboxide'})
CS = cs_loader({'metal','Pt','mono','suboxide','tet'})
  
% plotting convention
setMTEXpref('xAxisDirection','east');
setMTEXpref('zAxisDirection','outOfPlane');

% load EBSD data
%ebsd_full = loadEBSD(data_full,CS,'interface','ctf','convertSpatial2EulerReferenceFrame');
%%
ebsd_mono = EBSD.load(data_mono,CS,'interface','ctf','convertSpatial2EulerReferenceFrame');
%ebsd_met = loadEBSD(data_met,CS,'interface','ctf','convertSpatial2EulerReferenceFrame');

%ebsd_mono = gridify(ebsd_mono)

%ebsd_mono.unitCell = ebsd_mono.unitCell * 1.005

% globally define crystal symmetry of phase of interest
cs = ebsd_mono(phase_of_interest).CS

% Perform cross-section correction
%ebsd_full = x_section_correction(ebsd_full,'SPED','scan_rotation',90)
ebsd_mono = x_section_correction(ebsd_mono,'SPED','scan_rotation',90)

ebsd_mono = dataset_rotation(ebsd_mono,[0,25,0],'axis')
%ebsd_met = x_section_correction(ebsd_met,'SPED','scan_rotation',90)



%% ===========================================================================================================================================================================

otpt_tbl= grain_parameter_variation(ebsd_mono,'crys_sym',cs)
writetable(otpt_tbl,strcat(pname,Sample_ID,'_grain_param_variation.csv'))

%% ===========================================================================================================================================================================
%data_mono = [pname '1TD_no_LM_re_export_full.ctf'];
ebsd_mono = EBSD.load(data_mono,CS,'interface','ctf','convertSpatial2EulerReferenceFrame');
ebsd_mono = x_section_correction(ebsd_mono,'SPED','scan_rotation',90)
ebsd_mono = dataset_rotation(ebsd_mono,[0,25,0],'axis')

ebsd_mono_01 = ebsd_mono(ebsd_mono.mad>=0.01)
ebsd_mono_03 = ebsd_mono(ebsd_mono.mad>=0.03)
ebsd_mono_05 = ebsd_mono(ebsd_mono.mad>=0.05)
ebsd_mono_07 = ebsd_mono(ebsd_mono.mad>=0.07)
ebsd_mono_10 = ebsd_mono(ebsd_mono.mad>=0.1)
ebsd_mono_12 = ebsd_mono(ebsd_mono.mad>=0.12)
ebsd_mono_15 = ebsd_mono(ebsd_mono.mad>=0.15)

%%

%grains_full = create_grains(ebsd_full,'misorientation',15,'smallest_grain',1,'smoothing',1,'fill_gaps','no')
%grains_mono_a = create_grains(ebsd_mono,'misorientation',15,'smallest_grain',1,'smoothing',0,'fill_gaps','no','filter_type','none','filter_value',0,'phase_name','Monoclinic ZrO$$_2$$')
%grains_mono_fill = create_grains(ebsd_mono,'misorientation',15,'smallest_grain',1,'smoothing',1,'fill_gaps','no','assign_filter',0,'phase_name','Monoclinic ZrO$$_2$$')
%grains_mono_01 = create_grains(ebsd_mono_01,'misorientation',15,'smallest_grain',1,'smoothing',1,'fill_gaps','no','phase_name','Monoclinic ZrO$$_2$$')
%grains_mono_b = create_grains(ebsd_mono,'misorientation',15,'smallest_grain',1,'smoothing',1,'fill_gaps','no','filter_type','none','filter_value',0,'phase_name','Monoclinic ZrO$$_2$$')
%grains_mono_c = create_grains(ebsd_mono,'misorientation',15,'smallest_grain',1,'smoothing',2,'fill_gaps','no','filter_type','none','filter_value',0,'phase_name','Monoclinic ZrO$$_2$$')

%grains_mono_d = create_grains(ebsd_mono,'misorientation',15,'smallest_grain',1,'smoothing',3,'fill_gaps','no','filter_type','none','filter_value',0,'phase_name','Monoclinic ZrO$$_2$$')
%grains_mono_e = create_grains(ebsd_mono,'misorientation',15,'smallest_grain',1,'smoothing',5,'fill_gaps','no','filter_type','none','filter_value',0,'phase_name','Monoclinic ZrO$$_2$$')
%grains_mono_f = create_grains(ebsd_mono,'misorientation',15,'smallest_grain',1,'smoothing',10,'fill_gaps','no','filter_type','none','filter_value',0,'phase_name','Monoclinic ZrO$$_2$$')
%grains_met = create_grains(ebsd_met,'misorientation',15,'smallest_grain',5,'smoothing',5,'fill_gaps','no','phase_name','HCP Zr')



odf_00 = make_ODF(ebsd_mono('Monoclinic ZrO$$_2$$'))
odf_01 = make_ODF(ebsd_mono_01('Monoclinic ZrO$$_2$$'))
odf_03 = make_ODF(ebsd_mono_03('Monoclinic ZrO$$_2$$'))
odf_05 = make_ODF(ebsd_mono_05('Monoclinic ZrO$$_2$$'))
odf_07 = make_ODF(ebsd_mono_07('Monoclinic ZrO$$_2$$'))
odf_10 = make_ODF(ebsd_mono_10('Monoclinic ZrO$$_2$$'))
odf_15 = make_ODF(ebsd_mono_15('Monoclinic ZrO$$_2$$'))
%odf_data= calcODF(ebsd_mono('Monoclinic ZrO$$_2$$').orientations,'halfwidth', 3*degree)
%odf_metal= calcODF(ebsd_met('HCP Zr').orientations,'halfwidth', 3*degree)
desired_pole_figures = [[1,0,-3,"plane"];[0,0,1,"plane"];[1,1,1,"plane"]];
%desired_pole_figures_met = [[0,0,0,2,"plane"]];
%plot_pf(ebsd_mono,desired_pole_figures,'crys_sym',ebsd_mono('Monoclinic ZrO$$_2$$').CS)

cb_lim = 28

plot_pf(odf_00,desired_pole_figures,'crys_sym',ebsd_mono('Monoclinic ZrO$$_2$$').CS,'cbar_limit',cb_lim)

plot_pf(odf_01,desired_pole_figures,'crys_sym',ebsd_mono('Monoclinic ZrO$$_2$$').CS,'cbar_limit',cb_lim)
plot_pf(odf_03,desired_pole_figures,'crys_sym',ebsd_mono('Monoclinic ZrO$$_2$$').CS,'cbar_limit',cb_lim)
plot_pf(odf_05,desired_pole_figures,'crys_sym',ebsd_mono('Monoclinic ZrO$$_2$$').CS,'cbar_limit',cb_lim)
plot_pf(odf_07,desired_pole_figures,'crys_sym',ebsd_mono('Monoclinic ZrO$$_2$$').CS,'cbar_limit',cb_lim)
plot_pf(odf_10,desired_pole_figures,'crys_sym',ebsd_mono('Monoclinic ZrO$$_2$$').CS,'cbar_limit',cb_lim)
plot_pf(odf_15,desired_pole_figures,'crys_sym',ebsd_mono('Monoclinic ZrO$$_2$$').CS,'cbar_limit',cb_lim)
%plot_pf(odf_metal,desired_pole_figures_met,'crys_sym',ebsd_met('HCP Zr').CS)

odf_12 = make_ODF(ebsd_mono_12('Monoclinic ZrO$$_2$$'))
plot_pf(odf_12,desired_pole_figures,'crys_sym',ebsd_mono('Monoclinic ZrO$$_2$$').CS,'cbar_limit',cb_lim)

y_ax_max = 55
orientation_deviation_histogram_osc(ebsd_mono,'phase_name',phase_of_interest,'bin_size',1,'crys_sym',cs,'ref_text_comp',[1,0,-3],'max_y',y_ax_max,'y_scale','log')
orientation_deviation_histogram_osc(ebsd_mono_01,'phase_name',phase_of_interest,'bin_size',1,'crys_sym',cs,'ref_text_comp',[1,0,-3],'max_y',y_ax_max,'y_scale','log')
orientation_deviation_histogram_osc(ebsd_mono_03,'phase_name',phase_of_interest,'bin_size',1,'crys_sym',cs,'ref_text_comp',[1,0,-3],'max_y',y_ax_max,'y_scale','log')
orientation_deviation_histogram_osc(ebsd_mono_05,'phase_name',phase_of_interest,'bin_size',1,'crys_sym',cs,'ref_text_comp',[1,0,-3],'max_y',y_ax_max,'y_scale','log')
orientation_deviation_histogram_osc(ebsd_mono_07,'phase_name',phase_of_interest,'bin_size',1,'crys_sym',cs,'ref_text_comp',[1,0,-3],'max_y',y_ax_max,'y_scale','log')
orientation_deviation_histogram_osc(ebsd_mono_10,'phase_name',phase_of_interest,'bin_size',1,'crys_sym',cs,'ref_text_comp',[1,0,-3],'max_y',y_ax_max,'y_scale','log')
orientation_deviation_histogram_osc(ebsd_mono_12,'phase_name',phase_of_interest,'bin_size',1,'crys_sym',cs,'ref_text_comp',[1,0,-3],'max_y',y_ax_max,'y_scale','log')
orientation_deviation_histogram_osc(ebsd_mono_15,'phase_name',phase_of_interest,'bin_size',1,'crys_sym',cs,'ref_text_comp',[1,0,-3],'max_y',y_ax_max,'y_scale','log')

plot_map(ebsd_mono,'Deviation','phase_name','Monoclinic ZrO$$_2$$','ref_text_comp',[1,0,-3])
plot_map(ebsd_mono_01,'Deviation','phase_name','Monoclinic ZrO$$_2$$','ref_text_comp',[1,0,-3])
plot_map(ebsd_mono_03,'Deviation','phase_name','Monoclinic ZrO$$_2$$','ref_text_comp',[1,0,-3])
plot_map(ebsd_mono_05,'Deviation','phase_name','Monoclinic ZrO$$_2$$','ref_text_comp',[1,0,-3])
plot_map(ebsd_mono_07,'Deviation','phase_name','Monoclinic ZrO$$_2$$','ref_text_comp',[1,0,-3])
plot_map(ebsd_mono_10,'Deviation','phase_name','Monoclinic ZrO$$_2$$','ref_text_comp',[1,0,-3])
plot_map(ebsd_mono_12,'Deviation','phase_name','Monoclinic ZrO$$_2$$','ref_text_comp',[1,0,-3])
plot_map(ebsd_mono_15,'Deviation','phase_name','Monoclinic ZrO$$_2$$','ref_text_comp',[1,0,-3])

plot_map(ebsd_mono,'phase')
plot_map(ebsd_mono_01,'phase')
plot_map(ebsd_mono_03,'phase')
plot_map(ebsd_mono_05,'phase')
plot_map(ebsd_mono_07,'phase')
plot_map(ebsd_mono_10,'phase')
plot_map(ebsd_mono_12,'phase')
plot_map(ebsd_mono_15,'phase')

grains_mono = create_grains(ebsd_mono,'misorientation',15,'smallest_grain',1,'smoothing',1,'filter_type','none','filter_value',0,'fill_gaps','no')
grain_dimension_hist_ellipse(grains_mono,'bin_size',5,'max_size',500,'units','nm','max_percentage',10)

grains_01 =create_grains(ebsd_mono_01,'misorientation',15,'smallest_grain',1,'smoothing',1,'filter_type','none','filter_value',0,'fill_gaps','no')
grain_dimension_hist_ellipse(grains_01,'bin_size',5,'max_size',500,'units','nm','max_percentage',10)

grains_03 = create_grains(ebsd_mono_03,'misorientation',15,'smallest_grain',1,'smoothing',1,'filter_type','none','filter_value',0,'fill_gaps','no')
grain_dimension_hist_ellipse(grains_03,'bin_size',5,'max_size',500,'units','nm','max_percentage',10)

grains_05 = create_grains(ebsd_mono_05,'misorientation',15,'smallest_grain',1,'smoothing',1,'filter_type','none','filter_value',0,'fill_gaps','no')
grain_dimension_hist_ellipse(grains_05,'bin_size',5,'max_size',500,'units','nm','max_percentage',10)

grains_07 = create_grains(ebsd_mono_07,'misorientation',15,'smallest_grain',1,'smoothing',1,'filter_type','none','filter_value',0,'fill_gaps','no')
grain_dimension_hist_ellipse(grains_07,'bin_size',5,'max_size',500,'units','nm','max_percentage',10)

grains_10 = create_grains(ebsd_mono_10,'misorientation',15,'smallest_grain',1,'smoothing',1,'filter_type','none','filter_value',0,'fill_gaps','no')
grain_dimension_hist_ellipse(grains_10,'bin_size',5,'max_size',500,'units','nm','max_percentage',10)

grains_15 = create_grains(ebsd_mono_15,'misorientation',15,'smallest_grain',1,'smoothing',1,'filter_type','none','filter_value',0,'fill_gaps','no')
grain_dimension_hist_ellipse(grains_15,'bin_size',5,'max_size',500,'units','nm','max_percentage',10)


ebsd_mono_12 = ebsd_mono(ebsd_mono.mad>=0.12)
grains_12 = create_grains(ebsd_mono_12,'misorientation',15,'smallest_grain',1,'smoothing',1,'filter_type','none','filter_value',0,'fill_gaps','no')
grain_dimension_hist_ellipse(grains_12,'bin_size',5,'max_size',500,'units','nm','max_percentage',10)

plot_map(ebsd_mono_12,'Deviation','phase_name','Monoclinic ZrO$$_2$$','ref_text_comp',[1,0,-3])
%% ==================================================================================================================
%grains_mono_a = create_grains(ebsd_mono,'misorientation',15,'smallest_grain',1,'smoothing',0,'fill_gaps','no','filter_type','none','filter_value',0)
%%
%mODF = calcODF(grains_mono_a(phase_of_interest).meanOrientation,'halfwidth',3*degree)
%% ==================================================================================================================
%grain_details_a = grain_dimension_quant(grains_mono_a)
%grain_details_b = grain_dimension_quant(grains_mono_b)
%grain_details_c = grain_dimension_quant(grains_mono_c)
%grain_details_d = grain_dimension_quant(grains_mono_d)
%grain_details_e = grain_dimension_quant(grains_mono_e)
%grain_details_f = grain_dimension_quant(grains_mono_f)

%plot_map(ebsd_mono,'BC','gb_overlay',grains_mono,'phase_name','Monoclinic ZrO$$_2$$')
%plot_map(ebsd_mono,'BC','phase_name','Monoclinic ZrO$$_2$$')
%plot_map(grains_mono,'gb_only','phase_name','Monoclinic ZrO$$_2$$')
%%
%plot_map(grains_full,'phase')
%plot_map(grains_mono,'Deviation','phase_name','Monoclinic ZrO$$_2$$','ref_text_comp',[1,0,-3])
%plot_map(grains_mono_fill,'Deviation','phase_name','Monoclinic ZrO$$_2$$','ref_text_comp',[1,0,-3])
%plot_map(grains_mono_01,'Deviation','phase_name','Monoclinic ZrO$$_2$$','ref_text_comp',[1,0,-3])
%plot_map(grains_mono_02,'Deviation','phase_name','Monoclinic ZrO$$_2$$','ref_text_comp',[1,0,-3])
%plot_map(grains_mono_05,'Deviation','phase_name','Monoclinic ZrO$$_2$$','ref_text_comp',[1,0,-3])
%plot_map(grains_mono_10,'Deviation','phase_name','Monoclinic ZrO$$_2$$','ref_text_comp',[1,0,-3])
%plot_map(grains_met,'Deviation','phase_name','HCP Zr','crys_sym',ebsd_full('HCP Zr').CS,'ref_text_comp',[0,0,0,2],'view_unit_cell','CS')

%plot_substrate_mono(grains_met,grains_mono)

%combine_figures(f2,f3)

%grain_dimension_hist_ellipse(grains_mono,'bin_size',5,'max_size',500,'units','nm','max_percentage',10)
%orientation_deviation_histogram_osc(ebsd_mono,'bin_size',1,'max_y',15)
%orientation_deviation_histogram(ebsd_mono,'phase_name','Monoclinic ZrO$$_2$$')



%% Sign off
for n=1:1
    load gong
    sound(y,Fs)
    disp('FIN')
 
    figure;
    set(gca,'visible','off')
    text(0.3,0.4,'fin.', 'FontSize',100);
end






























