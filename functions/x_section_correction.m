function ebsd_out = x_section_correction(ebsd_in,aquisition_method,varargin)
	%{
	Function to apply orientation 'corrections' to datasets which were collected in cross-section. This is neccessary to produce
	pole figures, ODF's, etc with the same reference frame as those obtained via conventional plan-view techniques. Essentially
	produces 'ND' pole figures. ND must be pointing 'up' after any scan rotation is applied.

	REQUIRED ARGUMENTS
	ebsd_in = ebsd dataset to be rotated. Provided by loadEBSD mTeX function.
	aquisition_method = 'SPED' or 'EBSD'. SPED collection has an associated inherent rotation about phi1, so it's easier to
						 explicitly state the collection method for this correction to be automatically performed.

	OPTIONAL ARGUMENTS / PARAMETERS (varargin)
	scan_rotation = eg. 90. Defualt value = 0. If this map was collected with an imperfect scan rotation, this can be corrected with this argument by
					performing a rotation (in degrees) around the sample's z-axis (as collected). This is particularly useful
					for SPED datasets, as samples are usually scanned at a 90 degree angle (although this can differ).
	SPED_inherent_rotation = eg. 18. Default value = 18. Only used for SPED. The FEI Technai TF30 at the University of Manchester,
								when operated at a magnification of 43k, has patterns rotated by 18 degrees in φ1.
	%}
	

	p = inputParser;
	addRequired(p,'ebsd_in');
	addRequired(p,'aquisition_method');
	addOptional(p,'scan_rotation',0);
	addOptional(p,'SPED_inherent_rotation',18);
	parse(p,ebsd_in,aquisition_method,varargin{:})

	ebsd_out = ebsd_in;
	
	% Apply inherent SPED correction if necessary
	if strcmp(aquisition_method,'SPED') == 1
		ebsd_out = dataset_rotation(ebsd_out,[p.Results.SPED_inherent_rotation,0,0],'Euler','keep','keepXY');
	end

	% Apply scan rotation if necessary
	if p.Results.scan_rotation > 0
		ebsd_out = dataset_rotation(ebsd_out,[0,0,p.Results.scan_rotation*degree],'axis');
	end

	% Apply cross section correction
	ebsd_out = dataset_rotation(ebsd_out,[90,0,0],'axis','keep','keepXY');
end