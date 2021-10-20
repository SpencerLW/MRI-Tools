workingDir='/Users/spencerwaddle/Documents/boldProcessing/Projects/BOLD/Brainsplitter'
cd $workingDir

#################################### CBF maps

cd $workingDir/CBF_MM

#### normal maps
cd normal
fslmerge -t merged.nii.gz `ls *.nii.gz`
fslmaths merged.nii.gz -Tmean avgNormCBF.nii.gz
rm merged.nii.gz
cd ..

#### stenosed maps

cd stenosed
fslmerge -t merged.nii.gz `ls *.nii.gz`
fslmaths merged.nii.gz -Tmean avgStenosedCBF.nii.gz
rm merged.nii.gz

############################## Tmax maps

cd $workingDir/Tmax_MM

#### normal maps
cd normal
fslmerge -t merged.nii.gz `ls *.nii.gz`
fslmaths merged.nii.gz -Tmean avgNormTmax.nii.gz
rm merged.nii.gz
cd ..

#### stenosed maps

cd stenosed
fslmerge -t merged.nii.gz `ls *.nii.gz`
fslmaths merged.nii.gz -Tmean avgStenosedTmax.nii.gz
rm merged.nii.gz

############################ Zmax maps


cd $workingDir/Zmax_MM

#### normal maps
cd normal
fslmerge -t merged.nii.gz `ls *.nii.gz`
fslmaths merged.nii.gz -Tmean avgNormZmax.nii.gz
rm merged.nii.gz
cd ..

#### stenosed maps

cd stenosed
fslmerge -t merged.nii.gz `ls *.nii.gz`
fslmaths merged.nii.gz -Tmean avgStenosedZmax.nii.gz
rm merged.nii.gz

cd $workingDir
