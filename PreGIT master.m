%% Importing packages
for n=1:1
  addpath 'C:/Users/Rhys/My Documents/MATLAB/mtex-5.1.1';
  %addpath 'C:/Users/Sam/My Documents/MATLAB/mtex-5.2.8';
  addpath 'C:/Users/Sam/My Documents/MATLAB/Colormaps/Colormaps (5)/Colormaps'; %Adds matplotlib colormaps
  addpath 'C:/Users/Sam/My Documents/MATLAB/subtightplot/subtightplot';
  addpath 'C:/Users/Sam/My Documents/MATLAB/altmany-export_fig-3175417'; 
  startup_mtex
end
 
 
 
%% SAMPLE SPECIFIC PARAMETERS - EX HIGH DR 0.4EE FUZZY MASK ABIGUITIES RESOLVED        
%=======================================================================================================================================================================================================
for n=1:1
 
  %I have written this script so that I should only need to change values in this 'cell' in order to make any changes so that I don't need to go searching through the code and changing 
  %loads of things when I am looking for something different from a different ctf. Hopefully everything you need to change is also in this cell. Feel free to edit the main bodies of code for your needs.
  %I have put all of the individual cells/sections inside pointless loops so that they can be minimised using right click - code folding. This way you can more easily navigate things.
 
  %Saving figures takes time. Best to only use on final run: 'on' or 'no'.
  save_figures = 'no';
   
  %Main texture component - enter as list. This is the 'fibre'/'misorientation' plane normal.
  main_texture_component = [1,0,-3]
  %These are included for pltting lattice matching components side by side - when the lattice matching option is deselected below they don't do anything. Not really that useful anymore.
  lattice_matching_planar_component = [1,1,-2]
  lattice_matching_direction_component = [1,1,1]
 
  %Texture components for plotting pole figures comment-out / edit as needed
  %Format egs: [[1,1,1,"plane"];[0,0,1,"plane"]] or [[0,0,0,1,"direction"];[0,1,-2,0,"plane"]] etc.
  desired_pole_figures = [[1,0,-3,"plane"];[1,0,-4,"plane"];[1,0,-5,"plane"];[1,0,-6,"plane"]];
  %Projection type for pole figures. Accepts 'earea','edist', or 'eangle'
  projection_type = 'earea'
 
  %Phase of orientation to be plotted. 
  phase_of_interest = 'Monoclinic ZrO$$_2$$'
  
  
  %Method aquisition: ASTAR, EBSD, OR CSEBSD
  %ASTAR applies an orientation of -18deg to phi1 to compensate for scan
  %rotation and DP rotation at 43k. CSEBSD and ASTAR rotate data for cross section (ND parallel to y) .
  %EBSD applies no automatic rotation.
  aquisition_type = 'ASTAR'
  %Scan rotation for ASTAR or Cross-section EBSD. Couldn't be bothered to
  %change name when CS EBSD functionality was added.IF NORMAL EBSD IS
  %SELECTED ROTATION WON'T BE APPLIED
  ASTAR_scan_rotation = 90
 
 
  %ASTAR DATA FILTERING
  %ASTAR allows you to remove pixels according to mimnium index correlation and orientation reliability.
  %To explore the effects of different filtering in mTeX we would have to produce loads of ctf files from the ASTAR software.
  %By defining the limits below we can use one unfiltered ctf to llok at different filters.
  %COMMENT OUT IF NOT REQUIRED
  
  %index_correlation_min = 400
  %index_correlation_max = 400
  %orientation_reliability_min = 10
  %orientation_reliability_max = 10
 
  
  %Sample ID: name given to saved output figures. Choose to ensure that other files aren't overwritten    
  Sample_ID = "MIBL EX HIGH DR 0.8 EE FUZZY MASK TESTING FILTERS"
   
  % path to files. eg: 'J:\Nature Paper Figures\'
  pname = 'J:\MIBL SAMPLES\EX HIGH DR';
  %Full area file name, eg: [pname 'SPED_Substrate_MARIA.ctf']
  fname_full = [pname '\EX HIGH DR 2 EE_0.8 FUZZY MASK.ctf'];
 
  %OMR_file_names is used for importing multiple ctfs at once for pole figure comparison. I use it for looking at different oxide microtexture regions from subsets of a full ctf. If left empty, it won't do anything.
  %List of OMR file names - 6 MAXIMUM - need double quotation marks delimited by comma
  OMR_file_names = []  
 
  %Colormap choice (For fibre deviation coloring of scatter pole figures, histogram, and orientation map)
  %Choose from custom colormaps: "Discreet_BOGRPG" ; "Discreet_PBROGG" ; "Parula_maroon_spec_deg_inc", "Viridis_maroon_spec_deg_inc". 
  %OR native colormap (no quotes). Must have(90/Angle_increment_cmap)suffix. eg. colormap_choice = jet(90/Angle_increment_cmap).
  %Custom colormaps can be edited under "%%Define colormaps - Line 359ish if desired." I use this Parula_maroon_spec_deg_inc (shit name, I know) colormap which shows a nice linear scale up to 70, which then changes to maroon. This way, you get a clearer difference in
  %colour for the region you are interested in. This limit can be adjusted in by the Parula_limit variable on line 66.
  colormap_choice = "Parula_maroon_spec_deg_inc" 
  %'Resolution' of colour map. 5 degree steps are nice.
  Angle_increment_cmap = 5;
  %Values for Parula_maroon_spec_deg_inc colorbar. Point where parula colorbar turns to maroon.
  Parula_limit = 70;
  
  %Histogram parameters: max_angle_degs = coverage of histogram. The colorbar described above allows you to reduce the scale to show more important features while still plotting all data.
  %max_angle_degs removes this data entirely. I just leave it a 90 - I used it before I made the colorbar described above.
  %Histogram parameters: Discrete_color_quant = number of bins in histogram. The colouring of the histogram and map still follows the binning in Angle_increment_cmap, but Discrete_color_quant
  %allows you to visualise those bins broken-up into subdivisions. Here, I use 90 bins, so each bin corresponds to 1 degree. 
  max_angle_degs = 90; 
  Discrete_color_quant = 90;
  %Gives angle deviation above this angle an alpha of 0.1. Allows you to highlight small deviations while all other data with high transparency. Set to 90 for to leave as normal.
  angle_histogram_highlight = 90
  
  %ODF parametes - parameters to be used when calculating ODFs
  half_width = 3
  grid_line_spacing = 90
  
  %ODF colorbar options. These parameters allow you to choose the limits of pole figure contours incase you need to make lower intensities visible, but on the same scale as high intensities.
  %You set the main_texture_component_colorbar_limit to the maximum value (by running the script once and seeing the max value returned on the figure), then playing around with main_texture_component_saturated_limit
  %in order to change the scale. If they are set the same they behave as normal. 
  main_texture_component_saturated_limit = 200
  main_texture_component_colorbar_limit = 430
 
  %These are for the same as before, but for plotting specific lattice matching things for oxide - irrelevant for you, but don't want to delete in case it breaks stuff.
  lattice_matching_planar_component_saturated_limit = 90
  lattice_matching_planar_component_colorbar_limit = 220
 
  lattice_matching_direction_component_saturated_limit = 45
  lattice_matching_direction_component_colorbar_limit = 110
 
  
  % UPDATE THIS ACCORDING TO YOUR CTF FILE.
  % crystal symmetry
    % crystal symmetry
  CS = {...
    'notIndexed',...
    crystalSymmetry('m-3m', [4.086 4.086 4.086], 'mineral', 'Amorphous', 'color', 'cyan'),...
    crystalSymmetry('12/m1', [5.169 5.232 5.341], [90,99,90]*degree, 'X||a*', 'Y||b*', 'Z||c', 'mineral', 'Monoclinic ZrO$$_2$$', 'color', [34, 111, 84]/255),...
    crystalSymmetry('4/mmm', [3.596 3.596 5.184], 'mineral', 'Tetragonal ZrO$$_2$$', 'color', [160, 35, 41]/255),...
    crystalSymmetry('6/mmm', [3.232 3.232 5.147], 'X||a*', 'Y||b', 'Z||c*', 'mineral', 'HCP Zr', 'color', [2, 123, 206]/255),...
    crystalSymmetry('6/mmm', [5.312 5.312 3.197], 'X||a*', 'Y||b', 'Z||c*', 'mineral', 'H-Suboxide', 'color', [227, 181, 5]/255)};
 
 
  % plotting convention
  setMTEXpref('xAxisDirection','east');
  setMTEXpref('zAxisDirection','outOfPlane');
 
 
  % SELECT MAPS TO BE DISPLAYED-----------------
  % Toggle 'Y' and 'N' to plot. I think I have selected the ones you would be interested in. 
 
  RAW_IPF_MAP = 'Y'
  RAW_PHASE_MAP = 'Y'
  RAW_EULER_MAP = 'N'
  RAW_FIBRE_MAP_QUANT = 'Y'
  RAW_FIBRE_HIST_QUANT = 'Y'
  RAW_PF_SCATTER_FULL = 'Y' 
  RAW_PF_SCATTER_SUBSETS = 'N'
  RAW_PF_ODF_FULL = 'Y'
  RAW_PF_ODF_SUBSETS = 'N'
  RAW_PF_SCATTER_SUBSETS_LM_PLANAR = 'N'
  RAW_PF_ODF_SUBSETS_LM_PLANAR = 'N'
  RAW_PF_SCATTER_SUBSETS_LM_DIRECTION = 'N'
  RAW_PF_ODF_SUBSETS_LM_DIRECTION = 'N'
  GRAIN_CALCULATION = 'Y'
  GRAIN_IPF_MAP = 'Y'
  GRAIN_FIBRE_MAP = 'Y'
  RAW_FIBRE_MAP_QUAL = 'N'
  RAW_FIBRE_HIST_QUAL = 'N'
  GRAIN_PHASE_MAP = 'Y'
  GRAIN_STATS = 'Y'
  VIEW_CRYSTAL = 'N'
 
  %---------------------------------------------
  % Apply rotation------------------------------
  % Rotations to be applied after ASTAR rotation
  % All possibilities to apply rotations to correct for sample mounting etc. 
  % Generally best to stick to one method.
 
  % Rotate orientation data WITHOUT rotating map
  % bunge notations
  keep_xy_correction_angle_phi1 = 0
  keep_xy_correction_angle_phi = 0
  keep_xy_correction_angle_phi2 = 0
  % about axis
  keep_xy_correction_angle_about_x = 0
  keep_xy_correction_angle_about_y = 70
  keep_xy_correction_angle_about_z = 0
 
  % Rotate map WITHOUT rotating orientation data
  % about axis
  keep_euler_correction_angle_about_x = 0
  keep_euler_correction_angle_about_y = 0
  keep_euler_correction_angle_about_z = 0
  
  % Rotate map AND orientation data
  % bunge notation
  change_xy_correction_angle_phi1 = 0
  change_xy_correction_angle_phi = 0
  change_xy_correction_angle_phi2 = 0
  % about axis
  change_xy_correction_angle_about_x = 0
  change_xy_correction_angle_about_y = 0
  change_xy_correction_angle_about_z = 0
  
  %---------------------------------------------
  %If you select one of the discreet colormaps above, these values dictate the ranges. for different colours. They allow you to arbitrarily highlight specific misorientations
  %Comment out if colour not required - colour ranges for qualitative map. To display, toggle  RAW_FIBRE_MAP_QUAL = 'Y' RAW_FIBRE_HIST_QUAL = 'Y' above. If these aren't toggled,
  %the variables below won't do anything.
 
  qual_map_blue_min = 8
  qual_map_blue_max = 12
  
  qual_map_orange_min = 19
  qual_map_orange_max = 23
  
  qual_map_green_min = 54
  qual_map_green_max = 58
 
  qual_map_red_min = 65
  qual_map_red_max = 69
 
  %qual_map_purple_min = 59
  %qual_map_purple_max = 63
 
  %qual_map_pink_min = 76
  %qual_map_pink_max = 81
 
  
  %---------------------------------------------
  %Grain calculation parameters - standard parameters for grain calc function.
  Small_grain_param = 3
  Grain_mis_param = 15*degree
  Grain_smooth_param = 3
 
  %Aspect ratio fudge factor for equal height of colorbar and map for fibre deviation maps - purely for changing the appearance and size of figures.
  aspect_ratio_shift = 0.8
 
