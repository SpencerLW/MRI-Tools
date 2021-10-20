%% svm with two pre-specified indices
% load('observables_PCA.mat')
% normDat=normDat_PCA;
% stenDat=stenDat_PCA;
% index1=1;
% index2=2;
clf
% load('observables')
% % % 3,11...3,17...3,51...15,20...52,56 are good variables for identifying
% % % stenosis
index1=3;
index2=11;
% index2=1;

% normDat=rand(100,2);
% stenDat=0.05+rand(100,2);
%%%%% train with the first section of the group, predict with the last
%%%%% section. The test group will be groupSplit large.

trainingSize=0;

group1Split=floor(size(normDat,1)*trainingSize);
group2Split=floor(size(stenDat,1)*trainingSize);

% group1Split=size(normDat,1)-floor(size(normDat,1)*0.4);
% group2Split=size(stenDat,1)-floor(size(normDat,1)*0.4);
% group1Split=size(normDat,1)-18;
% group2Split=size(stenDat,1)-18;

% group1Split=0;
% group2Split=0;

group1=normDat(1:end-group1Split,[index1,index2]);
group2=stenDat(1:end-group2Split,[index1,index2]);
% group1=removeoutliers(X,Y,4);

X=[group1; group2];
Y=ones(size(X,1),1);
% Y(size(group1,1):end)=-1;
Y(1:size(group1,1))=-1;
% [X,Y]=removeoutliers(X,Y,4);

testSamp=[normDat(end-group1Split+1:end,[index1,index2]); stenDat(end-group2Split+1:end,[index1,index2])];
%%%%Box constraint option: 'BoxConstraint',Inf
svmModel=fitcsvm(X,Y,'KernelFunction','rbf','Standardize','on');
% Predict scores over the grid
d1 = 0.01*(max(X(:,1))-min(X(:,1)));
d2 = 0.01*(max(X(:,2))-min(X(:,2)));

[x1Grid,x2Grid] = meshgrid(min(X(:,1)):d1:max(X(:,1)),...
    min(X(:,2)):d2:max(X(:,2)));
xGrid = [x1Grid(:),x2Grid(:)];
[~,scores] = predict(svmModel,xGrid);

%%%%%%%%%ROC shift
rocShift=input('enter ROC shift or hit enter');
if rocShift<1.5 & rocShift>-1.5
tempScores=scores(:,2)./max(abs(scores(:)));
scores=tempScores+rocShift;
scores=[-scores scores];
else
    disp('roc shift is set to 0')
end


%%% stars are training, dots are predicting
% plot(group1(:,1),group1(:,2),'r*',group2(:,1),group2(:,2),'b*','MarkerSize',16,'LineWidth',3)
plot(X(Y==-1,1),X(Y==-1,2),'g*',X(Y==1,1),X(Y==1,2),'r*','MarkerSize',16,'LineWidth',3)
hold on

% figure
% plot(testSamp(1:group1Split,1),testSamp(1:group1Split,2),'r.',testSamp((group1Split+1):end,1),...
%     testSamp((group1Split+1):end,2),'b.','MarkerSize',36,'LineWidth',3)
% % % % % axis([-5 5 -5 5])
axis square
hold on
% plot(X(svmModel.IsSupportVector,1),X(svmModel.IsSupportVector,2),'k*');
contour(x1Grid,x2Grid,reshape(scores(:,2),size(x1Grid)),[0 0],'k','LineWidth',4);
% legend({'less stenosed training','more stenosed training','less stenosed predicting','more stenosed predicting'})
legend({'less stenosed training','more stenosed training'})

a=predict(svmModel,testSamp);
lessStenPredict=(a(1:group1Split)+1)*0.5; % should be 1
moreStenPredict=(a(group1Split+1:end)-1)*-0.5; % should be -1
disp(['indices are ',num2str(index1),' ',num2str(index2)])
disp('lessSten predict success is')
lessStenPercent=100*sum(lessStenPredict)/group1Split;
disp(lessStenPercent)
disp('moreSten predict success is')
moreStenPercent=100*sum(moreStenPredict)/group2Split;
disp(moreStenPercent)


%% svm loop through subsections of 2 variables
tic
% load('observables_PCA.mat')
% normDat=normDat_PCA;
% stenDat=stenDat_PCA;

group1Split=floor(size(normDat,1)*0.3);
group2Split=floor(size(stenDat,1)*0.3);

