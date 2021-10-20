%%% THIS IS FOR PROCESSING SPENCERS PROJECT. FOR PROCESSING WASH-U DATA USE
%%% SLW_ASEproc_v3


%%%% You will probably need to run matlab from terminal, so that it can
%%%% have access to all of the fsl tools and functions

% addpath('/Users/spencerwaddle/Documents/PPE/Scanning/CodeTools')
% addpath('/Users/spencerwaddle/Documents/PPE/Scripts')
standaloneDir='/Users/spencerwaddle/Documents/SLWtools/ASE_standalone_v2'; %Directory with all ASE processing scripts in it
addpath(genpath(standaloneDir))
slw_resourcesDir=[standaloneDir,'/slw_resources']; %%% directory for slw_resources

%%

datadir1='/Users/spencerwaddle/Documents/PPE/Scanning/';
% patstruct={'20210301_Donahue_241665','20210329_Donahue_241973','20210407_Donahue_242049','20210527_Donahue_142506', ...
%     '20210630_Donahue_242842','20210630_Donahue_242845','20210701_Donahue_242810','20210701_Donahue_242820', ...
%     '20210707_Donahue_242907','20210707_Donahue_242908','20210707_Donahue_242909','20210810_Donahue_243184',...
%     '20210810_Donahue_243185','20210813_Donahue_243203','20210813_Donahue_243262'}; %%% Names of all patient directories to process.

patstruct={'20210301_Donahue_241665'}; %%% Names of all patient directories to process.



% patstruct={'20210707_Donahue_242908'}; %%% Names of all patient directories to process.

warning('off','all')

hctUncorr=0.42; %% Uncorrected hematocrit. Estimated Value
sliceGrab=0; %%% 0 or 1. This won't do anything if threeD is 0
slice2grab=6;
echo2Exclude=0; %%% 0 or 1. Should be 0 if only one echo was collecte
%%%% This is the ordering of tau-shiftings in the ASE acquisition. This
%%%% has been standardized. Changing this, should be an intentional
%%%% decision. You will ruin the ASE processing if this is changed and the
%%%% ASE acquisition isn't altered accordingly
tauvec=[20.5 11 1 20 4.5 18.5 17 8 9.5 12 21.5 17.5 8.5 22 14.5 19 7 7.5 9 ...
    6.5 2 15 18 5.5 16 10 22.5 10.5 0.5 6 13 4 14 21 0 5 2.5 1.5 11.5 ...
    12.5 16.5 13.5 19.5 3 15.5 3.5];
TR=4400; %ms
TE1=64; %ms
TE2=107;

ASEresolution=[3.44,3.44,6]; %%% Gotta include slice gap in 3 dimension size
%%% We found that tau>20 has nonlinearity that is bad for ASE, so I exclude
%%% them here. I decided to keep acquiring it because it only adds a few
%%% seconds to the acquisition, and the ASE nonlinearity might be
%%% interesting later.
excludedyns_1echo=42:46; %% Should be the same as exclude dyns, but only the first echo indices
excludedyns=[42:46 88:92];%% Exclude [42:46 88:92] to remove nonlinearity at end of scan

%%%%%%%%%%%%%%%%%%%%%%
mni_brain=[slw_resourcesDir,'/atlases/MNI152_T1_2mm_brain.nii.gz'];
MNIdir=[standaloneDir,'/MNI_valGrab_sky/MNI_valGrab_masks'];
dcm2nii64_path=[slw_resourcesDir,'/dcm2nii64'];
dcm2niix_path=[slw_resourcesDir,'/dcm2niix'];
flirt_path=[slw_resourcesDir,'/FSLTOOLS/flirt'];
bet2_path=[slw_resourcesDir,'/FSLTOOLS/bet2'];
%%%%

for participantInd=1:length(patstruct)

    %%% Define parameters
