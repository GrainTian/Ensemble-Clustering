function cl = WOMC(cls,weight,k)
% ============Parameter============
% date: 2012-11-25
% WOMC
% author:Yazhou Ren  email:yazhou.ren@mail.scut.edu.cn 
%Input
%   cls  --- contains a library of clustering solutions, each row is one solution.
% weight --- the vector contains the weight of wach object
%    k   --- the number of clusters for the final clustering
%Output
%   cl   ---  consensus clustering result
% ==============Main===============
disp('CLUSTER ENSEMBLES using WOMC');

if ~exist('k'),
   k = max(max(cls));
end;
if((isempty(weight)) || (length(weight)~=size(cls,2)))  % Yazhou
    disp('WOMC: the size of weight vector must equal to the number of objects!!');
    return;
end
disp('WOMC: preparing graph for meta-clustering');
clb_o = clstoclbs(cls); % Yazhou
temp = repmat(sqrt(weight)',size(clb_o,1),1); % Yazhou
clb = clb_o.*temp; % Yazhou
cl_lab = clcgraph(clb,k,'simxjac'); % Yazhou
for i=1:max(cl_lab),
   matched_clusters = cl_lab==i;
   clb_cum(i,:) = mean(clb_o(matched_clusters,:),1);% Yazhou
end;
cl = clbtocl(clb_cum);

