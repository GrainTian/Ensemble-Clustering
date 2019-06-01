function result =SSEC(file_name,pair_ratio,sub_database_num,select_pro,iteration)

load(file_name);

X = zscore(fea); X = NonZeroX(X); 
Y = fixlabel(gnd);
k = length(unique(Y)); 

% sub_database_num=10;
% indict the number of sub database
% k=max(gnd)-min(gnd)+1;
% number of cluster label

sub_database_select(file_name,sub_database_num,select_pro);
% produce the relative low dimensional sub database

% for loop to produce seveal adjacency matrix which will be used in
% spectral clustering
% data=[fea,gnd];
data=[X,Y];
% data=sortrows(data,size(data,2));

n=size(data,1);
m=size(data,2)-1;


constraint = get_pc(file_name,pair_ratio,data,iteration); 

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
	eval(['w=w_',num2str(j),';']);
	cls_j=SpectralClustering(w,k,2);
	cls(j,:)=cls_j;
end


% find the similarit_matrix for ensemble clustering  
simi_matrix=similarity_matrix(cls);

% adjust the similarity matrix using constrain propogation 
simi_matrix=weight_adjustment_approach_2(F,simi_matrix);

% get the final result
result=graph_cut_ensemble(simi_matrix,1,k);
end 
% result=fixlabel(result);
% gnd(find(gnd==0),:)= max(gnd)+1;
% 
% [AR,RI,MI,HI]=valid_RandIndex(result,Y);
% 
% NMI=GetNMI(Y,result);
