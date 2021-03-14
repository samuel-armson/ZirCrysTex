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
	addRequired(p,'map_type');
	addOptional(p,'phase_name',phase_of_interest);
	addOptional(p,'plot_key','on');
	addOptional(p,'crys_sym',cs)
	addOptional(p,'ref_text_comp',reference_texture_component)
	addOptional(p,'save_fig','none');
	addOptional(p,'sample_ID','none');
	addOptional(p,'extension','none');
	addOptional(p,'resolution','none');
	addOptional(p,'view_unit_cell','no')
	addOptional(p,'IPF_key', ipfHSVKey(cs.Laue));
	addOptional(p,'figure_width',16); %Width of figure in cm. A4 paper is 21cm wide, so 16cm is good for thesis.

	parse(p,data_in,map_type,varargin{:});	

	if strcmp(p.Results.plot_key,'on') == 1
		Angle_increment_hist = 1
		Fig_Basal_angle_hist = figure('Name','Loading...');
		figure(Fig_Basal_angle_hist);
		Discrete_color_quant_hist = 90/Angle_increment_hist;
		integerValue = Discrete_color_quant_hist;
		numberOfBars = integerValue;
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
		
	end













































	