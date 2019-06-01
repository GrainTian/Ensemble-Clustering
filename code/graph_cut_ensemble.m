function [result] = graph_cut_ensemble(w,Type,k)
% w is the modified similarity matrix
% Type-- choose the ensemble funciton:
%		1 -- the metis method 
%		2 -- the spectral method
% k-- the number of clustering
% result return the final clustering result 

	if ~exist('Type')
		disp('no Type input, initial with metis method');
		Type=1;
	end
	switch Type
		case 1 
			result=metis(w,k);
		case 2 
			result=SpectralClustering(w,k,3);
	end 

end

