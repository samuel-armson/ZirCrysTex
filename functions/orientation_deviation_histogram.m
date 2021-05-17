function dev_hist = orientation_deviation_histogram(data_in,varargin)

	%{
	data_in = EBSD or grains2d data type. Best to use EBSD to get more representative results regarding
	volume of sample vs. simply number of grains.
	%}

	global cs
	global reference_texture_component
	global phase_of_interest
	global Sample_ID

	if isempty(reference_texture_component) == 1
		reference_texture_component = [0,0,1];
	end
	
	p = inputParser;
	addRequired(p,'data_in');
	addOptional(p,'bin_size',1);
	addOptional(p,'colormap_bins',1);
	addOptional(p,'phase_name',phase_of_interest);
	addOptional(p,'titles',' ')
	addOptional(p,'highlight_lower_limit',90)
	addOptional(p,'crys_sym',cs)
	addOptional(p,'ref_text_comp',reference_texture_component)
	addOptional(p,'save_fig','none');
	addOptional(p,'sample_ID','none');
	addOptional(p,'extension','none');
	addOptional(p,'resolution','none');
	addOptional(p,'view_unit_cell','no')
	addOptional(p,'IPF_key', ipfHSVKey(cs.Laue));
	addOptional(p,'figure_width',16); %Width of figure in cm. A4 paper is 21cm wide, so 16cm is good for thesis.

	parse(p,data_in,varargin{:});	


	disp('Plotting orientation histogram...')

	Angle_increment_hist = p.Results.bin_size;
	Angle_increment_cmap = p.Results.colormap_bins;
	angle_histogram_highlight = p.Results.highlight_lower_limit;
	max_angle_degs = 90

	Fig_Basal_angle_hist = figure('Name','Loading...');
	figure(Fig_Basal_angle_hist);
	Discrete_color_quant_hist = 90/Angle_increment_hist;
	numberOfBars = round(Discrete_color_quant_hist);
	cmap_extention_param = Angle_increment_cmap/Angle_increment_hist;
	%usable_colormap = repelem(parula_red('increment',Angle_increment_cmap),cmap_extention_param,1);
	usable_colormap = repelem(plasma(90/Angle_increment_cmap),cmap_extention_param,1);
	barColorMap = usable_colormap;
	f = define_fibre(p.Results.ref_text_comp,'crys_sym',p.Results.crys_sym)
	
	if isa(data_in, 'EBSD') == 1
		fibre_mis_angles = angle(data_in(p.Results.phase_name).orientations,f)./degree;
	elseif isa(data_in,'grain2d') == 1
		fibre_mis_angles = angle(data_in(p.Results.phase_name).meanOrientation,f)./degree;
	else
		disp('Input Data must be EBSD or grain2d data type!')
	end

	total_pixel_no = length(fibre_mis_angles)

	for fa = 1 : total_pixel_no
		if fibre_mis_angles(fa) > 90
			fibre_mis_angles(fa) = 180 - fibre_mis_angles(fa);
		end
		fa = fa+1;
	end



	for b = 1 : numberOfBars
		% Plot one single bar as a separate bar series.
		upper_bound(b) = b*max_angle_degs/Discrete_color_quant_hist;
		lower_bound(b) = upper_bound(b) - max_angle_degs/Discrete_color_quant_hist;
		mid_point(b) = upper_bound(b) - (max_angle_degs/Discrete_color_quant_hist)/2;
		counts(b) = (sum(fibre_mis_angles>lower_bound(b) & fibre_mis_angles<upper_bound(b))/total_pixel_no)*100;
		handleToThisBarSeries(b) = bar(mid_point(b), counts(b), 'BarWidth', max_angle_degs/Discrete_color_quant_hist);
		% Apply the color to this bar series.
		if b > angle_histogram_highlight
			set(handleToThisBarSeries(b), 'FaceColor', barColorMap(b,:),'FaceAlpha', 0.3);
			disp('greater than')
			disp(b)
		else
			set(handleToThisBarSeries(b), 'FaceColor', barColorMap(b,:));
			disp(b)
		end
		hold on;
		b=b+1
	end

	hold off;
	set(Fig_Basal_angle_hist,'Name','EBSD Basal fibre histogram');

	titleString =  "$$\left\{"
	for increment = 1:length(p.Results.ref_text_comp)
		if p.Results.ref_text_comp(increment) < 0
			tex_val = "\bar{" + num2str(abs(p.Results.ref_text_comp(increment))) + "}";
			titleString = strcat(titleString, tex_val);
		else
			titleString = strcat(titleString,num2str(p.Results.ref_text_comp(increment)));
		end
	end
	titleString = strcat(titleString,"\right\}$$ plane-normal deviation from growth direction $$ \left(^{\circ}\right)$$")

	title(p.Results.titles)
	xlim([0 90])
	xlabel(titleString,'Interpreter','latex','FontSize',8);
	ylabel(['Normalised Frequency (\%)']);
	set(gca, 'YTickMode', 'Auto');
	set(gca, 'XTickMode', 'Auto');
	set(gca,'TickDir','out');
	set(gcf, 'color','white');
	set(gcf, 'InvertHardcopy', 'off');
	set(findall(gcf,'-property','FontSize'),'FontSize',8)













































end
	