## targDir should be the top level directory for processing of an individual patient.
### For example, the directory I used to write this program was 
### targDir=/Users/spencerwaddle/Documents/boldProcessing/Projects/BOLD/Data_Storing/PTSTEN_144_01
### This program will save the concatonated file into targDir
### Alternatively, you can give the filepath as an input when you execute ./mkZstatMov_part1.sh


# targDir=/Users/spencerwaddle/Documents/boldProcessing/Projects/BOLD/Data_Storing/PTSTEN_013_05
targDir=$1


#####################################################################################################
#####################################################################################################

#### Finds the patient ID by grabbing the text after the last / in targDir

count=`expr ${#targDir} - 1`
flag=0
while [ $flag = 0 ]
do
count=`expr $count - 1`
tempChar=${targDir:count:1}
if [ $tempChar = "/" ]
then
	flag=1
	patID=${targDir:`expr $count + 1`}
fi
done

### Dat dir is where the temporary zstat files for each jitter are that we will merge to make the movie
rawZDir=$targDir/$patID/"misc/tmpout"/$patID"_TIDE"

mkdir zMovTmpDir

### coregister averaged BOLD image to 2mm MNI space, so that I can use that xform matrix on each zstat image
./code/fsl/flirt -in ${targDir}/Processed/${patID}_BOLD.feat/mean_func.nii.gz -ref ./atlases/MNI152_T1_2mm_brain.nii.gz -omat zMovTmpDir/${patID}.omat -out zMovTmpDir/BOLDcoreg


for ((k=1; k<200; k+=3))
do
./code/fsl/flirt -in $rawZDir/${k}_z.nii.gz -ref ./atlases/MNI152_T1_2mm_brain.nii.gz -applyxfm -init "zMovTmpDir/"$patID".omat" -out zMovTmpDir/${k}_z.nii.gz
echo $k
done

### This merges all the z files to make a movie. I know that it appears stupid to have written it all out like this, but this runs likes 30x faster than the other method below. Don't judge. Haha.
./code/fsl/fslmerge -t $targDir/$patID"_zstatMovie.nii.gz" zMovTmpDir/1_z.nii.gz zMovTmpDir/4_z.nii.gz zMovTmpDir/7_z.nii.gz zMovTmpDir/10_z.nii.gz zMovTmpDir/13_z.nii.gz zMovTmpDir/16_z.nii.gz zMovTmpDir/19_z.nii.gz zMovTmpDir/22_z.nii.gz zMovTmpDir/25_z.nii.gz zMovTmpDir/28_z.nii.gz zMovTmpDir/31_z.nii.gz zMovTmpDir/34_z.nii.gz zMovTmpDir/37_z.nii.gz zMovTmpDir/40_z.nii.gz zMovTmpDir/43_z.nii.gz zMovTmpDir/46_z.nii.gz zMovTmpDir/49_z.nii.gz zMovTmpDir/52_z.nii.gz zMovTmpDir/55_z.nii.gz zMovTmpDir/58_z.nii.gz zMovTmpDir/61_z.nii.gz zMovTmpDir/64_z.nii.gz zMovTmpDir/67_z.nii.gz zMovTmpDir/70_z.nii.gz zMovTmpDir/73_z.nii.gz zMovTmpDir/76_z.nii.gz zMovTmpDir/79_z.nii.gz zMovTmpDir/82_z.nii.gz zMovTmpDir/85_z.nii.gz zMovTmpDir/88_z.nii.gz zMovTmpDir/91_z.nii.gz zMovTmpDir/94_z.nii.gz zMovTmpDir/97_z.nii.gz zMovTmpDir/100_z.nii.gz zMovTmpDir/103_z.nii.gz zMovTmpDir/106_z.nii.gz zMovTmpDir/109_z.nii.gz zMovTmpDir/112_z.nii.gz zMovTmpDir/115_z.nii.gz zMovTmpDir/118_z.nii.gz zMovTmpDir/121_z.nii.gz zMovTmpDir/124_z.nii.gz zMovTmpDir/127_z.nii.gz zMovTmpDir/130_z.nii.gz zMovTmpDir/133_z.nii.gz zMovTmpDir/136_z.nii.gz zMovTmpDir/139_z.nii.gz zMovTmpDir/142_z.nii.gz zMovTmpDir/145_z.nii.gz zMovTmpDir/148_z.nii.gz zMovTmpDir/151_z.nii.gz zMovTmpDir/154_z.nii.gz zMovTmpDir/157_z.nii.gz zMovTmpDir/160_z.nii.gz zMovTmpDir/163_z.nii.gz zMovTmpDir/166_z.nii.gz zMovTmpDir/169_z.nii.gz zMovTmpDir/172_z.nii.gz zMovTmpDir/175_z.nii.gz zMovTmpDir/178_z.nii.gz zMovTmpDir/181_z.nii.gz zMovTmpDir/184_z.nii.gz zMovTmpDir/187_z.nii.gz zMovTmpDir/190_z.nii.gz zMovTmpDir/193_z.nii.gz zMovTmpDir/196_z.nii.gz zMovTmpDir/199_z.nii.gz

./code/fsl/fslmaths $targDir/$patID"_zstatMovie.nii.gz" -mul ./atlases/MNI152_T1_2mm_brain_mask.nii.gz $targDir/$patID"_zstatMovie.nii.gz"

