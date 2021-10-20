tic
sigmoid=@(S,A,B) 1/(1+exp(A*S+B));
% %%%%% Use all indices
% indices=[];
% for index1=1:size(normDat,2)
%     for index2=index1+1:size(normDat,2)

% % %specific indices
indices=[];    
for index1=1
    for index2=8
        
        
        
        %%% Less sten and more sten
        vars=[index1 index2]
        X=[normDat(:,vars); stenDat(:,vars)];
        Y=ones(size(normDat,1)+size(stenDat,1),1);
        Y(1:size(normDat,1))=-1;
        
        
        
        
        guessY=zeros(size(X,1),1);
        scoresY=zeros(size(X,1),1);
        postProbY=zeros(size(X,1),1);

        for i=1:size(X,1)
%             clf
            trainX=[X(1:i-1,:); X(i+1:end,:)];
            trainY=[Y(1:i-1,:); Y(i+1:end,:)];       
       
            
            svmModel=fitcsvm(trainX,trainY,'KernelFunction','rbf','Standardize',true,'CrossVal','off');
            scoreModel=fitSVMPosterior(svmModel,'Leaveout','on');
            [stenVal,score]=predict(svmModel,X(i,:));

            scoreCalc=eval(scoreModel.ScoreTransform);
            postProb=scoreCalc(score(2));
            guessY(i)=stenVal;
            scoresY(i)=score(2);
            postProbY(i)=postProb;
        end
        guessNorm=guessY(Y==-1);
        guessSten=guessY(Y==1);
        normSuccess=guessNorm==-1;
        stenSuccess=guessSten==1;

        [ rocAUC,defaultSpec, defaultSens, defaultmcc, maxSpec,maxSens,mccMax,rocshift ] = rocfunc_v5( postProbY, Y );
        drawnow
        %%% rocshift is the value that the svm decision threshold was
        %%% shifted by to make the sum of TPR+FPR a maximum
%         indices=[indices; [index1 index2 rocshift mccMax rocAUC maxSpec maxSens]];
        indices=[indices; [index1 index2 rocshift rocAUC defaultmcc mccMax defaultSpec maxSpec defaultSens maxSens]];
    end
end
save('lessvmoreEnvironment')
toc

%%

tic
sigmoid=@(S,A,B) 1/(1+exp(A*S+B));


%%%%% Use all indices
indices=[];
for index1=1:size(normDat,2)
    for index2=index1+1:size(normDat,2)
        
        
        
% %%%%% Use all indices
% indices=[];
% for index1=1
%     for index2=4

        %%% Control vs less stenosed
        vars=[index1 index2]

        X=[controlDat(:,vars); normDat(:,vars)];
        Y=ones(size(controlDat,1)+size(normDat,1),1);
        Y(1:size(controlDat,1))=-1;
        guessY=zeros(size(X,1),1);
        scoresY=zeros(size(X,1),1);
        postProbY=zeros(size(X,1),1);

        for i=1:size(X,1)
%             clf
            trainX=[X(1:i-1,:); X(i+1:end,:)];
            trainY=[Y(1:i-1,:); Y(i+1:end,:)];       
       
            
            svmModel=fitcsvm(trainX,trainY,'KernelFunction','rbf','Standardize',true,'CrossVal','off');
            scoreModel=fitSVMPosterior(svmModel,'Leaveout','on');
            [stenVal,score]=predict(svmModel,X(i,:));

            scoreCalc=eval(scoreModel.ScoreTransform);
            postProb=scoreCalc(score(2));
            guessY(i)=stenVal;
            scoresY(i)=score(2);
            postProbY(i)=postProb;
        end
        guessNorm=guessY(Y==-1);
        guessSten=guessY(Y==1);
        normSuccess=guessNorm==-1;
        stenSuccess=guessSten==1;

        [ rocAUC,defaultSpec, defaultSens, defaultmcc, maxSpec,maxSens,mccMax,rocshift ] = rocfunc_v5( postProbY, Y );
        drawnow
        %%% rocshift is the value that the svm decision threshold was
        %%% shifted by to make the sum of TPR+FPR a maximum
%         indices=[indices; [index1 index2 rocshift mccMax rocAUC maxSpec maxSens]];
        indices=[indices; [index1 index2 rocshift rocAUC defaultmcc mccMax defaultSpec maxSpec defaultSens maxSens]];
    end
end
save('contvlessEnvironment')
toc

tic
sigmoid=@(S,A,B) 1/(1+exp(A*S+B));
%%%%% Use all indices
indices=[];
for index1=1:size(normDat,2)
    for index2=index1+1:size(normDat,2)

        %%% Control vs more stenosed
        vars=[index1 index2]
        X=[controlDat(:,vars); stenDat(:,vars)];
        Y=ones(size(controlDat,1)+size(stenDat,1),1);
        Y(1:size(controlDat,1))=-1;
        
        
        
        
        guessY=zeros(size(X,1),1);
        scoresY=zeros(size(X,1),1);
        postProbY=zeros(size(X,1),1);

        for i=1:size(X,1)
%             clf
            trainX=[X(1:i-1,:); X(i+1:end,:)];
            trainY=[Y(1:i-1,:); Y(i+1:end,:)];       
       
            
            svmModel=fitcsvm(trainX,trainY,'KernelFunction','rbf','Standardize',true,'CrossVal','off');
            scoreModel=fitSVMPosterior(svmModel,'Leaveout','on');
            [stenVal,score]=predict(svmModel,X(i,:));

            scoreCalc=eval(scoreModel.ScoreTransform);
            postProb=scoreCalc(score(2));
            guessY(i)=stenVal;
            scoresY(i)=score(2);
            postProbY(i)=postProb;
        end
        guessNorm=guessY(Y==-1);
        guessSten=guessY(Y==1);
        normSuccess=guessNorm==-1;
        stenSuccess=guessSten==1;

        [ rocAUC,defaultSpec, defaultSens, defaultmcc, maxSpec,maxSens,mccMax,rocshift ] = rocfunc_v5( postProbY, Y );
        drawnow
        %%% rocshift is the value that the svm decision threshold was
        %%% shifted by to make the sum of TPR+FPR a maximum
%         indices=[indices; [index1 index2 rocshift mccMax rocAUC maxSpec maxSens]];
        indices=[indices; [index1 index2 rocshift rocAUC defaultmcc mccMax defaultSpec maxSpec defaultSens maxSens]];
    end
end
save('contvmoreEnvironment')
toc