indices=[];
maxMCC=0;
for index1=1:size(normDat,2)
    for index2=index1+1:size(normDat,2)

group1=normDat(1:end-group1Split,[index1,index2]);
group2=stenDat(1:end-group2Split,[index1,index2]);
X=[group1; group2];
testSamp=[normDat(end-group1Split+1:end,[index1,index2]); stenDat(end-group2Split+1:end,[index1,index2])];

Y=ones(size(X,1),1);
Y(size(group1,1):end)=-1;

%%%%Box constraint option: 'BoxConstraint',Inf
svmModel=fitcsvm(X,Y,'KernelFunction','rbf','Standardize','on');

a=predict(svmModel,testSamp);
lessStenPredict=(a(1:group1Split)+1)*0.5; % should be 1
moreStenPredict=(a(group1Split+1:end)-1)*-0.5; % should be -1
TP=sum(moreStenPredict);
FN=group2Split-TP;
TN=sum(lessStenPredict);
FP=group1Split-TN;
lessStenPercent=100*TN/group1Split;
moreStenPercent=100*TP/group2Split;
MCC=calcmcc(TP,TN,FP,FN);
rocAUC=

disp(['indices are ',num2str(index1),' ',num2str(index2)])

indices=[indices; [index1 index2 MCC lessStenPercent moreStenPercent]];
if MCC>maxMCC
    maxMCC=MCC;
end

    end
end
disp('max indices are')
% tempInd=find(indices(:,4)>60); % compare by lessStenPercent
tempInd=find(indices(:,3)>0.6); % compare by MCC

indices(tempInd,:)

%%%% timevec=[5 60 806 18334]; %%%% These are the times that it takes to run each
%%%% of these variable loops

toc
%% svm loop through subsections of 3 variables
tic
group1Split=floor(size(normDat,1)*0.3);
group2Split=floor(size(stenDat,1)*0.3);

indices=[];
maxMCC=0;
for index1=1:size(normDat,2)
    for index2=index1+1:size(normDat,2)
        disp(['two highest indices are ',num2str(index1),' ',num2str(index2)])
        for index3=index2+1:size(normDat,2)
% index1=3;
% index2=11;

group1=normDat(1:end-group1Split,[index1,index2,index3]);
group2=stenDat(1:end-group2Split,[index1,index2,index3]);
X=[group1; group2];
testSamp=[normDat(end-group1Split+1:end,[index1,index2,index3]); stenDat(end-group2Split+1:end,[index1,index2,index3])];

Y=ones(size(X,1),1);
Y(size(group1,1):end)=-1;

%%%%Box constraint option: 'BoxConstraint',Inf
svmModel=fitcsvm(X,Y,'KernelFunction','gaussian','Standardize','on');

a=predict(svmModel,testSamp);
lessStenPredict=(a(1:group1Split)+1)*0.5; % should be 1
moreStenPredict=(a(group1Split+1:end)-1)*-0.5; % should be -1
TP=sum(moreStenPredict);
FN=group2Split-TP;
TN=sum(lessStenPredict);
FP=group1Split-TN;
lessStenPercent=100*TN/group1Split;
moreStenPercent=100*TP/group2Split;
MCC=calcmcc(TP,TN,FP,FN);

indices=[indices; [index1 index2 index3 MCC lessStenPercent moreStenPercent]];
if MCC>maxMCC
    maxMCC=MCC;
end

        end
    end
end
disp('max indices are')
% tempInd=find(indices(:,4)>0.6); % check MCC
tempInd=find(indices(:,5)>65); %check less sten percent
indices(tempInd,:)

toc
%% svm loop through subsections of 4 variables
tic
% load('observables')

group1Split=floor(size(normDat,1)*0.3);
group2Split=floor(size(stenDat,1)*0.3);

%%%% these are the indices you want to check in the data. If you want to
%%%% compare all variables make searchIdx=size(normDat,2);
% searchIdx=[1 3 4 5 6 7 8 9 10 11 13 15 17 18 19 22 23 24 ...
%     27 29 31 33 34 35 36 39 40 41 42 43 44 45]; %good indices from 3 var compare

