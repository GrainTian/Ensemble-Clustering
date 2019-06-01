function [S_WOSP,S_WOHB,nc] = GetSimMatrices(X, weight, cls, t)
% ============Parameter============
% date: 2013-01-26
% Get similarity matrices for WOSP and WOHB
% author:Yazhou Ren  email:yazhou.ren@mail.scut.edu.cn 
%Input
%   X    --- Data
% weight --- weight vector of objects, N*1
%  cls   --- contains a library of clustering solutions, each column is a solution
%   t    --- parameter
%Output
% S_WOSP --- similarity matrix of WOSP
% S_WOHB --- similarity matrix of WOHB
%   nc   --- number of all the clusters

% ==============Main===============
[N,~] = size(X);
if (N~=size(cls,1))
    error('GetSimMatrices: the number of objects dose not match!');
end
[~,ensize] = size(cls); % ensemble size
S_WOSP = zeros(N,N);
A = [];
nc = 0;
for r=1:1:ensize
    idx = cls(:,r);
    K = length(unique(idx));
    [centroids, ~] = gWcentroids(X, idx, (1:K), weight, 'sqeuclidean');
    % please refer to the paper
    dist = pdist2(X,centroids,'euclidean');
    if (~exist('t','var'))
        t = mean(mean(dist.^2));
        fprintf('t=%f\n',t);
    end
    d = exp(-(dist.^2)/t);
    sum_d = sum(d,2);
    Prob = d./(repmat(sum_d,1,K));
    
    % WOSP
    S1 = pdist2(Prob,Prob,'cosine');
    S1 = 1-S1; % because 'pdist2(Prob,Prob,'cosine')' computes '1 - the cosine of the included angle between points'
    S_WOSP = S_WOSP+S1;
    % WOHB
    A = [A,Prob];
    nc = nc+K;
end
S_WOSP = S_WOSP/ensize;
S_WOHB = [zeros(nc,nc),A';A,zeros(N,N)];
end

        
% ============Sub functions============
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
