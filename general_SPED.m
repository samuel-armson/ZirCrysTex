
% Saving figures takes time. Best to only use on final run: 'on' or 'no'. Apply to all functions here.
save_figures = 'no';

% Sample ID: name given to saved output figures. Choose to ensure that other files aren't overwritten    
Sample_ID = "2NVa3";
% Path to files. eg: 'J:/Nature Paper Figures/'
pname = 'D:/Sam/Dropbox (The University of Manchester)/Sam Armson shared folder/Experimental/SPED/MIBL EX HIGH DR 3/';

% File name with pname prefix, eg: [pname 'SPED_Substrate_MARIA.ctf']
fname_full = [pname 'MIBL EX HIGH DR 3 R_1.6_EE_0.4_more_phases_index400_or_1.ctf'];

% Phase of interest for orientation analysis - select here for global phase of interest.

phase_of_interest = 'Monoclinic ZrO$$_2$$';


% Reference texture component. Used for plotting angular deviation of points from. Used for colouring and histogram (if desired).
reference_texture_component = [1,0,-3];

% UPDATE THIS ACCORDING TO YOUR CTF FILE.
% crystal symmetry
CS = {... 
  'notIndexed',...
  crystalSymmetry('12/m1', [5.169 5.232 5.341], [90,99,90]*degree, 'X||a*', 'Y||b*', 'Z||c', 'mineral', 'Monoclinic ZrO$$_2$$', 'color', [27 81 45]/255),...
  crystalSymmetry('6/mmm', [5.312 5.312 3.197], 'X||a*', 'Y||b', 'Z||c*', 'mineral', 'Hexagonal ZrO', 'color', [239 202 8]/255),...
  crystalSymmetry('4/mmm', [3.596 3.596 5.184], 'mineral', 'Tetragonal ZrO$$_2$$', 'color', [208 37 48]/255),...
  crystalSymmetry('6/mmm', [3.232 3.232 5.147], 'X||a*', 'Y||b', 'Z||c*', 'mineral', 'HCP Zr', 'color', [75 154 170]/255),...
  crystalSymmetry('4/mmm', [3.52 3.52 4.45], 'mineral', 'Zr Hydride', 'color', [240 135 0]/255),...
  crystalSymmetry('-3m1', [5.038 5.038 13.772], 'X||a*', 'Y||b', 'Z||c*', 'mineral', 'Hematite', 'color',[99 38 74]/255),...
  crystalSymmetry('m-3m', [4.086 4.086 4.086], 'mineral', 'Amorphous Pt', 'color', [100 100 100]/255)};



  
% plotting convention
setMTEXpref('xAxisDirection','east');
setMTEXpref('zAxisDirection','outOfPlane');

% load EBSD data
ebsd = loadEBSD(fname_full,CS,'interface','ctf','convertSpatial2EulerReferenceFrame');
% globally define crystal symmetry of phase of interest
cs = ebsd(phase_of_interest).CS

% Perform cross-section correction
ebsd = x_section_correction(ebsd,'SPED','scan_rotation',90)
%ebsd = dataset_rotation(ebsd,[0,0,90],'axis');

%fibre_comp = define_fibre(reference_texture_component,cs)

grains1 = create_grains(ebsd,'misorientation',10,'smallest_grain',2,'smoothing',1,'fill_gaps','no')
%odf = make_ODF(ebsd)
%odf_data= calcODF(ebsd(phase_of_interest).orientations,'halfwidth', 3*degree)

%desired_pole_figures = [[1,0,-3,"plane"];[1,0,-4,"plane"];[1,0,-5,"plane"];[1,0,-6,"plane"]];

%plot_pf(ebsd,desired_pole_figures)
%plot_pf(odf_data,desired_pole_figures)

plot_map(ebsd,'BC')
%plot_map(ebsd,'IPF','plot_key','off')
%plot_map(grains1,'Deviation')
%plot_map(ebsd,'Deviation','plot_key','off')
plot_map(ebsd,'phase')
plot_map(grains1,'phase')

%grain_area_hist(grains1,'bin_size',1,'max_size',50,'units','nm')
%grain_dimension_hist(grains1,'bin_size',0.001,'max_size',0.03,'units','nm','max_percentage',6)


%% Sign off
for n=1:1
    load gong
    sound(y,Fs)
    disp('FIN')
 
    figure;
    set(gca,'visible','off')
    text(0.3,0.4,'fin.', 'FontSize',100);
end































