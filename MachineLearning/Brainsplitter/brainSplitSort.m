%%% splits brains and sorts them by more stenosed or less stenosed.
%%% Separate out the MM data first using separateMM.m
%%% once brains are split and sorted, go to ~/MachineLearning and use
%%% maskFlowTerritories.sh to mask the flow territories and sort them by
%%% flow territory.

% [num,txt]=xlsread('processed_moyamoya_SKL.xlsx',1,'F:H');

Variable='CBF'; %%% which variable are we going to be splitting?

mkdir(['/Users/spencerwaddle/Documents/boldProcessing/Projects/BOLD/Brainsplitter/',Variable,'_MM']);

workingDir=['/Users/spencerwaddle/Documents/boldProcessing/Projects/BOLD/Brainsplitter/',Variable,'_MM'];
cd(workingDir)
addpath('/Users/spencerwaddle/Documents/boldProcessing/Projects/BOLD/Brainsplitter')

mkdir normal
mkdir stenosed

[num,~]=xlsread('/Users/spencerwaddle/Documents/boldProcessing/processed_moyamoya_SKL.xlsx',1,'G:H');
[~,patIDvec]=xlsread('/Users/spencerwaddle/Documents/boldProcessing/processed_moyamoya_SKL.xlsx',1,'F:F');
patIDvec=patIDvec(2:end);
RStenvec=num(:,1);
LStenvec=num(:,2);




if strcmp(Variable,'DSS0')
    for i=1:length(patIDvec)
        patID=patIDvec{i};
        patID=['PROC',patID(7:end)];
        try
            nift=load_nii([patID,'_',Variable,'2MNI','.nii.gz']);
            [L,R]=brainSplitter(nift);

            if RStenvec(i)
                save_nii(R,[workingDir,'/stenosed/',patID,'_R.nii.gz'])

            elseif ~RStenvec(i)
                save_nii(R,[workingDir,'/normal/',patID,'_R.nii.gz'])
            else    
                disp(['something went wrong with R side of patID ',patID])
            end

            if LStenvec(i)
                save_nii(L,[workingDir,'/stenosed/',patID,'_L.nii.gz'])

            elseif ~LStenvec(i)
                save_nii(L,[workingDir,'/normal/',patID,'_L.nii.gz'])
            else    
                disp(['something went wrong with L side of patID ',patID])
            end
        catch e
            disp(e.message)
            disp(['Something went wrong when trying to open and split ',patID])
        end


    %     save_nii(L,[workingDir,patID,'_L.nii.gz'])
    %     save_nii(R,[workingDir,patID,'_R.nii.gz'])
    end
else
    
    for i=1:length(patIDvec)
        patID=patIDvec{i};
        try
            nift=load_nii([patID,'_',Variable,'2STANDARD','.nii.gz']);
            [L,R]=brainSplitter(nift);

            if RStenvec(i)
                save_nii(R,[workingDir,'/stenosed/',patID,'_R.nii.gz'])

            elseif ~RStenvec(i)
                save_nii(R,[workingDir,'/normal/',patID,'_R.nii.gz'])
            else    
                disp(['something went wrong with R side of patID ',patID])
            end

            if LStenvec(i)
                save_nii(L,[workingDir,'/stenosed/',patID,'_L.nii.gz'])

            elseif ~LStenvec(i)
                save_nii(L,[workingDir,'/normal/',patID,'_L.nii.gz'])
            else    
                disp(['something went wrong with L side of patID ',patID])
            end
        catch e
            disp(e.message)
            disp(['Something went wrong when trying to open and split ',patID])
        end


    %     save_nii(L,[workingDir,patID,'_L.nii.gz'])
    %     save_nii(R,[workingDir,patID,'_R.nii.gz'])
    end 
    
end