% IncompDat={};
% fid=fopen('Incompletedata.txt');

%%%%%% To add or remove an observable, change the number of observables
%%%%%% here, then go into defineFeatures.m and add/remove that variables
%%%%%% from varvec
% Observables=4;
numObs=3;%%% number of observables ie. Mean, median, kurtosis...
normDat=[];
stenDat=[];
controlDat=[];
normNames={}; %%% names will be PTSTEN_xxx_xx_l or PTSTEN_xxx_xx_r
stenNames={};
controlNames={};

workingDir='/Users/spencerwaddle/Documents/MachineLearning/data';

modes={'normal','stenosed','controls'};
% modes={'controls'};
variables={'CBF','TMAX','ZMAX','DSS0'};
flowTerrs={'lica','rica','lvba','rvba'};

numVars=length(variables);
numTerrs=length(flowTerrs)/2; %over two because there is only one per hem

for a=modes
    for b=variables
        for c=flowTerrs
            mode=a{1};
            var=b{1};
            terr=c{1};
            files=dir([workingDir,'/',var,'/',mode,'/',terr,'/','*.nii.gz']);                        
            files={files.name};                     
            datPos=contains(terr,'vba')*numObs+(find(strcmp(variables,var))-1) ...
                *numTerrs*numObs+1;
            
            if strcmp(mode,'normal')
                
                [normDat,normNames]=defineFeatures_v2(files,workingDir,var,mode,terr, ...
                    normNames,normDat,numObs,numTerrs,datPos,numVars);

            elseif strcmp(mode,'stenosed')
                [stenDat,stenNames]=defineFeatures_v2(files,workingDir,var,mode,terr, ...
                    stenNames,stenDat,numObs,numTerrs,datPos,numVars);
                
            elseif strcmp(mode,'controls')
                [controlDat,controlNames]=defineFeatures_v2(files,workingDir,var,mode,terr, ...
                    controlNames,controlDat,numObs,numTerrs,datPos,numVars);
            end
%             normDat
%             disp({mode var terr})
% %             datPos
%             pause
            
        end
    end
end

%%% Add CoV
normDat(:,end+1)=100*normDat(:,3)./normDat(:,1);
normDat(:,end+1)=100*normDat(:,6)./normDat(:,4);
stenDat(:,end+1)=100*stenDat(:,3)./stenDat(:,1);
stenDat(:,end+1)=100*stenDat(:,6)./stenDat(:,4);
controlDat(:,end+1)=100*controlDat(:,3)./controlDat(:,1);
controlDat(:,end+1)=100*controlDat(:,6)./controlDat(:,4);

%%% Add demographic information below, after removing broken data


brokenData=[];

%%%% These were all removed at the beginning of processing
% brokenData=find(contains(normNames,'PTSTEN_093')); %% Double EDAS
% brokenData=[brokenData find(contains(normNames,'PTSTEN_090_01'))]; %% replaced by 090_03
% brokenData=[brokenData find(contains(normNames,'PTSTEN_135'))];%% bad artifacts in CBF
                %%%% Removed 157 because it was mostly athero
% % % brokenData=[brokenData find(contains(normNames,'PTSTEN_157'))];%%%
normDat(brokenData,:)=[];
normNames(brokenData)=[];

missingData=find(sum(normDat==0,2)~=0);
normDat(missingData,:)=[];
normNames(missingData)=[];

% brokenData=find(contains(stenNames,'PTSTEN_093')); %% Double EDAS
% brokenData=[brokenData find(contains(stenNames,'PTSTEN_090_01'))];%% replaced by 090_03
% brokenData=[brokenData find(contains(stenNames,'PTSTEN_135'))];%% bad artifacts in CBF
% % % brokenData=[brokenData find(contains(normNames,'PTSTEN_157'))];%%%
stenDat(brokenData,:)=[];
stenNames(brokenData)=[];

missingData=find(sum(stenDat==0,2)~=0);
stenDat(missingData,:)=[];
stenNames(missingData)=[];

missingData=find(sum(controlDat==0,2)~=0);
controlDat(missingData,:)=[];
controlNames(missingData)=[];
    
demXLSX='/Users/spencerwaddle/Documents/MachineLearning/SVM/postRevisions/demographics.xlsx';
normDem=xlsread(demXLSX,1,'C:G','basic');
stenDem=xlsread(demXLSX,1,'J:N','basic');
controlDem=xlsread(demXLSX,1,'Q:U','basic');

controlDat=[controlDat controlDem];
normDat=[normDat normDem];
stenDat=[stenDat stenDem];






    