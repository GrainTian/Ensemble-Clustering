function K=weight_adjustment_approach(pcp_used,F_normalized,F,K,N)
 % modifying graph K with F 
    if pcp_used
        if F_normalized
            F_max=max(abs(F(:))); F=F/F_max;    
        end;
        K(F>0)=1-(1-K(F>0)).*(1-F(F>0)); 
        K(F<0)=K(F<0).*(1+F(F<0));
        for i=1:N
            K(i,i)=0;
        end;
        K=(K+K')/2;
    else
        K_max=max(K(:)); K=K/K_max;
        K(F>0)=1; K(F<0)=0;
    end;              
    %clear F;
    
    %the normalized graph Laplacian of G(if you need)
        D=sum(K,2); D=1./sqrt(D);  D=diag(D);
        K=eye(N)-D*K*D; clear D; 

