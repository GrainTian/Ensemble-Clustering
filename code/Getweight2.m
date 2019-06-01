function weight = Getweight2(CoMatrix)
% ============Parameter============
%date: 2013-01-22
%Get weight of each object (w.s.t. each row of Matrix)
%author:Yazhou Ren  email:yazhou.ren@mail.scut.edu.cn 
%Input
% CoMatrix  ---  Co-association Matrix
%Output
% weight  --- the vector contains the weight of each object

% ==============Main===============
N = size(CoMatrix,1);
if (N~=size(CoMatrix,2))
    disp('Error-Getweight: the number of rows should equal to that of columns!');
    return;
end
confusion = CoMatrix.*(1-CoMatrix);
weight0 = sum(confusion,2);
weight = (4/N)*weight0;
e = 0.01;
weight = (weight+e)/(1+e);
% weight = weight/sum(weight);
% min_w = min(weight);
% if(0==min_w)
%     disp('Warning-Getweight: minimum of weights = 0!');
%     e = 0.01;
%     weight = (weight+e)/(1+e);
% end
