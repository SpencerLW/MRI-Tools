nift1=load_nii('/usr/local/fsl/data/standard/MNI152_T1_2mm_brain.nii.gz');
% nift1=load_nii('/Users/spencerwaddle/Documents/boldProcessing/Projects/BOLD/Spencer_BOLD-CBF-Brainsplit/MNI152_T1_2mm_brain_RsideHole.nii.gz');

% imgShift=1;
% [L,R]=brainSplitter(nift1,imgShift);

[L,R]=brainSplitter(nift1);
minVal=0;
maxVal=max(nift1.img(:));
for i=1:91
    disp('L')
    imagesc(L.img(:,:,i),[minVal maxVal])
    pause
    disp('R')
    imagesc(R.img(:,:,i),[minVal maxVal])
    if size(L.img)~=size(nift1.img)
        disp('SIZE ERROR!!!!!')       
    end
    pause
end