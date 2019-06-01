function [F]=generate_pc(ratio,X)
% function [A,B,F]=generate_pc(mcp,ccp,X)
%generate random pariwise constraints
    N=size(X,1); 
    dim=size(X,2);
    y=X(:,dim);
    [unique_X,ix,iux]=unique(X(:,dim));
    ix=sort(ix);
    ix=[ix;(N+1)];
    len_ix=length(ix);
      
    F=zeros(N,N);
    mcp = ratio*rand(1);
    ccp = ratio - mcp; 
    mc_n=round(mcp*N);
    cc_n=round(ccp*N);
    %number of must-link and cannot-link constraints
    
    n=0;
    while (n<mc_n)
        temp=randperm(N);
        part1=temp(1);
        part2=temp(2);
        idx=2;
        while(F(part1,part2)==1)
            idx=idx+1;
            part2=temp(idx);
        end
        if y(part1)==y(part2)%must-link
            F(part1,part2)=1;
            F(part2,part1)=1;
            n=n+1;
        end
    end
    
    n=0;
    while (n<cc_n)
        temp=randperm(N);
        part1=temp(1);
        part2=temp(2);
        idx=2;
        while(F(part1,part2)==-1)
            idx=idx+1;
            part2=temp(idx);
        end
        if y(part1)~=y(part2)%must-link
            F(part1,part2)=-1;
            F(part2,part1)=-1;
            n=n+1;
        end
    end
    
        
 % A=length(find(F==1));
 % B=length(find(F==-1));
    