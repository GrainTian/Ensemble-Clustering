function X2 = NonZeroX(X)
% ============Parameter============
% date: 2013-07-07
% processing step
% author:Yazhou Ren  www.scut.edu.cn  email:yazhou.ren@mail.scut.edu.cn 
%Input
%  X   ---  original X
%Output
%  X2  ---  delete features with the same values

% ==============Main===============
[~,R] = size(X);
idx = [];
for j=1:R
   if( ~all(X(:,j)==X(1,j)))
       idx = [idx;j];
   end
end
if (length(idx)~=R)
    fprintf('\nBad features exist: original #fea=%d; good #fea=%d\n',R,length(idx));
end
X2 = X(:,idx);