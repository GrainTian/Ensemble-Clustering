clear all;

file_name='C:\Users\Harry\Documents\MATLAB\SFSCPEC\data\colon.mat';
load(file_name);
sub_database_num=5;
% indict the number of sub database
sub_database_select(file_name,sub_database_num);
% produce the relative low dimensional sub database

knn_used=1; k=15; gamma=1.5; % parameters for k-NN graph
pcp_used=1; lamda=0.90; % parameter for constraint propagation
F_normalized=1; full_eig=1; 
trial_max=1;

% load the toy data
load sub_database_1; 
X=[sub_database_1,gnd];
N=size(X,1);
dim=size(X,2);  
last_column=X(:,dim);
C1=size(unique(last_column),1);% number of lables/clusters
nvec=C1+1; 
L=X(:,dim); 
bow=X(:,1:dim-1);% feature matrix

% compute gaussian kernel
K0=zeros(N,N);
for i=1:N
    for j=1:N 
        if j<i
            K0(i,j)=K0(j,i);
        else
            deltb=bow(i,:)-bow(j,:);           
            K0(i,j)=exp(-gamma*deltb*deltb');
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
    constrain=generate_pc(0.1,0.1,N,X,dim);

    % exhaustive and efficient constraint propagation (E2CP)
    F=E2CP(pcp_used,K,lamda,N,constrain);

    % modifying graph K with F 
    K=weight_adjustment_approach(pcp_used,F_normalized,F,K,N);

    if 0
        D=sum(K,2); D=1./sqrt(D);  D=diag(D);
        K=eye(N)-D*K*D; clear D; 
        if full_eig 
            % full eig
            [eig_vec,eig_val]=eig(K);
            eig_val=real(diag(eig_val));
            [eig_val, ind_eig]=sort(eig_val);
            eig_vec=eig_vec(:,ind_eig);  
        else            
            % nvec-order eig
            opts.disp=0;     
            [eig_vec,eig_val]=eigs(K,nvec+1,'sm',opts);    
        end;
        clear K;
        E1=real(eig_vec(:,2:nvec+1));
        clear eig_val eig_vec;  
        E1=E1./(sqrt(sum(E1.^2,2))*ones(1,nvec));
            
        % constrained spectral clustering
        type0=L;          
        EPOCH=5; sumd_best=inf;
        for epoch=1:EPOCH
            [type,centers,sumd]=kmeans(E1,C1,'emptyaction','singleton','display','off');       
            if sum(sumd)<sumd_best
                sumd_best=sum(sumd);
                type_best=type;
            end;               
        end;        
        ar=adjust_rand(type_best,type0);    
        trial_ar(trial)=ar;
        fprintf('Adjusted Rand Index = %f\n',ar);  
        rand('seed',sd0);
    end;
    clock1=clock;
    time_cost=(clock1(4:6)-clock0(4:6))*[3600;60;1];
    avg_time=time_cost/trial_max;
    ar_m=mean(trial_ar); 
    ar_std=std(trial_ar);
    fprintf('avg_ar=%.2f,std_ar=%.2f\n\n',ar_m,ar_std);
end 
% % show the results of E2CP
% %figure;
% hold on
% plot3(bow(type_best==3,1),bow(type_best==3,2),bow(type_best==3,3),'c.');
% plot3(bow(type_best==1,1),bow(type_best==1,2),bow(type_best==1,3),'m+');
% plot3(bow(type_best==2,1),bow(type_best==2,2),bow(type_best==2,3),'g^');
% 
% hold off
% grid on
% % axis([0 8 0 8]);
% box on
% ind=find(abs(F)>0.02);
% [rows,cols]=ind2sub(size(F),ind);
% vals=F(ind);
% num_pc=numel(rows);
% for i=1:num_pc
%     if rows(i)<cols(i)
%         continue;
%     end;
%     ind_i=[rows(i) cols(i)];    
%     hold on
%     if vals(i)>0        
%         plot3(bow(ind_i,1)',bow(ind_i,2)',bow(ind_i,3)','r-');      
%     else
%         plot3(bow(ind_i,1)',bow(ind_i,2)',bow(ind_i,3)','b-.');   
%     end;     
%     hold off
% end;