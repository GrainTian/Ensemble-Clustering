function cl = WOSP(S_WOSP,k)
% ============Parameter============
% date: 2013-01-26
% WOSP
% author:Yazhou Ren email:yazhou.ren@mail.scut.edu.cn 
%Input
% S_WOSP --- similarity matrix of WOSP
%    k   --- the number of clusters for the final clustering
%Output
%   cl   ---  consensus clustering result
% ==============Main===============
disp('CLUSTER ENSEMBLES using WOSP');

if(size(S_WOSP,2)~=size(S_WOSP,1))  % Yazhou
    disp('WOSP: the size of S_OWSP is wrong!!');
    return;
end

cl = metis(S_WOSP,k);