end
%=======================================================================================================================================================================================================
 
%% Imports and prelimninary calculations
for n=1:1
  % Import parent full file. 
  ebsd_full = loadEBSD(fname_full,CS,'interface','ctf',...
    'convertSpatial2EulerReferenceFrame')
 
  % ASTAR DATA ROTATIONS
  if strcmp(aquisition_type,'ASTAR') == 1
      inherent_phi1_correction = rotation('Euler',18*degree,0,0)
      scan_rotation_correction = rotation('axis',zvector,'angle',ASTAR_scan_rotation*degree);
      cross_section_correction = rotation('axis',xvector,'angle',90*degree)
      ebsd_full = rotate(ebsd_full,inherent_phi1_correction,'keepXY');
      ebsd_full = rotate(ebsd_full,scan_rotation_correction);
      ebsd_full = rotate(ebsd_full,cross_section_correction,'keepXY');
  end
 
   % CSEBSD DATA ROTATIONS
  if strcmp(aquisition_type,'CSEBSD') == 1
      scan_rotation_correction = rotation('axis',zvector,'angle',ASTAR_scan_rotation*degree);
      cross_section_correction = rotation('axis',xvector,'angle',90*degree)
      ebsd_full = rotate(ebsd_full,scan_rotation_correction);
      if VIEW_CRYSTAL == 'Y'
        ebsd_data_for_crystal_shapes = ebsd_full
      end
      ebsd_full = rotate(ebsd_full,cross_section_correction,'keepXY');
  end
 
 
  %Rotate Euler - maintain xy
  keep_xy_euler_rotation = rotation('Euler',keep_xy_correction_angle_phi1*degree,keep_xy_correction_angle_phi*degree,keep_xy_correction_angle_phi2*degree);
  keep_xy_x_axis_rot = rotation('axis',xvector,'angle',keep_xy_correction_angle_about_x*degree);
  keep_xy_y_axis_rot = rotation('axis',yvector,'angle',keep_xy_correction_angle_about_y*degree);
  keep_xy_z_axis_rot = rotation('axis',zvector,'angle',keep_xy_correction_angle_about_z*degree);
  %Rotate Euler - rotate xy
  change_xy_euler_rotation = rotation('Euler',change_xy_correction_angle_phi1*degree,change_xy_correction_angle_phi*degree,change_xy_correction_angle_phi2*degree);
  change_xy_x_axis_rot = rotation('axis',xvector,'angle',change_xy_correction_angle_about_x*degree);
  change_xy_y_axis_rot = rotation('axis',yvector,'angle',change_xy_correction_angle_about_y*degree);
  change_xy_z_axis_rot = rotation('axis',zvector,'angle',change_xy_correction_angle_about_z*degree);
  %Rotate XY - maintatin Euler
  keep_euler_x_axis_rot = rotation('axis',xvector,'angle',keep_euler_correction_angle_about_x*degree);
  keep_euler_y_axis_rot = rotation('axis',yvector,'angle',keep_euler_correction_angle_about_y*degree);
  keep_euler_z_axis_rot = rotation('axis',zvector,'angle',keep_euler_correction_angle_about_z*degree);
  %perform rotations
  %maintain xy
  ebsd_full = rotate(ebsd_full,keep_xy_euler_rotation,'keepXY');
  ebsd_full = rotate(ebsd_full,keep_xy_x_axis_rot,'keepXY');
  ebsd_full = rotate(ebsd_full,keep_xy_y_axis_rot,'keepXY');
  ebsd_full = rotate(ebsd_full,keep_xy_z_axis_rot,'keepXY');
  %rotate xy
  ebsd_full = rotate(ebsd_full,change_xy_euler_rotation);
  ebsd_full = rotate(ebsd_full,change_xy_x_axis_rot);
  ebsd_full = rotate(ebsd_full,change_xy_y_axis_rot);
  ebsd_full = rotate(ebsd_full,change_xy_z_axis_rot);
  %maintain euler
  ebsd_full = rotate(ebsd_full,keep_euler_x_axis_rot,'keepEuler');
  ebsd_full = rotate(ebsd_full,keep_euler_y_axis_rot,'keepEuler');
  ebsd_full = rotate(ebsd_full,keep_euler_z_axis_rot,'keepEuler');
 
 
  index_correlation_min = 0
  index_correlation_max = 400
  orientation_reliability_min = 0
  orientation_reliability_max = 10
 
  %Filter according ASTAR parameters. Before trying to do so, we must check that the variables exist (ie, not commented out as not required)
  if exist('index_correlation_min','var') == 1
    ebsd_full(ebsd_full.bc<index_correlation_min).phase=0;
    Sample_ID = strcat(Sample_ID," IC_min ",char(index_correlation_min));
  end
  if exist('index_correlation_max','var') == 1
    ebsd_full(ebsd_full.bc>index_correlation_max).phase=0;
    Sample_ID = strcat(Sample_ID," IC_,max ",char(index_correlation_max));
  end
  if exist('orientation_reliability_min','var') == 1
    ebsd_full(ebsd_full.mad<(orientation_reliability_min/100)).phase=0;
    Sample_ID = strcat(Sample_ID," OR_min ",char(orientation_reliability_min));
  end
  if exist('orientation_reliability_max','var') == 1
    ebsd_full(ebsd_full.mad>(orientation_reliability_max/100)).phase=0;
    Sample_ID = strcat(Sample_ID," OR_max ",char(orientation_reliability_max));
  end
 
  %Define symmetry
  cs=ebsd_full(phase_of_interest).CS
 
  Sample_ID_char = char(Sample_ID)
  Sample_ID_char = strcat(pname,Sample_ID_char)
 
  index_size = size(main_texture_component)
 
  tex_vals = strings(1,index_size(2))
  lm_p_tex_vals = strings(1,index_size(2))
  lm_d_tex_vals = strings(1,index_size(2))
  iteration = 1
  for iteration = 1:index_size(2)
     miller_index = num2str(main_texture_component(iteration))
     Sample_ID_char = strcat(Sample_ID_char, num2str(main_texture_component(iteration)));
     if main_texture_component(iteration) < 0
         tex_vals(iteration) = "\bar{" + abs(main_texture_component(iteration)) + "}";
     else
         tex_vals(iteration) = main_texture_component(iteration);
     end
     if lattice_matching_planar_component(iteration) < 0
         lm_p_tex_vals(iteration) = "\bar{" + abs(lattice_matching_planar_component(iteration)) + "}";
     else
         lm_p_tex_vals(iteration) = lattice_matching_planar_component(iteration)
     end
     if lattice_matching_direction_component(iteration) < 0
         lm_d_tex_vals(iteration) = "\bar{" + abs(lattice_matching_direction_component(iteration)) + "}";
     else
         lm_d_tex_vals(iteration) = lattice_matching_direction_component(iteration)
     end
 
     iteration = iteration + 1;
  end
  
 
  if index_size(2) == 3
    f = fibre(Miller(main_texture_component(1),main_texture_component(2),main_texture_component(3),cs),zvector);
    h_single = [Miller(main_texture_component(1),main_texture_component(2),main_texture_component(3),cs)];
    lm_component = [Miller(lattice_matching_planar_component(1),lattice_matching_planar_component(2),lattice_matching_planar_component(3),cs)];
    dt_component = [Miller(lattice_matching_direction_component(1),lattice_matching_direction_component(2),lattice_matching_direction_component(3),cs)];
  else
    f = fibre(Miller(main_texture_component(1),main_texture_component(2),main_texture_component(3),main_texture_component(4),cs),zvector);
    h_single = Miller(main_texture_component(1),main_texture_component(2),main_texture_component(3),main_texture_component(4),cs);
    lm_component = [Miller(lattice_matching_planar_component(1),lattice_matching_planar_component(2),lattice_matching_planar_component(3),lattice_matching_planar_component(4),cs)];
    dt_component = [Miller(lattice_matching_direction_component(1),lattice_matching_direction_component(2),lattice_matching_direction_component(3),lattice_matching_direction_component(4),cs)];
  end
 
  pf_shape = size(desired_pole_figures);
  pf_quant = pf_shape(1);
  index_quant = pf_shape(2);
 
  h = []
  for pf_i = 1:pf_quant
    ind = []
    each_pf = desired_pole_figures(pf_i,:)
    for pf_j = 1:length(each_pf)
      ind(pf_j) = each_pf(pf_j)
      pf_j = pf_j + 1
    end
    if length(each_pf) == 4
      if (strcmp(each_pf(4), "direction")) 
        each_h = Miller(ind(1),ind(2),ind(3),cs,'uvw')
      elseif (strcmp(each_pf(4), "plane")) 
        %each_h = Miller(ind(1),ind(2),ind(3),cs,'hkl') %VERSION 5.1.1 AND BEFORE
        each_h = Miller(ind(1),ind(2),ind(3),cs) %VERSION 5.2.8 AND AFTER
 
      end
    end
    if length(each_pf) == 5
      if (strcmp(each_pf(5), "direction")) 
        each_h = Miller(ind(1),ind(2),ind(3),ind(4),cs,'UVTW')
      elseif (strcmp(each_pf(5), "plane")) 
        %each_h = Miller(ind(1),ind(2),ind(3),ind(4),cs,'HKIL') %VERSION 5.1.1 AND BEFORE
        each_h = Miller(ind(1),ind(2),ind(3),ind(4),cs) %VERSION 5.2.8 AND AFFTER
 
      end
    end
    h = [h,each_h]
    pf_i = pf_i + 1 
  end
 
 
  OMR_quantity = size(OMR_file_names);
  OMR_quantity = OMR_quantity(2); 
   
  titleString =  "$$\left\{"
  for increment = 1:index_size(2)
      titleString = strcat(titleString,tex_vals(increment))
  end
  titleString = strcat(titleString,"\right\}$$ plane-normal deviation from growth direction $$ \left(^{\circ}\right)$$")
 
  %Calculate
  odf_full = calcODF(ebsd_full(phase_of_interest).orientations,'halfwidth',half_width*degree)
   
  ebsd_subsets = containers.Map('KeyType','double','ValueType','any')
  odf_subsets = containers.Map('KeyType','double','ValueType','any')
  for iteration = 1:OMR_quantity
    ebsd_subsets(iteration) = loadEBSD([pname char(OMR_file_names(iteration))],CS,'interface','ctf','convertEuler2SpatialReferenceFrame');
    OMR = ebsd_subsets(iteration)
    odf_subsets(iteration) = calcODF(OMR(phase_of_interest).orientations,'halfwidth',half_width*degree)
  end
  
  angle_limit = max_angle_degs*degree;
  % select all grain with misorientation angle to ori less then angle_limit
  raw_data_roi = ebsd_full(phase_of_interest)
  raw_data_selected = raw_data_roi(angle(raw_data_roi.orientations,f)<angle_limit);
 
  %Gubbins that doesn't really belong anywhere else. 
  disp('EBSD data imported') 
 
  set(groot,'defaulttextinterpreter','latex');
  set(groot, 'defaultAxesTickLabelInterpreter','latex'); 
  set(groot, 'defaultLegendInterpreter','latex');
  setMTEXpref('LaTex',true);  