searchIdx=newSearchIdx
% searchIdx = [2 3 7 9 12 17 18 32 33 37 38 42 44 49 50 51 52 53 55 56 57 60];
% searchIdx=x;
indices=[];
maxlessSten=0;
for search1=1:length(searchIdx)
    index1=searchIdx(search1);
    for search2=search1+1:length(searchIdx)
        index2=searchIdx(search2);
        disp(['Largest and second largest index are ',num2str(index1),' ',num2str(index2)])
        for search3=search2+1:length(searchIdx)
            index3=searchIdx(search3);
            for search4=search3+1:length(searchIdx)
                index4=searchIdx(search4);
% index1=3;
% index2=11;

group1=normDat(1:end-group1Split,[index1,index2,index3,index4]);
group2=stenDat(1:end-group2Split,[index1,index2,index3,index4]);
X=[group1; group2];
testSamp=[normDat(end-group1Split+1:end,[index1,index2,index3,index4]); stenDat(end-group2Split+1:end,[index1,index2,index3,index4])];

Y=ones(size(X,1),1);
Y(size(group1,1):end)=-1;

%%%%Box constraint option: 'BoxConstraint',Inf
svmModel=fitcsvm(X,Y,'KernelFunction','gaussian','Standardize','on');

a=predict(svmModel,testSamp);
lessStenPredict=(a(1:group1Split)+1)*0.5; % should be 1
moreStenPredict=(a(group1Split+1:end)-1)*-0.5; % should be -1
lessStenPercent=100*sum(lessStenPredict)/group1Split;
moreStenPercent=100*sum(moreStenPredict)/group2Split;

% disp(['indices are ',num2str(index1),' ',num2str(index2),' ',num2str(index3),' ',num2str(index4)])

indices=[indices; [index1 index2 index3 index4 lessStenPercent moreStenPercent]];
if lessStenPercent>maxlessSten
    maxlessSten=lessStenPercent;
end
            end
        end
    end
end
fprintf('\n\n')
disp('max indices are')
% tempInd=find(indices(:,5)==maxlessSten);
tempInd=find(indices(:,5)>60);
indices(tempInd,:)

toc

% % % % Using the PCA data, with 30% prediction size, we get this
% % %     2.0000    6.0000   12.0000   25.0000   63.6364   80.0000
% % %     2.0000   10.0000   16.0000   44.0000   63.6364   80.0000
% % %     3.0000    4.0000   25.0000   30.0000   63.6364   70.0000
% % %     4.0000    6.0000   25.0000   35.0000   63.6364   95.0000
% % %    11.0000   16.0000   43.0000   44.0000   63.6364   55.0000


% % % % Using non-PCA data with 30% prediction size, we get this
% % %     3.0000    9.0000   40.0000   42.0000   63.6364   80.0000
% % %     3.0000   12.0000   31.0000   38.0000   63.6364   85.0000
% % %     3.0000   12.0000   38.0000   42.0000   63.6364   95.0000
% % %     3.0000   12.0000   39.0000   42.0000   63.6364   80.0000
% % %     3.0000   34.0000   39.0000   42.0000   63.6364   85.0000
% % %     3.0000   35.0000   39.0000   42.0000   63.6364   90.0000
% % %     3.0000   36.0000   39.0000   42.0000   63.6364   90.0000
% % %     3.0000   39.0000   40.0000   42.0000   63.6364   90.0000
% % %     3.0000   39.0000   41.0000   42.0000   63.6364   85.0000



%% SVM loop through 5 variables Run this over night. It should take ~3hrs
tic
% clear
% load('observables')
% load('Observables_woEDAS')

% searchIdx=[1 3 4 5 6 7 8 9 10 11 13 15 17 18 19 22 23 24 ...
%     27 29 31 33 34 35 36 39 40 41 42 43 44 45]; %good indices from 3 var compare
searchIdx = [2 3 7 9 12 17 18 32 33 37 38 42 44 49 50 51 52 53 55 56 57 60]; %%% from 3 var, after adding DSS0
group1Split=floor(size(normDat,1)*0.3);
group2Split=floor(size(stenDat,1)*0.3);

indices=[];
maxlessSten=0;
for search1=1:length(searchIdx)
    index1=searchIdx(search1);
    for search2=search1+1:length(searchIdx)
        index2=searchIdx(search2);
        disp(['Largest and second largest index are ',num2str(index1),' ',num2str(index2)])
        for search3=search2+1:length(searchIdx)
            index3=searchIdx(search3);
            for search4=search3+1:length(searchIdx)
                index4=searchIdx(search4);
                for search5=search4+1:length(searchIdx)
                    index5=searchIdx(search5);
