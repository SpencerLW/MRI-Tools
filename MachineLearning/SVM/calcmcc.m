function [ MCC ] = calcmcc( TP,TN,FP,FN )
%calculate the Matthews correlation coefficient

numer=TP*TN-FP*FN;
denom=sqrt((TP+FP)*(TP+FN)*(TN+FP)*(TN+FN));

MCC=numer/denom;

end