end
%% Define colormaps 
for n=1:1
  disp('Loading colormaps...')
   
  for Discreet_BOGRPG_n = 1:1
  Discreet_BOGRPG = [49 130 189 %Blue
                     107 174 214
                     158 202 225
                     230 85 13 %Orange
                     253 141 60
                     253 174 107
                     49 163 84 %Green
                     116 196 118
                     199 233 192
                     132 60 56 %Red
                     173 73 74
                     214 97 107
                     123 65 115 %Purple
                     165 81 148
                     206 109 189
                     99 99 99 %Grey
                     150 150 150
                     189 189 189]/255;
  end
   
  for Discreet_PBROGG_n = 1:1
  Discreet_PBROGG = [123 65 115 %Purple
                     165 81 148
                     206 109 189
                     49 130 189 %Blue
                     107 174 214
                     158 202 225
                     132 60 56 %Red
                     173 73 74
                     214 97 107
                     230 85 13 %Orange
                     253 141 60
                     253 174 107
                     49 163 84 %Green
                     116 196 118
                     199 233 192
                     99 99 99 %Grey
                     150 150 150
                     189 189 189]/255;    
  end
   
  for Continuous_parula_90_n = 1:1
   
  Continuous_parula_90 =     [0.2422    0.1504    0.6603
                              0.2481    0.1602    0.6946
                              0.2535    0.1720    0.7257
                              0.2587    0.1838    0.7566
                              0.2636    0.1950    0.7878
                              0.2681    0.2066    0.8181
                              0.2719    0.2193    0.8456
                              0.2750    0.2333    0.8696
                              0.2773    0.2485    0.8903
                              0.2793    0.2641    0.9081
                              0.2805    0.2800    0.9237
                              0.2812    0.2958    0.9375
                              0.2814    0.3116    0.9499
                              0.2809    0.3272    0.9609
                              0.2797    0.3427    0.9705
                              0.2776    0.3582    0.9790
                              0.2743    0.3739    0.9859
                              0.2697    0.3900    0.9908
                              0.2632    0.4063    0.9941
                              0.2539    0.4228    0.9969
                              0.2407    0.4396    0.9993
                              0.2240    0.4569    0.9982
                              0.2064    0.4745    0.9925
                              0.1908    0.4913    0.9869
                              0.1835    0.5071    0.9799
                              0.1799    0.5224    0.9720
                              0.1776    0.5375    0.9622
                              0.1761    0.5522    0.9501
                              0.1709    0.5666    0.9385
                              0.1607    0.5809    0.9286
                              0.1514    0.5948    0.9184
                              0.1464    0.6081    0.9086
                              0.1415    0.6212    0.9006
                              0.1336    0.6342    0.8941
                              0.1239    0.6471    0.8877
                              0.1143    0.6596    0.8794
                              0.1042    0.6716    0.8689
                              0.0913    0.6828    0.8561
                              0.0722    0.6934    0.8416
                              0.0459    0.7030    0.8257
                              0.0186    0.7121    0.8088
                              0.0033    0.7205    0.7911
                              0.0027    0.7284    0.7730
                              0.0180    0.7357    0.7545
                              0.0513    0.7425    0.7354
                              0.0890    0.7488    0.7161
                              0.1230    0.7548    0.6964
                              0.1504    0.7607    0.6765
                              0.1711    0.7668    0.6561
                              0.1873    0.7730    0.6349
                              0.2018    0.7792    0.6125
                              0.2186    0.7851    0.5888
                              0.2400    0.7905    0.5637
                              0.2680    0.7949    0.5374
                              0.3017    0.7982    0.5101
                              0.3373    0.8006    0.4816
                              0.3727    0.8023    0.4514
                              0.4092    0.8031    0.4198
                              0.4489    0.8023    0.3885
                              0.4906    0.8002    0.3581
                              0.5316    0.7971    0.3277
                              0.5717    0.7932    0.2965
                              0.6112    0.7884    0.2659
                              0.6501    0.7828    0.2375
                              0.6881    0.7764    0.2125
                              0.7248    0.7697    0.1907
                              0.7602    0.7626    0.1711
                              0.7941    0.7555    0.1571
                              0.8263    0.7485    0.1536
                              0.8568    0.7420    0.1580
                              0.8860    0.7361    0.1675
                              0.9132    0.7315    0.1847
                              0.9381    0.7289    0.2087
                              0.9619    0.7286    0.2322
                              0.9843    0.7331    0.2446
                              0.9964    0.7452    0.2356
                              0.9971    0.7612    0.2235
                              0.9964    0.7776    0.2111
                              0.9944    0.7944    0.1994
                              0.9899    0.8116    0.1895
                              0.9829    0.8293    0.1811
                              0.9746    0.8472    0.1724
                              0.9672    0.8650    0.1638
                              0.9622    0.8828    0.1562
                              0.9598    0.9003    0.1489
                              0.9599    0.9175    0.1399
                              0.9622    0.9344    0.1287
                              0.9662    0.9510    0.1154
                              0.9714    0.9675    0.0993
                              0.9769    0.9839    0.0805];
  end
   
  for Continuous_parula_maroon_var_lim_n = 1:1
      
      Parula_limit = Parula_limit; %Change this value for point where colormap changes from parula to maroon
      
      Maroon_angular_range = 90 - Parula_limit;
      Angle_ratio=Maroon_angular_range/90;
      Maroon_colour_range = (Angle_ratio*90)/(1-Angle_ratio);
      Dark_maroon = [132 60 56]/255;
      Light_maroon = [231 149 155]/255;
      new_maroon = Light_maroon;
      RGB_change_per_degree = (Light_maroon - Dark_maroon)/Maroon_colour_range;
      Continuous_parula_maroon_var_lim = [Continuous_parula_90;Light_maroon];
      for iter_num = 1:Maroon_colour_range;
          new_maroon = new_maroon - RGB_change_per_degree;
          Continuous_parula_maroon_var_lim = [Continuous_parula_maroon_var_lim;new_maroon];
      end
  end    
   
  for Parula_maroon_spec_deg_inc_n = 1:1
   
      Parula_limit = Parula_limit; %Change this value for point where colormap changes from parula to maroon
      Angle_increment_cmap = Angle_increment_cmap;
      
      Maroon_angular_range = ((90 - Parula_limit)/Angle_increment_cmap)-1;
      Dark_maroon = [132 60 56]/255;
      Light_maroon = [231 149 155]/255;
      new_maroon = Light_maroon;
      RGB_change_per_degree = (Light_maroon - Dark_maroon)/Maroon_angular_range;
      Parula_maroon_spec_deg_inc = [parula(Parula_limit/Angle_increment_cmap);Light_maroon];
      for iter_num = 1:Maroon_angular_range;
          new_maroon = new_maroon - RGB_change_per_degree;
          Parula_maroon_spec_deg_inc = [Parula_maroon_spec_deg_inc;new_maroon];
      end
  end
  
  for Viridis_maroon_spec_deg_inc_n = 1:1
   
      Parula_limit = Parula_limit; %Change this value for point where colormap changes from parula to maroon
      Angle_increment_cmap = Angle_increment_cmap;
      
      Maroon_angular_range = ((90 - Parula_limit)/Angle_increment_cmap)-1;
      Dark_maroon = [132 60 56]/255;
      Light_maroon = [231 149 155]/255;
      new_maroon = Light_maroon;
      RGB_change_per_degree = (Light_maroon - Dark_maroon)/Maroon_angular_range;
      Viridis_maroon_spec_deg_inc = [viridis(Parula_limit/Angle_increment_cmap);Light_maroon];
      for iter_num = 1:Maroon_angular_range;
          new_maroon = new_maroon - RGB_change_per_degree;
          Viridis_maroon_spec_deg_inc = [Viridis_maroon_spec_deg_inc;new_maroon];
      end
    end
  
  for white_viridis_n=1:1
    white_to_purp = 10
    viridis_part = viridis(100-white_to_purp)
    white_viridis = zeros(100,3)
    white_viridis(white_to_purp+1:end,1:end) = viridis_part
    white_viridis(1:white_to_purp,1) = linspace(1,0.2670,white_to_purp)
    white_viridis(1:white_to_purp,2) = linspace(1,0.0049,white_to_purp)
    white_viridis(1:white_to_purp,3) = linspace(1,0.3294,white_to_purp) 
  end
  
  for qual_map_n =1:1
 
    blue = [31,119,180]/255
    orange = [255,127,14]/255
    green = [44,160,44]/255
    red=[214,39,40]/255
    purple=[148,103,189]/255
    pink=[227,119,194]/255
    grey=0
    qual_bl = exist('qual_map_blue_min')
    qual_or = exist('qual_map_orange_min')
    qual_gr = exist('qual_map_green_min')
    qual_re = exist('qual_map_red_min')
    qual_pu = exist('qual_map_purple_min')
    qual_pi = exist('qual_map_pink_min')
 
    qual_map = grey*ones(90,3)
 
    if qual_bl == 1
      for i = qual_map_blue_min:qual_map_blue_max
      qual_map(i,:) = blue
      end
    end
 
    if qual_or == 1
      for i = qual_map_orange_min:qual_map_orange_max
      qual_map(i,:) = orange
      end
    end
 
    if qual_gr == 1
      for i = qual_map_green_min:qual_map_green_max
      qual_map(i,:) = green
      end
    end
 
    if qual_re == 1
      for i = qual_map_red_min:qual_map_red_max
      qual_map(i,:) = red
      end
    end
 
    if qual_pu == 1
      for i = qual_map_purple_min:qual_map_purple_max
      qual_map(i,:) = purple
      end
    end
 
    if qual_pi == 1
      for i = qual_map_pink_min:qual_map_pink_max
      qual_map(i,:) = pink
      end
    end
  end
  
  if ( strcmp( colormap_choice, "Parula_maroon_spec_deg_inc" ) ) 
    consitent_cmap = Parula_maroon_spec_deg_inc;
  elseif ( strcmp( colormap_choice, "Discreet_BOGRPG" ) )
    consitent_cmap = Discreet_BOGRPG;
  elseif ( strcmp( colormap_choice, "Discreet_PBROGG" ) )
    consitent_cmap = Discreet_PBROGG;
  elseif ( strcmp( colormap_choice, "Viridis_maroon_spec_deg_inc" ) )
    consitent_cmap = Viridis_maroon_spec_deg_inc;
  else
    consitent_cmap = colormap_choice;
  end
  
  disp('Colormaps loaded') 
