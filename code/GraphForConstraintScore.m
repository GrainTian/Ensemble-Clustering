function [M,C] = GraphForConstraintScore(x,y,ConstraintNum)
%% ===========参数说明============
%Construct Graph  ---  must-link matrix & cannot-link matrix
%date: 2010-12-2
%author:renyazhou 任亚洲 www.scut.edu.cn  email:yazhou.ren@mail.scut.edu.cn 
%Input
%      x        ---  训练样本矩阵,N*R
%      y        ---  训练样本标签,N*1
% ConstraintNum ---  constraintnum 
%Output
%   M    ---  must-link matrix, N*N
%   C    ---  cannot-link matrix, N*N

%% ============main============
N = size(x,1);
M = zeros(N,N);%must-link matrix
%M = sparse(M);
C = zeros(N,N);%cannot-link matrix
%C = sparse(C);
Smax = 1;
nc = 0;
nm = 0;
count = 0;
while (count<ConstraintNum)
%     part1=randint(1,1,[1,N]);
    temp=randperm(N);
    part1=temp(1);
   
    part2=temp(2);
    idx=2;
%     part2=randint(1,1,[1,N]);
    while(M(part1,part2)==Smax||C(part1,part2)==Smax)
        idx=idx+1;
        part2=temp(idx);
    end
    count=count+1;
    if y(part1)==y(part2)%must-link
        M(part1,part2)=Smax;
        M(part2,part1)=Smax;
        nm=nm+1;
    else
        C(part1,part2)=Smax; %cannot-link
        C(part2,part1)=Smax;
        nc=nc+1;
    end
    %count=min(nc,nm);
end
