function [s] = similarity_matrix(cls)
% get the initial similarity_matrix from base clustering solution
	clbs = clstoclbs(cls);
	s = clbs' * clbs;
	s = checks(s./size(cls,1));

end