% index1=3;
% index2=11;

group1=normDat(1:end-group1Split,[index1,index2,index3,index4,index5]);
group2=stenDat(1:end-group2Split,[index1,index2,index3,index4,index5]);
X=[group1; group2];
testSamp=[normDat(end-group1Split+1:end,[index1,index2,index3,index4,index5]); stenDat(end-group2Split+1:end,[index1,index2,index3,index4,index5])];

Y=ones(size(X,1),1);
Y(size(group1,1):end)=-1;

%%%%Box constraint option: 'BoxConstraint',Inf
svmModel=fitcsvm(X,Y,'KernelFunction','gaussian','Standardize','on');

a=predict(svmModel,testSamp);
lessStenPredict=(a(1:group1Split)+1)*0.5; % should be 1
moreStenPredict=(a(group1Split+1:end)-1)*-0.5; % should be -1
lessStenPercent=100*sum(lessStenPredict)/group1Split;
moreStenPercent=100*sum(moreStenPredict)/group2Split;

% disp(['indices are ',num2str(index1),' ',num2str(index2),' ',num2str(index3),' ',num2str(index4)])

indices=[indices; [index1 index2 index3 index4 index5 lessStenPercent moreStenPercent]];
if lessStenPercent>maxlessSten
    maxlessSten=lessStenPercent;
end
                end
            end
        end
    end
end
fprintf('\n\n')
disp('max indices are')
tempInd=find(indices(:,6)==maxlessSten);
indices(tempInd,:)
tempInd=indices;%find(indices(:,6)>50);
newSearchIdx=indices;
newSearchIdx(newSearchIdx(:,6)>50,:)=[];
newSearchIdx=newSearchIdx(:,1:5);
newSearchIdx=unique(newSearchIdx);
save('Indices_5loop','indices')
toc
% % % % Run this code with 30% use for predicting
% %     1.0000    3.0000   35.0000   38.0000   38.0000   63.6364   70.0000
% %     1.0000    9.0000   35.0000   39.0000   44.0000   63.6364   85.0000
% %     3.0000   12.0000   31.0000   35.0000   38.0000   63.6364   85.0000
% %     3.0000   12.0000   31.0000   38.0000   39.0000   63.6364   90.0000
% %     3.0000   12.0000   34.0000   39.0000   42.0000   63.6364   90.0000
% %     3.0000   12.0000   35.0000   38.0000   39.0000   63.6364   90.0000
% %     3.0000   12.0000   35.0000   38.0000   42.0000   63.6364   95.0000
% %     3.0000   12.0000   35.0000   39.0000   42.0000   63.6364   90.0000
% %     3.0000   12.0000   38.0000   39.0000   42.0000   63.6364   90.0000
% %     3.0000   34.0000   35.0000   39.0000   42.0000   63.6364   90.0000
% %     3.0000   34.0000   36.0000   39.0000   42.0000   63.6364   95.0000
% %     3.0000   34.0000   39.0000   40.0000   42.0000   63.6364   90.0000
% %     3.0000   35.0000   36.0000   39.0000   42.0000   63.6364   90.0000
% %     3.0000   35.0000   36.0000   40.0000   42.0000   63.6364   90.0000
% %     3.0000   35.0000   38.0000   39.0000   42.0000   63.6364   90.0000
% %     3.0000   35.0000   39.0000   40.0000   42.0000   63.6364   90.0000
% %     3.0000   35.0000   39.0000   41.0000   42.0000   63.6364   85.0000
% %     3.0000   36.0000   39.0000   40.0000   42.0000   63.6364   90.0000
% %     3.0000   38.0000   39.0000   42.0000   43.0000   63.6364   90.0000
% %     3.0000   39.0000   40.0000   41.0000   42.0000   63.6364   95.0000
% %     7.0000    9.0000   24.0000   39.0000   39.0000   63.6364   85.0000

%% loop through 6 indexes. Run over weekend or something. Should take 2 ish days
tic
% clear
% load('observables')

group1Split=floor(size(normDat,1)*0.3);
group2Split=floor(size(stenDat,1)*0.3);


 searchIdx = [2 3 7 9 12 17 18 32 33 37 38 42 44 49 50 51 52 53 55 56 57 60];

