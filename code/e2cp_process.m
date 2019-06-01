function [F,K,K0]=e2cp_process(X,constraint)

knn_used=1; k=10; gamma=1.5; % parameters for k-NN graph
pcp_used=1; lamda=0.90; % parameter for constraint propagation
F_normalized=1; 
full_eig=1; 
trial_max=1;

N=size(X,1);
dim=size(X,2);  
last_column=X(:,dim);
C1=size(unique(last_column),1);% number of lables/clusters
nvec=C1+1; 
L=X(:,dim); 
bow=X(:,1:dim-1);% feature matrix
sigma=sum(sum((bow-mean(bow,1)).^2))/size(bow,1);

% compute gaussian kernel
K0=zeros(N,N);

for i=1:N
    for j=1:N 
        if j<i
            K0(i,j)=K0(j,i);
        else
            deltb=bow(i,:)-bow(j,:);           
            K0(i,j)=exp(-gamma*deltb*deltb'/sigma);
        end;
    end;
end;
% construct k-nn graph
if knn_used               
    Kn=zeros(N,N);
    for i=1:N
        [Ki,indx]=sort(K0(i,:),'descend');
        ind=indx(2:k+1);
        Kn(i,ind)=K0(i,ind);     
    end;
    K0=(Kn+Kn')/2; clear Kn;
else
    for i=1:N
        K0(i,i)=0;
    end;
end;
trial_ar=zeros(1,trial_max);
clock0=clock; 

for trial=1:trial_max 
    sd0=rand('seed');
    K=K0; 
    
    % select pairwise constraints  
    %F=generate_pc(0.1,0.1,X);

    % exhaustive and efficient constraint propagation (E2CP)
    F=E2CP(pcp_used,K,lamda,N,constraint);

    % modifying graph K with F 
    K=weight_adjustment_approach_1(pcp_used,F_normalized,F,K,N);
    
end;
% clock1=clock;
% time_cost=(clock1(4:6)-clock0(4:6))*[3600;60;1];
% fprintf('time_cost=%.2f\n',time_cost);
