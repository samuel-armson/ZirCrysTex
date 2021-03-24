% Master File for running Zirconia_mTeX 

% Select mTeX installation to use and start mTeX
addpath 'C:/Users/Rhys/My Documents/MATLAB/mtex-5.1.1';
addpath 'functions';
addpath 'third_party_packages';
% Define global variables
global phase_of_interest
global cs
global reference_texture_component
global Sample_ID
global pname
%addpath 'C:/Users/Sam/My Documents/MATLAB/mtex-5.2.8';
startup_mtex

% Saving figures takes time. Best to only use on final run: 'on' or 'no'. Apply to all functions here.
save_figures = 'no';

% Sample ID: name given to saved output figures. Choose to ensure that other files aren't overwritten    
Sample_ID = "2NVa3";
% Path to files. eg: 'J:/Nature Paper Figures/'
pname = 'D:/Sam/Dropbox (The University of Manchester)/Sam Armson shared folder/Experimental/SPED/';

% File name with pname prefix, eg: [pname 'SPED_Substrate_MARIA.ctf']
MIBL_3_full = [pname 'MIBL EX HIGH DR 3/MIBL EX HIGH DR 3 R_1.6_EE_0.4_more_phases_index400_or_1.ctf'];

MIBL3_phases = cs_loader({'mono','suboxide','tet','metal','hydride','hematite','pt'})

CS_MIBL_3 = {... 
  'notIndexed',...
  crystalSymmetry('12/m1', [5.169 5.232 5.341], [90,99,90]*degree, 'X||a*', 'Y||b*', 'Z||c', 'mineral', 'Monoclinic ZrO$$_2$$', 'color', [27 81 45]/255),...
  crystalSymmetry('6/mmm', [5.312 5.312 3.197], 'X||a*', 'Y||b', 'Z||c*', 'mineral', 'Hexagonal ZrO', 'color', [239 202 8]/255),...
  crystalSymmetry('4/mmm', [3.596 3.596 5.184], 'mineral', 'Tetragonal ZrO$$_2$$', 'color', [208 37 48]/255),...
  crystalSymmetry('6/mmm', [3.232 3.232 5.147], 'X||a*', 'Y||b', 'Z||c*', 'mineral', 'HCP Zr', 'color', [75 154 170]/255),...
  crystalSymmetry('4/mmm', [3.52 3.52 4.45], 'mineral', 'Zr Hydride', 'color', [240 135 0]/255),...
  crystalSymmetry('-3m1', [5.038 5.038 13.772], 'X||a*', 'Y||b', 'Z||c*', 'mineral', 'Hematite', 'color',[99 38 74]/255),...
  crystalSymmetry('m-3m', [4.086 4.086 4.086], 'mineral', 'Amorphous Pt', 'color', [100 100 100]/255)};


%% Sign off
for n=1:1
    load gong
    sound(y,Fs)
    disp('FIN')
 
    figure;
    set(gca,'visible','off')
    text(0.3,0.4,'fin.', 'FontSize',100);
end































