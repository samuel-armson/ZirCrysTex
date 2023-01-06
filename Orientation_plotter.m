% Master File for running Zirconia_mTeX 
%{
Found that best grain calc params are:
misorientation = 15 (degrees)
smallest_grain = 3 (pixels)
smoothing = 3 (unknown)
%}
% Select mTeX installation to use and start mTeX
addpath(genpath('C:/Users/Sam A/Documents/GitHub/Zirconia_mTeX'));
addpath 'functions';
addpath 'third_party_packages';
% Define global variables
global phase_of_interest
global cs
global reference_texture_component
global Sample_ID
global pname
addpath 'C:/Users/Sam A/My Documents/MATLAB/mtex-5.8.0/mtex-5.8.0';
startup_mtex
setMTEXpref('xAxisDirection','east');
setMTEXpref('zAxisDirection','outOfPlane');
% Phase of interest for orientation analysis - select here for global phase of interest.
phase_of_interest = 'Monoclinic ZrO$$_2$$';
% Reference texture component. Used for plotting angular deviation of points from. Used for colouring and histogram (if desired).
reference_texture_component = [1,0,-3];


%%

csBeta = crystalSymmetry('432',[3.3 3.3 3.3],'mineral','Ti (beta)');
csAlpha = crystalSymmetry('622',[3 3 4.7],'mineral','Ti (alpha)');

oriParent = orientation.rand(csBeta);
oriParent = orientation.byMiller([0 0 1],[0 0 1],csBeta)
%beta2alpha = orientation.Burgers(csBeta,csAlpha)

beta2alpha = orientation.map(Miller(1,1,0,csBeta),Miller(0,0,0,1,csAlpha),...
      Miller(-1,1,-1,csBeta),Miller(2,-1,-1,0,csAlpha));

oriChild = oriParent * inv(beta2alpha)

% (110) / (0001) pole figure
plotPDF(oriParent,Miller(1,1,0,csBeta),...
  'MarkerSize',20,'MarkerFaceColor','none','linewidth',4)
hold on
plot(oriChild.symmetrise * Miller(0,0,0,1,csAlpha),'MarkerSize',12)
xlabel(char(Miller(0,0,0,1,csAlpha)),'color',ind2color(2))
hold off

% [111] / [2-1-10] pole figure
nextAxis(2)
plotPDF(oriParent,Miller(1,1,1,csBeta,'uvw'),'upper',...
  'MarkerSize',20,'MarkerFaceColor','none','linewidth',4)

dAlpha = Miller(2,-1,-1,0,csAlpha,'uvw');
hold on
plot(oriChild.symmetrise * dAlpha,'MarkerSize',12)
%plot(oriChild.symmetrise,'MarkerSize',12)
xlabel(char(dAlpha),'color',ind2color(2))
hold off
drawNow(gcm)
%% Mono and HCP

csMetal = crystalSymmetry('6/mmm', [3.232 3.232 5.147], 'X||a', 'Y||b*', 'Z||c*', 'mineral', 'HCP Zr');
csMono = crystalSymmetry('12/m1', [5.169 5.232 5.341], [90,99,90]*degree, 'X||a*', 'Y||b*', 'Z||c', 'mineral', 'Monoclinic ZrO$$_2$$');

oriParent = orientation.rand(csMetal);
oriParent = orientation.byMiller([0 0 0 1],[0 0 1],csMetal)
oriChild = orientation.byMiller([1,1,-2],[0 0 1],csMono)
ss = specimenSymmetry('triclinic')
oriParent = orientation.byEuler(0*degree,0*degree,0*degree,csMetal,ss)
%oriChild = orientation.byEuler(0*degree,0*degree,0*degree,csMono,ss)
%Metal2Mono = orientation.Burgers(csBeta,csAlpha)

Metal2Mono = orientation.map(Miller(0,0,0,1,csMetal),Miller(1,1,-2,csMono),...
    Miller(1,-1,0,0,csMetal,'UVTW'),Miller(1,1,1,csMono,'uvw'));

