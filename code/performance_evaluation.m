function [AR,RI,MI,HI,NMI] = performance_evaluation(file_name,pair_ratio,sub_database_num,select_pro,iteration)
% this function is used to evaluate the performance of ISSCE
% input:
%	file_name: the name of the data base
%	mcp is the ratio of the musk-link constraint
% 	ccp is the ratio of the cannot link constraint 
% 	sub_database_num is the number of the sub_database in the primary select process 
%	select_ratio is the ratio of the feature selection process 
%	selected_num is the number of the sub_database in the second select process,
%	which should smaller than sub_database_num 

cluster_ensemble = SSEC(file_name,pair_ratio,sub_database_num,select_pro,iteration);
load(file_name);
Y = fixlabel(gnd);
cluster_ensemble = fixlabel(cluster_ensemble); 
if length(cluster_ensemble)~=length(Y)
    error('gnd and cluster result have different scale');
end 
[AR,RI,MI,HI]=valid_RandIndex(cluster_ensemble,Y);
NMI = GetNMI(Y,cluster_ensemble); 


