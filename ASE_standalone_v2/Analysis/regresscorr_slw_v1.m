function [ ICCval,slopeval,corrval ] = regresscorr_slw_v1( vec1,vec2,inTitle )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
figure
if length(vec1)~=length(vec2)
    error('input vectors are not the same length.')
end

fitvals=polyfit(vec1,vec2,1);
slopeval=fitvals(1);
interceptval=fitvals(2);

plot(vec1,vec2,'k.','MarkerSize',16)
hold on
plot([-100 100],[-100 100],'b--','LineWidth',3)
axis square

maxx=1.1*max(vec1);
minx=0.9*min(vec1);
% maxy=1.1*max(vec2);
% miny=0.9*min(vec2);
plot([minx maxx],interceptval+slopeval*[minx maxx],'r--','LineWidth',3)
axis([0.2 0.6 0.2 0.6])

[ICCval, LB, UB, F, df1, df2, p]=ICC([vec1,vec2],'1-1');
tempmat=corrcoef(vec1,vec2);
corrval=tempmat(1,2);
disp([inTitle, ' :: ICC = ',num2str(round(ICCval,2)), ' : Pearson r = ',num2str(round(corrval,2)), ...
    ' : Slope = ',num2str(round(slopeval,2))]);
title([inTitle, ' n = ',num2str(length(vec1))])
xlabel('Measurement 1')
ylabel('Measurement 2')

end

