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
Sample_ID = "Slice 207";
% Path to files. eg: 'J:/Nature Paper Figures/'
pname = 'D:/Sam/Dropbox (The University of Manchester)/Dream 3D files/';

% File name with pname prefix, eg: [pname 'SPED_Substrate_MARIA.ctf']
data_1 = [pname 'Slice_207.ctf'];



% Phase of interest for orientation analysis - select here for global phase of interest.
phase_of_interest = 'HCP Zr';

% Reference texture component. Used for plotting angular deviation of points from. Used for colouring and histogram (if desired).
reference_texture_component = [0,0,0,2];

% UPDATE THIS ACCORDING TO YOUR CTF FILE.
% crystal symmetry

CS = cs_loader({'metal'})
  
% plotting convention
setMTEXpref('xAxisDirection','east');
setMTEXpref('zAxisDirection','outOfPlane');

% load EBSD data
ebsd_1 = loadEBSD(data_1,CS,'interface','ctf','convertSpatial2EulerReferenceFrame');
ebsd_1 = ebsd_1.gridify;


% globally define crystal symmetry of phase of interest
cs = ebsd_1(phase_of_interest).CS

% Perform cross-section correction
%ebsd_1 = x_section_correction(ebsd_1,'EBSD','scan_rotation',180)
ebsd_1 = dataset_rotation(ebsd_1,[0,0,180],'axis')
grains_1 = create_grains(ebsd_1,'misorientation',5,'smallest_grain',1,'smoothing',3,'fill_gaps','no')


ebsd_mis=ebsd_1(phase_of_interest)
[grains_mis,ebsd_mis.grainId] = calcGrains(ebsd_mis(phase_of_interest),'unitCell')
ebsd_mis(grains_mis(grains_mis.grainSize <= 1)) = [];
[grains_mis,ebsd_mis.grainId] = calcGrains(ebsd_mis(phase_of_interest),'angle',5*degree,'unitCell','smoothing',3);

% smooth grain boundaries
grains_mis = smooth(grains_mis,3);


%grains_1_fill = create_grains(ebsd_1,'misorientation',15,'smallest_grain',1,'smoothing',3,'fill_gaps','yes')



%odf_data= calcODF(ebsd_1(phase_of_interest).orientations,'halfwidth', 3*degree)
%desired_pole_figures = [[0,0,0,2,"plane"];[1,1,-2,0,"plane"]];
%plot_pf(ebsd_1,desired_pole_figures,'crys_sym',ebsd_1(phase_of_interest).CS)
%plot_pf(odf_data,desired_pole_figures,'crys_sym',ebsd_1(phase_of_interest).CS)
%plot_pf(ebsd_mis,desired_pole_figures,'crys_sym',ebsd_mis(phase_of_interest).CS,'colouring','IPF')

%%
%ebsd_single = ebsd_mis(grains_mis(171))
%odf_single= calcODF(ebsd_single(phase_of_interest).orientations,'halfwidth', 3*degree)
desired_pole_figures = [[0,0,0,2,"plane"];[1,1,-2,0,"plane"]];
plot_pf(ebsd_1,desired_pole_figures,'crys_sym',ebsd_1(phase_of_interest).CS,'colouring','IPF')
%plot_pf(grains_1,desired_pole_figures,'crys_sym',ebsd_1(phase_of_interest).CS,'colouring','IPF')
%plot_pf(odf_single,desired_pole_figures,'crys_sym',ebsd_single(phase_of_interest).CS)
%plot_pf(ebsd_single,desired_pole_figures,'crys_sym',ebsd_single(phase_of_interest).CS,'colouring','IPF')
%%
%plot_map(ebsd_mono,'BC','gb_overlay',grains_mono,'phase_name','Monoclinic ZrO$$_2$$')
%plot_map(ebsd_mono,'BC','phase_name','Monoclinic ZrO$$_2$$')
%plot_map(grains_mono,'gb_only','phase_name','Monoclinic ZrO$$_2$$')

bounds_1 = grains_1.boundary(phase_of_interest,phase_of_interest)

plot_map(grains_1,'IPF','phase_name','HCP Zr','crys_sym',ebsd_1('HCP Zr').CS,'ref_text_comp',[0,0,0,2],'plot_key','on','ipf_key',ipfHSVKey(cs.Laue),'facealpha',0.5)
figure()
plot(bounds_1,bounds_1.misorientation.angle./degree,'linewidth',2)
mtexColorMap LaboTeX
mtexColorbar('title','misorientation angle')

figure()
plot(bounds_1,bounds_1.misorientation.angle./degree,'linewidth',2)
mtexColorMap parula
mtexColorbar('title','misorientation angle')


plot_map(grains_1,'IPF','phase_name','HCP Zr','crys_sym',ebsd_1('HCP Zr').CS,'ref_text_comp',[0,0,0,2])
plot_map(ebsd_1,'IPF','phase_name','HCP Zr','crys_sym',ebsd_1('HCP Zr').CS,'ref_text_comp',[0,0,0,2])

%plot_map(ebsd_1,'Euler','phase_name','HCP Zr','crys_sym',ebsd_1('HCP Zr').CS,'ref_text_comp',[0,0,0,2])


