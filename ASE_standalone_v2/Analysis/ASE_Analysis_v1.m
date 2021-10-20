% % % % % % ASE
%%% This will look for data in the structure output by the ASE pipeline, ASEmaster_v2.m
clear
% % % % % From another paper 
% % % Repeatability and reproducibility were evaluated using within-subject 
% % % coefficient of variation (wCV), intraclass correlation coefficient (ICC), 
% % % agreement index (AI), and repeatability coefficient (RC). Correlations 
% % % were measured by Pearson's correlation coefficients.

%%%%% Tests to perform
%%% 1. Correlation of each ASE method with TRUST. (signrank)
%%% 2. Repeatability of each ASE method, TRUST, and pCASL. (ICC)
%%% 3. Correlations between pCASL and OEF?

%%% We need patdirs, so the program can grab the excel files with the
%%% processed data in them.
datadir='/Users/spencerwaddle/Documents/PPE/Scanning';

% % %%%% All participants
% % patdirs={'20210301_Donahue_241665', '20210329_Donahue_241973', '20210407_Donahue_242049', ...
% %     '20210527_Donahue_142506', '20210630_Donahue_242842', '20210630_Donahue_242845', '20210701_Donahue_242810', ...
% %     '20210701_Donahue_242820', '20210707_Donahue_242907', '20210707_Donahue_242908', '20210707_Donahue_242909', ...
% %     '20210810_Donahue_243184','20210810_Donahue_243185','20210813_Donahue_243203','20210813_Donahue_243262'};

%%% Exclude JB
patdirs={'20210301_Donahue_241665', '20210407_Donahue_242049', ...
    '20210527_Donahue_142506', '20210630_Donahue_242842', '20210630_Donahue_242845', '20210701_Donahue_242810', ...
    '20210701_Donahue_242820', '20210707_Donahue_242907', '20210707_Donahue_242908', '20210707_Donahue_242909', ...
    '20210810_Donahue_243184','20210810_Donahue_243185','20210813_Donahue_243203','20210813_Donahue_243262'};


warning('off','all')

%%%%%%%%% Initialize asestruct
asestruct.patnames=patdirs;
vartypes={'R2prime','rOEF','rvCBV','Rsquared'};
scantypes={'ms_ASE_RFoff','ms_ASE_RFon','ss_ASE_RFoff','vasoase'};
vecnames={'GM_L','GM_R','frontal_L','frontal_R','occipital_L','occipital_R','parietal_L', ...
        'parietal_R','temporal_L','temporal_R','wm_eroded_L','wm_eroded_R'};
for i=1:length(scantypes)
    for j=1:length(vartypes)
        for k=1:length(vecnames)
            asestruct.(vartypes{i}).(scantypes{j}).(vecnames{k})=[];
        end
    end
end
asltypes={'CBFmean','CBFstd'};
for i=1:length(asltypes)
    for j=1:length(vecnames)
        asestruct.(asltypes{i}).(vecnames{j})=[];
    end
end
%%%%%%%%%% End initialize asestruct

%%%%%%%%%%% Read in data to structure
for patind=1:length(patdirs)
    newpat=[1 1 1 1 1 1];
    patdir=[datadir,'/',patdirs{patind}];
    csvfile=[patdir,'/Results/coregResults/',patdirs{patind},'_ProcResults.csv'];
    t=readtable(csvfile);
    for i=1:size(t(:,3),1)
        filename=t{i,3};
        if contains(filename,'ASL') && strcmp(t{i,4},'mean')
            asestruct=fillASEvals_v1(asestruct,t{i,5:end},'CBFmean',t{i,2}{:},newpat(1));
            newpat(1)=0;
        elseif contains(filename,'ASL') && strcmp(t(i,4),'STD')
            asestruct=fillASEvals_v1(asestruct,t{i,5:end},'CBFstd',t{i,2}{:},newpat(2));
            newpat(2)=0;
        elseif contains(filename,'ms_ASE_tau') && contains(filename,'RFoff')
            asestruct=fillASEvals_v1(asestruct,t{i,5:end},'ms_ASE_RFoff',t{i,2}{:},newpat(3));
            if strcmp(t{i,2}{:},'Rsquared');newpat(3)=0;end
        elseif contains(filename,'ms_ASE_tau') && contains(filename,'RFon')
            asestruct=fillASEvals_v1(asestruct,t{i,5:end},'ms_ASE_RFon',t{i,2}{:},newpat(4));
            if strcmp(t{i,2}{:},'Rsquared');newpat(4)=0;end
        elseif contains(filename,'ss_ASE_tau') && contains(filename,'RFoff')
            asestruct=fillASEvals_v1(asestruct,t{i,5:end},'ss_ASE_RFoff',t{i,2}{:},newpat(5));
            if strcmp(t{i,2}{:},'Rsquared');newpat(5)=0;end
        elseif contains(filename,'VASOASE_tau')
            asestruct=fillASEvals_v1(asestruct,t{i,5:end},'vasoase',t{i,2}{:},newpat(6));
            if strcmp(t{i,2}{:},'Rsquared');newpat(6)=0;end
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%

% % % % % % TRUST
vartypes={'HbAA','HbF','Bovine','HbS'};
for i=1:length(vartypes)
        asestruct.TRUST.(vartypes{i})=[];
end
for i=1:length(patdirs)
    trustresults=[datadir,'/',patdirs{i},'/Results/TRUSTresults.txt'];
    YAval=readtable([datadir,'/',patdirs{i},'/Ya_val.txt']);
    YAval=YAval{1,1}/100;
    t=readtable(trustresults);
    asestruct.TRUST.HbAA{end+1}=YAval-[t{2,2},t{2,4}]/YAval;
    asestruct.TRUST.HbF{end+1}=YAval-[t{3,2},t{3,4}]/YAval;
    asestruct.TRUST.Bovine{end+1}=YAval-[t{4,2},t{4,4}]/YAval;
    asestruct.TRUST.HbS{end+1}=YAval-[t{5,2},t{5,4}]/YAval;
end
