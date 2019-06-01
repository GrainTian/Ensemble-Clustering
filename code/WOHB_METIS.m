function clusterid=WOHB_METIS(S_WOHB, k, N_clu)
% ============Parameter============
% date: 2013-01-26
% WOHB
% author:Yazhou Ren email:yazhou.ren@mail.scut.edu.cn 
%Input
%   S_OWHB   --- similarity matrix of WOHB
%     k      --- the number of clusters in the final clustering
%    N_clu   --- number of all the clusters
%Output
%   clusterid   ---  consensus clustering result
% ==============Main===============
disp('CLUSTER ENSEMBLES using WOHB');
N_total = size(S_WOHB,1);
if(N_total~=size(S_WOHB,2))  % Yazhou
    disp('WOHB: the size of S_OWHB is wrong!!');
    return;
end
N_obj = N_total-N_clu; 
% need 'ClusterEnsemble-V2.0' package
clusterid = metis(S_WOHB,k);
clusterid = clusterid(N_clu+1:N_clu+N_obj); % the last N_obj items are objects

