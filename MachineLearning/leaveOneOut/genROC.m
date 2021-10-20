%%% Run L1O on a specific set of two variabls, then run this. We have to
%%% have ScoresY and Y to be able to do this.
steps=-1.1:0.01:1.1;

FPRvec=zeros(1,length(steps));
TPRvec=zeros(1,length(steps));
tempScores=scoresY/max(abs(scoresY));
count=1;
for scoreMod=steps
%     tempScores+scoreMod
%     pause
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
    count=count+1;
%     pause
end
if FPRvec(1)~=0 | FPRvec(end)~=1 | TPRvec(1)~=0 | TPRvec(end)~=1
    error('broken ROC')
end

findSens=(1-FPRvec)+TPRvec;
goodVals=find(findSens==max(findSens));
fprintf('\n\n')
disp(['Specificity is ',num2str(1-FPRvec(goodVals(end)))])
disp(['Sensitivity is ',num2str(TPRvec(goodVals(end)))])
disp(['ROC shift is ',num2str(steps(goodVals(end)))])

plot(FPRvec,TPRvec,'k')
% trapz(FPRvec,TPRvec)