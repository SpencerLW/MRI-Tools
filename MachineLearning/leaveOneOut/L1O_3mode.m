%%% run findObservables.m first

%% find stats for norm v sten

disp('are you sure, this will take like a half hour to run?')
pause
disp('Really, REALLY sure?')
pause
disp('okay')
% index1=3;
% index2=46;
tic
datMat1=normDat;
datMat2=stenDat;

% %%% only use significant indices
% load('signifInds')
% searchIdx=signifInds;
% indices=[];
% for search1=1:length(searchIdx)
%     index1=searchIdx(search1);
%     for search2=search1+1:length(searchIdx)
%         index2=searchIdx(search2);

%%%%% Use all indices
indices=[];
for index1=1:size(datMat1,2)
    for index2=index1+1:size(datMat1,2)
        
%%%% use specific indices
% for index1=3
%     for index2=11
        vars=[index1 index2]
        X=[datMat1(:,vars); datMat2(:,vars)];
        Y=ones(size(datMat1,1)+size(datMat2,1),1);
        Y(1:size(datMat1,1))=-1;
%         [X,Y]=removeoutliers(X,Y,4); %%%%remove outliers
%         size(X)
%         pause

        guessY=zeros(size(X,1),1);
        scoresY=zeros(size(X,1),1);
        for i=1:size(X,1)
%             clf
            trainX=[X(1:i-1,:); X(i+1:end,:)];
            trainY=[Y(1:i-1,:); Y(i+1:end,:)];
            
       
            svmModel=fitcsvm(trainX,trainY,'KernelFunction','rbf','Standardize','on');
            
%             %%%%%% to plot dots and contour
%             d =1;
%             [x1Grid,x2Grid] = meshgrid(min(X(:,1)):d:max(X(:,1)),...
%                 min(X(:,2)):d:max(X(:,2)));
%             xGrid = [x1Grid(:),x2Grid(:)];
%             [~,scores] = predict(svmModel,xGrid);
%             %%% stars are training, dots are predicting
%             plot(datMat1(:,index1),datMat1(:,index2),'k*',datMat2(:,index1),datMat2(:,index2),'g*','MarkerSize',16,'LineWidth',3)
%             hold on
% 
%             % figure
%             plot(X(i,1),X(i,2),'r.','MarkerSize',36,'LineWidth',3)
%             % % % % % axis([-5 5 -5 5])
%             axis square
%             contour(x1Grid,x2Grid,reshape(scores(:,2),size(x1Grid)),[0 0],'k','LineWidth',4);
%             legend({'less stenosed training','more stenosed training'})
%             set(gca,'FontSize',16)
%             %%%%%%%%%%%%
            [stenVal,score]=predict(svmModel,X(i,:));
            guessY(i)=stenVal;
            scoresY(i)=score(2);
