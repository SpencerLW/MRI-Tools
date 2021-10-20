###########
#### remember to remove EDAS data after masking flow territories with removeEdas.sh

Zdir=/Users/spencerwaddle/Documents/boldProcessing/Projects/BOLD/Brainsplitter/Zmax_MM
Tdir=/Users/spencerwaddle/Documents/boldProcessing/Projects/BOLD/Brainsplitter/Tmax_MM
CBFdir=/Users/spencerwaddle/Documents/boldProcessing/Projects/BOLD/Brainsplitter/CBF_MM
DSS0dir=/Users/spencerwaddle/Documents/boldProcessing/Projects/BOLD/Brainsplitter/DSS0_MM
workingDir=/Users/spencerwaddle/Documents/MachineLearning 

licamask=/Users/spencerwaddle/Documents/boldProcessing/Projects/BOLD/Brainsplitter/FlowTerritoryMasks/LICA_mask.nii.gz
ricamask=/Users/spencerwaddle/Documents/boldProcessing/Projects/BOLD/Brainsplitter/FlowTerritoryMasks/RICA_mask.nii.gz
lvbamask=/Users/spencerwaddle/Documents/boldProcessing/Projects/BOLD/Brainsplitter/FlowTerritoryMasks/VBA_Lmask.nii.gz
rvbamask=/Users/spencerwaddle/Documents/boldProcessing/Projects/BOLD/Brainsplitter/FlowTerritoryMasks/VBA_Rmask.nii.gz

################### Mask ZMAX data
cd $workingDir
mkdir ZMAX
cd ZMAX
mkdir normal stenosed
cd normal
mkdir lica rica lvba rvba
cd ../stenosed
mkdir lica rica lvba rvba
cd $Zdir/normal
for patfile in `ls *.nii.gz`
do
	echo $patfile
	patID=`sed "s/_L.nii.gz//g" <<< $patfile`
	echo $patID
	echo done
	if [ "$patID" != "$patfile" ]
		then
			echo $patID
			fslmaths $patfile -mul $licamask $workingDir/'ZMAX/normal/lica/'$patID'_lica.nii.gz'
			fslmaths $patfile -mul $lvbamask $workingDir/'ZMAX/normal/lvba/'$patID'_lvba.nii.gz'
	fi
	patID=`sed "s/_R.nii.gz//g" <<< $patfile`
	if [ "$patID" != "$patfile" ]
		then
			fslmaths $patfile -mul $ricamask $workingDir/'ZMAX/normal/rica/'$patID'_rica.nii.gz'
			fslmaths $patfile -mul $rvbamask $workingDir/'ZMAX/normal/rvba/'$patID'_rvba.nii.gz'
	fi
#	read -p 'This is a pause'
done
		echo stenosed
cd $Zdir/stenosed
for patfile in `ls *.nii.gz`
do
	echo $patfile
	patID=`sed "s/_L.nii.gz//g" <<< $patfile`
	echo $patID
	echo $done
	if [ "$patID" != "$patfile" ]
		then
			fslmaths $patfile -mul $licamask $workingDir/'ZMAX/stenosed/lica/'$patID'_lica.nii.gz'
			fslmaths $patfile -mul $lvbamask $workingDir/'ZMAX/stenosed/lvba/'$patID'_lvba.nii.gz'
	fi
	patID=`sed "s/_R.nii.gz//g" <<< $patfile`
	if [ "$patID" != "$patfile" ]
		then
			fslmaths $patfile -mul $ricamask $workingDir/'ZMAX/stenosed/rica/'$patID'_rica.nii.gz'
			fslmaths $patfile -mul $rvbamask $workingDir/'ZMAX/stenosed/rvba/'$patID'_rvba.nii.gz'
	fi
#	read -p 'This is a pause'
done



################### Mask TMAX data
cd $workingDir
mkdir TMAX
cd TMAX
mkdir normal stenosed
cd normal
mkdir lica rica lvba rvba
cd ../stenosed
mkdir lica rica lvba rvba
cd $Tdir/normal
for patfile in `ls *.nii.gz`
do
	patID=`sed "s/_L.nii.gz//g" <<< $patfile`
	if [ "$patID" != "$patfile" ]
		then
			fslmaths $patfile -mul $licamask $workingDir/'TMAX/normal/lica/'$patID'_lica.nii.gz'
			fslmaths $patfile -mul $lvbamask $workingDir/'TMAX/normal/lvba/'$patID'_lvba.nii.gz'
	fi
	patID=`sed "s/_R.nii.gz//g" <<< $patfile`
	if [ "$patID" != "$patfile" ]
		then
			fslmaths $patfile -mul $ricamask $workingDir/'TMAX/normal/rica/'$patID'_rica.nii.gz'
			fslmaths $patfile -mul $rvbamask $workingDir/'TMAX/normal/rvba/'$patID'_rvba.nii.gz'
	fi
