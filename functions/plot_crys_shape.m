function pm = plot_crys_shape(data_in,grain_ids,varargin)
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
	addRequired(p,'grain_ids');
	addOptional(p,'phase_name',phase_of_interest);
	addOptional(p,'plot_key','off');
	addOptional(p,'gb_overlay','off');
	addOptional(p,'ellipse_overlay','off');
	addOptional(p,'crys_sym','cs')
	addOptional(p,'ref_text_comp',reference_texture_component)
	addOptional(p,'save_fig','none');
	addOptional(p,'sample_ID','none');
	addOptional(p,'output_dir','none');
	addOptional(p,'extension','none');
	addOptional(p,'resolution','none');
	addOptional(p,'view_unit_cell','no')
	addOptional(p,'IPF_key','none');
	addOptional(p,'figure_width',16); %Width of figure in cm. A4 paper is 21cm wide, so 16cm is good for thesis.

	parse(p,data_in,grain_ids,varargin{:});


	aspect_ratio_correction = 0.6
	ellipse_colour = [12,176,16]./255

	cs = data_in(p.Results.phase_name).CS

	disp('')
	disp('Plotting map...')
	disp('')

	figure_width = p.Results.figure_width;
	
	

	if isa(data_in, 'grain2d') == 1


		map_figure = figure('Name','Map loading...');
		newMtexFigure(map_figure)

		aspect_ratio_correction = 0.6
		f = define_fibre(p.Results.ref_text_comp,'crys_sym',cs)
		fibre_angles = angle(data_in(p.Results.phase_name).meanOrientation,f,'antipodal')./degree;
		for fa = 1 : length(fibre_angles)
			if fibre_angles(fa) > 90
				fibre_angles(fa) = 180 - fibre_angles(fa);
			end
			fa = fa + 1;
		end
		plot(data_in(p.Results.phase_name),fibre_angles)
		if strcmp(p.Results.phase_name,'HCP Zr')
			colormap(gca,algae);
			gB = data_in(p.Results.phase_name).boundary;
			hold on
			plot(gB,'LineColor','white')
			hold off
		else
			colormap(gca,plasma);
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

		hold on 
		text(data_in(p.Results.phase_name),int2str(data_in(p.Results.phase_name).id),'textColor','red')
		hold off

		set(gca,'Color','black');
			set(gcf, 'InvertHardcopy', 'off');
			set(gca,'linewidth',1);
		crystal_diagram = crystalShape.hex(cs)

		output_loc = p.Results.output_dir
		mkdir output_loc;

		grains = data_in(p.Results.phase_name);
		crystal_diagram_grains = grains.meanOrientation * crystal_diagram;
		
	
		cross_section_correction = rotation('axis',xvector,'angle',270*degree);
		crystal_diagram_grains = rotate(crystal_diagram_grains,cross_section_correction);
		grain_ids = p.Results.grain_ids
		for grain_id = 1:length(grain_ids)
			grain_figure = figure('Name',int2str(grain_ids(grain_id)));
			newMtexFigure(grain_figure)

			grain = crystal_diagram_grains(grain_ids(grain_id));
			
			plot(grain,'FaceColor',[200 200 200]/255,'FaceAlpha',0.8,'linewidth',1.5)
			set(gca,'DataAspectRatio',[1 1 1]);
			set(gca,'XColor', 'none','YColor','none');
			set(gcf,'color','none');
			set(gca,'color','none');
			title(int2str(grain_ids(grain_id)));
			
			
			filename = strcat(output_loc,'UC_grain_',int2str(grain_ids(grain_id)),'.png')
			export_fig(filename, '-dpng', '-transparent', '-r600');
		end
		

		

		
  		set(gca,'Color','black');
  		set(gcf, 'InvertHardcopy', 'off');
  		set(gca,'linewidth',1);
  		%Uncomment lines below to remove scale bar 
  		%hgt = findall(gca,'type','hgtransform')
  		%set(hgt,'visible','off')	

	else
		disp("'data_in' must be of type 'GRAINS' ")
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

































































