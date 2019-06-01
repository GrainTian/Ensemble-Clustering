function [idx, C, sumD, D] = WeightedKmeans(X, K, InitC, MaxSte, weight)
% ============Parameter============
% date: 2013-01-24
% Kmeans && Objects weighted K means
% author:Yazhou Ren  email:yazhou.ren@mail.scut.edu.cn 
% Note: In our paper, we only use euclidean distance --- 'sqeuclidean'
%Input
%  X     ---  samples,N*R
%  K     ---  number of clusters
% IniC   ---  the initial K cluster cetroids in X, K*R (R is the dimensionality of X)
% MaxSte ---  maximum number of steps
% weight ---  weight vector of objects, N*1
%Output
% idx    ---  the cluster indicexs of each point, N*1
%  C     ---  the K cluster centroid locations in the K-by-R matrix C
% sumD   ---  the within-cluster sums of point-to-centroid distances, 1*K
%  D     ---  distances from each point to every centroid, N*K
% ============Main============
if (4~=nargin) && (5~=nargin)
    error('stats:WeightedKmeans:Inputs','Wrong input.');
end
[N,~] = size(X);
if (5==nargin) && (size(weight,1)~=N)
    error('stats:WeightedKmeans:Inputs','number of objects should match');
end
CurrC = InitC-1;       %Current K cluster centroid locations
NextC = InitC;         %Next K cluster centroid locations. This step is to make sure 'CurrC~=NextC' in the first time
idx = ones(N,1);       
d = zeros(N,1);        

while (sum(sum(CurrC~=NextC))) && MaxSte %Stop when CurrC equals to NextC
    CurrC = NextC;
    D = distfun(X, CurrC, 'sqeuclidean', 0);
    [d, idx] = min(D, [], 2);
    if (4==nargin)  % K means
        [NextC, ~] = gcentroids(X, idx, (1:K), 'sqeuclidean');
    else % Objects weighted K means
        [NextC, ~] = gWcentroids(X, idx, (1:K), weight, 'sqeuclidean');
    end
    % empty cluster
    if sum(sum(isnan(NextC)))
        warning('WeightedKmeans:process','WeightedKmeans: empty cluster exists');
        for i=1:K
            if sum(isnan(NextC(i,:)))
                randC = randi([1,N]); % randomly select an object as a new centroid
                NextC(i,:) = X(randC,:);
            end
        end
    end
    MaxSte = MaxSte-1;
end
C = CurrC;
sumD = accumarray(idx,d,[K,1]);

end % main function

%% ============Sub functions============

function D = distfun(X, C, dist, iter)
%DISTFUN Calculate point to cluster centroid distances.
[n,p] = size(X);
D = zeros(n,size(C,1));
nclusts = size(C,1);

switch dist
case 'sqeuclidean'
    for i = 1:nclusts
        D(:,i) = (X(:,1) - C(i,1)).^2;
        for j = 2:p
            D(:,i) = D(:,i) + (X(:,j) - C(i,j)).^2;
        end
        % D(:,i) = sum((X - C(repmat(i,n,1),:)).^2, 2);
    end
case 'cityblock'
    for i = 1:nclusts
        D(:,i) = abs(X(:,1) - C(i,1));
        for j = 2:p
            D(:,i) = D(:,i) + abs(X(:,j) - C(i,j));
        end
        % D(:,i) = sum(abs(X - C(repmat(i,n,1),:)), 2);
    end
case {'cosine','correlation'}
    % The points are normalized, centroids are not, so normalize them
    normC = sqrt(sum(C.^2, 2));
    if any(normC < eps(class(normC))) % small relative to unit-length data points
        error('stats:kmeans:ZeroCentroid', ...
              'Zero cluster centroid created at iteration %d.',iter);
    end
    
    for i = 1:nclusts
        D(:,i) = max(1 - X * (C(i,:)./normC(i))', 0);
    end
case 'hamming'
    for i = 1:nclusts
        D(:,i) = abs(X(:,1) - C(i,1));
        for j = 2:p
            D(:,i) = D(:,i) + abs(X(:,j) - C(i,j));
        end
        D(:,i) = D(:,i) / p;
        % D(:,i) = sum(abs(X - C(repmat(i,n,1),:)), 2) / p;
    end
end
end % function
%------------------------------------------------------------------

function [centroids, counts] = gWcentroids(X, index, clusts, weight, dist)
%GWCENTROIDS Weighted Centroids and counts stratified by group.
[n,p] = size(X);
num = length(clusts);
centroids = NaN(num,p);
counts = zeros(num,1);
WeightX = X.*(repmat(weight,1,p)); % Yazhou
for i = 1:num
    members = (index == clusts(i));
    if any(members)
        counts(i) = sum(members);
        switch dist
        case 'sqeuclidean'
            % centroids(i,:) = sum(X(members,:),1) / counts(i);
            centroids(i,:) = sum(WeightX(members,:),1) / sum(weight(members)); % Yazhou
        end
    end
end
end % function
%------------------------------------------------------------------

function [centroids, counts] = gcentroids(X, index, clusts, dist)
%GCENTROIDS Centroids and counts stratified by group.
[n,p] = size(X);
num = length(clusts);
centroids = NaN(num,p);
counts = zeros(num,1);

for i = 1:num
    members = (index == clusts(i));
    if any(members)
        counts(i) = sum(members);
        switch dist
        case 'sqeuclidean'
            centroids(i,:) = sum(X(members,:),1) / counts(i);
        case 'cityblock'
            % Separate out sorted coords for points in i'th cluster,
            % and use to compute a fast median, component-wise
            Xsorted = sort(X(members,:),1);
            nn = floor(.5*counts(i));
            if mod(counts(i),2) == 0
                centroids(i,:) = .5 * (Xsorted(nn,:) + Xsorted(nn+1,:));
            else
                centroids(i,:) = Xsorted(nn+1,:);
            end
        case {'cosine','correlation'}
            centroids(i,:) = sum(X(members,:),1) / counts(i); % unnormalized
        case 'hamming'
            % Compute a fast median for binary data, component-wise
            centroids(i,:) = .5*sign(2*sum(X(members,:), 1) - counts(i)) + .5;
        end
    end
end
end % function
%------------------------------------------------------------------
