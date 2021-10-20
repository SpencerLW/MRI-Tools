%% leave one out testing SVM. Three variables.

% index1=3;
% index2=46;
tic

indices=[];
for index1=1:size(normDat,2)
    for index2=index1+1:size(normDat,2)
        for index3=index2+1:size(normDat,2)
        vars=[index1 index2 index3];
        X=[normDat(:,vars); stenDat(:,vars)];
        Y=ones(size(normDat,1)+size(stenDat,1),1);
        Y(1:size(normDat,1)+1)=-1;
%         [X,Y]=removeoutliers(X,Y,4);

        guessY=zeros(size(X,1),1);
        for i=1:size(X,1)
            trainX=[X(1:i-1,:); X(i+1:end,:)];
            trainY=[Y(1:i-1,:); Y(i+1:end,:)];
       
            svmModel=fitcsvm(trainX,trainY,'KernelFunction','rbf','Standardize','on');
            [stenVal,score]=predict(svmModel,X(i,:));
            guessY(i)=stenVal;
        end

        guessNorm=guessY(Y==-1);
        guessSten=guessY(Y==1);
        normSuccess=guessNorm==-1;
        stenSuccess=guessSten==1;
        TP=sum(stenSuccess);
        TN=sum(normSuccess);
        FP=length(normSuccess)-TN;
        FN=length(stenSuccess)-TP;
        lessStenPercent=TN/size(normDat,1);
        moreStenPercent=TP/size(stenDat,1);
        MCC=calcmcc(TP,TN,FP,FN);
        indices=[indices; [vars MCC lessStenPercent moreStenPercent]];
        end
    end
end
toc


%% leave one out testing two variables

% index1=3;
% index2=46;
tic


%%% only use significant indices
load('signifInds')
searchIdx=signifInds;
indices=[];
for search1=1:length(searchIdx)
    index1=searchIdx(search1);
    for search2=search1+1:length(searchIdx)
        index2=searchIdx(search2);

%%%%%% Use all indices
% indices=[];
% for index1=1:size(normDat,2)
%     for index2=index1+1:size(normDat,2)
        
%%%% use specific indices
% for index1=3
%     for index2=11
        vars=[index1 index2]
        X=[normDat(:,vars); stenDat(:,vars)];
        Y=ones(size(normDat,1)+size(stenDat,1),1);
        Y(1:size(normDat,1))=-1;
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
%             plot(normDat(:,index1),normDat(:,index2),'k*',stenDat(:,index1),stenDat(:,index2),'g*','MarkerSize',16,'LineWidth',3)
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

%% L1O single variabl

% Y=ones(size(normDat,1)+size(stenDat,1),1);
% Y(1:size(normDat,1)+1)=-1;
indices=[];
for index=1:length(normDat)
%     X=[normDat(:,index); stenDat(:,index)];
    index
%     guessY=zeros(size(X,1),1);
    
    
    X=[normDat(:,index); stenDat(:,index)];
    Y=ones(size(normDat,1)+size(stenDat,1),1);
    Y(1:size(normDat,1)+1)=-1;
%     [X,Y]=removeoutliers(X,Y,4);

    
    guessY=zeros(size(X,1),1);
    scoresY=zeros(size(X,1),1);
    for i=1:size(X,1)
%         clf
        trainX=[X(1:i-1); X(i+1:end)];
        trainY=[Y(1:i-1); Y(i+1:end)];


        svmModel=fitcsvm(trainX,trainY,'KernelFunction','rbf','Standardize','on');

%         %%%%%% to plot dots and contour
%         d =1;
%         [x1Grid,x2Grid] = meshgrid(min(X(:,1)):d:max(X(:,1)),...
%             min(X(:,2)):d:max(X(:,2)));
%         xGrid = [x1Grid(:),x2Grid(:)];
%         [~,scores] = predict(svmModel,xGrid);
%         %%% stars are training, dots are predicting
%         plot(normDat(:,index),normDat(:,index2),'k*',stenDat(:,index),stenDat(:,index2),'g*','MarkerSize',16,'LineWidth',3)
%         hold on
% 
%         % figure
%         plot(X(i,1),X(i,2),'r.','MarkerSize',36,'LineWidth',3)
%         % % % % % axis([-5 5 -5 5])
%         axis square
%         contour(x1Grid,x2Grid,reshape(scores(:,2),size(x1Grid)),[0 0],'k','LineWidth',4);
%         legend({'less stenosed training','more stenosed training'})
%         set(gca,'FontSize',16)
%         %%%%%%%%%%%%

        [stenVal,score]=predict(svmModel,X(i));
        guessY(i)=stenVal;
        scoresY(i)=score(2);    
%             disp(guessY')
%         pause
    end

    guessNorm=guessY(1:size(normDat,1));
    guessSten=guessY(size(normDat,1)+1:end);
    normSuccess=guessNorm==-1;
    stenSuccess=guessSten==1;
%     TP=sum(stenSuccess);
%     TN=sum(normSuccess);
%     FP=length(normSuccess)-TN;
%     FN=length(stenSuccess)-TP;
%     lessStenPercent=TN/size(normDat,1);
%     moreStenPercent=TP/size(stenDat,1);
%     MCC=calcmcc(TP,TN,FP,FN);
    [rocAUC, maxSpec, maxSens, mccMax]=rocfunc( scoresY, Y );
    indices=[indices; [index mccMax rocAUC maxSpec maxSens]];
%     disp('done')
end