done
cd $Tdir/stenosed
for patfile in `ls *.nii.gz`
do
	patID=`sed "s/_L.nii.gz//g" <<< $patfile`
	if [ "$patID" != "$patfile" ]
		then
			fslmaths $patfile -mul $licamask $workingDir/'TMAX/stenosed/lica/'$patID'_lica.nii.gz'
			fslmaths $patfile -mul $lvbamask $workingDir/'TMAX/stenosed/lvba/'$patID'_lvba.nii.gz'
	fi
	patID=`sed "s/_R.nii.gz//g" <<< $patfile`
	if [ "$patID" != "$patfile" ]
		then
			fslmaths $patfile -mul $ricamask $workingDir/'TMAX/stenosed/rica/'$patID'_rica.nii.gz'
			fslmaths $patfile -mul $rvbamask $workingDir/'TMAX/stenosed/rvba/'$patID'_rvba.nii.gz'
	fi
done


############################## MASK CBF DATA


################### Mask CBF data
cd $workingDir
mkdir CBF
cd CBF
mkdir normal stenosed
cd normal
mkdir lica rica lvba rvba
cd ../stenosed
mkdir lica rica lvba rvba
cd $CBFdir/normal
for patfile in `ls *.nii.gz`
do
	patID=`sed "s/_L.nii.gz//g" <<< $patfile`
	if [ "$patID" != "$patfile" ]
		then
			fslmaths $patfile -mul $licamask $workingDir/'CBF/normal/lica/'$patID'_lica.nii.gz'
			fslmaths $patfile -mul $lvbamask $workingDir/'CBF/normal/lvba/'$patID'_lvba.nii.gz'
	fi
	patID=`sed "s/_R.nii.gz//g" <<< $patfile`
	if [ "$patID" != "$patfile" ]
		then
			fslmaths $patfile -mul $ricamask $workingDir/'CBF/normal/rica/'$patID'_rica.nii.gz'
			fslmaths $patfile -mul $rvbamask $workingDir/'CBF/normal/rvba/'$patID'_rvba.nii.gz'
	fi
#	read -p 'This is a pause'
done
cd $CBFdir/stenosed
for patfile in `ls *.nii.gz`
do
	patID=`sed "s/_L.nii.gz//g" <<< $patfile`
	if [ "$patID" != "$patfile" ]
		then
			fslmaths $patfile -mul $licamask $workingDir/'CBF/stenosed/lica/'$patID'_lica.nii.gz'
			fslmaths $patfile -mul $lvbamask $workingDir/'CBF/stenosed/lvba/'$patID'_lvba.nii.gz'
	fi
	patID=`sed "s/_R.nii.gz//g" <<< $patfile`
	if [ "$patID" != "$patfile" ]
		then
			fslmaths $patfile -mul $ricamask $workingDir/'CBF/stenosed/rica/'$patID'_rica.nii.gz'
			fslmaths $patfile -mul $rvbamask $workingDir/'CBF/stenosed/rvba/'$patID'_rvba.nii.gz'
	fi
#	read -p 'This is a pause'
done


##################### Mask DSS0 data
cd $workingDir
mkdir DSS0
cd DSS0
mkdir normal stenosed
cd normal
mkdir lica rica lvba rvba
cd ../stenosed
mkdir lica rica lvba rvba
cd $DSS0dir/normal
for patfile in `ls *.nii.gz`
do
	patID=`sed "s/_L.nii.gz//g" <<< $patfile`
	if [ "$patID" != "$patfile" ]
		then
			fslmaths $patfile -mul $licamask $workingDir/'DSS0/normal/lica/'$patID'_lica.nii.gz'
			fslmaths $patfile -mul $lvbamask $workingDir/'DSS0/normal/lvba/'$patID'_lvba.nii.gz'
	fi
	patID=`sed "s/_R.nii.gz//g" <<< $patfile`
	if [ "$patID" != "$patfile" ]
		then
			fslmaths $patfile -mul $ricamask $workingDir/'DSS0/normal/rica/'$patID'_rica.nii.gz'
			fslmaths $patfile -mul $rvbamask $workingDir/'DSS0/normal/rvba/'$patID'_rvba.nii.gz'
	fi
#	read -p 'This is a pause'
done
cd $DSS0dir/stenosed
for patfile in `ls *.nii.gz`
do
	patID=`sed "s/_L.nii.gz//g" <<< $patfile`
	if [ "$patID" != "$patfile" ]
		then
			fslmaths $patfile -mul $licamask $workingDir/'DSS0/stenosed/lica/'$patID'_lica.nii.gz'
			fslmaths $patfile -mul $lvbamask $workingDir/'DSS0/stenosed/lvba/'$patID'_lvba.nii.gz'
	fi
	patID=`sed "s/_R.nii.gz//g" <<< $patfile`
	if [ "$patID" != "$patfile" ]
		then
			fslmaths $patfile -mul $ricamask $workingDir/'DSS0/stenosed/rica/'$patID'_rica.nii.gz'
			fslmaths $patfile -mul $rvbamask $workingDir/'DSS0/stenosed/rvba/'$patID'_rvba.nii.gz'
	fi
#	read -p 'This is a pause'
done
