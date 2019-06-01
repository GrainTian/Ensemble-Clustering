function sub_database_select( file_name, sub_database_num,select_pro)
%	file_name - the name of high dimensional database 
%   sub_database_nmu is the number of sub database the 
%	function produced
	load(file_name);
    fea = zscore(fea);
    fea = NonZeroX(fea);
	fea_t=fea' ;
	[fea_num,data_num]=size(fea_t);
	fea_cluster_num=floor(sqrt(fea_num));
	% indict the number of cluster for k-means
	[fea_idx,fea_C]=kmeans(fea_t,fea_cluster_num,'start','uniform',...
	    'Replicates',5,'emptyaction','singleton');
	% cluster the feature
	[fea_selected_index]=stratified_sampling(fea_idx,fea_cluster_num,...
	    sub_database_num,select_pro);
	% get the index matrix of stratified sampling feature,ecah row
	% is the index of a subdatabase
	for i=1:sub_database_num

		s1=['sub_database_',num2str(i),'=fea_t(fea_selected_index',...
		'(',num2str(i),',:),:)'';'];
		% sub_database_i=fea_t(fea_selected_index(i,:),:)';
		eval(s1);
		s2=['save(''sub_database_',num2str(i),'.mat'',''sub_database_'...
		,num2str(i),''');'];
		% save('sub_database_i.mat','sub_database_i');
		eval(s2);
	end
	

end

