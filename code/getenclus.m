function cls = getenclus(X,csize,krange,type)
% ============Parameter============
%date: 2012-11-27
%Generate ensumble clustering results
%author:Yazhou Ren  www.scut.edu.cn  email:yazhou.ren@mail.scut.edu.cn 
%Input
%   X    ---  data
% csize  ---  ensemble size
% krange ---  the range of the number of clusters for each clustering
%  type  ---  the type of generating ensumble clustering results
%Output
%  cls   ---  contains a library of clustering solutions, each column is one solution 

% ==============Main===============
[N,R] = size(X); % number of samples, features
cls = zeros(N,csize);
switch type
    case 0 % Toy example
        for i=1:csize 
            k = randi(krange);
            temp = randperm(N);
            n_subS = ceil(0.7*N);
            [sub_idx,~] = sort(temp(1:n_subS),'ascend'); 
            subSX = X(sub_idx,:);
            [~,C,~,~] = kmeans(subSX,k,'emptyaction','singleton');            
            D = pdist2(X,C,'euclidean');
            [~, IDX] = min(D, [], 2);  
            cls(:,i) = IDX;
        end        
    case 1 % only use K-means       
        for i=1:csize
            k = randi(krange);
            [IDX,~,~,~] = kmeans(X,k,'emptyaction','singleton');
            cls(:,i) = IDX;
        end
    case 2 % use random subsampling and random subspace(sub feature set)
        mid = fix(csize/2);
        % random subsampling, select 70% of samples each time (K-means)
        for i=1:mid 
            k = randi(krange);
            temp = randperm(N);
            n_subS = ceil(0.7*N);
            [sub_idx,~] = sort(temp(1:n_subS),'ascend'); 
            subSX = X(sub_idx,:);
            [~,C,~,~] = kmeans(subSX,k,'emptyaction','singleton');            
            D = pdist2(X,C,'euclidean');
            [~, IDX] = min(D, [], 2);  
            cls(:,i) = IDX;
        end
        % random subspace, select 70% of features each time (K-means)
        for i=mid+1:csize 
            k = randi(krange);
            temp = randperm(R);
            n_subF = ceil(0.7*R);
            [sub_idx,~] = sort(temp(1:n_subF),'ascend'); 
            subFX = X(:,sub_idx);
            [IDX,~,~,~] = kmeans(subFX,k,'emptyaction','singleton');
            cls(:,i) = IDX;
        end        
    case 3 % use random subsampling and random subspace(sub feature set)
        mid = fix(csize/2);
        % random subsampling, select 70% of samples each time (K-means)
        for i=1:mid 
            k = randi(krange);
            temp = randperm(N);
            n_subS = ceil(0.7*N);
            [sub_idx,~] = sort(temp(1:n_subS),'ascend'); 
            subSX = X(sub_idx,:);
            [~,C,~,~] = kmeans(subSX,k,'emptyaction','singleton');            
            D = pdist2(X,C,'euclidean');
            [~, IDX] = min(D, [], 2);  
            cls(:,i) = IDX;
        end
        % random subspace, select 70% of features each time (average-link/spectral clustering)
        for i=mid+1:csize 
            k = randi(krange);
            temp = randperm(R);
            n_subF = ceil(0.7*R);
            [sub_idx,~] = sort(temp(1:n_subF),'ascend'); 
            subFX = X(:,sub_idx);
            IDX = clusterdata(subFX,'linkage','single','distance','euclidean','maxclust',k);
            % Spectral Clustering
%             graph_k = fix(log(N));
%             W = GraphConstruct(subFX,'KNN1',graph_k);
%             [IDX, ~, ~] = SpectralClustering(W, k, 1);
            cls(:,i) = IDX;
        end          
    case 4 % use random subsampling and random subspace(sub feature set)
        mid = fix(csize/2);
        % random subsampling, select 70% of samples each time (average-link/spectral clustering)
        for i=1:mid 
            k = randi(krange);
            temp = randperm(N);
            n_subS = ceil(0.7*N);
            [sub_idx,~] = sort(temp(1:n_subS),'ascend'); 
            subSX = X(sub_idx,:);

            IDX = clusterdata(subSX,'linkage','average','distance','euclidean','maxclust',k);
            % Spectral Clustering
%             graph_k = fix(log(N));
%             W = GraphConstruct(subSX,'KNN1',graph_k);
%             [IDX, ~, ~] = SpectralClustering(W, k, 1);
            C = zeros(k,R);
            for ind=1:k
                members = (ind==IDX);
                counts = sum(members);
                C(ind,:) = sum(subSX(members,:),1) / counts;
            end
            D = pdist2(X,C,'euclidean');
            [~, IDX2] = min(D, [], 2);  
            IDX2(sub_idx) = IDX;
            cls(:,i) = IDX2;            
        end
        % random subspace, select 70% of features each time (K-means)
        for i=mid+1:csize 
            k = randi(krange);
            temp = randperm(R);
            n_subF = ceil(0.7*R);
            [sub_idx,~] = sort(temp(1:n_subF),'ascend'); 
            subFX = X(:,sub_idx);
            
            [IDX,~,~,~] = kmeans(subFX,k,'emptyaction','singleton');            
            cls(:,i) = IDX;
        end             
end

