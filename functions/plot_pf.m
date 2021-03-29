function pf = plot_pf(data_in,desired_pfs,varargin)
	%{
	Plots desired pole figures from either raw EBSD data or pre-calculated ODF data and plots. This function plots multiple pole
	figures (potentially of different types ie. direction vs. planar) on one plot and gives you the option to save them. This 
	therfore drastically reduces the number of lines in the MAIN code and takes more intuitive arguments to achieve multiple
	plots. It also plots figures with latex font and interpreter. This function allows scatter plots and ODF calculated contour
	plots. The defualt contour colouring is viridis with 10% white to purple transition at the low-end: this therefore provides
	linearly coherent colouring while also separating very weak (but present) textures from the 0 MRD background. There are a lot
	of optional arguments due to the nature of this function. Optimal defaults are selected to reduce the number of required
	inputs.

	REQUIRED ARGUMENTS
	data_in = EBSD, ODF, or GRAINS data types provided by mTeX. If ODF type is given, ODF contour plots will be automatically
				plotted and the plot_type argument will be overridden. Using EBSD data allows you to plot pole figures as scatter
				points or ODF-calculated contours.
	desired_pfs = [[1,0,-3,"plane"];[1,0,-4,"plane"];[1,0,-5,"plane"];[1,0,-6,"plane"]], for example. A 2D array containing the
				miller indices and pole_figure type.

	OPTIONAL ARGUMENTS
	plot_type = 'scatter' or 'ODF'. If raw data default will be scatter. If ODF data, default will be ODF. Cannot plot scatter
				from ODF data. If ODF is selected for raw data, the ODF will be calculated within this function.
	save_fig = 'yes' or 'no'. Default value is no. This is useful for saving time and storage space when testing scripts before
				commiting to saving them.
	sample_ID = 'Example sample ID', for example. Required when you want to save the figure. It is useful to set a global sample
				name using the figure_name function directly before starting to plot figures. The char string produced by this
				function can then be used as the sample_ID argument.
	extension = 'tif','png','jpg','pdf' etc. Default is pdf.
	resolution = integer value. Default is 1000. (dpi)
	proj = 'earea' / 'eangle' / 'edist'. Different types of pole figure projection. equal area is default.

	%}

