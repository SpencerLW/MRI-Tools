%generats an ROC and calculates area under curve for the point where the
%sum of sensetivity and specificity is a maximum. The addition from v2 was
%the output of default statistics as well as maximum statistics. Addition
%from v3 is fixing the rocshift normalization problem. Before I was
%normalizing to the highest value in the scores vec, and then later was
%normalizing to the highest value in the whole space scoring grid, which
%are not the same number. This led to some SVMs that were really incorrect.

WRONG WRONG WRONG
% 
% index1=3;
% index2=46;
% tic
% 
% %         %%% Control vs less stenosed
% %         load('contvlessEnvironment.mat')
% %         vars=[index1 index2]
% %         X=[controlDat(:,vars); normDat(:,vars)];
% %         Y=ones(size(controlDat,1)+size(normDat,1),1);
% %         Y(1:size(controlDat,1))=-1;
% %         
% %         %%% Control vs more stenosed
% %         load('contvmoreEnvironment.mat')
% %         vars=[index1 index2]
% %         X=[controlDat(:,vars); stenDat(:,vars)];
% %         Y=ones(size(controlDat,1)+size(stenDat,1),1);
% %         Y(1:size(controlDat,1))=-1;
% 
%         %%% Less sten and more sten
%         load('lessvmoreEnvironment.mat')
%         vars=[index1 index2]
%         X=[normDat(:,vars); stenDat(:,vars)];
%         Y=ones(size(normDat,1)+size(stenDat,1),1);
%         Y(1:size(normDat,1))=-1;
%                 
% %         [X,Y]=removeoutliers(X,Y,4); %%%%remove outliers
% 
%         guessY=zeros(size(X,1),1);
%         scoresY=zeros(size(X,1),1);
%         for i=1:size(X,1)
% %             clf
%             trainX=[X(1:i-1,:); X(i+1:end,:)];
%             trainY=[Y(1:i-1,:); Y(i+1:end,:)];       
%        
%             svmModel=fitcsvm(trainX,trainY,'KernelFunction','rbf','Standardize','on');
%             [stenVal,score]=predict(svmModel,X(i,:));            
%             
%             guessY(i)=stenVal;
%             scoresY(i)=score(2);
% %             drawnow
% %             disp(guessY')
% %             pause
%         end
%         guessNorm=guessY(Y==-1);
%         guessSten=guessY(Y==1);
%         normSuccess=guessNorm==-1;
%         stenSuccess=guessSten==1;
%         
%         
%         % modVal=1.4;
% % steps=min(scoresY)*modVal:0.0001:max(scoresY)*modVal;
% 
% d=0.0001;
% steps=-max(scoresY)-d:d:-min(scoresY)+d;
% 
% %%%%%%%%%% calculate shifted statistics
% FPRvec=zeros(1,length(steps));
% TPRvec=zeros(1,length(steps));
% accVec=zeros(1,length(steps));
% tempScores=scoresY;
% count=1;
% for scoreMod=steps
%     guessNorm=sign(tempScores(Y==-1)+scoreMod);
%     guessSten=sign(tempScores(Y==1)+scoreMod);
%     normSuccess=guessNorm==-1;
%     stenSuccess=guessSten==1;
%     TP=sum(stenSuccess);
%     TN=sum(normSuccess);
%     FP=length(normSuccess)-TN;
%     FN=length(stenSuccess)-TP;
%     FPR=FP/(FP+TN);
%     TPR=TP/(TP+FN);
%     FPRvec(count)=FPR;
%     TPRvec(count)=TPR;
%     accVec(count)=(TP+TN)/(TP+TN+FP+FN);
%     count=count+1;
% %     pause
% end
% 
% 
% %%%%% test that ROC is working correctly
% % if FPRvec(1)~=0 | FPRvec(end)~=1 | TPRvec(1)~=0 | TPRvec(end)~=1
% %     error('broken ROC')
% % end
% 
% rocAUC=trapz(FPRvec,TPRvec);
% % plot(FPRvec,TPRvec,'k','LineWidth',4)
% findSens=(1-FPRvec)+TPRvec; %% linear sum
% goodVals=find(findSens==max(findSens)); % Find Youden Index
% maxSpec=1-FPRvec(goodVals(end));
% maxSens=TPRvec(goodVals(end));
% accMax=accVec(goodVals(end));
% rocshift=steps(goodVals(end));
% 
% plot(FPRvec,TPRvec,'k','LineWidth',2)
% title(['ROC-AUC: ',num2str(rocAUC)])
