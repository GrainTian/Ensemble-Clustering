function F=E2CP(pcp_used,K,lamda,N,F)
% exhaustive and efficient constraint propagation (E2CP)
    if pcp_used  
        D=sum(K,2); D=1./sqrt(D); D=diag(D);          
        W=(1-lamda)*inv(eye(N)-lamda*D*K*D); clear D; 
        F=W*F*W'; clear W;              
    end;
