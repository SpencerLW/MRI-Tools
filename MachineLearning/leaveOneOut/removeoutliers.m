function [ X, Y ] = removeoutliers( X,Y,stDvAllow )
%removes outliers from X, and from Y at the same row values. Y and
%stDvAllow are options
if ~exist('stDvAllow','var')
    stDvAllow=3;
end

devi=std(X);
avg=mean(X);
upperB=avg+devi*stDvAllow;
lowerB=avg-devi*stDvAllow;

outLiers=X>upperB | X<lowerB;
replaceVec=sum(outLiers,2)>0;
X(replaceVec,:)=[];
if exist('Y','var')
    Y(replaceVec,:)=[];
end
end

