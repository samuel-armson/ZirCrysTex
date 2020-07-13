function ebsd_out = dataset_rotation(ebsd_in,rotation_angles,method,varargin)
	%{
	Function to perform rotations to datasets in one line, rather than using several lines of code
	and repeating the same functions. Performs rotations described by Euler angles (in Bunge notation) or, as is
	often more intuitive, by angles around specimen coordinate axes x,y,z.
	
	REQUIRED ARGUMENTS
	ebsd_in = ebsd dataset to be rotated. Provided by loadEBSD mTeX function.
	rotation_angles = 1x3 matrix of rotation angles: eg [φ1,Φ,φ2] or [θx,θy,θz]. Degrees, not rads.
	method = 'Euler' or 'axis'. Rotate dataset according to specifc euler angles or rotations about sample axes x,y,z.
				Note that rotations are performed in the order phi1,phi,phi2 or x,y,z. If you require an alternate order,
				use this function multiple times.
				
	OPTIONAL ARGUMENTS / PARAMETERS (varargin)
	keep = 'keepXY' or 'keepEuler'. Useful for only rotating the orientations while maintaining coordinates and vice versa.
	%}
    
	p = inputParser;
	addRequired(p,'ebsd_in');
	addRequired(p,'rotation_angles');
	addRequired(p,'method');
	addOptional(p,'keep','none');
	parse(p,ebsd_in,rotation_angles,method,varargin{:});

	if strcmp(method,'Euler') == 1
		rotation_description = rotation('Euler',rotation_angles(1)*degree,rotation_angles(2)*degree,rotation_angles(3)*degree);
		if strcmp(p.Results.keep,'none') == 1
			ebsd_out = rotate(ebsd_in,rotation_description);
		else
			ebsd_out = rotate(ebsd_in,rotation_description,p.Results.keep);
		end
	end

	if strcmp(method,'axis') == 1
		ebsd_out = ebsd_in;
		rotation_description_1 = rotation('axis',xvector,'angle',rotation_angles(1)*degree);
		rotation_description_2 = rotation('axis',yvector,'angle',rotation_angles(2)*degree);
		rotation_description_3 = rotation('axis',zvector,'angle',rotation_angles(3)*degree);
		if strcmp(p.Results.keep,'none') == 1
			ebsd_out = rotate(ebsd_out,rotation_description_1);
			ebsd_out = rotate(ebsd_out,rotation_description_2);
			ebsd_out = rotate(ebsd_out,rotation_description_3);
		else
			ebsd_out = rotate(ebsd_out,rotation_description_1,p.Results.keep);
			ebsd_out = rotate(ebsd_out,rotation_description_2,p.Results.keep);
			ebsd_out = rotate(ebsd_out,rotation_description_3,p.Results.keep);
		end
	end
end