oriChild = oriParent * inv(Metal2Mono)

% (110) / (0001) pole figure
plotPDF(oriParent,Miller(0,0,0,1,csMetal),...
  'MarkerSize',20,'MarkerFaceColor','none','linewidth',4)
hold on
plot(oriChild.symmetrise * Miller(1,1,-2,csMono),'MarkerSize',12)
%plot(oriChild,'MarkerSize',12)
xlabel(char(Miller(1,1,-2,csMono)),'color',ind2color(2))
hold off

% [111] / [2-1-10] pole figure
nextAxis(2)
plotPDF(oriParent,Miller(1,-1,0,0,csMetal,'UVTW'),'upper',...
  'MarkerSize',20,'MarkerFaceColor','none','linewidth',4)

dMono = Miller(1,-1,0,0,csMetal,'UVTW');
hold on
plot(oriChild.symmetrise * dMono,'MarkerSize',12)
%xlabel(char(dMono),'color',ind2color(2))
hold off
drawNow(gcm)



%% FROM SCRATCH ==========================================================================================================================================================
setMTEXpref('pfAnnotations',@(varargin) 1);
csMetal = crystalSymmetry('6/mmm', [3.232 3.232 5.147], 'X||a', 'Y||b*', 'Z||c*', 'mineral', 'HCP Zr');
csMono = crystalSymmetry('12/m1', [5.169 5.232 5.341], [90,99,90]*degree, 'X||a*', 'Y||b*', 'Z||c', 'mineral', 'Monoclinic ZrO$$_2$$');
%--------------------------------------------------------------------------------------------------------------------------------------------------------
oriChild = orientation.byMiller([1,1,-2],[0 0 1],csMono)
oriParent = orientation.byMiller([0,0,0,2],[0 0 1],csMetal)

Metal2Mono = orientation.map(Miller(0,0,0,2,csMetal),Miller(1,1,-2,csMono),...
    Miller(1,-1,0,0,csMetal,'UVTW'),Miller(1,1,1,csMono,'uvw'));

Metal2Mono_min = orientation.map(Miller(0,0,0,1,csMetal,'HKIL'),Miller(3,1,-2,csMono,'hkl'),...
    Miller(1,-1,0,0,csMetal,'UVTW'),Miller(1,1,1,csMono,'uvw'));

oriParent_sym = symmetrise(oriParent)

oriChild = oriParent_sym * inv(Metal2Mono)
%oriChild_min = oriParent_sym * inv(Metal2Mono_min)



%--------------------------------------------------------------------------------------------------------------------------------------------------------
proj_type = 'earea'
plotPDF(oriChild,Miller(1,0,-6,csMono),'MarkerSize',12,'antipodal','projection',proj_type)
hold on
%plot(oriChild_min*Miller(3,1,-2,csMono),'MarkerSize',8)
plot(oriParent*Miller(0,0,0,2,csMetal),'MarkerSize',20,'MarkerFaceColor','none','linewidth',4)
hold off

nextAxis(2)
plotPDF(oriChild,Miller(1,1,-2,csMono),'MarkerSize',12,'antipodal','projection',proj_type)
hold on
%plot(oriChild_min*Miller(3,1,-2,csMono),'MarkerSize',8)
plot(oriParent*Miller(0,0,0,2,csMetal),'MarkerSize',20,'MarkerFaceColor','none','linewidth',4)
hold off


nextAxis(3)
plotPDF(oriChild,Miller(1,1,1,csMono,'uvw'),'MarkerSize',12,'antipodal','projection',proj_type)
hold on
%plot(oriChild_min*Miller(3,1,-2,csMono),'MarkerSize',8)
plot(oriParent_sym*Miller(1,-1,0,0,csMetal,'UVTW'),'MarkerSize',20,'MarkerFaceColor','none','linewidth',4)
hold off


%% Sign off
for n=1:1
    load gong
    sound(y,Fs)
    disp('FIN')
 
    figure;
    set(gca,'visible','off')
    text(0.3,0.4,'fin.', 'FontSize',100);
end































































