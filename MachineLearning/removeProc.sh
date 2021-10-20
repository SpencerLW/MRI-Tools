#### this program goes through and changes everything that starts with PROC so that it starts with PTSTEN
#### I wrote this because Manus' DSS0 data started with PROC

names=`find /Users/spencerwaddle/Documents/MachineLearning/data -name "PROC*"`
###newNames=`sed 's/PROC/PTSTEN/g' <<< $names`

for line in $names
do
newline=`sed 's/PROC/PTSTEN/g' <<< $line`

mv $line $newline

done

##mv $names $newNames

##echo $names
##echo $newNames
##rm $names