end
%% Plotting raw phase map
if RAW_PHASE_MAP == 'Y'
    figure
    plot(ebsd_full('indexed'))
    hold on
    plot(ebsd_full('notIndexed'),'FaceColor','white')
    hold off
    
    if save_figures == 'on'
      fig_name = strcat(Sample_ID_char,' MAP PHASE GRAINS.pdf')
      export_fig(fig_name)
    end
end
%% Plotting Raw IPF map
if RAW_IPF_MAP == 'Y'
  %IPF Legend creaion
  disp('Calculating IPF legend...')
   
  Fig_IPF_leg_full = figure('Name','Loading...');
  figure(Fig_IPF_leg_full);
   
  ipfKey = ipfHSVKey(cs.Laue);
  %ipfKey = ipfSpotKey(cs.Laue);
  %ipfKey = ipfHKLKey(cs.Laue);
  %ipfKey = TSLDirectionKey(cs);
  %ipfKey = ipfTSLKey(cs.Laue);
  %ipfKey.inversePoleFigureDirection = zvector
  %ipfKey.colorPostRotation = reflection(yvector);
  
  %centre_miller = Miller(main_texture_component(1),main_texture_component(2),main_texture_component(3),cs)
  %centre_miller_ref = Miller(0,0,1,cs,'uvw')
  %centre_miller = Miller(1,0,-6,cs)
  %centre_ori = orientation.byMiller(centre_miller,centre_miller_ref)
  
  %ipfKey.inversePoleFigureDirection = mean(ebsd_full(phase_of_interest).orientations,'robust') * ipfKey.whiteCenter;
  %ipfKey.center = centre_miller
 
  
  %ipfKey.maxAngle = 5*degree;
   
  %plot(ipfKey,'complete','lower','resolution',0.25*degree);
  plot(ipfKey)
  if strcmp(phase_of_interest,'Monoclinic ZrO$$_2$$')
    hold on 
    annotate([Miller(1,0,0,cs),Miller(1,1,0,cs),Miller(0,0,1,cs),Miller(0,1,0,cs),Miller(-1,0,0,cs),Miller(-1,1,0,cs),Miller(1,0,-6,cs)],...
      'all','labeled','BackgroundColor','white');
    hold off
  end
 
  set(Fig_IPF_leg_full,'Name','IPF Legend');
  disp('IPF legend plotted')
  
 
  if save_figures == 'on'
      fig_name = strcat(Sample_ID_char,' IPF LEGEND.pdf')
      export_fig(fig_name)
  end
   
  % Plot IPF Orientation map
  disp('Plotting raw IPF orientation map...')
  Fig_IPF_map_full = figure('Name','Loading...');
  figure(Fig_IPF_map_full);
  ipfcolor = ipfKey.orientation2color(ebsd_full(phase_of_interest).orientations);
  %ipfcolor = TSLDirectionKey(ebsd_full(phase_of_interest).orientations);
  plot(ebsd_full(phase_of_interest),ipfcolor,'add2all');
  set(Fig_IPF_map_full,'Name','Raw orientation map - IPF colour');
  set(gca,'Color','black');
  set(gcf, 'InvertHardcopy', 'off');
  set(gca,'linewidth',3);  
  hgt = findall(gca,'type','hgtransform')
  set(hgt,'visible','off')
    
  if save_figures == 'on'
      fig_name = strcat(Sample_ID_char,' MAP IPF RAW.pdf')
      export_fig(fig_name)
  end
 
  disp('Raw IPF Orientation map plotted')
end
%% Plotting Raw Euler map 
if RAW_EULER_MAP == 'Y'
  disp('Calculating Euler colouring...')
   
  oM = BungeColorKey(cs);
  eulercolor = oM.orientation2color(ebsd_full(phase_of_interest).orientations);
  %plot(oM)
   
  % Plot Euler Orientation map
  disp('Plotting raw Euler orientation map...')
  Fig_Euler_map_full = figure('Name','Loading...');
  figure(Fig_Euler_map_full);
  plot(ebsd_full(phase_of_interest),eulercolor);
  set(Fig_Euler_map_full,'Name','Raw orientation map - Euler colour');
  set(gca,'Color','black');
  set(gcf, 'InvertHardcopy', 'off');
  set(gca,'linewidth',3);
 
  disp('Raw Euler Orientation map plotted')
   
  if save_figures == 'on'
      fig_name = strcat(Sample_ID_char,' MAP EULER RAW.pdf')
      export_fig(fig_name)
  end
   
  disp('Raw Euler Orientation map plotted')
end
%% Plot fibre map RAW
if RAW_FIBRE_MAP_QUANT == 'Y'
    
  Scale_bar_limits = [0 max_angle_degs];
  
  % Create figure
  disp('Plotting fibre misorientation map...')
  Fig_103_Fibre_Map = figure('Name','Loading...');
  figure(Fig_103_Fibre_Map);
  
   
  %overlay_plot_raw_fibre = axes('NextPlot','add');
  %Plot grains <angle_limit
  %plot(grains_selected(phase_of_interest),angle(grains_selected.meanOrientation,f)./degree,'linecolor','r','linewidth',1)
  %plot(grains_selected(phase_of_interest),angle(grains_selected.meanOrientation,f)./degree);
  plot(raw_data_selected(phase_of_interest),angle(raw_data_selected.orientations,f)./degree);
  %plot(gB_clean,'linecolor',[90 90 90]/255,'linewidth',0.1,'Parent',overlay_plot_raw_fibre);
   
  if ( strcmp( colormap_choice, "Parula_maroon_spec_deg_inc" ) ) 
    colormap(gca,Parula_maroon_spec_deg_inc);
    consitent_cmap = Parula_maroon_spec_deg_inc
  elseif ( strcmp( colormap_choice, "Discreet_BOGRPG" ) )
    colormap(gca,Discreet_BOGRPG);
    consitent_cmap = Discreet_BOGRPG
  elseif ( strcmp( colormap_choice, "Discreet_PBROGG" ) )
    colormap(gca,Discreet_PBROGG);
    consitent_cmap = Discreet_PBROGG
  elseif ( strcmp( colormap_choice, "Viridis_maroon_spec_deg_inc" ) )
    colormap(gca,Viridis_maroon_spec_deg_inc);
    consitent_cmap = Viridis_maroon_spec_deg_inc
  else
    colormap(gca,colormap_choice);
    consitent_cmap = colormap_choice
  end
   
  %colormap(parula(Discrete_color_quant))
  %colormap(parula)
  %colormap(Discreet_PBROGG)
  caxis(Scale_bar_limits);
  cb_new = mtexColorbar
  cb_new.Label.Interpreter = 'latex';
  set(cb_new,'TickLabelInterpreter', 'latex');
  colorTitleHandle = get(cb_new,'Label');
 
  set(colorTitleHandle ,'String',titleString);
  %plot(ebsd('Not Indexed'),'FaceColor','black','Parent',overlay_plot_raw_fibre);
  %plot(ebsd(phase_of_interest),'FaceColor',[150 150 150]/255,'Parent',overlay_plot_raw_fibre);
  %plot(ebsd('Tetragonal ZrO$$_2$$'),'FaceColor','white','Parent',overlay_plot_raw_fibre);
   
  axesHandles = findall(Fig_103_Fibre_Map,'type','axes');
  axes_props = get(axesHandles,'position')
  aspect_ratio = axes_props(3)/axes_props(4)
   
  %set(Fig_103_Fibre_Map,'Name','EBSD Orientation map - fibre','outerposition',[0 0 1 aspect_ratio*aspect_ratio_shift]);
  set(gca,'Color','black')
  set(gcf,'Color','white')
  set(gcf, 'InvertHardcopy', 'off');
  set(gca,'linewidth',3);
  hgt = findall(gca,'type','hgtransform')
  set(hgt,'visible','off')
 
   
  if save_figures == 'on'
      fig_name = strcat(Sample_ID_char,' MAP FIBRE QUANT RAW.pdf')
      export_fig(fig_name)
  end
   
  disp('Fibre misorientation map plotted')