%     patdir='/Users/spencerwaddle/Documents/PPE/Scanning/20210701_Donahue_242810'; %%% patdir should have an Acquired folder with all scans in it
    patdir=[datadir1 patstruct{participantInd}];
    [~,patid]=system(['basename ',patdir]);patid=patid(1:end-1);

    mkdir([patdir,'/2dCoreg'])
    mkdir([patdir,'/Results'])

    %%% Find B0 file
    B0=dir([patdir,'/Acquired/*B0*.PAR']);
    try
        B0=[patdir,'/Acquired/',B0(1).name];
    end
    if isempty(B0)
        B0=3;
    end
    % %%%%%%%%%% USE B0=3 Tesla
    % B0=3;
    % %%%%%%%%%%

    ASEcheck_v6_fn( patdir, hctUncorr,sliceGrab,slice2grab,echo2Exclude,tauvec,TR,TE1,TE2,excludedyns_1echo,excludedyns,B0,dcm2nii64_path,flirt_path,ASEresolution)
    disp('finished ASEcheck')
    Master_SA_v2_fn(patdir,hctUncorr) %%% TRUST
    try
        movefile([patdir,'/Acquired/TRUSTresults.txt'],[patdir,'/Results/TRUSTresults.txt'])
    end

    aslfiles=dir([patdir,'/Acquired/*SOURCE*pCASL*.PAR']);
    m0files=dir([patdir,'/Acquired/*pCASL*M0*.PAR']);
    if length(aslfiles) ~= length(m0files)
        error('there arent the same number of asl and m0 files. There is a probably a problem, resolve this to continue processing')
    end
    %%%% Move ASL files out of acquired. That is how we process them
    mkdir([patdir,'/Acquired/ASLstore_moveToAcquired'])
    for i=1:length(aslfiles)
        movefile([patdir,'/Acquired/',aslfiles(i).name],[patdir,'/Acquired/ASLstore_moveToAcquired/',aslfiles(i).name])
        movefile([patdir,'/Acquired/',aslfiles(i).name(1:end-4),'.REC'],[patdir,'/Acquired/ASLstore_moveToAcquired/',aslfiles(i).name(1:end-4),'.REC'])
        movefile([patdir,'/Acquired/',m0files(i).name],[patdir,'/Acquired/ASLstore_moveToAcquired/',m0files(i).name])
        movefile([patdir,'/Acquired/',m0files(i).name(1:end-4),'.REC'],[patdir,'/Acquired/ASLstore_moveToAcquired/',m0files(i).name(1:end-4),'.REC'])
    end
    for i=1:length(aslfiles)
        aslname=aslfiles(i).name(1:end-4);
        movefile([patdir,'/Acquired/ASLstore_moveToAcquired/',aslfiles(i).name],[patdir,'/Acquired/',aslfiles(i).name])
        movefile([patdir,'/Acquired/ASLstore_moveToAcquired/',aslname,'.REC'],[patdir,'/Acquired/',aslname,'.REC'])
        movefile([patdir,'/Acquired/ASLstore_moveToAcquired/',m0files(i).name],[patdir,'/Acquired/',m0files(i).name])
        movefile([patdir,'/Acquired/ASLstore_moveToAcquired/',m0files(i).name(1:end-4),'.REC'],[patdir,'/Acquired/',m0files(i).name(1:end-4),'.REC'])
        %%% Process pCASL. This will get confused if there are 2 pCASL scans in
        %%% patdir
        [~,M0file]=pcasl_slw_v1([patdir,'/Acquired']);
        M0file=[patdir,'/Acquired/',M0file];
        %%%%%%

        %%%%%%%%%%% move output of processing to results
        try
        movefile([patdir,'/Acquired/',aslname,'_readme.txt'],[patdir,'/Results/',aslname,'_readme.txt'])
        end
        try
        movefile([patdir,'/Acquired/pCASLimg.png'],[patdir,'/Results/',aslname,'pCASLimg.png'])
        end
        try
        movefile([patdir,'/Acquired/CBF.nii.gz'],[patdir,'/Results/',aslname,'_CBF.nii.gz'])
        end

        coregdir=[patdir,'/Results/coreg_junk'];
        coregResults=[patdir,'/Results/coregResults'];
        T1file=dir([patdir,'/Acquired/*3DT1*.PAR']);
        T1file=T1file.name; T1file=[patdir,'/Acquired/',T1file];
        %%%%%%%%%%%%% CBF to MNI
        %%% M0 to T1
        ASE_coreg_slw_v1( M0file, [coregdir,'/M02T1.nii.gz'], T1file, [coregdir,'/M02T1.omat'], 'save', dcm2nii64_path, flirt_path, '', bet2_path, '','-f 0.2', 1, 1 )
        %%% T1 to MNI
        ASE_coreg_slw_v1( T1file, [coregdir,'/T12MNI.nii.gz'], mni_brain, [coregdir,'/T12MNI.omat'], 'save', dcm2nii64_path, flirt_path, '', bet2_path, '','', 1, 0 )
        %%% CBF to T1
        ASE_coreg_slw_v1( [patdir,'/Results/',aslname,'_CBF.nii.gz'], [coregdir,'/',aslname,'_CBF2T1.nii.gz'], T1file, [coregdir,'/M02T1.omat'], 'use', dcm2nii64_path, flirt_path, '', bet2_path, '','', 0, 0 )
        %%% CBF to MNI
        ASE_coreg_slw_v1( [coregdir,'/',aslname,'_CBF2T1.nii.gz'], [coregResults,'/',aslname,'_CBF2MNI.nii.gz'], mni_brain, [coregdir,'/T12MNI.omat'], 'use', dcm2nii64_path, flirt_path, '', bet2_path, '','', 0, 0 )
        % % % % % % % % MNI_valGrab_v2(inFile, roidir, fxnHandles, csvname)
        MNI_valGrab_v2([coregResults,'/',aslname,'_CBF2MNI.nii.gz'],MNIdir,{@mean},[coregResults,'/',patid,'_ProcResults.csv'],patid,'CBF',aslname,'mean');
        MNI_valGrab_v2([coregResults,'/',aslname,'_CBF2MNI.nii.gz'],MNIdir,{@std},[coregResults,'/',patid,'_ProcResults.csv'],patid,'CBF',aslname,'STD');
        movefile([patdir,'/Acquired/',aslfiles(i).name],[patdir,'/Acquired/ASLstore_moveToAcquired/',aslfiles(i).name])
        movefile([patdir,'/Acquired/',aslname,'.REC'],[patdir,'/Acquired/ASLstore_moveToAcquired/',aslname,'.REC'])
        movefile([patdir,'/Acquired/',m0files(i).name],[patdir,'/Acquired/ASLstore_moveToAcquired/',m0files(i).name])
        movefile([patdir,'/Acquired/',m0files(i).name(1:end-4),'.REC'],[patdir,'/Acquired/ASLstore_moveToAcquired/',m0files(i).name(1:end-4),'.REC'])
    end
    %%% Move ASL files back to acquired
    for i=1:length(aslfiles)
        movefile([patdir,'/Acquired/ASLstore_moveToAcquired/',aslfiles(i).name],[patdir,'/Acquired/',aslfiles(i).name])
        movefile([patdir,'/Acquired/ASLstore_moveToAcquired/',aslfiles(i).name(1:end-4),'.REC'],[patdir,'/Acquired/',aslfiles(i).name(1:end-4),'.REC'])
        movefile([patdir,'/Acquired/ASLstore_moveToAcquired/',m0files(i).name],[patdir,'/Acquired/',m0files(i).name])
        movefile([patdir,'/Acquired/ASLstore_moveToAcquired/',m0files(i).name(1:end-4),'.REC'],[patdir,'/Acquired/',m0files(i).name(1:end-4),'.REC'])
    end
    % %%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%% OEF 2 MNI

    %%%%%% Multislice first
    names=dir([patdir,'/Acquired/*ms_ASE*.PAR']);
    system('. /usr/local/fsl/etc/fslconf/fsl.sh')
    %%%% Find which 3d matrices we will coregister each 2d acquisition to
    [ ase2dstruct, ase3dstruct, simvec ] = Find2dSimVec_v1( patdir );
    %%%%%%%%%%%%%%%%%%%%%
    for i=1:length(names)
        try
            rmdir(coregdir,'s')
        end

        tempname=names(i).name;
        scanname=tempname(1:end-4);

        %%% ASE to T1
        ASE_coreg_slw_v1( [patdir,'/Acquired/',tempname], [coregdir,'/ASEn2T1.nii.gz'], T1file, [coregdir,'/ASEn2T1.omat'], 'save', dcm2nii64_path, flirt_path, '', bet2_path, '','-f 0.2', 1, 1 )
        %%% T1 to MNI
        ASE_coreg_slw_v1( T1file, [coregdir,'/T12MNI.nii.gz'], mni_brain, [coregdir,'/T12MNI.omat'], 'save', dcm2nii64_path, flirt_path, '', bet2_path, '','', 1, 0 )

        %%% R2prime to T1
        ASE_coreg_slw_v1( [patdir,'/Results/',scanname,'_R2prime.nii.gz'], [coregdir,'/R2prime2T1.nii.gz'], T1file, [coregdir,'/ASEn2T1.omat'], 'use', dcm2nii64_path, flirt_path, '', bet2_path, '','', 0, 0 )
        %%% R2prime to MNI
        ASE_coreg_slw_v1( [coregdir,'/R2prime2T1.nii.gz'], [coregResults,'/',scanname,'_R2prime_coreg.nii.gz'], mni_brain, [coregdir,'/T12MNI.omat'], 'use', dcm2nii64_path, flirt_path, '', bet2_path, '','', 0, 0 )

        %%% rOEF to T1
        ASE_coreg_slw_v1( [patdir,'/Results/',scanname,'_rOEF.nii.gz'], [coregdir,'/rOEF2T1.nii.gz'], T1file, [coregdir,'/ASEn2T1.omat'], 'use', dcm2nii64_path, flirt_path, '', bet2_path, '','', 0, 0 )
        %%% rOEF to MNI
        ASE_coreg_slw_v1( [coregdir,'/rOEF2T1.nii.gz'], [coregResults,'/',scanname,'_rOEF_coreg.nii.gz'], mni_brain, [coregdir,'/T12MNI.omat'], 'use', dcm2nii64_path, flirt_path, '', bet2_path, '','', 0, 0 )

        %%% rvCBV to T1
        ASE_coreg_slw_v1( [patdir,'/Results/',scanname,'_rvCBV.nii.gz'], [coregdir,'/rvCBV2T1.nii.gz'], T1file, [coregdir,'/ASEn2T1.omat'], 'use', dcm2nii64_path, flirt_path, '', bet2_path, '','', 0, 0 )
        %%% rvCBV to MNI
        ASE_coreg_slw_v1( [coregdir,'/rvCBV2T1.nii.gz'], [coregResults,'/',scanname,'_rvCBV_coreg.nii.gz'], mni_brain, [coregdir,'/T12MNI.omat'], 'use', dcm2nii64_path, flirt_path, '', bet2_path, '','', 0, 0 )

        %%% Rsquared to T1
        ASE_coreg_slw_v1( [patdir,'/Results/',scanname,'_Rsquared.nii.gz'], [coregdir,'/Rsquared2T1.nii.gz'], T1file, [coregdir,'/ASEn2T1.omat'], 'use', dcm2nii64_path, flirt_path, '', bet2_path, '','', 0, 0 )
        %%% Rsquared to MNI
        ASE_coreg_slw_v1( [coregdir,'/Rsquared2T1.nii.gz'], [coregResults,'/',scanname,'_Rsquared_coreg.nii.gz'], mni_brain, [coregdir,'/T12MNI.omat'], 'use', dcm2nii64_path, flirt_path, '', bet2_path, '','', 0, 0 )

        %%%% Grab regional mean values
        MNI_valGrab_v2([coregResults,'/',scanname,'_R2prime_coreg.nii.gz'],MNIdir,{@mean},[coregResults,'/',patid,'_ProcResults.csv'],patid,'R2prime',scanname,'mean');
        MNI_valGrab_v2([coregResults,'/',scanname,'_rOEF_coreg.nii.gz'],MNIdir,{@mean},[coregResults,'/',patid,'_ProcResults.csv'],patid,'rOEF',scanname,'mean');
        MNI_valGrab_v2([coregResults,'/',scanname,'_rvCBV_coreg.nii.gz'],MNIdir,{@mean},[coregResults,'/',patid,'_ProcResults.csv'],patid,'rvCBV',scanname,'mean');
        MNI_valGrab_v2([coregResults,'/',scanname,'_Rsquared_coreg.nii.gz'],MNIdir,{@mean},[coregResults,'/',patid,'_ProcResults.csv'],patid,'Rsquared',scanname,'mean');
        %%% Save omats for later if we are going to use them to coregister 2d
        %%% Otherwise they get overwritten in each coregistration
        for j=1:length(simvec)
            if strcmp([scanname,'.PAR'], ase3dstruct(simvec(j)).name)
                copyfile([coregdir,'/ASEn2T1.omat'],[patdir,'/2dCoreg/',scanname,'ASE2T1.omat'])
                copyfile([coregdir,'/T12MNI.omat'],[patdir,'/2dCoreg/',scanname,'T12MNI.omat'])          
            end
        end
    end

    %%%%% Single slice second
    % % % % % % [ ase2dstruct, ase3dstruct, simvec ] = Find2dSimVec_v1( patdir );
    for i=1:length(ase2dstruct)
        ASE2dcoreg=coreg2dto3d_v1(ase2dstruct(i).name, ase3dstruct(simvec(i)).name, T1file, mni_brain,patdir,ASEresolution,dcm2nii64_path,flirt_path,bet2_path);
        tempname=ase2dstruct(i).name(1:end-4);
        MNI_valGrab_v2([patdir,'/2dCoreg/',tempname,'_R2prime_3dcoreg.nii.gz'],MNIdir,{@mean},[coregResults,'/',patid,'_ProcResults.csv'],patid,'R2prime',ase2dstruct(i).name,'mean');
        MNI_valGrab_v2([patdir,'/2dCoreg/',tempname,'_rOEF_3dcoreg.nii.gz'],MNIdir,{@mean},[coregResults,'/',patid,'_ProcResults.csv'],patid,'rOEF',ase2dstruct(i).name,'mean');
        MNI_valGrab_v2([patdir,'/2dCoreg/',tempname,'_rvCBV_3dcoreg.nii.gz'],MNIdir,{@mean},[coregResults,'/',patid,'_ProcResults.csv'],patid,'rvCBV',ase2dstruct(i).name,'mean');
        MNI_valGrab_v2([patdir,'/2dCoreg/',tempname,'_Rsquared_3dcoreg.nii.gz'],MNIdir,{@mean},[coregResults,'/',patid,'_ProcResults.csv'],patid,'Rsquared',ase2dstruct(i).name,'mean');
    end
end