% PROBABLY NEED ANOTHER OPTIONAL ARGUMENT FOR PROJECTION TYPE (equal area and what not)
% CERTAIN COLOURINGS MAY BE AN ISSUE. PROBABLY JUST USE BLACK AND WHITE IF UNDEFINED AND FIBRE DEVIATION IF FIBRE IS PROVIDED

	global cs
	global reference_texture_component
	global phase_of_interest
	global Sample_ID

	if isempty(reference_texture_component) == 1
		reference_texture_component = [0,0,1];
	end

	p = inputParser;
	addRequired(p,'data_in');
	addRequired(p,'desired_pfs');
	addOptional(p,'phase_name',phase_of_interest);
	addOptional(p,'crys_sym',cs)
	addOptional(p,'ref_text_comp',reference_texture_component)
	addOptional(p,'plot_type','scatter');
	addOptional(p,'save_fig','none');
	addOptional(p,'sample_ID','none');
	addOptional(p,'extension','none');
	addOptional(p,'resolution','none');
	addOptional(p,'proj','earea');
	addOptional(p,'marker_size',0.5);
	addOptional(p,'grid_spacing',90);
	addOptional(p,'colouring','fibre');

	parse(p,data_in,desired_pfs,varargin{:});

	setMTEXpref('pfAnnotations',@(varargin) 1);

	disp('')
	disp('Plotting pole figures...')
	disp('')

	pf_figure = figure('Name','Pole figures loading...');
	newMtexFigure(pf_figure)

	axes_quant = size(p.Results.desired_pfs); %Number of pole figures to plot
	axes_quant = axes_quant(1);

	%Determine layout of figure for consistant pole figure sizes. 
	figure_width = 18; %Width of figure in cm. A4 paper is 21cm wide, so 18cm is good.
	pf_height = 5.5; % Height to allow for PF in figure window. This height works well with 18cm width.
	pf_width = 4.5; % Width to allow for PF in figure window.

	if axes_quant <= 4
		n_rows = 1;
		n_cols = axes_quant;
	elseif rem(axes_quant,4)==0
		n_rows = ceil(axes_quant/4);
		n_cols = 4;
	elseif rem(axes_quant,3)==0
		n_rows = ceil(axes_quant/3);
		n_cols = 3;
	else
		n_cells_4 = ceil(axes_quant/4)*4;
		n_cells_3 = ceil(axes_quant/3)*3;
		unoccupied_4 = n_cells_4-axes_quant;
		unoccupied_3 = n_cells_3-axes_quant;
		if unoccupied_4 > unoccupied_3
			n_cols = 3;
			n_rows =ceil(axes_quant/3);
		else
			n_cols = 4;
			n_rows =ceil(axes_quant/4);
		end

	end

	

	if isa(data_in,'EBSD') == 1
		%PLOT SCATTER PF
		if strcmp(p.Results.plot_type,'scatter') == 1
			%COLOUR EACH POINT ACCORDING TO DEVIATION FROM REFERENCE TEXTURE
			if strcmp(p.Results.colouring,'fibre') == 1
				for i=1:axes_quant
					miller_val = multi_miller(p.Results.desired_pfs(i,:));
					fibre_angles = angle(data_in(p.Results.phase_name).orientations,p.Results.ref_text_comp,'antipodal')./degree;
					for fa = 1 : length(fibre_angles)
						if fibre_angles(fa) > 90
							fibre_angles(fa) = 180 - fibre_angles(fa);
						end
						fa = fa + 1 
					end
					plotPDF(data_in(p.Results.phase_name).orientations,fibre_angles,miller_val,'antipodal','MarkerSize',p.Results.marker_size,'all','grid','grid_res',p.Results.grid_spacing*degree,'projection',p.Results.proj);
					axes_title = miller_latex(p.Results.desired_pfs(i,:));
					title(axes_title,'FontSize',8);
					if i<axes_quant; nextAxis; end
				end
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
				colormap(parula_red('increment',1));
				cb = mtexColorbar('location','southoutside');
				x_label = xlabel(cb, titleString,'FontSize',8)
				Scale_bar_limits = [0 90]
				caxis(Scale_bar_limits);
    			cb.Label.Interpreter = 'latex';
    			set(cb,'TickLabelInterpreter', 'latex','FontSize',8);
    			set(gcf,'units','centimeters')
    			figure_height = (n_rows*pf_height)+1.5
    			figure_width = (n_cols*pf_width)
    			set(gcf,'position',[10 10 figure_width figure_height])
    			figure_id = figure_name(Sample_ID,'reference_texture_component',p.Results.ref_text_comp,'suffix','scatter PF fibre colour')
    			set(pf_figure,'Name',string(figure_id));

			else
				%COLOUR EACH POINT BLACK
				for i=1:axes_quant
					miller_val = multi_miller(p.Results.desired_pfs(i,:));
					plotPDF(data_in(p.Results.phase_name).orientations,miller_val,'antipodal','MarkerSize',p.Results.marker_size,'all','grid','grid_res',p.Results.grid_spacing*degree,'projection',p.Results.proj,'MarkerFaceColor','none','MarkerEdgeColor','black');
					axes_title = miller_latex(p.Results.desired_pfs(i,:));
					title(axes_title,'FontSize',8);
					if i<axes_quant; nextAxis; end
				end
    			set(gcf,'units','centimeters')
    			figure_height = (n_rows*pf_height)
    			figure_width = (n_cols*pf_width)
    			set(gcf,'position',[5 5 figure_width figure_height])
    			figure_id = figure_name(Sample_ID,'reference_texture_component',p.Results.ref_text_comp,'suffix','scatter PF no colour')
    			set(pf_figure,'Name',string(figure_id));
			end
		elseif strcmp(p.Results.plot_type,'ODF') == 1
        end

	elseif isa(data_in,'ODF') == 1
		for i=1:axes_quant
			miller_val = multi_miller(p.Results.desired_pfs(i,:));
			plotPDF(data_in,miller_val,'grid','grid_res',p.Results.grid_spacing*degree,'projection',p.Results.proj);
			axes_title = miller_latex(p.Results.desired_pfs(i,:));
			title(axes_title,'FontSize',8);
			if i<axes_quant; nextAxis; end
		end
		CLim(gcm,'equal'); % set equal color range to all plots
  		colormap(white_viridis('white_percentage',10))
  		cb = mtexColorbar('location','southoutside');
		x_label = xlabel(cb, 'MRD Values','FontSize',8)
    	cb.Label.Interpreter = 'latex';
    	set(cb,'TickLabelInterpreter', 'latex','FontSize',8);
  		set(gcf,'units','centimeters')
    	figure_height = (n_rows*pf_height)+1.5
    	figure_width = (n_cols*pf_width)
    	set(gcf,'position',[5 5 figure_width figure_height])
    	figure_id = figure_name(Sample_ID,'reference_texture_component',p.Results.ref_text_comp,'suffix','scatter PF no colour')
    	set(pf_figure,'Name',string(figure_id));
    	disp('ODF SHOULD PLOT')
    	disp('ODF SHOULD PLOT')
    	disp('ODF SHOULD PLOT')
    	disp('ODF SHOULD PLOT')
    	disp('ODF SHOULD PLOT')
    	disp('ODF SHOULD PLOT')
    	disp('ODF SHOULD PLOT')
    	disp('ODF SHOULD PLOT')
    	disp('ODF SHOULD PLOT')
    	disp('ODF SHOULD PLOT')
    	



	elseif isa(data_in,'GRAINS') == 1 %need to check data type here.
		disp("grains")
	else
		disp("'data_in' must be of type 'EBSD' or 'ODF' ")
	end

	disp('')
	disp('Pole figures plotted')
	disp('')
end









