end
%% Fibre misorientation histogram raw
if RAW_FIBRE_HIST_QUANT == 'Y' 
  Angle_increment_hist = 1
  disp('Creating fibre misorientation histogram...')
  Fig_Basal_angle_hist = figure('Name','Loading...');
  figure(Fig_Basal_angle_hist);
  Discrete_color_quant_hist = 90/Angle_increment_hist;
  integerValue = Discrete_color_quant_hist;
  numberOfBars = integerValue;
  %barColorMap = jet(Discrete_color_quant);
  %barColorMap = parula(Discrete_color_quant);
  cmap_extention_param = Angle_increment_cmap/Angle_increment_hist
  usable_colormap = repelem(consitent_cmap,cmap_extention_param,1)
  barColorMap = usable_colormap;
  fibre_mis_angles = angle(ebsd_full(phase_of_interest).orientations,f)./degree;
   
  for b = 1 : numberOfBars
      % Plot one single bar as a separate bar series.
      upper_bound(b) = b*max_angle_degs/Discrete_color_quant_hist;
      lower_bound(b) = upper_bound(b) - max_angle_degs/Discrete_color_quant_hist;
      mid_point(b) = upper_bound(b) - (max_angle_degs/Discrete_color_quant_hist)/2;
      counts(b) = sum(fibre_mis_angles>lower_bound(b) & fibre_mis_angles<upper_bound(b));
      handleToThisBarSeries(b) = bar(mid_point(b), counts(b), 'BarWidth', max_angle_degs/Discrete_color_quant_hist);
      % Apply the color to this bar series.
      if b > angle_histogram_highlight
          set(handleToThisBarSeries(b), 'FaceColor', barColorMap(b,:),'FaceAlpha', 0.3);
      else
          set(handleToThisBarSeries(b), 'FaceColor', barColorMap(b,:));
      end
      hold on;
  end
   
  hold off;
  set(Fig_Basal_angle_hist,'Name','EBSD Basal fibre histogram');
   
  xlabel(titleString,'Interpreter','latex');
  ylabel(['Frequency']);
  set(gca, 'YTickMode', 'Auto');
  set(gca, 'XTickMode', 'Auto');
  set(gcf, 'color','white');
  set(gcf, 'InvertHardcopy', 'off');
 
  if save_figures == 'on'
      fig_name = strcat(Sample_ID_char,' HIST FIBRE QUANT RAW.pdf')
      export_fig(fig_name)
  end
   
  disp('Fibre misorientation histogram produced')
end
%% Plot raw data scatter Pole figure full
if RAW_PF_SCATTER_FULL == 'Y' 
  disp('Plotting scatter based scatter pole figure...')
  Fig_scatter_PF_raw = figure('Name','Loading...');
  figure(Fig_scatter_PF_raw)
  
  % Plot PFs
  plotPDF(raw_data_selected.orientations,angle(raw_data_selected.orientations,f)./degree,h,'antipodal','MarkerSize',0.5,'all','grid','grid_res',5*degree,'projection',projection_type)
  hold on
  % Plot circle at particular angle
  %circle(f.h.project2FundamentalRegion,15*degree,'linewidth',2,'linecolor','k')
  %circle(f.h.project2FundamentalRegion,30*degree,'linewidth',2,'linecolor','k')
   
  % Define colormap
  colormap(consitent_cmap);
  Scale_bar_limits = [0 max_angle_degs];
  caxis(Scale_bar_limits)
  setColorRange('equal')
  cb = mtexColorbar('title',titleString,'FontSize',16,'FontWeight','bold','TickLength',0)
  CLim(gcm,'equal');
  cb.Label.Interpreter = 'latex';
  set(cb,'TickLabelInterpreter', 'latex');
   
  % Rename figure
  set(Fig_scatter_PF_raw,'Name','EBSD Scatter pole figure raw data based')
  hold off
  if save_figures == 'on'
      fig_name = strcat(Sample_ID_char,' PF SCATTER FIBRES FULL MAP RAW.pdf')
      export_fig(fig_name)
  end
  disp('Scatter pole figure plotted') 
end
%% Subsets Scatter fibre
if RAW_PF_SCATTER_SUBSETS == 'Y'
  if OMR_quantity > 0
 
    disp('Plotting OMR scatter fibre PFs...')        
    multifig_OMRs_scatter = figure('units','normalized','outerposition',[0 0 1 1])
    figure(multifig_OMRs_scatter)
    colormap(consitent_cmap);
    set(gcf,'color','w');
     
    stp_1 = [0.05 0.05]; %Spacing between plots: x,y
    stp_2 = [0.05 0.05]; %Margin size: top, bottom
    stp_3 = [0.05 0.05]; %Margin size: left,right
 
  subplot_location = [1 2 3 11 12 13 21 22 23]
  for iteration = 1:OMR_quantity
    axesPos = subtightplot(6,10,subplot_location,stp_1,stp_2,stp_3);
    OMR = ebsd_subsets(iteration)
    plotPDF(OMR(phase_of_interest).orientations,angle(OMR(phase_of_interest).orientations,f)./degree,h_single,'antipodal','MarkerSize',0.5,'all','grid','grid_res',5*degree,'parent',axesPos,'projection',projection_type);
    subset_title_string =  "\textbf{Region "
    subset_title_string = strcat(subset_title_string, num2str(iteration))
    subset_title_string = strcat(subset_title_string, "} \boldmath$$\left\{")
    for increment = 1:index_size(2)
      subset_title_string = strcat(subset_title_string,tex_vals(increment))
    end
    subset_title_string = strcat(subset_title_string,"\right\}$$")
    title(subset_title_string)
    if iteration < 3    
    subplot_location = subplot_location + 3
    end
    if iteration == 3
        subplot_location = [31 32 33 41 42 43 51 52 53]
    end
    if iteration > 3
        subplot_location = subplot_location + 3
    end
  end
     
    hold on
    colorbar_location = get(subtightplot(6,10,[10 20 30 40 50 60]),'Position')
    axesPos = subtightplot(6,10,[10 20 30 40 50 60],stp_1,stp_2,stp_3);
    set(axesPos,'Visible','off');
    set(gca,'Color','none');
    colormap(consitent_cmap);
    caxis(Scale_bar_limits)
    cb_new = mtexColorbar('Position', [colorbar_location(1)+0.06 colorbar_location(2) colorbar_location(3)/5 colorbar_location(4)],'FontSize',16,'FontWeight','bold','TickLength',0)
    yyaxis right
 
    y_label = ylabel(cb_new, titleString)
    cb_new.Label.Interpreter = 'latex';
    set(cb_new,'TickLabelInterpreter', 'latex');
    hold off
     
    if save_figures == 'on'
        fig_name = strcat(Sample_ID_char,' PF SCATTER FIBRE SUBSETS RAW.pdf')
        export_fig(fig_name)
    end
     
    disp('OMR scatter fibre PFs plotted') 
  end
end
%% ODF full map
if RAW_PF_ODF_FULL == 'Y' 
  disp('Plotting full map ODF pole figure...')
  odf = calcODF(raw_data_selected.orientations,'halfwidth',half_width*degree)
  Fig_ODF_PF_full_map = figure('Name','Loading...')
  figure(Fig_ODF_PF_full_map)
  plotPDF(odf,h,'grid','grid_res',grid_line_spacing*degree,'minmax','projection',projection_type)
  mtexColorMap(white_viridis)
  
  CLim(gcm,'equal'); % set equal color range to all plots
   
  cb = mtexColorbar('title','MRD values')
  CLim(gcm,'equal');
  cb.Label.Interpreter = 'latex';
  set(cb,'TickLabelInterpreter', 'latex');
  set(Fig_ODF_PF_full_map,'Name','EBSD ODF contoured pole figure from full map')
  [cm,cmd] = getColormaps
  disp(cm)
  if save_figures == 'on'
      fig_name = strcat(Sample_ID_char,'PF ODF FIBRES FULL MAP RAW.pdf')
      export_fig(fig_name)
  end
   
  disp('ODF pole figure plotted')    
end
%% Subsets ODF fibre
if RAW_PF_ODF_SUBSETS == 'Y'
 
    if OMR_quantity > 0
 
    cbarlimits = [0 main_texture_component_colorbar_limit]
    dark_red = [0.5 0 0]
    saturation_counts = (main_texture_component_colorbar_limit-main_texture_component_saturated_limit)*(100/main_texture_component_saturated_limit)
    saturated_colorbar = [WhiteJetColorMap;repmat(dark_red,round(saturation_counts),1)]
 
    disp('Plotting OMR ODFs...')
 
    multifig_OMRs_ODF = figure('units','normalized','outerposition',[0 0 1 1]);
    figure(multifig_OMRs_ODF);
    colormap(saturated_colorbar)
 
    set(gcf,'color','w');
 
    stp_1 = [0.05 0.05]; %Spacing between plots: x,y
    stp_2 = [0.05 0.05]; %Margin size: top, bottom
    stp_3 = [0.05 0.05]; %Margin size: left,right
 
    subplot_location = [1 2 3 11 12 13 21 22 23]
    for iteration = 1:OMR_quantity
      axesPos = subtightplot(6,10,subplot_location,stp_1,stp_2,stp_3);
      plotPDF(odf_subsets(iteration),h_single,'grid','grid_res',grid_line_spacing*degree,'parent',axesPos,'minmax','projection',projection_type);
      caxis(cbarlimits)
      mtexColorbar('off')
      subset_title_string =  "\textbf{Region "
      subset_title_string = strcat(subset_title_string, num2str(iteration))
      subset_title_string = strcat(subset_title_string, "} \boldmath$$\left\{")
      for increment = 1:index_size(2)
        subset_title_string = strcat(subset_title_string,tex_vals(increment))
      end
      subset_title_string = strcat(subset_title_string,"\right\}$$")
      title(subset_title_string)
      if iteration < 3    
      subplot_location = subplot_location + 3
      end
      if iteration == 3
          subplot_location = [31 32 33 41 42 43 51 52 53]
      end
      if iteration > 3
          subplot_location = subplot_location + 3
      end
    end
 
    hold on
    colorbar_location = get(subtightplot(6,10,[10 20 30 40 50 60]),'Position')
    axesPos = subtightplot(6,10,[10 20 30 40 50 60],stp_1,stp_2,stp_3);
    set(axesPos,'Visible','off');
    set(gca,'Color','none');
 
    caxis(cbarlimits)
    colormap(white_viridis);
    cb_new = mtexColorbar('Position', [colorbar_location(1)+0.06 colorbar_location(2) colorbar_location(3)/5 colorbar_location(4)],'FontSize',16,'FontWeight','bold')
    yyaxis right
    y_label = ylabel(cb_new, 'MRD values')
    cb_new.Label.Interpreter = 'latex';
    set(cb_new,'TickLabelInterpreter', 'latex');
    hold off
 
    if save_figures == 'on'
        fig_name = strcat(Sample_ID_char,' PF ODF FIBRE SUBSETS RAW.pdf')
        export_fig(fig_name)
    end
 
    disp('OMR ODFs plotted')
 
    end 
