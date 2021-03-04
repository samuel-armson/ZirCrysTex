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





	disp('')
	disp('Plotting map...')
	disp('')

	figure_width = p.Results.figure_width;
	map_type = p.Results.map_type;
	
	if isa(data_in,'EBSD') == 1

		if strcmp(map_type,'IPF') == 1
			ipfKey = p.Results.IPF_key
			mapcolor = ipfKey.orientation2color(data_in(phase_of_interest).orientations);
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
			mapcolor = oM.orientation2color(data_in(phase_of_interest).orientations);
		end



		map_figure = figure('Name','Map loading...');
		newMtexFigure(map_figure)

		if strcmp(map_type,'Deviation') == 1
			plot(data_in(p.Results.phase_name),angle(data_in(phase_of_interest).orientations,p.Results.ref_text_comp)./degree)
			colormap(gca,parula);
			Scale_bar_limits = [0 90]
			caxis(Scale_bar_limits);
  			cb_new = mtexColorbar
  			cb_new.Label.Interpreter = 'latex';
  			set(cb_new,'TickLabelInterpreter', 'latex')
  			axesHandles = findall(map_figure,'type','axes');
  			axes_props = get(axesHandles,'position')
  			aspect_ratio = axes_props(3)/axes_props(4)
  		elseif strcmp(map_type,'BC') == 1
  			plot(data_in(p.Results.phase_name),data_in(p.Results.phase_name).bc)
  			colormap(gca,gray);
		else
			plot(data_in(p.Results.phase_name),mapcolor,'add2all');
  		end
  		set(gca,'Color','black');
  		set(gcf, 'InvertHardcopy', 'off');
  		set(gca,'linewidth',3);
  		%Uncomment lines below to remove scale bar 
  		%hgt = findall(gca,'type','hgtransform')
  		%set(hgt,'visible','off')
		
	elseif isa(data_in, 'grain2d') ==1

		gB = data_in(p.Results.phase_name).boundary

		if strcmp(map_type,'IPF') == 1
			ipfKey = p.Results.IPF_key
			mapcolor = ipfKey.orientation2color(data_in(phase_of_interest).meanOrientation);
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
			mapcolor = oM.orientation2color(data_in(phase_of_interest).meanOrientation);
		end

		map_figure = figure('Name','Map loading...');
		newMtexFigure(map_figure)

		if strcmp(map_type,'Deviation') == 1
			plot(data_in(p.Results.phase_name),angle(data_in(phase_of_interest).meanOrientation,p.Results.ref_text_comp)./degree)
			colormap(gca,parula);
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
		else
			plot(data_in(p.Results.phase_name),mapcolor,'add2all');
			%hold on
			%plot(gB,'linecolor','black','linewidth',3,'micronBar','off');
    		%plot(gB,'linecolor','white','linewidth',1,'micronBar','off');
    		%hold off
  		end
  		set(gca,'Color','black');
  		set(gcf, 'InvertHardcopy', 'off');
  		set(gca,'linewidth',3);
  		%Uncomment lines below to remove scale bar 
  		%hgt = findall(gca,'type','hgtransform')
  		%set(hgt,'visible','off')

  		if strcmp(p.Results.view_unit_cell, 'no') == 0
  			hold on
  			unitcell_overlay_ori_data = data_in(phase_of_interest)
  			crystal_diagram = crystalShape.hex(cs)
    		crystal_diagram_grains = unitcell_overlay_ori_data.meanOrientation * crystal_diagram * 0.4 * sqrt(unitcell_overlay_ori_data.area);
    		if strcmp(p.Results.view_unit_cell, 'CS') == 1
    			cross_section_correction = rotation('axis',xvector,'angle',270*degree);
  				crystal_diagram_grains = rotate(crystal_diagram_grains,cross_section_correction);
  			end
    		plot(unitcell_overlay_ori_data.centroid + crystal_diagram_grains,'FaceColor',[255 255 255]/255,'linewidth',1.5,'micronBar','on')
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
	desired_height = desired_width * (current_height./current_width) * 0.6
    set(gcf,'position',[5 5 desired_width desired_height])

end

































































