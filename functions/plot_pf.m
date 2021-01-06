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
	addOptional(p,'grid_spacing',5);
	addOptional(p,'colouring','fibre');

	parse(p,data_in,desired_pfs,varargin{:});

	

	disp('')
	disp('Plotting pole figures...')
	disp('')

	%pf_figure = figure('Name','Loading...')
	%figure(pf_figure)
	pf_figure = newMtexFigure;

	%miller_indices = multi_miller(p.Results.desired_pfs)
	axes_quant = length(p.Results.desired_pfs);

	if isa(data_in,'EBSD') == 1
		if strcmp(p.Results.plot_type,'scatter') == 1
			if strcmp(p.Results.colouring,'fibre') == 1
				for i=1:axes_quant
					miller_val = multi_miller(p.Results.desired_pfs(i,:));
					plotPDF(data_in(p.Results.phase_name).orientations,angle(data_in(p.Results.phase_name).orientations,p.Results.ref_text_comp)./degree./2,miller_val,'antipodal','MarkerSize',p.Results.marker_size,'all','grid','grid_res',p.Results.grid_spacing*degree,'projection',p.Results.proj);
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
				cb = mtexColorbar('location','southoutside');
				x_label = xlabel(cb, titleString,'FontSize',8)
    			cb.Label.Interpreter = 'latex';
    			set(cb,'TickLabelInterpreter', 'latex','FontSize',8);

			else
				plotPDF(data_in(p.Results.phase_name).orientations,miller_indices,'antipodal','MarkerSize',p.Results.marker_size,'all','grid','grid_res',p.Results.grid_spacing*degree,'projection',p.Results.proj,'MarkerFaceColor','none','MarkerEdgeColor','black');
			end
		elseif strcmp(p.Results.plot_type,'ODF') == 1
        end

	elseif isa(data_in,'ODF') == 1
		disp('ODF')

	elseif isa(data_in,'GRAINS') == 1 %need to check data type here.
		disp("grains")
	else
		disp("'data_in' must be of type 'EBSD' or 'ODF' ")
	end

	set(gcf,'units','centimeters')
	set(gcf,'position',[0.1 0.1 18 8])
	disp('')
	disp('Pole figures plotted')
	disp('')
end









