end
%% Subsets Scatter fibre LATTICE MATCHING
if RAW_PF_SCATTER_SUBSETS_LM_PLANAR == 'Y'
  if OMR_quantity > 0
 
    disp('Plotting OMR scatter fibre PFs...')
 
    multifig_OMRs_scatter_lattice_matching = figure('units','normalized','outerposition',[0 0 1 1])
    figure(multifig_OMRs_scatter_lattice_matching)
    colormap(consitent_cmap);
    set(gcf,'color','w');
 
    stp_1 = [0.05 0.05]; %Spacing between plots: x,y
    stp_2 = [0.05 0.05]; %Margin size: top, bottom
    stp_3 = [0.05 0.05]; %Margin size: left,right
 
 
    subplot_location = [1 2 3 11 12 13 21 22 23]
    for iteration = 1:OMR_quantity
      axesPos = subtightplot(6,10,subplot_location,stp_1,stp_2,stp_3);
      OMR = ebsd_subsets(iteration)
      plotPDF(OMR(phase_of_interest).orientations,angle(OMR(phase_of_interest).orientations,f)./degree,lm_component,'antipodal','MarkerSize',0.5,'all','grid','grid_res',5*degree,'parent',axesPos,'projection',projection_type);
      subset_title_string_lm_p =  "\textbf{Region "
      subset_title_string_lm_p = strcat(subset_title_string_lm_p, num2str(iteration))
      subset_title_string_lm_p = strcat(subset_title_string_lm_p, "} \boldmath$$\left\{")
      for increment = 1:index_size(2)
        subset_title_string_lm_p = strcat(subset_title_string_lm_p,lm_p_tex_vals(increment))
      end
      subset_title_string_lm_p = strcat(subset_title_string_lm_p,"\right\}$$")
      title(subset_title_string_lm_p)
      if iteration < 3    
      subplot_location = subplot_location + 3
      end
      if iteration == 3
          subplot_location = [31 32 33 41 42 43 51 52 53]
      end
      if iteration > 3
          subplot_location = subplot_location + 3
      end
    end
 
    hold on
    colorbar_location = get(subtightplot(6,10,[10 20 30 40 50 60]),'Position')
    axesPos = subtightplot(6,10,[10 20 30 40 50 60],stp_1,stp_2,stp_3);
    set(axesPos,'Visible','off');
    set(gca,'Color','none');
    colormap(consitent_cmap);
    caxis(Scale_bar_limits)
    cb_new = mtexColorbar('Position', [colorbar_location(1)+0.06 colorbar_location(2) colorbar_location(3)/5 colorbar_location(4)],'FontSize',16,'FontWeight','bold','TickLength',0)
    yyaxis right
    y_label = ylabel(cb_new, titleString)
    cb_new.Label.Interpreter = 'latex';
    set(cb_new,'TickLabelInterpreter', 'latex');
    hold off
 
    if save_figures == 'on'
        fig_name = strcat(Sample_ID_char, ' PF SCATTER SUBSETS LM PLANAR RAW.pdf')
        export_fig(fig_name)
    end
 
    disp('OMR scatter fibre PFs plotted') 
  end
end
%% Subsets ODF fibre LATTICE MATCHING
if RAW_PF_ODF_SUBSETS_LM_PLANAR == 'Y'
      if OMR_quantity > 0
 
      cbarlimits = [0 lattice_matching_planar_component_colorbar_limit]
      dark_red = [0.5 0 0]
      saturation_counts = (main_texture_component_colorbar_limit-main_texture_component_saturated_limit)*(100/main_texture_component_saturated_limit)
      saturated_colorbar = [WhiteJetColorMap;repmat(dark_red,round(saturation_counts),1)]
 
      disp('Plotting OMR ODFs...')
 
      multifig_OMRs_ODF_LATTICE_MATCHING = figure('units','normalized','outerposition',[0 0 1 1]);
      figure(multifig_OMRs_ODF_LATTICE_MATCHING);
      colormap(saturated_colorbar)
 
      set(gcf,'color','w');
 
      stp_1 = [0.05 0.05]; %Spacing between plots: x,y
      stp_2 = [0.05 0.05]; %Margin size: top, bottom
      stp_3 = [0.05 0.05]; %Margin size: left,right
      
 
      subplot_location = [1 2 3 11 12 13 21 22 23]
      for iteration = 1:OMR_quantity
        axesPos = subtightplot(6,10,subplot_location,stp_1,stp_2,stp_3);
        plotPDF(odf_subsets(iteration),lm_component,'grid','grid_res',grid_line_spacing*degree,'parent',axesPos,'minmax','projection',projection_type);
        caxis(cbarlimits)
        mtexColorbar('off')
        subset_title_string_lm_p =  "\textbf{Region "
        subset_title_string_lm_p = strcat(subset_title_string_lm_p, num2str(iteration))
        subset_title_string_lm_p = strcat(subset_title_string_lm_p, "} \boldmath$$\left\{")
        for increment = 1:index_size(2)
          subset_title_string_lm_p = strcat(subset_title_string_lm_p,lm_p_tex_vals(increment))
        end
        subset_title_string_lm_p = strcat(subset_title_string_lm_p,"\right\}$$")
        title(subset_title_string_lm_p)
        if iteration < 3    
        subplot_location = subplot_location + 3
        end
        if iteration == 3
            subplot_location = [31 32 33 41 42 43 51 52 53]
        end
        if iteration > 3
            subplot_location = subplot_location + 3
        end
      end
 
      hold on
      colorbar_location = get(subtightplot(6,10,[10 20 30 40 50 60]),'Position')
      axesPos = subtightplot(6,10,[10 20 30 40 50 60],stp_1,stp_2,stp_3);
      set(axesPos,'Visible','off');
      set(gca,'Color','none');
 
      caxis(cbarlimits)
      colormap(saturated_colorbar);
      cb_new = mtexColorbar('Position', [colorbar_location(1)+0.06 colorbar_location(2) colorbar_location(3)/5 colorbar_location(4)],'FontSize',16,'FontWeight','bold')
      yyaxis right
      y_label = ylabel(cb_new, 'MRD values')
      cb_new.Label.Interpreter = 'latex';
      set(cb_new,'TickLabelInterpreter', 'latex');
      hold off
 
      colormap(white_viridis)
 
      if save_figures == 'on'
          fig_name = strcat(Sample_ID_char, ' PF ODF SUBSETS LM PLANAR RAW.pdf')
          export_fig(fig_name)
      end
      end
      disp('OMR ODFs plotted') 
end
%% Subsets Scatter fibre DIRECTION
if RAW_PF_SCATTER_SUBSETS_LM_DIRECTION == 'Y'
  if OMR_quantity > 0
 
  disp('Plotting OMR scatter fibre PFs...')
 
  multifig_OMRs_scatter_lattice_matching_DIRECTION = figure('units','normalized','outerposition',[0 0 1 1])
  figure(multifig_OMRs_scatter_lattice_matching_DIRECTION)
  colormap(consitent_cmap);
  set(gcf,'color','w');
 
  stp_1 = [0.05 0.05]; %Spacing between plots: x,y
  stp_2 = [0.05 0.05]; %Margin size: top, bottom
  stp_3 = [0.05 0.05]; %Margin size: left,right
 
  subplot_location = [1 2 3 11 12 13 21 22 23]
  for iteration = 1:OMR_quantity
    axesPos = subtightplot(6,10,subplot_location,stp_1,stp_2,stp_3);
    OMR = ebsd_subsets(iteration)
    plotIPDF(OMR(phase_of_interest).orientations,angle(OMR(phase_of_interest).orientations,f)./degree,dt_component,'antipodal','MarkerSize',0.5,'all','grid','grid_res',5*degree,'parent',axesPos,'complete');
    subset_title_string_lm_d =  "\textbf{Region "
    subset_title_string_lm_d = strcat(subset_title_string_lm_d, num2str(iteration))
    subset_title_string_lm_d = strcat(subset_title_string_lm_d, "} \boldmath$$\left<")
    for increment = 1:index_size(2)
      subset_title_string_lm_d = strcat(subset_title_string_lm_d,lm_d_tex_vals(increment))
    end
    subset_title_string_lm_d = strcat(subset_title_string_lm_d,"\right>$$")
    title(subset_title_string_lm_d)
    if iteration < 3    
    subplot_location = subplot_location + 3
    end
    if iteration == 3
        subplot_location = [31 32 33 41 42 43 51 52 53]
    end
    if iteration > 3
        subplot_location = subplot_location + 3
    end
  end
 
  hold on
  colorbar_location = get(subtightplot(6,10,[10 20 30 40 50 60]),'Position')
  axesPos = subtightplot(6,10,[10 20 30 40 50 60],stp_1,stp_2,stp_3);
  set(axesPos,'Visible','off');
  set(gca,'Color','none');
  colormap(consitent_cmap);
  caxis(Scale_bar_limits)
  cb_new = mtexColorbar('Position', [colorbar_location(1)+0.06 colorbar_location(2) colorbar_location(3)/5 colorbar_location(4)],'FontSize',16,'FontWeight','bold','TickLength',0)
  yyaxis right
  y_label = ylabel(cb_new, titleString)
  cb_new.Label.Interpreter = 'latex';
  set(cb_new,'TickLabelInterpreter', 'latex');
  hold off
 
  if save_figures == 'on'
      fig_name = strcat(Sample_ID_char, ' PF SCATTER SUBSETS LM DIRECTION RAW.pdf')
      export_fig(fig_name)
  end
  end
  disp('OMR scatter fibre PFs plotted') 
end
%% Subsets ODF fibre LATTICE MATCHING DIRECTION
if RAW_PF_ODF_SUBSETS_LM_DIRECTION == 'Y'
   if OMR_quantity > 0
 
    cbarlimits = [0 lattice_matching_direction_component_colorbar_limit]
    dark_red = [0.5 0 0]
    saturation_counts = (main_texture_component_colorbar_limit-main_texture_component_saturated_limit)*(100/main_texture_component_saturated_limit)
    saturated_colorbar = [WhiteJetColorMap;repmat(dark_red,round(saturation_counts),1)]
 
    disp('Plotting OMR ODFs...')
 
    multifig_OMRs_ODF_DIRECTION = figure('units','normalized','outerposition',[0 0 1 1]);
    figure(multifig_OMRs_ODF_DIRECTION);
    colormap(saturated_colorbar)
 
    set(gcf,'color','w');
 
    stp_1 = [0.05 0.05]; %Spacing between plots: x,y
    stp_2 = [0.05 0.05]; %Margin size: top, bottom
    stp_3 = [0.05 0.05]; %Margin size: left,right
 
 
    subplot_location = [1 2 3 11 12 13 21 22 23]
    for iteration = 1:OMR_quantity
      axesPos = subtightplot(6,10,subplot_location,stp_1,stp_2,stp_3);
      plotIPDF(odf_subsets(iteration),dt_component,'grid','grid_res',grid_line_spacing*degree,'parent',axesPos,'minmax','complete');
      caxis(cbarlimits)
      mtexColorbar('off')
      subset_title_string_lm_d =  "\textbf{Region "
      subset_title_string_lm_d = strcat(subset_title_string_lm_d, num2str(iteration))
      subset_title_string_lm_d = strcat(subset_title_string_lm_d, "} \boldmath$$\left<")
      for increment = 1:index_size(2)
        subset_title_string_lm_d = strcat(subset_title_string_lm_d,lm_d_tex_vals(increment))
      end
      subset_title_string_lm_d = strcat(subset_title_string_lm_d,"\right>$$")
      title(subset_title_string_lm_d)
      if iteration < 3    
      subplot_location = subplot_location + 3
      end
      if iteration == 3
          subplot_location = [31 32 33 41 42 43 51 52 53]
      end
      if iteration > 3
          subplot_location = subplot_location + 3
      end
    end
 
    hold on
    colorbar_location = get(subtightplot(6,10,[10 20 30 40 50 60]),'Position')
    axesPos = subtightplot(6,10,[10 20 30 40 50 60],stp_1,stp_2,stp_3);
    set(axesPos,'Visible','off');
    set(gca,'Color','none');
 
    caxis(cbarlimits)
    colormap(saturated_colorbar);
    cb_new = mtexColorbar('Position', [colorbar_location(1)+0.06 colorbar_location(2) colorbar_location(3)/5 colorbar_location(4)],'FontSize',16,'FontWeight','bold')
    yyaxis right
    y_label = ylabel(cb_new, 'MRD values')
    cb_new.Label.Interpreter = 'latex';
    set(cb_new,'TickLabelInterpreter', 'latex');
    hold off
 
    colormap(white_viridis)
 
    if save_figures == 'on'
        fig_name = strcat(Sample_ID_char, ' PF ODF SUBSETS LM DIRECTION RAW.pdf')
        export_fig(fig_name)
    end
 
    disp('OMR ODFs plotted') 
  end 
