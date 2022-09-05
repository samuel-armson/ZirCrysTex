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


% Path to files. eg: 'J:/Nature Paper Figures/'
pname = 'D:/Sam/Dropbox (The University of Manchester)/Sam Armson shared folder/Experimental/SPED/2022_ctf_comp/';

data_mono_38NVa1= [pname '38NV_full_stitched.ctf'];
data_mono_1TDa1 = [pname '1TD_no_LM_re_export_mono.ctf'];
data_mono_2NVa3 = [pname '2NV_NO_LM_FINAL_full.ctf'];
data_mono_LOWDR = [pname 'LOW DR LARGE_22_mono.ctf'];
data_mono_MEDDR = [pname 'MIBL MED DR_22_mono.ctf'];
data_mono_HIGH = [pname 'MIBL HIGH DR FUZZ_22_mono.ctf']
%data_mono_EXHI3 = [pname 'MIBL EX HIGH DR 3/MIBL EX HIGH DR 3 R_1.6_EE_0.4_more_phases_index400_or_1_mono.ctf'];
data_mono_EXHI2= [pname 'MIBL_EX_HIGH_DR_2_22_mono.ctf'];

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

% Perform cross-section correction
ebsd_mono_38NVa1 = x_section_correction(ebsd_mono_38NVa1,'SPED','scan_rotation',270)
ebsd_mono_1TDa1 = x_section_correction(ebsd_mono_1TDa1,'SPED','scan_rotation',90)
ebsd_mono_2NVa3 = x_section_correction(ebsd_mono_2NVa3,'SPED','scan_rotation',90)
ebsd_mono_LOWDR = x_section_correction(ebsd_mono_LOWDR,'SPED','scan_rotation',90)
ebsd_mono_MEDDR = x_section_correction(ebsd_mono_MEDDR,'SPED','scan_rotation',90)
ebsd_mono_HIGH = x_section_correction(ebsd_mono_HIGH,'SPED','scan_rotation',90)
%ebsd_mono_EXHI3 = x_section_correction(ebsd_mono_EXHI3,'SPED','scan_rotation',90)
ebsd_mono_EXHI2 = x_section_correction(ebsd_mono_EXHI2,'SPED','scan_rotation',90)

%ebsd_mono_2NVa3 = dataset_rotation(ebsd_mono_2NVa3,[0,0,-5],'axis','keep','keepXY');
ebsd_mono_LOWDR = dataset_rotation(ebsd_mono_LOWDR,[0,20,0],'axis')
ebsd_mono_MEDDR = dataset_rotation(ebsd_mono_MEDDR,[0,25,0],'axis');

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
name_list = {'AC 350','AC 400','AC 450','MIBL Low DR','MIBL Med DR','MIBL High DR','MIBL Ex High DR'}
mono_ebsd_list = {ebsd_mono_38NVa1,ebsd_mono_1TDa1,ebsd_mono_2NVa3,ebsd_mono_LOWDR,ebsd_mono_MEDDR,ebsd_mono_HIGH,ebsd_mono_EXHI2}



for sgi = 1:length(mono_ebsd_list)
  disp(name_list{1,sgi})
  if strcmp(name_list{1,sgi},'AC 350') == 1
    otpt_tbl= grain_parameter_variation(mono_ebsd_list{1,sgi},'crys_sym',cs)
  elseif strcmp(name_list{1,sgi},'MIBL Ex High DR') == 1
    otpt_tbl= grain_parameter_variation(mono_ebsd_list{1,sgi},'crys_sym',cs)
  else
    %otpt_tbl= grain_parameter_variation(mono_ebsd_list{1,sgi},'crys_sym',cs,'small_removal_method','corr_3_by_3')
    otpt_tbl= grain_parameter_variation(mono_ebsd_list{1,sgi},'crys_sym',cs)
  end
  writetable(otpt_tbl,strcat(pname,name_list{1,sgi},'no_px_corr_grain_param_variation.csv'))
end


%% Sign off
for n=1:1
    load gong
    sound(y,Fs)
    disp('FIN')
 
    figure;
    set(gca,'visible','off')
    text(0.3,0.4,'fin.', 'FontSize',100);
end































































