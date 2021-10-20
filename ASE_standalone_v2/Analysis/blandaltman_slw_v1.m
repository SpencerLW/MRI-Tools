function [ finflag ] = blandaltman_slw_v1( vec1,vec2 )
% 
% plotopts can be ''. 

figure
if length(vec1)~=length(vec2)
    error('vectors are not the same length')    
end

newvec=vec2-vec1;
meanvec=(vec1+vec2)/2;

plot(meanvec,newvec,'k.','MarkerSize',12)
axis square
hold on
maxvaly=ceil(max(abs(newvec))*100)/100;
maxvalx=ceil(max(abs(meanvec))*100)/100;

meanx=mean(meanvec);
diffx=maxvalx-meanx;

confval=1.96*std(newvec); %%% 1.96 to calculate limits of agreement, i.e. confidence interval
meanval=mean(newvec);

plot([-100 100],meanval+[confval confval],'r--','LineWidth',3)
plot([-100 100],meanval-[confval confval],'r--','LineWidth',3)
plot([-100 100],[meanval meanval],'b-','LineWidth',3)

axis([meanx-diffx meanx+diffx -maxvaly maxvaly])

xlabel('average of two measures')
ylabel('difference between two measures')

finflag='bland altman has finished';
end

