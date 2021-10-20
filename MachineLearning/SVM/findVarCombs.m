cd /Users/spencerwaddle/Documents/MachineLearning/SVM

load('contvlessEnvironment.mat')
ind1=indices(:,[1,2,4]);

load('lessvmoreEnvironment.mat')
ind1=[ind1 indices(:,4)];

ind1(:,5)=sum(ind1(:,[3 4]),2);

ignoreInds=[4:5:60 5:5:60]; %These are kurtosis and median values
signifInds=[2 3 14 15 21 22 24 25 29 43 46 50 51 52 53 56 60]; % These are the indices that are significant p<0.05 for ICA, VBA, and ICA/VBA combinations
temp=1:60;
insignifInds=temp;
insignifInds(signifInds)=[];
delInds=[insignifInds ignoreInds];
delInds=sort(unique(delInds)); %These variables are ignored
includedIndices=1:60;
includedIndices(delInds)=[];

delVec=[];
for i=1:size(ind1,1)
    if sum(ind1(i,1)==delInds)>0
        delVec=[delVec i];   
    end
end
ind1(delVec,:)=[];

delVec=[];
for i=1:size(ind1,1)
    if sum(ind1(i,2)==delInds)>0
        delVec=[delVec i];   
    end
end
ind1(delVec,:)=[];

ind1(find(ind1(:,5)>1.40),:)

%%% Removed [ 1 2 3 7 8 ] for representing redundant information

%%% I eliminated some variables combinations if I decided that they
%%% represented the same thing