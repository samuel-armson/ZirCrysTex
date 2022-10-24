function cs_out = cs_loader(data_in,varargin)

	%{
	data_in = EBSD or grains2d data type. Best to use EBSD to get more representative results regarding
	volume of sample vs. simply number of grains.
	%}


	p = inputParser;
	addRequired(p,'data_in');
	
	parse(p,data_in,varargin{:});	

	mono_c = [102 163 109]/255;
	suboxide_c = [227 181 5]/255;
	tet_c = [189 24 15]/255;
	metal_c = [79 109 122]/255;
	hydride_c = [244 96 54]/255;
	hematite_c = [108 49 135]/255;
	pt_c = [205 202 177]/255;
	SPP_c = [205 202 177 ]/255;

	cs_out = {'notIndexed'};

	for phase = 1 : length(data_in)
		
		if ismember(data_in(phase),{'mono','monoclinic','Monoclinic','Mono','MONO','MONOCLINIC','Monoclinic ZrO$$_2$$'}) == 1 
			%Default
			cs_out{end+1} = crystalSymmetry('12/m1', [5.169 5.232 5.341], [90,99,90]*degree, 'X||a*', 'Y||b*', 'Z||c', 'mineral', 'Monoclinic ZrO$$_2$$', 'color', mono_c);
			%Adjusted
			%cs_out{end+1} = crystalSymmetry('12/m1', [5.169 5.232 5.341], [90,99,90]*degree,'X||a' ,'Y||b', 'Z||c*', 'mineral', 'Monoclinic ZrO$$_2$$', 'color', mono_c);

		elseif ismember(data_in(phase),{'suboxide','Suboxide','SUBOXIDE','SubOxide','ZrO','hex suboxide','h-ZrO','Hexagonal ZrO'}) == 1 
			cs_out{end+1} = crystalSymmetry('6/mmm', [5.312 5.312 3.197], 'X||a*', 'Y||b', 'Z||c*', 'mineral', 'Hexagonal ZrO', 'color', suboxide_c);

		elseif ismember(data_in(phase),{'tet','Tet','TET','Tetragonal','tetragonal','Tetragonal','Tetragonal ZrO$$_2$$'}) == 1 
			cs_out{end+1} = crystalSymmetry('4/mmm', [3.596 3.596 5.184], 'mineral', 'Tetragonal ZrO$$_2$$', 'color', tet_c);

		elseif ismember(data_in(phase),{'metal','Metal','METAL','Zr','substrate','HCP Zr'}) == 1 
			cs_out{end+1} = crystalSymmetry('6/mmm', [3.232 3.232 5.147], 'X||a', 'Y||b*', 'Z||c*', 'mineral', 'HCP Zr', 'color', metal_c);

		elseif ismember(data_in(phase),{'hydride','Hydride','HYDRIDE'}) == 1 
			cs_out{end+1} = crystalSymmetry('4/mmm', [3.52 3.52 4.45], 'mineral', 'Zr Hydride', 'color', hydride_c);

		elseif ismember(data_in(phase),{'hematite','Hematite','HEMATITE'}) == 1 
			cs_out{end+1} = crystalSymmetry('-3m1', [5.038 5.038 13.772], 'X||a*', 'Y||b', 'Z||c*', 'mineral', 'Hematite', 'color',hematite_c);

		elseif ismember(data_in(phase),{'Pt','pt','PT','amorphous','Amorphous','AMORPHOUS'}) == 1 
			cs_out{end+1} = crystalSymmetry('m-3m', [4.086 4.086 4.086], 'mineral', 'Amorphous Pt', 'color', pt_c);

		elseif ismember(data_in(phase),{'SPP','Fe Cr SPP','Zr Fe Cr SPP','ZrFeCr SPP','Fe Cr SPP'}) == 1 
			cs_out{end+1} = crystalSymmetry('6/mmm', [5.028 5.028 8.248], 'X||a*', 'Y||b', 'Z||c*', 'mineral', 'Zr Fe Cr SPP', 'color', SPP_c);

        elseif ismember(data_in(phase),{'beta zirc','beta','beta Zr', 'beta zr'}) == 1 
			cs_out{end+1} = crystalSymmetry('6/mmm', [5.028 5.028 8.248], 'X||a*', 'Y||b', 'Z||c*', 'mineral', 'Zr Fe Cr SPP', 'color', SPP_c);

		else
			error("cs_loader: Phase ID not recognised!")
		end
	end






	













































end
	