end
%% Plot fibre map RAW QUALITATIVE
if RAW_FIBRE_MAP_QUAL == 'Y'
 
    Scale_bar_limits = [0 max_angle_degs];
    angle_limit = max_angle_degs*degree;
    % Create figure
    disp('Plotting fibre misorientation map...')
    Fig_103_Fibre_Map = figure('Name','Loading...');
    figure(Fig_103_Fibre_Map);
    % select all grain with misorientation angle to ori less then angle_limit
 
    
    %Plot grains <angle_limit
    %plot(grains_selected('Monoclinic ZrO$$_2$$'),angle(grains_selected.meanOrientation,f)./degree,'linecolor','r','linewidth',1)
    %plot(grains_selected('Monoclinic ZrO$$_2$$'),angle(grains_selected.meanOrientation,f)./degree);
    plot(raw_data_selected(phase_of_interest),angle(raw_data_selected.orientations,f)./degree);
    %plot(gB_clean,'linecolor',[90 90 90]/255,'linewidth',0.1,'Parent',overlay_plot_raw_fibre);
 
    colormap(gca,qual_map);
    
 
    %colormap(parula(Discrete_color_quant))
    %colormap(parula)
    %colormap(Discreet_PBROGG)
    caxis(Scale_bar_limits);
    cb_new = mtexColorbar
    cb_new.Label.Interpreter = 'latex';
    set(cb_new,'TickLabelInterpreter', 'latex');
    colorTitleHandle = get(cb_new,'Label');
    set(colorTitleHandle ,'String',titleString);
    %plot(ebsd('Not Indexed'),'FaceColor','black','Parent',overlay_plot_raw_fibre);
    %plot(ebsd('HCP Zr'),'FaceColor',[150 150 150]/255,'Parent',overlay_plot_raw_fibre);
    %plot(ebsd('Tetragonal ZrO$$_2$$'),'FaceColor','white','Parent',overlay_plot_raw_fibre);
 
    axesHandles = findall(Fig_103_Fibre_Map,'type','axes');
    axes_props = get(axesHandles,'position')
    aspect_ratio = axes_props(3)/axes_props(4)
 
    %cset(Fig_103_Fibre_Map,'Name','EBSD Orientation map - fibre','outerposition',[0 0 1 aspect_ratio*aspect_ratio_shift]);
    set(gca,'Color','black')
    set(gcf,'Color','white')
    set(gcf, 'InvertHardcopy', 'off');
    
 
    if save_figures == 'on'
        fig_name = strcat(Sample_ID_char, ' MAP FIBRE QUAL RAW.pdf')
        export_fig(fig_name)
    end
 
    disp('Fibre misorientation map plotted')
end
%% Fibre misorientation histogram raw QUALITATIVE
if RAW_FIBRE_HIST_QUAL == 'Y'
 
    Angle_increment_hist = 1
    disp('Creating fibre misorientation histogram...')
    Fig_Basal_angle_hist = figure('Name','Loading...');
    figure(Fig_Basal_angle_hist);
    Discrete_color_quant_hist = 90/Angle_increment_hist;
    integerValue = Discrete_color_quant_hist;
    numberOfBars = integerValue;
    %barColorMap = jet(Discrete_color_quant);
    %barColorMap = parula(Discrete_color_quant);
    cmap_extention_param = Angle_increment_cmap/Angle_increment_hist
    usable_colormap = repelem(qual_map,cmap_extention_param,1)
    %barColorMap = usable_colormap;
    barColorMap = qual_map
    fibre_mis_angles = angle(ebsd_full(phase_of_interest).orientations,f)./degree;
 
    for b = 1 : numberOfBars
        % Plot one single bar as a separate bar series.
        upper_bound(b) = b*max_angle_degs/Discrete_color_quant_hist;
        lower_bound(b) = upper_bound(b) - max_angle_degs/Discrete_color_quant_hist;
        mid_point(b) = upper_bound(b) - (max_angle_degs/Discrete_color_quant_hist)/2;
        counts(b) = sum(fibre_mis_angles>lower_bound(b) & fibre_mis_angles<upper_bound(b));
        handleToThisBarSeries(b) = bar(mid_point(b), counts(b), 'BarWidth', max_angle_degs/Discrete_color_quant_hist);
        % Apply the color to this bar series.
        set(handleToThisBarSeries(b), 'FaceColor', barColorMap(b,:));
        hold on;
    end
 
        hold off;
        set(Fig_Basal_angle_hist,'Name','EBSD Basal fibre histogram');
 
        xlabel(titleString,'Interpreter','latex');
        ylabel(['Frequency']);
        set(gca, 'YTickMode', 'Auto');
        set(gca, 'XTickMode', 'Auto');
        set(gcf, 'color','white');
        set(gcf, 'InvertHardcopy', 'off');
        if save_figures == 'on'
            fig_name = strcat(Sample_ID_char, ' HIST FIBRE QUAL RAW.pdf')
        export_fig(fig_name)
    end
 
    disp('Fibre misorientation histogram produced') 
end
%% Grain calculation
if GRAIN_CALCULATION == 'Y'
  disp('Calulating grains...')
  % Calculate phase of interest only
  [grains_dirty,ebsd_full(phase_of_interest).grainId] = calcGrains(ebsd_full(phase_of_interest),'angle',Grain_mis_param,'unitCell')
  ebsd_full(grains_dirty(grains_dirty.grainSize <= Small_grain_param)) = [];
  ebsd_full= fill(ebsd_full(phase_of_interest),grains_dirty);
  [grains_clean,ebsd_full(phase_of_interest).grainId] = calcGrains(ebsd_full(phase_of_interest),'angle',Grain_mis_param,'unitCell');
  %ebsd_phase_smoothed = smooth(ebsd_full(phase_of_interest),grains_dirty,splineFilter,'fill');
  grains_clean = smooth(grains_clean,Grain_smooth_param)
  % Calculate for all
  [grains_dirty_full,ebsd_full('indexed').grainId] = calcGrains(ebsd_full('indexed'),'angle',Grain_mis_param,'unitCell')
  ebsd_full(grains_dirty_full(grains_dirty_full.grainSize < Small_grain_param)) = [];
  [grains_clean_full,ebsd_full('indexed').grainId] = calcGrains(ebsd_full('indexed'),'angle',Grain_mis_param,'unitCell');
  grains_clean_full = smooth(grains_clean_full,Grain_smooth_param);
 
  if VIEW_CRYSTAL == 'Y'
    [grains_dirty_crys,ebsd_data_for_crystal_shapes(phase_of_interest).grainId] = calcGrains(ebsd_data_for_crystal_shapes(phase_of_interest),'angle',Grain_mis_param,'unitCell')
    ebsd_data_for_crystal_shapes(grains_dirty_crys(grains_dirty_crys.grainSize <= Small_grain_param)) = [];
    ebsd_data_for_crystal_shapes= fill(ebsd_data_for_crystal_shapes(phase_of_interest),grains_dirty_crys);
    [grains_clean_crys,ebsd_data_for_crystal_shapes(phase_of_interest).grainId] = calcGrains(ebsd_data_for_crystal_shapes(phase_of_interest),'angle',Grain_mis_param,'unitCell');
    %ebsd_phase_smoothed = smooth(ebsd_full(phase_of_interest),grains_dirty,splineFilter,'fill');
    grains_clean_crys = smooth(grains_clean_crys,Grain_smooth_param)
  end
 
  
  disp('Grains calulated')
end
%% Grain plotting : Phase
if GRAIN_PHASE_MAP == 'Y'
    figure
    set(gca,'visible', 'off');
    plot(grains_clean_full)
    set(gca,'color', 'black');
    if save_figures == 'on'
      fig_name = strcat(Sample_ID_char,' MAP PHASE GRAINS.pdf')
      export_fig(fig_name)
    end
end
%% Grain plotting : IPF
if GRAIN_IPF_MAP == 'Y'
  %IPF Legend creaion
  % Plot IPF Orientation map
  disp('Plotting grain IPF orientation map...')
  Fig_IPF_map_full = figure('Name','Loading...');
  figure(Fig_IPF_map_full);
  ipfcolor = ipfKey.orientation2color(grains_clean.meanOrientation);
  %ipfcolor = TSLDirectionKey(ebsd_full(phase_of_interest).orientations);
  plot(grains_clean,ipfcolor,'add2all');
  set(Fig_IPF_map_full,'Name','Raw orientation map - IPF colour');
  set(gca,'Color','black');
  set(gca,'linewidth',3);
  set(gcf, 'InvertHardcopy', 'off');
  
  if save_figures == 'on'
      fig_name = strcat(Sample_ID_char,' MAP IPF GRAINS.pdf')
      export_fig(fig_name)
  end
   
  disp('Grain IPF Orientation map plotted')