indices=[];
maxMCC=0;
for search1=1:length(searchIdx)
    index1=searchIdx(search1);
    for search2=search1+1:length(searchIdx)
        index2=searchIdx(search2);
        disp(['Largest and second largest index are ',num2str(index1),' ',num2str(index2)])
        for search3=search2+1:length(searchIdx)
            index3=searchIdx(search3);
            for search4=search3+1:length(searchIdx)
                index4=searchIdx(search4);
                for search5=search4+1:length(searchIdx)
                    index5=searchIdx(search5);
                    for search6=search5+1:length(searchIdx)
                        index6=searchIdx(search6);
% index1=3;
% index2=11;

group1=normDat(1:end-group1Split,[index1,index2,index3,index4,index5,index6]);
group2=stenDat(1:end-group2Split,[index1,index2,index3,index4,index5,index6]);
X=[group1; group2];
testSamp=[normDat(end-group1Split+1:end,[index1,index2,index3,index4,index5,index6]); ...
    stenDat(end-group2Split+1:end,[index1,index2,index3,index4,index5,index6])];

Y=ones(size(X,1),1);
Y(size(group1,1):end)=-1;

%%%%Box constraint option: 'BoxConstraint',Inf
svmModel=fitcsvm(X,Y,'KernelFunction','gaussian','Standardize','on');

a=predict(svmModel,testSamp);
lessStenPredict=(a(1:group1Split)+1)*0.5; % should be 1
moreStenPredict=(a(group1Split+1:end)-1)*-0.5; % should be -1
TP=sum(moreStenPredict);
FN=group2Split-TP;
TN=sum(lessStenPredict);
FP=group1Split-TN;
lessStenPercent=100*TN/group1Split;
moreStenPercent=100*TP/group2Split;
MCC=calcmcc(TP,TN,FP,FN);

% disp(['indices are ',num2str(index1),' ',num2str(index2),' ',num2str(index3),' ',num2str(index4)])

indices=[indices; [index1 index2 index3 index4 index5 index6 MCC lessStenPercent moreStenPercent]];
if MCC>maxMCC
    maxMCC=MCC;
end
                    end
                end
            end
        end
    end
end
fprintf('\n\n')
disp('max indices are')
tempInd=find(indices(:,7)==maxMCC);
indices(tempInd,:)
% save('Indices_6loop','indices')
toc

% %     9.0000   32.0000   33.0000   49.0000   52.0000   56.0000   85.7143   92.3077
% %     9.0000   33.0000   38.0000   49.0000   52.0000   56.0000   85.7143   92.3077
% %     9.0000   37.0000   44.0000   55.0000   56.0000   60.0000   85.7143   92.3077
% %     9.0000   38.0000   44.0000   55.0000   56.0000   60.0000   85.7143   92.3077
% %    32.0000   33.0000   37.0000   38.0000   49.0000   56.0000   85.7143   84.6154
% %    32.0000   33.0000   37.0000   49.0000   52.0000   56.0000   85.7143   84.6154
% %    32.0000   33.0000   37.0000   49.0000   56.0000   57.0000   85.7143   84.6154
% %    32.0000   33.0000   38.0000   49.0000   52.0000   56.0000   85.7143   84.6154
% %    32.0000   33.0000   38.0000   49.0000   56.0000   57.0000   85.7143   84.6154
% %    32.0000   33.0000   44.0000   49.0000   56.0000   60.0000   85.7143   92.3077
% %    32.0000   37.0000   38.0000   49.0000   52.0000   56.0000   85.7143   84.6154
% %    32.0000   37.0000   44.0000   49.0000   56.0000   60.0000   85.7143  100.0000
% %    32.0000   38.0000   44.0000   49.0000   56.0000   60.0000   85.7143  100.0000
% %    33.0000   37.0000   38.0000   49.0000   52.0000   56.0000   85.7143   84.6154
% %    33.0000   37.0000   44.0000   49.0000   56.0000   60.0000   85.7143  100.0000

%%%%%%%%%% Mac MCC
% %    32.0000   37.0000   44.0000   49.0000   56.0000   60.0000    0.8921   85.7143  100.0000
% %    32.0000   38.0000   44.0000   49.0000   56.0000   60.0000    0.8921   85.7143  100.0000
% %    33.0000   37.0000   44.0000   49.0000   56.0000   60.0000    0.8921   85.7143  100.0000
%% SVM with ALL available variables

%%%%%%%%%%%%%%%%%%%
%%%%%% develop svm
group1Split=floor(size(normDat,1)*0.4);
group2Split=floor(size(stenDat,1)*0.3);

