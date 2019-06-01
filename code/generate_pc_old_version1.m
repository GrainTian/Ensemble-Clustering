function [F]=generate_pc(mcp,ccp,X)
% function [A,B,F]=generate_pc(mcp,ccp,X)
%generate random pariwise constraints
    N=size(X,1); 
    dim=size(X,2);
    [unique_X,ix,iux]=unique(X(:,dim));
    ix=sort(ix);
    ix=[ix;(N+1)];
    len_ix=length(ix);
    
    %calculate the number of the total constraints
    N_mc=0;
    for i=1:len_ix-1
        N_mc=N_mc+(ix(i+1)-ix(i))*((ix(i+1)-ix(i))-1)/2; 
    end
    N_cc=(ix(2)-ix(1))*(ix(len_ix)-ix(2));
    if len_ix>3
        for i=2:len_ix-2
            N_cc=N_cc+(ix(i+1)-ix(i))*(ix(len_ix)-ix(i+1)+ix(i)-ix(1)); 
        end
    end
    N_cc=N_cc+(ix(len_ix-1)-ix(1))*(ix(len_ix)-ix(len_ix-1));
      
    F=zeros(N,N); 
    mc_n=round(N_mc*mcp);
    cc_n=round(N_cc*ccp);
    %number of must-link and cannot-link constraints
    

    n=0;
    %generate must_link pairwise constraints
    for i=1:len_ix-1
        eval(['index_rand',int2str(i),'=randperm(ix(i+1)-ix(i))+ix(i)-1;'])
    end
    
    j=1;
    while(n<=mc_n)
        i=1;
        while(i<=len_ix-1)
            if eval(['rem(length(index_rand',int2str(i),'),2)==0'])
                while(eval(['j+2>length(index_rand',int2str(i),')']))
                    i=i+1;
                    if(i>len_ix-1),break,end
                end
            else   
                while(eval(['j+1>length(index_rand',int2str(i),')']))
                    i=i+1;
                    if(i>len_ix-1),break,end
                end
            end
            if(i>len_ix-1),break,end
            rand_mc(1)=eval(['index_rand',int2str(i),'(j)']);
            rand_mc(2)=eval(['index_rand',int2str(i),'(j+1)']);
            F(rand_mc(1),rand_mc(2))=1;
            F(rand_mc(2),rand_mc(1))=1;
            n=n+1;
            if n==mc_n,break,end
            i=i+1;
        end
        j=j+2;
    end
       
%     n=1;
%     %generate must_link pairwise constraints
%     while(n<=mc_n)
%         for j=1:(length(ix)-1)
%             rand_mc=ones(1,2);
% %             if length(find(F(ix(j):(ix(j+1)-1),ix(j):(ix(j+1)-1))==1))...
% %                     /((ix(j+1)-ix(j))*(ix(j+1)-ix(j)-1)/2)>=1.8
% %                 j=j+1;
% %             end
% %             if j==length(ix)-1,break,end
%             while(rand_mc(1)==ix(j)-1||rand_mc(2)==ix(j)-1||rand_mc(1)==rand_mc(2)||F(rand_mc(1),rand_mc(2))==1||F(rand_mc(2),rand_mc(1))==1) 
%                 %checking
%                 rand_mc(1)=round(rand(1)*(ix(j+1)-ix(j)))+ix(j)-1;
%                 rand_mc(2)=round(rand(1)*(ix(j+1)-ix(j)))+ix(j)-1;
%             end
%                 F(rand_mc(1),rand_mc(2))=1;
%                 F(rand_mc(2),rand_mc(1))=1;
%                 n=n+1;
%                 if n-1==mc_n,break,end
%         end
%     end
    
    n=1;
    %generate cannot_link pairwise constraints
    while(n<=cc_n)
        for j=1:(length(ix)-1)
            rand_cc=ones(1,2);
            while(rand_cc(1)==0||rand_cc(2)==0||rand_cc(1)==ix(j)-1||rand_cc(2)==ix(j)-1||rand_cc(1)==ix(j+1)-1||rand_cc(2)==ix(j+1)-1||rand_cc(1)==rand_cc(2)||F(rand_cc(1),rand_cc(2))==-1||F(rand_cc(2),rand_cc(1))==-1) 
                %checking
                if j==1
                    rand_cc(1)=round(rand(1)*(ix(j+1)-1));
                    rand_cc(2)=round(rand(1)*(N+1-ix(j+1))+ix(j+1)-1);
                elseif j==(length(ix)-1)
                    rand_cc(1)=round(rand(1)*(ix(j)-1));
                    rand_cc(2)=round(rand(1)*(N+1-ix(length(ix)-1)))+ix(length(ix)-1)-1; 
                else
                    rand_cc(1)=round(rand(1)*(ix(j+1)-ix(j)))+ix(j)-1;
                    rand_cc_choice=rand(1)*2;
                    if rand_cc_choice<1
                        rand_cc(2)=round(rand(1)*(ix(j)-1)); 
                    else
                        rand_cc(2)=round(rand(1)*(N+1-ix(j+1))+ix(j+1)-1); 
                    end
                end
            end
            F(rand_cc(1),rand_cc(2))=-1;
            F(rand_cc(2),rand_cc(1))=-1;
            n=n+1;
            if n-1==cc_n,break,end
        end
    end
        
% A=length(find(F==1)); B=length(find(F==-1));
    