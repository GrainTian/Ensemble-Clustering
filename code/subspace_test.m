data = 'Iris'; 
load(data);
size_fea=size(fea);
clusters=round(sqrt(size_fea(1,2)));
[IDX,C]=kmeans(fea',clusters);