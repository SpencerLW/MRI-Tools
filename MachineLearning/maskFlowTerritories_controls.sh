###########
#### remember to remove EDAS data after masking flow territories with removeEdas.sh

workingDir=/Users/spencerwaddle/Documents/MachineLearning 

Zdir=/Users/spencerwaddle/Documents/MachineLearning/controlData/Zmax_controls
Tdir=/Users/spencerwaddle/Documents/MachineLearning/controlData/Tmax_controls
CBFdir=/Users/spencerwaddle/Documents/MachineLearning/controlData/CBF_controls
DSS0dir=/Users/spencerwaddle/Documents/MachineLearning/controlData/DSS0_controls

licamask=/Users/spencerwaddle/Documents/boldProcessing/Projects/BOLD/Brainsplitter/FlowTerritoryMasks/LICA_mask.nii.gz
ricamask=/Users/spencerwaddle/Documents/boldProcessing/Projects/BOLD/Brainsplitter/FlowTerritoryMasks/RICA_mask.nii.gz
lvbamask=/Users/spencerwaddle/Documents/boldProcessing/Projects/BOLD/Brainsplitter/FlowTerritoryMasks/VBA_Lmask.nii.gz
rvbamask=/Users/spencerwaddle/Documents/boldProcessing/Projects/BOLD/Brainsplitter/FlowTerritoryMasks/VBA_Rmask.nii.gz

################### Mask ZMAX data
cd $workingDir
mkdir ZMAX
cd ZMAX
mkdir controls
cd controls
mkdir lica rica lvba rvba
cd $Zdir
for patfile in `ls *.nii.gz`
do
	patID=`sed "s/_L.nii.gz//g" <<< $patfile`
	if [ "$patID" != "$patfile" ]
		then
			fslmaths $patfile -mul $licamask $workingDir/'ZMAX/controls/lica/'$patID'_lica.nii.gz'
			fslmaths $patfile -mul $lvbamask $workingDir/'ZMAX/controls/lvba/'$patID'_lvba.nii.gz'
	fi
	patID=`sed "s/_R.nii.gz//g" <<< $patfile`
	if [ "$patID" != "$patfile" ]
		then
			fslmaths $patfile -mul $ricamask $workingDir/'ZMAX/controls/rica/'$patID'_rica.nii.gz'
			fslmaths $patfile -mul $rvbamask $workingDir/'ZMAX/controls/rvba/'$patID'_rvba.nii.gz'
	fi
#	read -p 'This is a pause'
done



#################### Mask TMAX data

cd $workingDir
mkdir TMAX
cd TMAX
mkdir controls
cd controls
mkdir lica rica lvba rvba
cd $Tdir
for patfile in `ls *.nii.gz`
do
	patID=`sed "s/_L.nii.gz//g" <<< $patfile`
	if [ "$patID" != "$patfile" ]
		then
			fslmaths $patfile -mul $licamask $workingDir/'TMAX/controls/lica/'$patID'_lica.nii.gz'
			fslmaths $patfile -mul $lvbamask $workingDir/'TMAX/controls/lvba/'$patID'_lvba.nii.gz'
	fi
	patID=`sed "s/_R.nii.gz//g" <<< $patfile`
	if [ "$patID" != "$patfile" ]
		then
			fslmaths $patfile -mul $ricamask $workingDir/'TMAX/controls/rica/'$patID'_rica.nii.gz'
			fslmaths $patfile -mul $rvbamask $workingDir/'TMAX/controls/rvba/'$patID'_rvba.nii.gz'
	fi
#	read -p 'This is a pause'
done

############################### MASK CBF DATA

cd $workingDir
mkdir CBF
cd CBF
mkdir controls
cd controls
mkdir lica rica lvba rvba
cd $CBFdir
for patfile in `ls *.nii.gz`
do
	patID=`sed "s/_L.nii.gz//g" <<< $patfile`
	if [ "$patID" != "$patfile" ]
		then
			fslmaths $patfile -mul $licamask $workingDir/'CBF/controls/lica/'$patID'_lica.nii.gz'
			fslmaths $patfile -mul $lvbamask $workingDir/'CBF/controls/lvba/'$patID'_lvba.nii.gz'
	fi
	patID=`sed "s/_R.nii.gz//g" <<< $patfile`
	if [ "$patID" != "$patfile" ]
		then
			fslmaths $patfile -mul $ricamask $workingDir/'CBF/controls/rica/'$patID'_rica.nii.gz'
			fslmaths $patfile -mul $rvbamask $workingDir/'CBF/controls/rvba/'$patID'_rvba.nii.gz'
	fi
#	read -p 'This is a pause'
done



############################### MASK DSS0 data

cd $workingDir
mkdir DSS0
cd DSS0
mkdir controls
cd controls
mkdir lica rica lvba rvba
cd $DSS0dir
for patfile in `ls *.nii.gz`
do
	patID=`sed "s/_L.nii.gz//g" <<< $patfile`
	if [ "$patID" != "$patfile" ]
		then
			fslmaths $patfile -mul $licamask $workingDir/'DSS0/controls/lica/'$patID'_lica.nii.gz'
			fslmaths $patfile -mul $lvbamask $workingDir/'DSS0/controls/lvba/'$patID'_lvba.nii.gz'
	fi
	patID=`sed "s/_R.nii.gz//g" <<< $patfile`
	if [ "$patID" != "$patfile" ]
		then
			fslmaths $patfile -mul $ricamask $workingDir/'DSS0/controls/rica/'$patID'_rica.nii.gz'
			fslmaths $patfile -mul $rvbamask $workingDir/'DSS0/controls/rvba/'$patID'_rvba.nii.gz'
	fi
#	read -p 'This is a pause'
done
