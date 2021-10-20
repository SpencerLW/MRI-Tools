### This program takes 3 command line inputs. first input is the full path to the directory that contains files you want to rename.
### second input is the string within the files that you want to replace. third input is the string you want to replace input 2 with.
###
### for example, ./deidentifyFileNames.sh /Users/spencerwaddle/Documents/dataMisc/testData/PTSTEN_144_01 PTSTEN_144_01 bigDog
###
### would result in all files containing PTSTEN_144_01 to have that string replaced by bigDog. So
### PTSTEN_144_01_WIP_DWI_SENSE_4_1.PAR becomes bigDog_WIP_DWI_SENSE_4_1.PAR

### Spencer Waddle 12/07/2018
### v2 added a function to remove whitespace from the input filenames and replace it with underscores. 11/8/2019

dataDir=$1
currentName=$2
newName=$3

### ^^^^^^^^^^^^ Change stuff

while IFS='' read -r -d '' fname ; do
   nname="${fname##*/}"
   mv -n "${fname}"  "${fname%/*}/${nname//[[:space:]]/_}"
done < <(find "$dataDir"  -name "* *" -type f  -print0)

tempFile="TEMP48djFILE1cfo0STORAGE26dbb.txt"
find $dataDir -name *$currentName* -print > $tempFile #### go through data folder and grab all filenames that have currentName

## ${#word} check length of variable word
## ${word:2:10} print 10 characters of word, starting at character 3
## ${word:4:1} print only the fifth character of word

currNameLen=${#currentName}

if [ -s $tempFile ]
then
	echo "files were identified with the currentName, $currentName, and will be renamed with $newName"
	flag=0
	## We successfully identified files to rename	
else
	echo "No files with the user input currentName, $currentName, were identified"
	flag=3
fi

while read line
do
	fullNameLen=${#line}
	i=`expr $fullNameLen - $currNameLen - 1`	

#	while [ $i -le ${#line} ] && [ $flag = 0 ]
	while [ $flag = 0 ]
	do
		word=${line:$i:$currNameLen}
		if [ $word = $currentName ] 
		then
			flagInd=$i
			flag=1		
		fi

		if [ ${line:$i:1} = '/' ]
		then
			flag=2
			echo "It appears that the user input current name, $currentName, was not found in at least one of the file names"
		fi
		i=`expr $i - 1`
	done

	if [ $flag = 1 ]
	then
		updateName="${line:0:$flagInd}$newName${line:`expr $flagInd + $currNameLen`}"
	fi

	mv $line $updateName

done < $tempFile

rm $tempFile
