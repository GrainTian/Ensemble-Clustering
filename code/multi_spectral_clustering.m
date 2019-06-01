function [cls] = multi_spectral_clustering(k,Type,varargin)
%	the function multi_spectral_clustering is going to do several
%	spectral clustering in this funtion and return a label matrix 
%	which will be used in the ensemble learning 
%	'k' - Number of clusters to look for
%   Type' - Defines the type of spectral clustering algorithm
%            that should be used. Choices are:
%      1 - Unnormalized
%      2 - Normalized according to Shi and Malik (2000)
%      3 - Normalized according to Jordan and Weiss (2002)
%	varagin - several adjacency matrix, needs to be square
	number_of_dataset=numel(varargin);
	cls=[];
	for i=1:number_of_dataset
		cls_i=SpectralClustering(varargin(i),k,Type);
		cls=[cls;cls_i];
	end 

end

