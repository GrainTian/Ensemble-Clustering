function [fea_selected_index] = stratified_sampling(fea_clustered_index,...
fea_cluster_num,subdata_num,select_pro)
% INPUT: 
%	fea_clustered_index: the label of each feature obtained by kmeans
%	fea_cluster_num: the number of the cluster
%	subdata_num: the number of subdatabase we need to get 
% OUTPUT:
%   fea_selected_index:return the index of feature which should be 
%       selected, each row represent the index of selected feature index
%       for each subdataset, for example, an m*n matrix means m sub dataset
%       and n features will be selected for each dataset
    
    sample_pro=select_pro; 
    % determin the sampling propotioan
    fea_selected_index=[];
    % posibality = linspace
    for i=1:fea_cluster_num
    	index_i=find(fea_clustered_index==i);
        index_i_t=index_i';
    	% find the index of feature whose cluster label == i
    	sample_num_i=round(size(index_i,1)*sample_pro);
    	% the ith stratified sampling number
    	sample_seed=[];
        possibility = ones(1,size(index_i,1));
        possibility = possibility / sum(possibility);
        index_feature = linspace(1,size(index_i,1),size(index_i,1));
        
    	for j=1:subdata_num % select non-repeating features in a given diverse distribution every time
            possibility_old = possibility; % backup
            sample_seed_j = [];
            for k=1:sample_num_i
                temp = randsrc(1,1,[index_feature;possibility]);
                possibility(temp) = 0; % for non-repeating
                possibility = possibility / sum(possibility);
                sample_seed_j = [sample_seed_j,temp];
            end
            possibility = possibility_old;
            %sample_seed_j=randsrc(1,sample_num_i,[index_feature;possibility]);
            possibility(sample_seed_j)=possibility(sample_seed_j)/2;
            possibility = possibility / sum(possibility);
			%sample_seed_j=randperm(size(index_i,1),sample_num_i);
            sample_seed_j=index_i_t(sample_seed_j);
			sample_seed=[sample_seed;sample_seed_j];
        end 
    	fea_selected_index=[fea_selected_index,sample_seed];
    	% add the selected index into the fea_selected_index matrix
    end
    previous_fea_selected_num=size(fea_selected_index,2);
    total_fea_selected_num = round(size(fea_clustered_index,1)*sample_pro);
    select_error=size(fea_selected_index,2)-total_fea_selected_num;
    % the difference between selected feature and the expected number
    display(['random selected feature number is ',num2str(select_error)]);
    % if number of the selected feature is less than expected, randomly pick
    % some feature from the dataset 
    if select_error<0,
        for m=1:abs(select_error)
            add_cloumn=[];
            for n=1:size(fea_selected_index,1)
                sample_seed_n=randperm(size(fea_clustered_index,1),1);
                % randomly pick the index of feature
                while(any(fea_selected_index(n,:)==sample_seed_n))
                    sample_seed_n=randperm(size(fea_clustered_index,1),1);
                    % determin if the feature alreasy been selected
                end
                add_cloumn=[add_cloumn;sample_seed_n];
            end
            fea_selected_index=[fea_selected_index,add_cloumn];
            % add the randomly selected feature index into feature selected index
            % matrix
        end  
       
        
    elseif select_error>0,
        % if the number of seleted feafure is more than expected, then delete 
        % feature randomly
        remove_cloumn=randperm(size(fea_selected_index,2),select_error);
        fea_selected_index(:,remove_cloumn)=[];
    end

end