%plot_map(ebsd_1,'BC','phase_name','HCP Zr','crys_sym',ebsd_1('HCP Zr').CS,'ref_text_comp',[0,0,0,2])


%plot_map(grains_1,'gb_only','phase_name','HCP Zr')


%plot_map(ebsd_1,'Deviation','phase_name','HCP Zr','crys_sym',ebsd_1('HCP Zr').CS,'ref_text_comp',[0,0,0,2])
%plot_map(ebsd_2,'Deviation','phase_name','HCP Zr','crys_sym',ebsd_1('HCP Zr').CS,'ref_text_comp',[0,0,0,2])
%%
%plot_map(grains_1,'Deviation','phase_name','HCP Zr','crys_sym',ebsd_1('HCP Zr').CS,'ref_text_comp',[0,0,0,2],'view_unit_cell','PV')
plot_map(grains_1,'Deviation','phase_name','HCP Zr','crys_sym',ebsd_1('HCP Zr').CS,'ref_text_comp',[0,0,0,2],'view_dev_val','yes')


%plot_map(ebsd_1,'Deviation','phase_name','HCP Zr','crys_sym',ebsd_1('HCP Zr').CS,'ref_text_comp',[0,0,0,2])

%plot_map(grains_1_fill,'Deviation','phase_name','HCP Zr','crys_sym',ebsd_1('HCP Zr').CS,'ref_text_comp',[0,0,0,2],'view_unit_cell','CS')
%plot_map(grains_2_fill,'Deviation','phase_name','HCP Zr','crys_sym',ebsd_1('HCP Zr').CS,'ref_text_comp',[0,0,0,2],'view_unit_cell','CS')

%% Hmm

output_1 = 'D:/Sam/Dropbox (The University of Manchester)/NanoSIMS data for collab/EBSD/104JX/2020_10_14/crystal_shapes/'


%plot_map(grains_mis,'numbered_orientations','phase_name','HCP Zr','crys_sym',ebsd_1('HCP Zr').CS,'ref_text_comp',[0,0,0,2],'view_unit_cell','no','output_dir',output_1)


%combine_figures(f2,f3)

%grain_dimension_hist_ellipse(grains_mono,'bin_size',5,'max_size',250,'units','nm','max_percentage',20)
%orientation_deviation_histogram(ebsd_mono,'phase_name','Monoclinic ZrO$$_2$$')

%{
figure()
kam = ebsd_1.KAM./degree;
% lets plot it
plot(ebsd_1,kam,'micronbar','off')
set(gca,'Color','black');
caxis([0,5])
mtexColorbar('title','.KAM function')
mtexColorMap LaboTeX
hold on
plot(grains_1.boundary,'lineWidth',0.5)
plot(grains_1.innerBoundary,'edgeAlpha',grains_1.innerBoundary.misorientation.angle / (3*degree))
hold off

figure()
% plot the misorientation angle of the GROD
plot(grains_1,grains_1.GOS,'micronbar','off')
mtexColorbar('title','.GOS function')
set(gca,'Color','black');
mtexColorMap LaboTeX
hold on 
plot(grains_mis.innerBoundary,'edgeAlpha',grains_mis.innerBoundary.misorientation.angle / (3*degree))
hold off



figure()
grod = ebsd_mis.calcGROD(grains_mis);
% plot it
plot(ebsd_mis, grod.angle./degree,'micronbar','off')
mtexColorbar('title','calcGROD function')
set(gca,'Color','black');
mtexColorMap LaboTeX
hold on
plot(grains_mis.boundary,'lineWidth',1.5)
hold off

figure()
gos_from_grod = grainMean(ebsd_mis,grod.angle);
% plot it
plot(grains_mis, gos_from_grod./degree,'micronbar','off')
mtexColorbar('title','GOS from .calcGROD')
set(gca,'Color','black');
mtexColorMap LaboTeX
hold on
plot(grains_mis.boundary,'lineWidth',0.5)
hold off


figure()
% compute the maximum misorientation angles for each grain
MGOS = grainMean(ebsd_mis,grod.angle,@max);
% plot it
plot(grains_mis, MGOS ./ degree)
mtexColorbar('title','MGOS from calcGROD')
set(gca,'Color','black');
mtexColorMap LaboTeX


figure()
gam = ebsd_mis.grainMean(ebsd_mis.KAM);
plot(grains_mis,gam./degree)
mtexColorbar('title','GAM from KAM')
set(gca,'Color','black');
mtexColorMap LaboTeX


% overlay grain and subgrain boundaries
hold on
plot(grains_1.boundary,'lineWidth',0.5)
hold off
%}
%%
figure()
gam = ebsd_mis.grainMean(ebsd_mis.KAM);
plot(grains_mis,gam./degree)
mtexColorbar('title','GAM from KAM')
hold on
text(grains_mis,gam./degree)

set(gca,'Color','black');
mtexColorMap LaboTeX
disp(gam)

%% Sign off
for n=1:1
    load gong
    sound(y,Fs)
    disp('FIN')
 
    figure;
    set(gca,'visible','off')
    text(0.3,0.4,'fin.', 'FontSize',100);
end