end
%% Grain plotting : Basal deviation
if GRAIN_FIBRE_MAP == 'Y'
 
  Discrete_color_quant = 90;
   
  Scale_bar_limits = [0 90];
  angle_limit = angle_histogram_highlight*degree;
   
  % Create figure
  disp('Plotting fibre misorientation map...')
  Fig_103_Fibre_Map = figure('Name','Loading...','units','normalized','outerposition',[0 0 1 1]);
  figure(Fig_103_Fibre_Map);
  set(gca,'visible', 'off');
  % select all grain with misorientation angle to ori less then angle_limit
  raw_data_roi = grains_clean
  fibre_grains = grains_clean(angle(grains_clean.meanOrientation,f)<angle_limit);
  fibre_grains_above = grains_clean(angle(grains_clean.meanOrientation,f)>=angle_limit)
  fibre_gbs = fibre_grains.boundary
  set(gca,'color','none')
  overlay_plot = axes('NextPlot','add');
  
   
  
  %Plot grains <angle_limit
  %plot(grains_selected('HCP Zr'),angle(grains_selected.meanOrientation,f)./degree,'linecolor','r','linewidth',1)
  %plot(grains_selected('HCP Zr'),angle(grains_selected.meanOrientation,f)./degree);
  if angle_histogram_highlight ~=90
     plot(fibre_grains_above(phase_of_interest),angle(fibre_grains_above(phase_of_interest).meanOrientation,f)./degree,'FaceAlpha',0.3,'Parent',overlay_plot);
  end
  [~,mP] = plot(fibre_grains(phase_of_interest),angle(fibre_grains(phase_of_interest).meanOrientation,f)./degree,'Parent',overlay_plot);
  hold all
  if strcmp(aquisition_type,'ASTAR') == 0
    plot(fibre_gbs(phase_of_interest),'linecolor','black','linewidth',3,'Parent',overlay_plot,'micronBar','off');
    plot(fibre_gbs(phase_of_interest),'linecolor','white','linewidth',1,'Parent',overlay_plot,'micronBar','off');
  end
  
  %plot(gB_clean,'linecolor',[90 90 90]/255,'linewidth',0.1,'Parent',overlay_plot_raw_fibre);
   
  if ( strcmp( colormap_choice, "Parula_maroon_spec_deg_inc" ) ) 
    colormap(gca,Parula_maroon_spec_deg_inc);
    consitent_cmap = Parula_maroon_spec_deg_inc
  elseif ( strcmp( colormap_choice, "Discreet_BOGRPG" ) )
    colormap(gca,Discreet_BOGRPG);
    consitent_cmap = Discreet_BOGRPG
  elseif ( strcmp( colormap_choice, "Discreet_PBROGG" ) )
    colormap(gca,Discreet_PBROGG);
    consitent_cmap = Discreet_PBROGG
  elseif ( strcmp( colormap_choice, "Viridis_maroon_spec_deg_inc" ) )
    colormap(gca,Viridis_maroon_spec_deg_inc);
    consitent_cmap = Viridis_maroon_spec_deg_inc
  else
    colormap(gca,colormap_choice);
    consitent_cmap = colormap_choice
  end
   
  %colormap(parula(Discrete_color_quant))
  %colormap(parula)
  %colormap(Discreet_PBROGG)
  caxis(Scale_bar_limits);
  cb_new = mtexColorbar('TickLength',0)
  cb_new.Label.Interpreter = 'latex';
  set(cb_new,'TickLabelInterpreter', 'latex');
  colorTitleHandle = get(cb_new,'Label');
  set(colorTitleHandle ,'String',titleString);
  %plot(ebsd('Not Indexed'),'FaceColor','black','Parent',overlay_plot_raw_fibre);
  %plot(ebsd('HCP Zr'),'FaceColor',[150 150 150]/255,'Parent',overlay_plot_raw_fibre);
  %plot(ebsd('Tetragonal ZrO$$_2$$'),'FaceColor','white','Parent',overlay_plot_raw_fibre);
  
  
  %set(gca,'color','none')
  %set(gca,'visible','off')
  set(gcf,'Color','white')
  set(gcf, 'InvertHardcopy', 'off');
  set(gca,'linewidth',3);
  
  %axesHandles = findall(Fig_103_Fibre_Map,'type','axes');
  %axes_props = get(axesHandles,'position')
  %aspect_ratio = axes_props(3)/axes_props(4) 
  %set(Fig_103_Fibre_Map,'Name','EBSD Orientation map - fibre','outerposition',[0 0 1 aspect_ratio*0.7]);
  hgt = findall(gca,'type','hgtransform')
  set(hgt,'visible','off')
  set(hgt,'visible','on')
  set(gca,'Color','black')
 
  
 
 
  if VIEW_CRYSTAL == 'Y'
    crystal_diagram = crystalShape.hex(cs)
    crystal_diagram_grains = grains_clean_crys.meanOrientation * crystal_diagram * 0.35 * sqrt(grains_clean.area);
    %now we can plot these crystal shapes at the grain centers
    plot(grains_clean_crys.centroid + crystal_diagram_grains,'FaceColor',[88 88 88]/255,'linewidth',1.5,'Parent',overlay_plot,'micronBar','off')
 hold off
  end
 
 
  if save_figures == 'on'
      fig_name = strcat(Sample_ID_char,' MAP FIBRE GRAINS.pdf')
      export_fig(fig_name)
  end
   
  disp('Fibre misorientation map plotted') 
end
%% Grain statistics - grain sizes
if GRAIN_STATS == 'Y'
 
  grain_areas = grains_clean.area
  aspect_ratios = grains_clean.aspectRatio
  disp(grain_areas)
  largest_grain = max(grain_areas)
  total_area = sum(grain_areas,'double')
  disp(total_area)
 
  Angle_increment_hist = 0.0001
  max_angle = 0.01
  disp('Creating grain size histogram...')
  grain_size_hist = figure('Name','Loading...');
  figure(grain_size_hist);
  Discrete_color_quant_hist = largest_grain/Angle_increment_hist;
  integerValue = Discrete_color_quant_hist;
  numberOfBars = integerValue;
  %barColorMap = jet(Discrete_color_quant);
  barColorMap = parula(Discrete_color_quant);
  cmap_extention_param = Angle_increment_cmap/Angle_increment_hist
  usable_colormap = repelem(consitent_cmap,cmap_extention_param,1)
  barColorMap = usable_colormap;
  fibre_mis_angles = angle(ebsd_full(phase_of_interest).orientations,f)./degree;
   
  for b = 1 : numberOfBars
      % Plot one single bar as a separate bar series.
      counts(b)=0
      upper_bound(b) = b*largest_grain/Discrete_color_quant_hist;
      lower_bound(b) = upper_bound(b) - largest_grain/Discrete_color_quant_hist;
      mid_point(b) = upper_bound(b) - (largest_grain/Discrete_color_quant_hist)/2;
      for grain_id = 1 : length(grain_areas)
        if grain_areas(grain_id)>lower_bound(b) & grain_areas(grain_id)<upper_bound(b)
          counts(b) = counts(b) + grain_areas(grain_id)
        end
 
      end
      %counts(b) = sum(grain_areas>lower_bound(b) & grain_areas<upper_bound(b),'double')/total_area;
      handleToThisBarSeries(b) = bar(mid_point(b), (counts(b)/total_area)*100, 'BarWidth', largest_grain/Discrete_color_quant_hist);
      % Apply the color to this bar series.
      hold on;
  end
   
  hold off;
  set(grain_size_hist,'Name','EBSD Basal fibre histogram');
   
  xlabel(['Grain area (nm$^2$)'],'Interpreter','latex');
  ylabel(['$\%$ Total area of phase']);
  set(gca, 'YTickMode', 'Auto');
  set(gca, 'XTickMode', 'Auto');
  xlim([0 max_angle])
  ylim([0 50])
  set(gcf, 'color','white');
  set(gcf, 'InvertHardcopy', 'off');
  xticks = get(gca,'xtick') 
  scaling  = 1000000 
  newlabels = arrayfun(@(x) sprintf('%.0f', scaling * x), xticks, 'un', 0)
  set(gca,'xticklabel',newlabels)
  set(gca,'XMinorTick','on','YMinorTick','on')
  set(gca,'TickDir','out');
  
  if save_figures == 'on'
      fig_name = strcat(Sample_ID_char,phase_of_interest,' grain size hist.pdf');
      export_fig(fig_name);
  end
end
%% Grain statistics: major and minor axes 2d hist
if GRAIN_STATS == 'Y'
  [omega,maj_ax,min_ax] = grains_clean.fitEllipse;
  ax_bin_size = 0.01
  max_axis_val = 0.6
  maj_ax = maj_ax*2
  min_ax = min_ax*2
  
  
  for ax_val = 1 : length(maj_ax)
      ellipse_areas(ax_val) = (maj_ax(ax_val)/2)*(min_ax(ax_val)/2)*pi;
  end
  
  max_axis_vals = [max(maj_ax),max(min_ax)]
  %max_axis_val = max(max_axis_vals)
  maj_axis_bins = ((ax_bin_size-ax_bin_size/2):ax_bin_size:(max_axis_val-ax_bin_size/2))'
  min_axis_bins = ((ax_bin_size-ax_bin_size/2):ax_bin_size:(max_axis_val-ax_bin_size/2))
  relative_area = ((maj_axis_bins/2).*(min_axis_bins/2)*pi)/sum(ellipse_areas)
  axis_bins = {maj_axis_bins min_axis_bins}
 
  hist_2d = hist3([maj_ax, min_ax],'Ctrs',axis_bins');
  
  Fig_2d_hist_as_res= figure('Name','Loading...');
  figure(Fig_2d_hist_as_res);
 
  hist_2d_normalised = (hist_2d.*relative_area)*100
  
  pcolor(hist_2d_normalised)
  cb_new = mtexColorbar('TickLength',0)
  cb_new.Label.Interpreter = 'latex';
  set(cb_new,'TickLabelInterpreter', 'latex');
  colorTitleHandle = get(cb_new,'Label');
  set(colorTitleHandle ,'String','$\%$ of phase area', 'fontsize', 12);
 
  set(gcf,'Color','white')
  set(gcf, 'InvertHardcopy', 'off');
  %set(gca,'linewidth',1);
 
  colormap(white_viridis_n)
  xticks = get(gca,'xtick') 
  scaling  = 1000*ax_bin_size
  newxlabels = arrayfun(@(x) sprintf('%.0f', scaling * x), xticks, 'un', 0)
  yticks = get(gca,'ytick')
  newylabels = arrayfun(@(y) sprintf('%.0f', scaling * y), yticks, 'un', 0)
  set(gca,'xticklabel',newxlabels)
  set(gca,'yticklabel',newylabels)
  set(gca,'XMinorTick','on','YMinorTick','on')
  set(gca,'TickDir','out');
  xlabel('Minor axis length (nm)')
  ylabel('Major axis length (nm)')
  
  if save_figures == 'on'
    fig_name = strcat(Sample_ID_char,' 2D aspect_ratio_hist.pdf')
    export_fig(fig_name)
  end
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
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 

