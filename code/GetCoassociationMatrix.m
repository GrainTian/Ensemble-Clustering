function CoMatrix = GetCoassociationMatrix(cls)
% ============Parameter============
%date: 2013-01-22
%Get Co-association Matrix from cls
%author:Yazhou Ren  email:yazhou.ren@mail.scut.edu.cn 
%Input
%   cls  --- contains a library of clustering solutions, each row is one
%   solution
%Output
% CoMatrix --- Co-association Matrix

% ==============Main===============
clbs = clstoclbs(cls); % need 'ClusteringEnsemble-V2.0' package
CoMatrix = clbs' * clbs;
CoMatrix = checks(CoMatrix./size(cls,1));