group1=normDat(1:end-group1Split,:);
group2=stenDat(1:end-group2Split,:);
X=[group1; group2];
testSamp=[normDat(end-group1Split+1:end,:); stenDat(end-group2Split+1:end,:)];

Y=ones(size(X,1),1);
Y(size(group1,1):end)=-1;

%%%%Box constraint option: 'BoxConstraint',Inf
svmModel=fitcsvm(X,Y,'OptimizeHyperparameters','auto','KernelFunction','rbf','KernelScale','auto','Standardize','on');
cvsvmModel=crossval(svmModel);


a=predict(svmModel,testSamp);
lessStenPredict=(a(1:group1Split)+1)*0.5; % should be 1
moreStenPredict=(a(group1Split+1:end)-1)*-0.5; % should be -1
% disp(['indices are ',num2str(index1),' ',num2str(index2)])
disp('lessSten predict success is')
lessStenPercent=100*sum(lessStenPredict)/group1Split;
disp(lessStenPercent)
disp('moreSten predict success is')
moreStenPercent=100*sum(moreStenPredict)/group2Split;
disp(moreStenPercent)

disp('Did it')


%% test ficlinear

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% test ficlinear

group1=normDat(1:end-5,:);
group2=stenDat(1:end-10,:);
X=[group1; group2];
testSamp=[normDat(end-4:end,:); stenDat(end-9:end,:)];

Y=ones(size(X,1),1);
Y(size(group1,1):end)=-1;

mdl=fitclinear(X,Y);

labels=predict(mdl,testSamp)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% original testing

%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% Generate groups
pointsPerGroup=25;
separationDistance=3;
group2ang=(0.5)*pi;

%%% generate group1 in the center
mags1=rand(pointsPerGroup,1)-0.5;
rand1=2*pi*rand(pointsPerGroup,1);
group1=mags1.*[cos(rand1) sin(rand1)];

%%% generate group2 and shift along the x axis
mags2=rand(pointsPerGroup,1)-0.5;
rand2=2*pi*rand(pointsPerGroup,1);
group2=mags2.*[cos(rand2) sin(rand2)]+separationDistance*[ones(pointsPerGroup,1) zeros(pointsPerGroup,1)];

%%% rotate group2 by the specified group2ang
g2mag=sqrt(group2(:,1).^2+group2(:,2).^2);
g2angInit=atan(group2(:,2)./group2(:,1));
g2angFin=g2angInit+group2ang;
group2=g2mag.*[cos(g2angFin) sin(g2angFin)];

%%%%%%%%%%%%%%%%%%%%%
%%%%%%% develop test svm

X=[group1; group2];
Y=ones(length(X),1);
Y(length(group1)+1:end)=-1;

svmModel=fitcsvm(X,Y,'KernelFunction','gaussian','Standardize','off');

% Predict scores over the grid
d = 0.02;
[x1Grid,x2Grid] = meshgrid(min(X(:,1)):d:max(X(:,1)),...
    min(X(:,2)):d:max(X(:,2)));
xGrid = [x1Grid(:),x2Grid(:)];
[~,scores] = predict(svmModel,xGrid);

% sum(svmModel.IsSupportVector)

plot(group1(:,1),group1(:,2),'r.',group2(:,1),group2(:,2),'g.','MarkerSize',14)
axis([-5 5 -5 5])
axis square
hold on
plot(X(svmModel.IsSupportVector,1),X(svmModel.IsSupportVector,2),'ko');
contour(x1Grid,x2Grid,reshape(scores(:,2),size(x1Grid)),[0 0],'k','LineWidth',8);

%% generate rotation and movie

% % % This is the thing I was screwwing around with to make a bouncy
% % % spinny thing
rotationSpeed=0.07;
% rotationSpeed=0;
radialSpeed=0.1;
% radialSpeed=0;
simLength=4*2*pi;
pointsPerGroup=50;
separationDistance=4;
dispersion=4;
axisLen=6;

%%%by pulling the mags and rands outside, it stops the points for shaking
%%%around
mags1=dispersion*rand(pointsPerGroup,1)-0.5;
rand1=2*pi*rand(pointsPerGroup,1);
mags2=dispersion*rand(pointsPerGroup,1)-0.5;
rand2=2*pi*rand(pointsPerGroup,1);
i=1;
for group2ang=0:rotationSpeed:simLength
    separationDistance=separationDistance-radialSpeed;
