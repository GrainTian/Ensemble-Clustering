clear all;
file_name='E:\MATLAB\bin\SFSCPEC2\10digit_2classes.mat';
load(file_name);
sub_database_num=5;
% indict the number of sub database
k=max(gnd)-min(gnd)+1;
% number of cluster label
select_pro=0.1;
sub_database_select(file_name,sub_database_num,select_pro);
% produce the relative low dimensional sub database

% for loop to produce seveal adjacency matrix which will be used in
% spectral clustering
data=[fea,gnd];
constraint=generate_pc(0.5,0.5,data); 
for i=1:sub_database_num
	
	eval(['load sub_database_',num2str(i),';']);
	% load sub_database_i;
	
	eval(['sub_database_',num2str(i),'=[sub_database_',...
		num2str(i),',gnd];']);
	% sub_database_i=[sub_database_i,gnd];
	
	if i==sub_database_num
		global F;
		eval(['global w_',num2str(i),';']);
		% global w_i;
		eval(['[F,w_',num2str(i),',k0]=e2cp_process(sub_database_'...
			,num2str(i),',constraint);']);
		% [F,w_i,k0]=e2cp_process(sub_database_i,constraint);
	else
		eval(['global w_',num2str(i),';']);
		% global w_i;
		eval(['[~,w_',num2str(i),',~]=e2cp_process(sub_database_'...
			,num2str(i),',constraint);'])
		% [~,w_i,~]=e2cp_process(sub_database_i,constraint);
	end 
end 

% multi spectral clustering and get the label matrix
cls=zeros(sub_database_num,size(w_1,1));
for j=1:sub_database_num
	eval(['w=w_',num2str(j),';'])
	cls_j=SpectralClustering(w,k,3);
	cls(j,:)=cls_j;
end

% find the similarit_matrix for ensemble clustering  
simi_matrix=similarity_matrix(cls);

% adjust the similarity matrix using constrain propogation 
adjust_simi_matrix=weight_adjustment_approach_2(F,simi_matrix);

% get the final result
result=graph_cut_ensemble(adjust_simi_matrix,2,k);
gnd(find(gnd==0),:)= max(gnd)+1;
[~,accuracy,~,~]=valid_RandIndex(result,gnd');