%             drawnow
%             disp(guessY')
%             pause
        end

        guessNorm=guessY(Y==-1);
        guessSten=guessY(Y==1);
        normSuccess=guessNorm==-1;
        stenSuccess=guessSten==1;
%         TP=sum(stenSuccess);
%         TN=sum(normSuccess);
%         FP=length(normSuccess)-TN;
%         FN=length(stenSuccess)-TP;
%         MCC=calcmcc(TP,TN,FP,FN);
        [rocAUC, maxSpec, maxSens, mccMax]=rocfunc( scoresY, Y );
        indices=[indices; [index1 index2 mccMax rocAUC maxSpec maxSens]];
%         pause
    end
end
toc

normStenStats=indices;
%% find stats for norm v cont

% index1=3;
% index2=46;
tic
datMat1=normDat;
datMat2=controlDat;

% %%% only use significant indices
% load('signifInds')
% searchIdx=signifInds;
% indices=[];
% for search1=1:length(searchIdx)
%     index1=searchIdx(search1);
%     for search2=search1+1:length(searchIdx)
%         index2=searchIdx(search2);

%%%%% Use all indices
indices=[];
for index1=1:size(datMat1,2)
    for index2=index1+1:size(datMat1,2)
        
%%%% use specific indices
% for index1=3
%     for index2=11
        vars=[index1 index2]
        X=[datMat1(:,vars); datMat2(:,vars)];
        Y=ones(size(datMat1,1)+size(datMat2,1),1);
        Y(1:size(datMat1,1))=-1;
%         [X,Y]=removeoutliers(X,Y,4); %%%%remove outliers
%         size(X)
%         pause

        guessY=zeros(size(X,1),1);
        scoresY=zeros(size(X,1),1);
        for i=1:size(X,1)
%             clf
            trainX=[X(1:i-1,:); X(i+1:end,:)];
            trainY=[Y(1:i-1,:); Y(i+1:end,:)];
            
       
            svmModel=fitcsvm(trainX,trainY,'KernelFunction','rbf','Standardize','on');
            
%             %%%%%% to plot dots and contour
%             d =1;
%             [x1Grid,x2Grid] = meshgrid(min(X(:,1)):d:max(X(:,1)),...
%                 min(X(:,2)):d:max(X(:,2)));
%             xGrid = [x1Grid(:),x2Grid(:)];
%             [~,scores] = predict(svmModel,xGrid);
%             %%% stars are training, dots are predicting
%             plot(datMat1(:,index1),datMat1(:,index2),'k*',datMat2(:,index1),datMat2(:,index2),'g*','MarkerSize',16,'LineWidth',3)
%             hold on
% 
%             % figure
%             plot(X(i,1),X(i,2),'r.','MarkerSize',36,'LineWidth',3)
%             % % % % % axis([-5 5 -5 5])
%             axis square
%             contour(x1Grid,x2Grid,reshape(scores(:,2),size(x1Grid)),[0 0],'k','LineWidth',4);
%             legend({'less stenosed training','more stenosed training'})
%             set(gca,'FontSize',16)
%             %%%%%%%%%%%%
            [stenVal,score]=predict(svmModel,X(i,:));
            guessY(i)=stenVal;
            scoresY(i)=score(2);
%             drawnow
%             disp(guessY')
%             pause
        end

        guessNorm=guessY(Y==-1);
        guessSten=guessY(Y==1);
        normSuccess=guessNorm==-1;
        stenSuccess=guessSten==1;
%         TP=sum(stenSuccess);
%         TN=sum(normSuccess);
%         FP=length(normSuccess)-TN;
%         FN=length(stenSuccess)-TP;
%         MCC=calcmcc(TP,TN,FP,FN);
        [rocAUC, maxSpec, maxSens, mccMax]=rocfunc( scoresY, Y );
        indices=[indices; [index1 index2 mccMax rocAUC maxSpec maxSens]];
%         pause
    end
end
toc
normContStats=indices;
%% find stats for sten v cont

% index1=3;
% index2=46;
tic
datMat1=stenDat;
datMat2=controlDat;

% %%% only use significant indices
% load('signifInds')
% searchIdx=signifInds;
% indices=[];
% for search1=1:length(searchIdx)
%     index1=searchIdx(search1);
%     for search2=search1+1:length(searchIdx)
%         index2=searchIdx(search2);

%%%%% Use all indices
indices=[];
for index1=1:size(datMat1,2)
    for index2=index1+1:size(datMat1,2)
        
%%%% use specific indices
% for index1=3
%     for index2=11
        vars=[index1 index2]
        X=[datMat1(:,vars); datMat2(:,vars)];
        Y=ones(size(datMat1,1)+size(datMat2,1),1);
        Y(1:size(datMat1,1))=-1;
%         [X,Y]=removeoutliers(X,Y,4); %%%%remove outliers
%         size(X)
%         pause

        guessY=zeros(size(X,1),1);
        scoresY=zeros(size(X,1),1);
        for i=1:size(X,1)
%             clf
            trainX=[X(1:i-1,:); X(i+1:end,:)];
            trainY=[Y(1:i-1,:); Y(i+1:end,:)];
            
       
            svmModel=fitcsvm(trainX,trainY,'KernelFunction','rbf','Standardize','on');
            
%             %%%%%% to plot dots and contour
%             d =1;
%             [x1Grid,x2Grid] = meshgrid(min(X(:,1)):d:max(X(:,1)),...
%                 min(X(:,2)):d:max(X(:,2)));
%             xGrid = [x1Grid(:),x2Grid(:)];
%             [~,scores] = predict(svmModel,xGrid);
%             %%% stars are training, dots are predicting
%             plot(datMat1(:,index1),datMat1(:,index2),'k*',datMat2(:,index1),datMat2(:,index2),'g*','MarkerSize',16,'LineWidth',3)
%             hold on
% 
%             % figure
%             plot(X(i,1),X(i,2),'r.','MarkerSize',36,'LineWidth',3)
%             % % % % % axis([-5 5 -5 5])
%             axis square
%             contour(x1Grid,x2Grid,reshape(scores(:,2),size(x1Grid)),[0 0],'k','LineWidth',4);
%             legend({'less stenosed training','more stenosed training'})
%             set(gca,'FontSize',16)
%             %%%%%%%%%%%%
            [stenVal,score]=predict(svmModel,X(i,:));
            guessY(i)=stenVal;
            scoresY(i)=score(2);
%             drawnow
%             disp(guessY')
%             pause
        end

        guessNorm=guessY(Y==-1);
        guessSten=guessY(Y==1);
        normSuccess=guessNorm==-1;
        stenSuccess=guessSten==1;
%         TP=sum(stenSuccess);
%         TN=sum(normSuccess);
%         FP=length(normSuccess)-TN;
%         FN=length(stenSuccess)-TP;
%         MCC=calcmcc(TP,TN,FP,FN);
        [rocAUC, maxSpec, maxSens, mccMax]=rocfunc( scoresY, Y );
        indices=[indices; [index1 index2 mccMax rocAUC maxSpec maxSens]];
%         pause
    end
end
toc
stenContStats=indices;
%%
mccMaxThresh=0.4;
rocAUCThresh=0.6;
maxSpecThresh=0.65;
maxSensThresh=0.65;

tempNormSten=normStenStats(find(normStenStats(:,3)>mccMaxThresh & normStenStats(:,4)>rocAUCThresh ...
    & normStenStats(:,5)>maxSpecThresh & normStenStats(:,6)>maxSensThresh),:)
% size(tempNormSten)

mccMaxThresh=0.65;
rocAUCThresh=0.75;
maxSpecThresh=0.8;
maxSensThresh=0.8;

tempNormCont=normContStats(find(normContStats(:,3)>mccMaxThresh & normContStats(:,4)>rocAUCThresh ...
    & normContStats(:,5)>maxSpecThresh & normContStats(:,6)>maxSensThresh),:)
% size(tempNormCont)

mccMaxThresh=0.75;
rocAUCThresh=0.85;
maxSpecThresh=0.9;
maxSensThresh=0.9;

tempStenCont=stenContStats(find(stenContStats(:,3)>mccMaxThresh & stenContStats(:,4)>rocAUCThresh ...
    & stenContStats(:,5)>maxSpecThresh & stenContStats(:,6)>maxSensThresh),:)
% size(tempStenCont)
