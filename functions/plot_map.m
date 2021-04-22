function pm = plot_map(data_in,map_type,varargin)
	%{
	Plots raw EBSD data or pre-calculated grain data. 

	REQUIRED ARGUMENTS
	data_in = EBSD or GRAINS data type provided by mTeX.
	map_type = Either: 'IPF','Euler','Deviation', 'Phase', 'BC'

	OPTIONAL ARGUMENTS
	IPF_key = 
	plot_key = 'off' or 'on'. On is defualt.
	ref_texture_comp = Eg. [0,0,0,2] or [0,0,1]. 
	view_unit_cell = 'CS' for cross-section corrected data, 'PV' or 'yes' for plan-view data. Default is 'no'.
	save_fig = 'yes' or 'no'. Default value is no. This is useful for saving time and storage space when testing scripts before
				commiting to saving them.
	sample_ID = 'Example sample ID', for example. Required when you want to save the figure. It is useful to set a global sample
				name using the figure_name function directly before starting to plot figures. The char string produced by this
				function can then be used as the sample_ID argument.
	extension = 'tif','png','jpg','pdf' etc. Default is pdf.
	resolution = integer value. Default is 1000. (dpi)

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
	addOptional(p,'gb_overlay','off');
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

	aspect_ratio_correction = 0.6



	disp('')
	disp('Plotting map...')
	disp('')

	figure_width = p.Results.figure_width;
	map_type = p.Results.map_type;
	
	if isa(data_in,'EBSD') == 1

		if strcmp(map_type,'IPF') == 1
			ipfKey = p.Results.IPF_key
			mapcolor = ipfKey.orientation2color(data_in(p.Results.phase_name).orientations);
			if strcmp(p.Results.plot_key,'on') == 1
				ipf_key_fig = figure('Name','IPF Key');
				newMtexFigure(ipf_key_fig)
				plot(ipfKey)
  				if strcmp(p.Results.phase_name,'Monoclinic ZrO$$_2$$')
    				hold on 
    				annotate([Miller(1,0,0,cs),Miller(1,1,0,cs),Miller(0,0,1,cs),Miller(0,1,0,cs),Miller(-1,0,0,cs),Miller(-1,1,0,cs),Miller(1,0,-6,cs)],...
      				'all','labeled','BackgroundColor','white');
   					hold off
  				end
  			end
		end

		if strcmp(map_type,'Euler') == 1
			oM = BungeColorKey(cs);
			mapcolor = oM.orientation2color(data_in(p.Results.phase_name).orientations);
		end


		if strcmp(map_type,'Deviation') == 1
			if strcmp(p.Results.plot_key,'on') == 1
				Angle_increment_hist = 1;
				Angle_increment_cmap = 1;
  				Fig_Basal_angle_hist = figure('Name','Loading...');
  				figure(Fig_Basal_angle_hist);
  				Discrete_color_quant_hist = 90/Angle_increment_hist;
  				integerValue = Discrete_color_quant_hist;
  				numberOfBars = integerValue;
  				cmap_extention_param = Angle_increment_cmap/Angle_increment_hist;
  				usable_colormap = repelem(consitent_cmap,cmap_extention_param,1);
  				barColorMap = usable_colormap;
  				f = define_fibre(p.Results.ref_text_comp,'crys_sym',p.Results.crys_sym)
  				fibre_mis_angles = angle(ebsd_full(p.Results.phase_name).orientations,f,'antipodal')./degree;
   
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
			
			map_figure = figure('Name','Map loading...');
			newMtexFigure(map_figure)
			fibre_angles = angle(data_in(p.Results.phase_name).orientations,p.Results.ref_text_comp,'antipodal')./degree;
			for fa = 1 : length(fibre_angles)
				if fibre_angles(fa) > 90
					fibre_angles(fa) = 180 - fibre_angles(fa);
				end
				fa = fa+1;
			end
			plot(data_in(p.Results.phase_name),fibre_angles)
			if strcmp(p.Results.phase_name,'HCP Zr')
				colormap(gca,purple_red(90));
			else
				colormap(gca,parula_red('increment',1));
			end
			%Scale_bar_limits = [0 90]
			%caxis(Scale_bar_limits);
  			cb_new = mtexColorbar
  			cb_new.Label.Interpreter = 'latex';
  			set(cb_new,'TickLabelInterpreter', 'latex')
  			axesHandles = findall(map_figure,'type','axes');
  			axes_props = get(axesHandles,'position')
  			aspect_ratio = axes_props(3)/axes_props(4)
  		elseif strcmp(map_type,'BC') == 1
  			map_figure = figure('Name','Map loading...');
			newMtexFigure(map_figure)
  			plot(data_in(p.Results.phase_name),data_in(p.Results.phase_name).bc)
  			colormap(gca,gray);
  			if strcmp(p.Results.gb_overlay,'off') == 0
  				hold on
  				grain_data = p.Results.gb_overlay(p.Results.phase_name)
  				gB = grain_data.boundary
  				boundaries_for_misorientation = gB(p.Results.phase_name,p.Results.phase_name)
  				%plot(boundaries,'lineColor',[190,25,25]./255)
  				plot(gB,boundaries_for_misorientation.misorientation.angle./degree)
  				hold off
  			end
		elseif strcmp(map_type,'phase')
			map_figure = figure('Name','Map loading...');
			newMtexFigure(map_figure)
			plot(data_in('indexed'));
			aspect_ratio_correction = 1.2
			%hold on
    		%plot(data_in('notIndexed'),'FaceColor','black')
    		%hold off

    	else
    		plot(data_in(p.Results.phase_name),mapcolor,'add2all');
  		end
  		set(gca,'Color','black');
  		set(gcf, 'InvertHardcopy', 'off');
  		set(gca,'linewidth',1);
  		%Uncomment lines below to remove scale bar 
  		%hgt = findall(gca,'type','hgtransform')
  		%set(hgt,'visible','off')

	elseif isa(data_in, 'grain2d') ==1

		

		gB = data_in(p.Results.phase_name).boundary

		if strcmp(map_type,'IPF') == 1
			ipfKey = p.Results.IPF_key
			mapcolor = ipfKey.orientation2color(data_in(p.Results.phase_name).meanOrientation);
			if strcmp(p.Results.plot_key,'on') == 1
				ipf_key_fig = figure('Name','IPF Key');
				newMtexFigure(ipf_key_fig)
				plot(ipfKey)
  				if strcmp(phase_of_interest,'Monoclinic ZrO$$_2$$')
    				hold on 
    				annotate([Miller(1,0,0,cs),Miller(1,1,0,cs),Miller(0,0,1,cs),Miller(0,1,0,cs),Miller(-1,0,0,cs),Miller(-1,1,0,cs),Miller(1,0,-6,cs)],...
      				'all','labeled','BackgroundColor','white');
   					hold off
  				end
  			end
		end

		if strcmp(map_type,'Euler') == 1
			oM = BungeColorKey(cs);
			mapcolor = oM.orientation2color(data_in(p.Results.phase_name).meanOrientation);
		end

		map_figure = figure('Name','Map loading...');
		newMtexFigure(map_figure)

		if strcmp(map_type,'Deviation') == 1
			aspect_ratio_correction = 0.6
			f = define_fibre(p.Results.ref_text_comp,'crys_sym',p.Results.crys_sym)
			fibre_angles = angle(data_in(p.Results.phase_name).meanOrientation,f,'antipodal')./degree;
			for fa = 1 : length(fibre_angles)
				if fibre_angles(fa) > 90
					fibre_angles(fa) = 180 - fibre_angles(fa);
				end
				fa = fa + 1;
			end
			plot(data_in(p.Results.phase_name),fibre_angles)
			if strcmp(p.Results.phase_name,'HCP Zr')
				colormap(gca,purple_red(90));
			else
				colormap(gca,parula_red('increment',1));
			end
			Scale_bar_limits = [0 90]
			caxis(Scale_bar_limits);
  			cb_new = mtexColorbar('location','southoutside')
  			cb_new.Label.Interpreter = 'latex';
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
  			x_label = xlabel(cb_new, titleString,'FontSize',8)
  			set(cb_new,'TickLabelInterpreter', 'latex')
  			axesHandles = findall(map_figure,'type','axes');
  			axes_props = get(axesHandles,'position')
  			aspect_ratio = axes_props(3)/axes_props(4)
  			%hold on
			%plot(gB,'linecolor','black','linewidth',3,'micronBar','off');
    		%plot(gB,'linecolor','white','linewidth',1,'micronBar','off');
    		%hold off
    	elseif strcmp(map_type,'phase')
    		aspect_ratio_correction = 0.3
			plot(data_in('indexed'));
			%hold on
    		%plot(data_in('notIndexed'),'FaceColor','black')
    		%hold off
    	elseif strcmp(map_type,'gb_only')
    		aspect_ratio_correction = 0.3
			grain_data = data_in(p.Results.phase_name)
  			boundaries = grain_data.boundary
  			plot(boundaries,'lineColor',[190,25,25]./255)
		else
			aspect_ratio_correction = 0.3
			plot(data_in(p.Results.phase_name),mapcolor,'add2all');
			%hold on
			%plot(gB,'linecolor','black','linewidth',3,'micronBar','off');
    		%plot(gB,'linecolor','white','linewidth',1,'micronBar','off');
    		%hold off
  		end
  		set(gca,'Color','black');
  		set(gcf, 'InvertHardcopy', 'off');
  		set(gca,'linewidth',1);
  		%Uncomment lines below to remove scale bar 
  		%hgt = findall(gca,'type','hgtransform')
  		%set(hgt,'visible','off')

  		if strcmp(p.Results.view_unit_cell, 'no') == 0
  			hold on
  			unitcell_overlay_ori_data = data_in(p.Results.phase_name)
  			crystal_diagram = crystalShape.hex(p.Results.crys_sym)
    		crystal_diagram_grains = unitcell_overlay_ori_data.meanOrientation * crystal_diagram * 0.4 * sqrt(unitcell_overlay_ori_data.area);
    		if strcmp(p.Results.view_unit_cell, 'CS') == 1
    			cross_section_correction = rotation('axis',xvector,'angle',270*degree);
  				crystal_diagram_grains = rotate(crystal_diagram_grains,cross_section_correction);
  			end
			plot(unitcell_overlay_ori_data.centroid + crystal_diagram_grains,'FaceColor',[200 200 200]/255,'FaceAlpha',0.8,'linewidth',1.5)
 			hold off
 		end

	else
		disp("'data_in' must be of type 'EBSD' or 'GRAINS' ")
	end

	set(findall(gcf,'-property','FontSize'),'FontSize',8)
 	set(gcf,'units','centimeters')
    desired_width = 15.5
    pos = get(gca, 'Position'); %// gives x left, y bottom, width, height
	current_width = pos(3)
	current_height = pos(4)
	desired_height = desired_width * (current_height./current_width) * aspect_ratio_correction
    set(gcf,'position',[5 5 desired_width desired_height])
    set(groot,'defaulttextinterpreter','latex');
	set(groot,'defaultLegendInterpreter','latex');
	set(groot,'defaultAxesTickLabelInterpreter','latex');  


end

































