group1=mags1.*[cos(rand1) sin(rand1)];
group2=mags2.*[cos(rand2) sin(rand2)]+separationDistance*[ones(pointsPerGroup,1) zeros(pointsPerGroup,1)];
%%% rotate group2 by the specified group2ang
g2mag=sqrt(group2(:,1).^2+group2(:,2).^2);
g2angInit=atan(group2(:,2)./group2(:,1));
g2angFin=g2angInit+group2ang;
group2=g2mag.*[cos(g2angFin) sin(g2angFin)];

clf


X=[group1; group2];
Y=ones(length(X),1);
Y(length(group1)+1:end)=-1;

svmModel=fitcsvm(X,Y,'KernelFunction','linear','Standardize','off');

% Predict scores over the grid
d = 0.02;
[x1Grid,x2Grid] = meshgrid(min(X(:,1)):d:max(X(:,1)),...
    min(X(:,2)):d:max(X(:,2)));
xGrid = [x1Grid(:),x2Grid(:)];
[~,scores] = predict(svmModel,xGrid);

%%% Dots are training, stars are predicting
plot(group1(:,1),group1(:,2),'k.',group2(:,1),group2(:,2),'g.','MarkerSize',16)
% axis([-5 5 -5 5])
axis square
hold on
plot(X(svmModel.IsSupportVector,1),X(svmModel.IsSupportVector,2),'ko');
contour(x1Grid,x2Grid,reshape(scores(:,2),size(x1Grid)),[0 0],'k','LineWidth',4);
legend({'group1','group2'})
set(gca,'FontSize',16)

plot(group1(:,1),group1(:,2),'k.',group2(:,1),group2(:,2),'g.','MarkerSize',14)
axis([-1 1 -1 1]*axisLen)
axis square
set(gca,'XTickLabel',[]);
set(gca,'YTickLabel',[]);
drawnow
M(i)=getframe(gcf);
M(i+1)=getframe(gcf);
M(i+2)=getframe(gcf);
i=i+3;
    if separationDistance<-4
        separationDistance=4;
    end
    
    pause
end

%%%% Save video
% v=VideoWriter('/Users/spencerwaddle/Documents/MachineLearning/svmVideo');
% open(v);
% writeVideo(v,M);
% close(v);

%% rotation generation program

% % % This is the thing I was screwwing around with to make a bouncy
% % % spinny thing
rotationSpeed=0.07;
radialSpeed=0.1;
simLength=100*2*pi;
pointsPerGroup=50;
separationDistance=4;

%%%by pulling the mags and rands outside, it stops the points for shaking
%%%around
mags1=rand(pointsPerGroup,1)-0.5;
rand1=2*pi*rand(pointsPerGroup,1);
mags2=rand(pointsPerGroup,1)-0.5;
rand2=2*pi*rand(pointsPerGroup,1);
for group2ang=0:rotationSpeed:100*2*pi
    separationDistance=separationDistance-radialSpeed;
%%% generate group1 in the center
% mags1=rand(pointsPerGroup,1)-0.5;
% rand1=2*pi*rand(pointsPerGroup,1);
group1=mags1.*[cos(rand1) sin(rand1)];

%%% generate group2 and shift along the x axis
% mags2=rand(pointsPerGroup,1)-0.5;
% rand2=2*pi*rand(pointsPerGroup,1);
group2=mags2.*[cos(rand2) sin(rand2)]+separationDistance*[ones(pointsPerGroup,1) zeros(pointsPerGroup,1)];

%%% rotate group2 by the specified group2ang
g2mag=sqrt(group2(:,1).^2+group2(:,2).^2);
g2angInit=atan(group2(:,2)./group2(:,1));
g2angFin=g2angInit+group2ang;
group2=g2mag.*[cos(g2angFin) sin(g2angFin)];


% Predict scores over the grid
d = 0.02;
[x1Grid,x2Grid] = meshgrid(min(X(:,1)):d:max(X(:,1)),...
    min(X(:,2)):d:max(X(:,2)));
xGrid = [x1Grid(:),x2Grid(:)];
[~,scores] = predict(svmModel,xGrid);

plot(group1(:,1),group1(:,2),'k.',group2(:,1),group2(:,2),'g.','MarkerSize',14)
axis([-5 5 -5 5])
axis square
drawnow

    if separationDistance<-4
        separationDistance=4;
    end
end