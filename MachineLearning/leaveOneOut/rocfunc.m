function [ rocAUC, maxSpec,maxSens,mccMax ] = rocfunc( scoresY, Y )
%generates an ROC and calculates area under curve

steps=-1.1:0.01:1.1;

FPRvec=zeros(1,length(steps));
TPRvec=zeros(1,length(steps));
mccVec=zeros(1,length(steps));
tempScores=scoresY/max(abs(scoresY));
count=1;
for scoreMod=steps
    guessNorm=sign(tempScores(Y==-1)+scoreMod);
    guessSten=sign(tempScores(Y==1)+scoreMod);
    normSuccess=guessNorm==-1;
    stenSuccess=guessSten==1;
    TP=sum(stenSuccess);
    TN=sum(normSuccess);
    FP=length(normSuccess)-TN;
    FN=length(stenSuccess)-TP;
    FPR=FP/(FP+TN);
    TPR=TP/(TP+FN);
    FPRvec(count)=FPR;
    TPRvec(count)=TPR;
    mccVec(count)=calcmcc(TP,TN,FP,FN);
    count=count+1;
%     pause
end

%%%%% test that ROC is working correctly
% if FPRvec(1)~=0 | FPRvec(end)~=1 | TPRvec(1)~=0 | TPRvec(end)~=1
%     error('broken ROC')
% end

rocAUC=trapz(FPRvec,TPRvec);
findSens=(1-FPRvec)+TPRvec;
goodVals=find(findSens==max(findSens));
maxSpec=1-FPRvec(goodVals(1));
maxSens=TPRvec(goodVals(1));
mccMax=mccVec(goodVals(1));

end

